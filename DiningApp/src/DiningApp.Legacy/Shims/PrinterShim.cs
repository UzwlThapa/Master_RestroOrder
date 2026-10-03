// IPrinterBackend seam: production printing is delegated to a pluggable backend.
// The legacy SageFrame/App_Code/Printer.cs (GDI+ System.Drawing.Printing, 780 lines) only runs on Windows;
// DiningApp.Api registers the concrete backend at startup (Windows raw/GDI printer or queue-file fallback).
public interface IPrinterBackend {
    void PrintKOT(string printerName, KOT kot);
    void PrintShiftBill(string printerName, KOT kot, string fromTable, string toTable);
    void PrintViewBill(string printerName, SageFrame.RestroOrder.SalesBill bill);
    void PrintKOTforCake(string printerName, KOT kot);
}
public static class PrinterBackend {
    // Default: no-op (dev/offline). Replaced by DI in Program.cs for production.
    public static IPrinterBackend Current { get; set; } = new NullPrinterBackend();
}
// Waiter-call notification seam (legacy Hangfire job target). Pluggable like the printer backend;
// default is a no-op so callWaiter never faults when no notifier is configured.
public interface IWaiterNotifier { void CallWaiter(string waiterIp); }
public static class WaiterNotification {
    public static IWaiterNotifier Current { get; set; } = new NullWaiterNotifier();
    public static void CallWaiter(string waiterIp) => Current.CallWaiter(waiterIp);
}
public class NullWaiterNotifier : IWaiterNotifier { public void CallWaiter(string waiterIp) { } }
// Cash-drawer kick seam (legacy PrintRaw.CashDrawer.SendStringToPrinter, P/Invoke winspool.drv).
// Windows-only in production (DiningApp.Api wires RawCashDrawerBackend); no-op elsewhere so a
// missing/offline drawer never faults an order request.
public interface ICashDrawerBackend { void SendStringToPrinter(string printerName, string command); }
public static class CashDrawer {
    public static ICashDrawerBackend Current { get; set; } = new NullCashDrawerBackend();
    public static bool SendStringToPrinter(string printerName, string command) {
        try { Current.SendStringToPrinter(printerName, command); } catch { /* best-effort, legacy parity */ }
        return true;
    }
}
public class NullCashDrawerBackend : ICashDrawerBackend { public void SendStringToPrinter(string p, string c) { } }
public class NullPrinterBackend : IPrinterBackend {
    public void PrintKOT(string p, KOT k) { }
    public void PrintShiftBill(string p, KOT k, string f, string t) { }
    public void PrintViewBill(string p, SageFrame.RestroOrder.SalesBill b) { }
    public void PrintKOTforCake(string p, KOT k) { }
}
// Legacy-compatible façade so verbatim-ported OrderPrint.cs compiles unchanged.
public class Printer : IPrinterBackend {
    public void PrintKOT(string printerName, KOT KOT) => PrinterBackend.Current.PrintKOT(printerName, KOT);
    public void PrintShiftBill(string printerName, KOT KOT, string fromTable, string toTable) => PrinterBackend.Current.PrintShiftBill(printerName, KOT, fromTable, toTable);
    public void PrintViewBill(string printerName, SageFrame.RestroOrder.SalesBill bill) => PrinterBackend.Current.PrintViewBill(printerName, bill);
    public void PrintKOTforCake(string printerName, KOT KOT) => PrinterBackend.Current.PrintKOTforCake(printerName, KOT);
}
