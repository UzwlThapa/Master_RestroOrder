// Production IWaiterNotifier for the legacy waiter-call bell (usp_GetWaiterLog rows -> UDP wake packet).
// Legacy parity: SageFrame ran a Hangfire job that pinged the waiter's registered LAN IP so the waiter
// tablet rang. Here we send a small UDP datagram to the configured port of the waiter IP. Failures are
// logged and swallowed — a dead waiter device must never fail an order request (same posture as the
// Hangfire shim). Port comes from Dining:UdpNotifyPort (default 51100; see appsettings.example.json).
#pragma warning disable
using System;
using System.Collections.Concurrent;
using System.Net.Sockets;
using System.Threading;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace DiningApp.Api {
    public class UdpWaiterNotifier : IWaiterNotifier {
        static readonly TimeSpan Throttle = TimeSpan.FromSeconds(2);
        readonly ILogger<UdpWaiterNotifier> _log;
        readonly int _port;
        readonly ConcurrentDictionary<string, DateTime> _lastSent = new();

        public UdpWaiterNotifier(ILogger<UdpWaiterNotifier> log, IConfiguration cfg) {
            _log = log;
            _port = cfg.GetValue<int?>("Dining:UdpNotifyPort") ?? 51100;
        }

        public void CallWaiter(string waiterIp) {
            try {
                if (string.IsNullOrWhiteSpace(waiterIp)) return; // stale registration (device off Wi-Fi)
                var now = DateTime.UtcNow;
                // Throttle bursts: multiple items ordered at once should ring once per waiter per 2s.
                var last = _lastSent.GetOrAdd(waiterIp, DateTime.MinValue);
                if (now - last < Throttle) return;
                _lastSent[waiterIp] = now;
                using (var udp = new UdpClient()) {
                    var payload = System.Text.Encoding.ASCII.GetBytes("WAITERCALL");
                    udp.Send(payload, payload.Length, waiterIp, _port);
                }
            } catch (Exception ex) {
                _log.LogWarning(ex, "Waiter call notification to {Ip} failed (ignored by design).", waiterIp);
            }
        }
    }
}
