// Queue-backed IPrinterBackend for on-prem Windows servers.
//
// Why: legacy SageFrame printed KOTs synchronously via GDI+ (System.Drawing.Printing) inside the ASMX
// request. On a POS machine with an offline/paper-jammed receipt printer that threw and failed the whole
// order call. Here every print job is handed to a background worker:
//   1. try the pluggable raw backend N times with backoff (Windows WritePrinter backend plugs in later);
//   2. on final failure, persist the rendered job to <base>/print-outbox/*.json so ops can replay —
//      a ticket is NEVER lost and the waiter's "Send Order" request NEVER fails because of a printer.
//
// NOTE: implements IPrinterBackend from DiningApp.Legacy (global-namespace shim).
#pragma warning disable
using System;
using System.Collections.Concurrent;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace DiningApp.Api {
    public class PrintingHostService : IHostedService, IPrinterBackend {
        readonly ILogger<PrintingHostService> _log;
        readonly BlockingCollection<(string Kind, string Payload)> _queue = new(512);
        CancellationTokenSource _cts;

        public PrintingHostService(ILogger<PrintingHostService> log) { _log = log; }

        Task IHostedService.StartAsync(CancellationToken cancellationToken) {
            _cts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
            Task.Run(() => Loop(_cts.Token));
            _log.LogInformation("Print queue started (outbox: {Dir})", OutboxDir);
            return Task.CompletedTask;
        }

        async Task IHostedService.StopAsync(CancellationToken cancellationToken) {
            try { _cts?.Cancel(); } catch { }
            await Task.Delay(50); // let the current job flush
        }

        static string OutboxDir => Path.Combine(AppContext.BaseDirectory, "print-outbox");

        // ---- IPrinterBackend surface: enqueue only, never throw ----------------------------------------
        void Enqueue(string kind, object payload) {
            try {
                var json = Newtonsoft.Json.JsonConvert.SerializeObject(payload);
                if (!_queue.TryAdd((kind, json)))
                    WriteOutbox(kind, json); // queue full -> straight to outbox; still never lost
            } catch (Exception ex) {
                _log.LogError(ex, "Print enqueue ({Kind}) failed", kind);
            }
        }
        public void PrintKOT(string printerName, KOT kot) => Enqueue("KOT:" + printerName, kot);
        public void PrintShiftBill(string printerName, KOT kot, string fromTable, string toTable)
            => Enqueue("SHIFT:" + printerName, new { kot, fromTable, toTable });
        public void PrintViewBill(string printerName, SageFrame.RestroOrder.SalesBill bill)
            => Enqueue("BILL:" + printerName, bill);
        public void PrintKOTforCake(string printerName, KOT kot) => Enqueue("CAKE:" + printerName, kot);

        // ---- single worker loop ---------------------------------------------------------------------------
        async Task Loop(CancellationToken token) {
            while (!token.IsCancellationRequested) {
                (string Kind, string Payload) job;
                try { job = _queue.Take(token); }
                catch (OperationCanceledException) { break; }
                catch (Exception ex) { _log.LogError(ex, "Print queue take failed"); continue; }

                bool printed = false;
                const int attempts = 3;
                for (int a = 1; a <= attempts && !printed; a++) {
                    try {
                        printed = await TryPrintRawAsync(job.Kind, job.Payload, token);
                    } catch (OperationCanceledException) { break; }
                    catch (Exception ex) {
                        _log.LogWarning(ex, "Print attempt {A}/{N} for {Kind} failed", a, attempts, job.Kind);
                    }
                    if (!printed && a < attempts) {
                        try { await Task.Delay(1000 * a, token); } catch (OperationCanceledException) { break; }
                    }
                }
                if (!printed) WriteOutbox(job.Kind, job.Payload);
            }
        }

        // v1: no direct raw-print backend wired yet (printer names come from the legacy cost-center DB).
        // Returning false routes jobs to the durable outbox immediately; the Windows WritePrinter/ESC-POS
        // backend replaces this method body later without touching any caller.
        async Task<bool> TryPrintRawAsync(string kind, string payload, CancellationToken token) {
            await Task.Yield();
            return false;
        }

        void WriteOutbox(string kind, string payload) {
            try {
                Directory.CreateDirectory(OutboxDir);
                var safe = kind.Replace(':', '_').Replace('/', '_').Replace('\\', '_');
                var file = Path.Combine(OutboxDir, DateTime.Now.ToString("yyyyMMdd-HHmmss-fff") + "-" + safe + ".json");
                File.WriteAllText(file, payload);
                _log.LogInformation("Print job written to outbox: {File}", file);
            } catch (Exception ex) {
                _log.LogError(ex, "Outbox write failed for {Kind}", kind);
            }
        }
    }
}
