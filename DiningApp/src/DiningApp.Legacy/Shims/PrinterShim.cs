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
