using OfficeOpenXml;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Text;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace SageFrame.RestroOrder
{
    public class DailyReportController
    {
        private DailyReportProvider dailyReportProvider;
        private RestrOrderProvider restroOrderProvider;

        // Maps the sheet name shown in the Table Of Contents to its TOC row,
        // used to generate both the TOC links and the per-sheet "back" link.
        private static readonly (string SheetName, int TocRow)[] TocEntries = new[]
        {
            ("Summary", 10),
            ("Daily Sales Report", 11),
            ("Item Sales Report", 12),
            ("Card Transactions", 13),
            ("Cheque Transactions", 14),
            ("Credit Collection", 15),
            ("Daily Purchase Report", 16),
            ("Daily Stock Report", 17),
            ("Customers", 18),
            ("Vendors", 19),
        };

        public DailyReportController()
        {
            dailyReportProvider = new DailyReportProvider();
            restroOrderProvider = new RestrOrderProvider();
        }

        /// <summary>
        /// Locates the Excel template file by searching several common locations.
        /// Logs all attempts and throws if not found.
        /// </summary>
        private string ResolveTemplatePath(string templateBasePath, string logPath)
        {
            string templateFileName = "RestroOrder_Daily_Report_AsOf_Template.xlsx";

            var candidates = new List<string>();
            candidates.Add(Path.Combine(templateBasePath, templateFileName));

            string assemblyDir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            if (assemblyDir != null)
            {
                candidates.Add(Path.Combine(assemblyDir, templateFileName));
                candidates.Add(Path.Combine(assemblyDir, "Documents", "XLSX", templateFileName));
            }

            string appBase = AppDomain.CurrentDomain.BaseDirectory;
            candidates.Add(Path.Combine(appBase, templateFileName));
            candidates.Add(Path.Combine(appBase, "Documents", "XLSX", templateFileName));
            candidates.Add(Path.Combine(appBase, "..", "Documents", "XLSX", templateFileName));

            if (assemblyDir != null)
            {
                string dir = assemblyDir;
                for (int i = 0; i < 4; i++)
                {
                    dir = Path.GetDirectoryName(dir);
                    if (string.IsNullOrEmpty(dir)) break;
                    candidates.Add(Path.Combine(dir, "Documents", "XLSX", templateFileName));
                }
            }

            foreach (var path in candidates)
            {
                try
                {
                    string normalized = Path.GetFullPath(path);
                    if (File.Exists(normalized))
                    {
                        File.AppendAllText(logPath,
                            "[" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "] Template found at: " + normalized + "\n");
                        return normalized;
                    }
                }
                catch { /* skip invalid paths */ }
            }

            var tried = string.Join("\n  ", candidates.Select(p =>
            { try { return Path.GetFullPath(p); } catch { return p; } }));
            string error = "Template '" + templateFileName + "' not found. Searched:\n  " + tried;
            File.AppendAllText(logPath,
                "[" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "] ERROR: " + error + "\n");

            throw new FileNotFoundException(error, templateFileName);
        }

        /// <summary>
        /// Writes a live worksheet hyperlink into the Table Of Contents row for the given sheet
        /// and styles it as a link (blue, underlined). Re-created on every run, so it can never
        /// go stale even if sheet names change later.
        /// </summary>
        private void CreateTocLink(ExcelWorksheet toc, int row, string targetSheet)
        {
            var cell = toc.Cells["E" + row];
            cell.Hyperlink = new ExcelHyperLink("'" + targetSheet + "'!A1", targetSheet);
            cell.Style.Font.UnderLine = true;
            cell.Style.Font.Color.SetColor(Color.Blue);
        }

        /// <summary>
        /// Attaches a "back to contents" hyperlink to A1 of a report sheet. The template already
        /// contains the "&lt; Back" label text and styling in A1 — this only wires up the link.
        /// </summary>
        private void AddBackLink(ExcelWorksheet ws)
        {
            var cell = ws.Cells["A1"];
            cell.Hyperlink = new ExcelHyperLink("'Table Of Contents'!A1", "Table Of Contents");
        }

        public void GenerateXlsxFile(string date, string templateBasePath)
        {
            if (!Directory.Exists(templateBasePath))
                Directory.CreateDirectory(templateBasePath);

            string logPath = Path.Combine(templateBasePath, "MailLog.txt");
            string templatePath = ResolveTemplatePath(templateBasePath, logPath);

            DateTime reportDate;
            string[] formats = { "yyyyMMdd", "yyyy-MM-dd", "MM/dd/yyyy", "M/d/yyyy", "dd/MM/yyyy" };
            if (!DateTime.TryParseExact(date, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out reportDate))
            {
                reportDate = DateTime.Today;
                File.AppendAllText(logPath,
                    "[" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "] WARNING: Could not parse '" + date + "', using today (" + reportDate.ToString("yyyyMMdd") + ").\n");
            }
            else
            {
                File.AppendAllText(logPath,
                    "[" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "] GenerateXlsxFile called with date: " + date + " -> parsed as " + reportDate.ToString("yyyyMMdd") + "\n");
            }

            string safeDate = reportDate.ToString("yyyyMMdd");

            using (ExcelPackage p = new ExcelPackage())
            {
                using (FileStream stream = new FileStream(templatePath, FileMode.Open))
                {
                    p.Load(stream);
                    ExcelWorksheet worksheetTOC = p.Workbook.Worksheets["Table Of Contents"];
                    worksheetTOC.Cells["D6"].Value = reportDate.ToLongDateString();

                    ExcelWorksheet worksheetSummary = p.Workbook.Worksheets["Summary"];
                    ExcelWorksheet worksheetCard = p.Workbook.Worksheets["Card Transactions"];
                    ExcelWorksheet worksheetCheque = p.Workbook.Worksheets["Cheque Transactions"];
                    ExcelWorksheet worksheetSales = p.Workbook.Worksheets["Daily Sales Report"];
                    ExcelWorksheet worksheetStocks = p.Workbook.Worksheets["Daily Stock Report"];
                    ExcelWorksheet worksheetCreditors = p.Workbook.Worksheets["Customers"];
                    ExcelWorksheet worksheetVendors = p.Workbook.Worksheets["Vendors"];
                    ExcelWorksheet worksheetPurchase = p.Workbook.Worksheets["Daily Purchase Report"];
                    ExcelWorksheet worksheetCreditCollection = p.Workbook.Worksheets["Credit Collection"];
                    ExcelWorksheet worksheetItemSales = p.Workbook.Worksheets["Item Sales Report"];
                    // NOTE: the old "worksheetCredit" variable was a duplicate reference to
                    // "Cheque Transactions" and was never used anywhere — removed.

                    // ---- Table Of Contents: generate real hyperlinks every run ----
                    foreach (var entry in TocEntries)
                        CreateTocLink(worksheetTOC, entry.TocRow, entry.SheetName);

                    // ---- Every report sheet: wire up the "< Back" link in A1 ----
                    AddBackLink(worksheetSummary);
                    AddBackLink(worksheetSales);
                    AddBackLink(worksheetItemSales);
                    AddBackLink(worksheetCard);
                    AddBackLink(worksheetCheque);
                    AddBackLink(worksheetStocks);
                    AddBackLink(worksheetCreditCollection);
                    AddBackLink(worksheetPurchase);
                    AddBackLink(worksheetCreditors);
                    AddBackLink(worksheetVendors);

                    // Credit Collection
                    List<CreditPayReport> creditCollectionList = getCreditPayReportByDates(
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture), true);
                    int rowIdex = 10;
                    foreach (CreditPayReport row in creditCollectionList)
                    {
                        worksheetCreditCollection.Cells["D" + rowIdex].Value = row.AddedOn;
                        worksheetCreditCollection.Cells["E" + rowIdex].Value = row.CustName;
                        worksheetCreditCollection.Cells["F" + rowIdex].Value = row.PaymentMode;
                        worksheetCreditCollection.Cells["G" + rowIdex].Value = row.PayAmount;
                        worksheetCreditCollection.Cells["G" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetCreditCollection.Cells["H" + rowIdex].Value = row.AddedBy;
                        rowIdex++;
                    }
                    using (ExcelRange Rng = worksheetCreditCollection.Cells[10, 4, rowIdex, 8])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8));
                    }
                    using (ExcelRange Rng = worksheetCreditCollection.Cells[rowIdex, 4, rowIdex, 8])
                    {
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 10));
                        dataFont.Bold = true;
                        Rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        Rng.Style.Fill.BackgroundColor.SetColor(Color.LightGray);
                    }
                    if (creditCollectionList.Count > 0)
                    {
                        worksheetCreditCollection.Cells["D" + rowIdex].Value = "Total";
                        worksheetCreditCollection.Cells["G" + (rowIdex).ToString()].Formula = "SUM(G10:G" + (rowIdex - 1).ToString() + ")";
                        worksheetCreditCollection.Cells["G" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                    }

                    // Purchase Report
                    List<dailyreport> purchaseList = getdailyReportByReportNumber(
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture), 4); //4 for purchase report
                    rowIdex = 10;
                    foreach (dailyreport row in purchaseList)
                    {
                        worksheetPurchase.Cells["D" + rowIdex].Value = rowIdex - 9;
                        worksheetPurchase.Cells["E" + rowIdex].Value = row.PuNo;
                        worksheetPurchase.Cells["F" + rowIdex].Value = row.VenderName;
                        worksheetPurchase.Cells["G" + rowIdex].Value = row.Address;
                        worksheetPurchase.Cells["H" + rowIdex].Value = row.ITName;
                        worksheetPurchase.Cells["I" + rowIdex].Value = row.Qnty;
                        worksheetPurchase.Cells["J" + rowIdex].Value = row.UnitName;
                        worksheetPurchase.Cells["K" + rowIdex].Value = row.UnitRate;
                        worksheetPurchase.Cells["K" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetPurchase.Cells["L" + rowIdex].Value = row.Vat;
                        worksheetPurchase.Cells["L" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetPurchase.Cells["M" + rowIdex].Value = row.sumAmount;
                        worksheetPurchase.Cells["M" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetPurchase.Cells["N" + rowIdex].Value = row.fyName;
                        worksheetPurchase.Cells["O" + rowIdex].Value = row.PostedBy;
                        worksheetPurchase.Cells["P" + rowIdex].Value = row.PostedOn;
                        rowIdex++;
                    }
                    using (ExcelRange Rng = worksheetPurchase.Cells[10, 4, rowIdex, 16])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8));
                    }
                    using (ExcelRange Rng = worksheetPurchase.Cells[rowIdex, 4, rowIdex, 16])
                    {
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 10));
                        dataFont.Bold = true;
                        Rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        Rng.Style.Fill.BackgroundColor.SetColor(Color.LightGray);
                    }
                    if (purchaseList.Count > 0)
                    {
                        worksheetPurchase.Cells["D" + rowIdex].Value = "Total";
                        worksheetPurchase.Cells["M" + (rowIdex).ToString()].Formula = "SUM(M10:M" + (rowIdex - 1).ToString() + ")";
                        worksheetPurchase.Cells["M" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                    }

                    // Daily Sales Report
                    List<SalesReport> salesList = GenerateDailySalesReport(safeDate);
                    rowIdex = 10;
                    foreach (SalesReport row in salesList)
                    {
                        worksheetSales.Cells["D" + rowIdex].Value = row.BillNo;
                        worksheetSales.Cells["E" + rowIdex].Value = row.BillTime;
                        worksheetSales.Cells["F" + rowIdex].Value = row.BasicAmount;
                        worksheetSales.Cells["F" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["G" + rowIdex].Value = row.TotalDiscount;
                        worksheetSales.Cells["G" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["H" + rowIdex].Value = row.ServiceCharge;
                        worksheetSales.Cells["H" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["I" + rowIdex].Value = row.VAT;
                        worksheetSales.Cells["I" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["J" + rowIdex].Value = row.NetAmount;
                        worksheetSales.Cells["J" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["K" + rowIdex].Value = row.TenderAmount;
                        worksheetSales.Cells["K" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["L" + rowIdex].Value = row.ReturnAmount;
                        worksheetSales.Cells["L" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["M" + rowIdex].Value = row.ReceivedAmount;
                        worksheetSales.Cells["M" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["N" + rowIdex].Value = row.ChequeAmount;
                        worksheetSales.Cells["N" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["O" + rowIdex].Value = row.CardAmount;
                        worksheetSales.Cells["O" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["P" + rowIdex].Value = row.CreditAmount;
                        worksheetSales.Cells["P" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["Q" + rowIdex].Value = row.PaymentMode;
                        worksheetSales.Cells["R" + rowIdex].Value = row.Customer;
                        rowIdex++;
                    }
                    using (ExcelRange Rng = worksheetSales.Cells[10, 4, rowIdex, 18])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8));
                    }
                    using (ExcelRange Rng = worksheetSales.Cells[rowIdex, 4, rowIdex, 18])
                    {
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 10));
                        dataFont.Bold = true;
                        Rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        Rng.Style.Fill.BackgroundColor.SetColor(Color.LightGray);
                    }
                    if (salesList.Count > 0)
                    {
                        worksheetSales.Cells["D" + rowIdex].Value = "Total";
                        worksheetSales.Cells["F" + (rowIdex).ToString()].Formula = "SUM(F10:F" + (rowIdex - 1).ToString() + ")";
                        worksheetSales.Cells["F" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["G" + (rowIdex).ToString()].Formula = "SUM(G10:G" + (rowIdex - 1).ToString() + ")";
                        worksheetSales.Cells["G" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["H" + (rowIdex).ToString()].Formula = "SUM(H10:H" + (rowIdex - 1).ToString() + ")";
                        worksheetSales.Cells["H" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["I" + (rowIdex).ToString()].Formula = "SUM(I10:I" + (rowIdex - 1).ToString() + ")";
                        worksheetSales.Cells["I" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["J" + (rowIdex).ToString()].Formula = "SUM(J10:J" + (rowIdex - 1).ToString() + ")";
                        worksheetSales.Cells["J" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["K" + (rowIdex).ToString()].Formula = "SUM(K10:K" + (rowIdex - 1).ToString() + ")";
                        worksheetSales.Cells["K" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["L" + (rowIdex).ToString()].Formula = "SUM(L10:L" + (rowIdex - 1).ToString() + ")";
                        worksheetSales.Cells["L" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["M" + (rowIdex).ToString()].Formula = "SUM(M10:M" + (rowIdex - 1).ToString() + ")";
                        worksheetSales.Cells["M" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["N" + (rowIdex).ToString()].Formula = "SUM(N10:N" + (rowIdex - 1).ToString() + ")";
                        worksheetSales.Cells["N" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["O" + (rowIdex).ToString()].Formula = "SUM(O10:O" + (rowIdex - 1).ToString() + ")";
                        worksheetSales.Cells["O" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSales.Cells["P" + (rowIdex).ToString()].Formula = "SUM(P10:P" + (rowIdex - 1).ToString() + ")";
                        worksheetSales.Cells["P" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                    }

                    // Day-part sales
                    List<SalesReport> dayPartSalesList = dailyReportProvider.GetDayPartWiseSalesReport(safeDate);
                    rowIdex = 10;
                    foreach (SalesReport row in dayPartSalesList)
                    {
                        if (row.Customer == "BREAKFAST")
                        {
                            worksheetSales.Cells["U12"].Value = row.BasicAmount;
                            worksheetSales.Cells["U12"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["U13"].Value = row.TotalDiscount;
                            worksheetSales.Cells["U13"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["U14"].Value = row.ServiceCharge;
                            worksheetSales.Cells["U14"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["U15"].Value = row.VAT;
                            worksheetSales.Cells["U15"].Style.Numberformat.Format = "###,###,##0.00";
                        }
                        else if (row.Customer == "DINNER")
                        {
                            worksheetSales.Cells["U19"].Value = row.BasicAmount;
                            worksheetSales.Cells["U19"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["U20"].Value = row.TotalDiscount;
                            worksheetSales.Cells["U20"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["U21"].Value = row.ServiceCharge;
                            worksheetSales.Cells["U21"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["U22"].Value = row.VAT;
                            worksheetSales.Cells["U22"].Style.Numberformat.Format = "###,###,##0.00";
                        }
                        else if (row.Customer == "LUNCH")
                        {
                            worksheetSales.Cells["X12"].Value = row.BasicAmount;
                            worksheetSales.Cells["X12"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["X13"].Value = row.TotalDiscount;
                            worksheetSales.Cells["X13"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["X14"].Value = row.ServiceCharge;
                            worksheetSales.Cells["X14"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["X15"].Value = row.VAT;
                            worksheetSales.Cells["X15"].Style.Numberformat.Format = "###,###,##0.00";
                        }
                        else if (row.Customer == "TOTAL")
                        {
                            worksheetSales.Cells["X19"].Value = row.BasicAmount;
                            worksheetSales.Cells["X19"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["X20"].Value = row.TotalDiscount;
                            worksheetSales.Cells["X20"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["X21"].Value = row.ServiceCharge;
                            worksheetSales.Cells["X21"].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetSales.Cells["X22"].Value = row.VAT;
                            worksheetSales.Cells["X22"].Style.Numberformat.Format = "###,###,##0.00";
                        }
                    }
                    worksheetSales.Cells["U16"].Formula = "ROUND(U12-U13+U14+U15,2)";
                    worksheetSales.Cells["U16"].Style.Numberformat.Format = "###,###,##0.00";
                    worksheetSales.Cells["U23"].Formula = "ROUND(U19-U20+U21+U22,2)";
                    worksheetSales.Cells["U23"].Style.Numberformat.Format = "###,###,##0.00";
                    worksheetSales.Cells["X16"].Formula = "ROUND(X12-X13+X14+X15,2)";
                    worksheetSales.Cells["X16"].Style.Numberformat.Format = "###,###,##0.00";
                    worksheetSales.Cells["X23"].Formula = "ROUND(X19+X20+X21+X22,2)";
                    worksheetSales.Cells["X23"].Style.Numberformat.Format = "###,###,##0.00";

                    // Card Transactions
                    List<providersReport> cardSalesList = getAllProvidersReport(
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture), 3, 0);
                    rowIdex = 10;
                    foreach (providersReport row in cardSalesList)
                    {
                        worksheetCard.Cells["D" + rowIdex].Value = row.billDate;
                        worksheetCard.Cells["E" + rowIdex].Value = row.billNo;
                        worksheetCard.Cells["F" + rowIdex].Value = row.restroRoom;
                        worksheetCard.Cells["G" + rowIdex].Value = row.restrotableTitle;
                        worksheetCard.Cells["H" + rowIdex].Value = row.ProviderName;
                        worksheetCard.Cells["I" + rowIdex].Value = "CARD";
                        worksheetCard.Cells["J" + rowIdex].Value = "";
                        worksheetCard.Cells["K" + rowIdex].Value = row.TransactionNo;
                        worksheetCard.Cells["L" + rowIdex].Value = row.payAmount;
                        worksheetCard.Cells["L" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        rowIdex++;
                    }
                    using (ExcelRange Rng = worksheetCard.Cells[10, 4, rowIdex, 12])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8));
                    }
                    using (ExcelRange Rng = worksheetCard.Cells[rowIdex, 4, rowIdex, 12])
                    {
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 10));
                        dataFont.Bold = true;
                        Rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        Rng.Style.Fill.BackgroundColor.SetColor(Color.LightGray);
                    }
                    if (cardSalesList.Count > 0)
                    {
                        worksheetCard.Cells["D" + rowIdex].Value = "Total";
                        worksheetCard.Cells["L" + (rowIdex).ToString()].Formula = "SUM(L10:L" + (rowIdex - 1).ToString() + ")";
                        worksheetCard.Cells["L" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                    }

                    // Cheque Transactions
                    List<providersReport> chequeSalesList = getAllProvidersReport(
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture), 2, 0);
                    rowIdex = 10;
                    foreach (providersReport row in chequeSalesList)
                    {
                        worksheetCheque.Cells["D" + rowIdex].Value = row.billDate;
                        worksheetCheque.Cells["E" + rowIdex].Value = row.billNo;
                        worksheetCheque.Cells["F" + rowIdex].Value = row.restroRoom;
                        worksheetCheque.Cells["G" + rowIdex].Value = row.restrotableTitle;
                        worksheetCheque.Cells["H" + rowIdex].Value = row.ProviderName;
                        worksheetCheque.Cells["I" + rowIdex].Value = "CHEQUE";
                        worksheetCheque.Cells["J" + rowIdex].Value = row.ChequeNo;
                        worksheetCheque.Cells["K" + rowIdex].Value = "";
                        worksheetCheque.Cells["L" + rowIdex].Value = row.payAmount;
                        worksheetCheque.Cells["L" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        rowIdex++;
                    }
                    using (ExcelRange Rng = worksheetCheque.Cells[10, 4, rowIdex, 12])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8));
                    }
                    using (ExcelRange Rng = worksheetCheque.Cells[rowIdex, 4, rowIdex, 11])
                    {
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 10));
                        dataFont.Bold = true;
                        Rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                        Rng.Style.Fill.BackgroundColor.SetColor(Color.LightGray);
                    }
                    if (chequeSalesList.Count > 0)
                    {
                        worksheetCheque.Cells["D" + rowIdex].Value = "Total";
                        worksheetCheque.Cells["L" + (rowIdex).ToString()].Formula = "SUM(L10:L" + (rowIdex - 1).ToString() + ")";
                        worksheetCheque.Cells["L" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                    }

                    // Daily Stock Report
                    List<StockReport> stockList = GenerateDailyStockReport(safeDate);
                    rowIdex = 10;
                    foreach (StockReport row in stockList)
                    {
                        worksheetStocks.Cells["D" + rowIdex].Value = row.ItemName;
                        worksheetStocks.Cells["E" + rowIdex].Value = row.OpeningBalance;
                        worksheetStocks.Cells["F" + rowIdex].Value = row.PurchaseBalance;
                        worksheetStocks.Cells["G" + rowIdex].Value = row.ConsumedBalance;
                        worksheetStocks.Cells["H" + rowIdex].Value = row.ClosingBalance;
                        worksheetStocks.Cells["I" + rowIdex].Value = row.Symbol;
                        rowIdex++;
                    }
                    using (ExcelRange Rng = worksheetStocks.Cells[10, 4, rowIdex, 9])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8));
                    }

                    // Summary Report
                    List<SummaryReport> summaryReportList = GenerateDailySummaryReport(safeDate);
                    rowIdex = 9;
                    foreach (SummaryReport row in summaryReportList)
                    {
                        worksheetSummary.Cells["F9"].Value = row.OpeningBalance;
                        worksheetSummary.Cells["F9"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F10"].Value = row.Cash;
                        worksheetSummary.Cells["F10"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F11"].Value = row.Card;
                        worksheetSummary.Cells["F11"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F12"].Value = row.Cheque;
                        worksheetSummary.Cells["F12"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F13"].Value = row.Credit;
                        worksheetSummary.Cells["F13"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F14"].Value = row.eSewa;
                        worksheetSummary.Cells["F14"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F15"].Value = row.FonePay;
                        worksheetSummary.Cells["F15"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F16"].Value = row.SurplusDeficit;
                        worksheetSummary.Cells["F16"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F17"].Value = row.CreditCollectedInCash;
                        worksheetSummary.Cells["F17"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F18"].Value = row.CreditCollectedInCard;
                        worksheetSummary.Cells["F18"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F19"].Value = row.CreditCollectedInCheque;
                        worksheetSummary.Cells["F19"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F20"].Value = row.CreditCollectedIneSewa;
                        worksheetSummary.Cells["F20"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F21"].Value = row.CreditCollectedInFonePay;
                        worksheetSummary.Cells["F21"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F22"].Value = row.AdvanceCollectedInCash;
                        worksheetSummary.Cells["F22"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F23"].Value = row.AdvanceCollectedInCard;
                        worksheetSummary.Cells["F23"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F24"].Value = row.AdvanceCollectedInCheque;
                        worksheetSummary.Cells["F24"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F25"].Value = row.AdvanceCollectedIneSewa;
                        worksheetSummary.Cells["F25"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F26"].Value = row.AdvanceCollectedInFonePay;
                        worksheetSummary.Cells["F26"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F27"].Value = row.TotalCashReceived;
                        worksheetSummary.Cells["F27"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F28"].Value = row.TotalExpenses;
                        worksheetSummary.Cells["F28"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F29"].Value = row.CashInCounter;
                        worksheetSummary.Cells["F29"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F30"].Value = row.CashSettlement;
                        worksheetSummary.Cells["F30"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["F31"].Value = row.ClosingBalance;
                        worksheetSummary.Cells["F31"].Style.Numberformat.Format = "###,###,##0.00";
                    }

                    CashDenomination deno = dailyReportProvider.GetCashDenomination();
                    worksheetSummary.Cells["H10"].Value = deno.thousand;
                    worksheetSummary.Cells["H11"].Value = deno.fivehundred;
                    worksheetSummary.Cells["H12"].Value = deno.hundred;
                    worksheetSummary.Cells["H13"].Value = deno.fifty;
                    worksheetSummary.Cells["H14"].Value = deno.twenty;
                    worksheetSummary.Cells["H15"].Value = deno.ten;
                    worksheetSummary.Cells["H16"].Value = deno.five;
                    worksheetSummary.Cells["H17"].Value = deno.two;
                    worksheetSummary.Cells["H18"].Value = deno.one;

                    // Provider summary
                    List<providersReport> summaryProviders = restroOrderProvider.getSummaryProvidersReport(
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture), 0, 0);
                    rowIdex = 10;
                    foreach (providersReport row in summaryProviders)
                    {
                        worksheetSummary.Cells["K" + rowIdex].Value = row.ProviderName;
                        worksheetSummary.Cells["L" + rowIdex].Value = row.payAmount;
                        worksheetSummary.Cells["L" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        rowIdex++;
                    }
                    using (ExcelRange Rng = worksheetSummary.Cells[10, 11, rowIdex, 12])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8));
                    }

                    // Cost Center
                    List<costCenterReport> summaryCostCenter = restroOrderProvider.getSummaryCostCenterReport(
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture),
                        DateTime.ParseExact(safeDate, "yyyyMMdd", CultureInfo.InvariantCulture), 0);
                    rowIdex = 10;
                    foreach (costCenterReport row in summaryCostCenter)
                    {
                        worksheetSummary.Cells["N" + rowIdex].Value = row.CostCenterName;
                        worksheetSummary.Cells["O" + rowIdex].Value = row.Total;
                        worksheetSummary.Cells["O" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        rowIdex++;
                    }
                    using (ExcelRange Rng = worksheetSummary.Cells[10, 14, rowIdex, 15])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8));
                    }

                    // Creditors
                    List<CreditorBalanceReport> creditorBalanceReportList = GenerateDailyCreditorsReport();
                    rowIdex = 10;
                    foreach (CreditorBalanceReport row in creditorBalanceReportList)
                    {
                        worksheetCreditors.Cells["D" + rowIdex].Value = row.Fname + " " + row.Lname;
                        worksheetCreditors.Cells["E" + rowIdex].Value = row.Country;
                        worksheetCreditors.Cells["F" + rowIdex].Value = row.City;
                        worksheetCreditors.Cells["G" + rowIdex].Value = row.Address;
                        worksheetCreditors.Cells["H" + rowIdex].Value = row.TelMobile;
                        worksheetCreditors.Cells["I" + rowIdex].Value = row.CardNumber;
                        worksheetCreditors.Cells["J" + rowIdex].Value = row.PAN;
                        worksheetCreditors.Cells["K" + rowIdex].Value = row.RemainingBalance;
                        worksheetCreditors.Cells["K" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        rowIdex++;
                    }
                    using (ExcelRange Rng = worksheetCreditors.Cells[10, 4, rowIdex, 11])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8));
                    }

                    // Vendors
                    List<CreditorBalanceReport> vendorBalanceReportList = GenerateDailyVendorsReport();
                    rowIdex = 10;
                    foreach (CreditorBalanceReport row in vendorBalanceReportList)
                    {
                        worksheetVendors.Cells["D" + rowIdex].Value = row.Fname + " " + row.Lname;
                        worksheetVendors.Cells["E" + rowIdex].Value = row.Country;
                        worksheetVendors.Cells["F" + rowIdex].Value = row.City;
                        worksheetVendors.Cells["G" + rowIdex].Value = row.Address;
                        worksheetVendors.Cells["H" + rowIdex].Value = row.TelMobile;
                        worksheetVendors.Cells["I" + rowIdex].Value = row.CardNumber;
                        worksheetVendors.Cells["J" + rowIdex].Value = row.PAN;
                        worksheetVendors.Cells["K" + rowIdex].Value = row.RemainingBalance;
                        worksheetVendors.Cells["K" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        rowIdex++;
                    }
                    using (ExcelRange Rng = worksheetVendors.Cells[10, 4, rowIdex, 11])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8));
                    }

                    // Item Sales Report
                    if (worksheetItemSales != null)
                    {
                        List<ItemSalesReport> itemSalesList = GetDailyItemSalesForMail(safeDate);
                        rowIdex = 10;
                        foreach (ItemSalesReport row in itemSalesList)
                        {
                            worksheetItemSales.Cells["D" + rowIdex].Value = row.Category;
                            worksheetItemSales.Cells["E" + rowIdex].Value = row.ItemName;
                            worksheetItemSales.Cells["F" + rowIdex].Value = row.Quantity;
                            worksheetItemSales.Cells["F" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetItemSales.Cells["G" + rowIdex].Value = row.ITUnit;
                            worksheetItemSales.Cells["H" + rowIdex].Value = row.UnitPrice;
                            worksheetItemSales.Cells["H" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetItemSales.Cells["I" + rowIdex].Value = row.NetAmount;
                            worksheetItemSales.Cells["I" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                            rowIdex++;
                        }
                        using (ExcelRange Rng = worksheetItemSales.Cells[10, 4, rowIdex, 9])
                        {
                            var border = Rng.Style.Border;
                            border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                            var dataFont = Rng.Style.Font;
                            dataFont.SetFromFont(new Font("Calibri", 8));
                        }
                        if (itemSalesList.Count > 0)
                        {
                            worksheetItemSales.Cells["D" + rowIdex].Value = "Total";
                            using (ExcelRange Rng = worksheetItemSales.Cells[rowIdex, 4, rowIdex, 9])
                            {
                                var dataFont = Rng.Style.Font;
                                dataFont.SetFromFont(new Font("Calibri", 10));
                                dataFont.Bold = true;
                                Rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                                Rng.Style.Fill.BackgroundColor.SetColor(Color.LightGray);
                            }
                            worksheetItemSales.Cells["F" + rowIdex].Formula = "SUM(F10:F" + (rowIdex - 1) + ")";
                            worksheetItemSales.Cells["F" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                            worksheetItemSales.Cells["I" + rowIdex].Formula = "SUM(I10:I" + (rowIdex - 1) + ")";
                            worksheetItemSales.Cells["I" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        }
                    }

                    // ---- AutoFit every populated sheet now that all data is in, before recalculation ----
                    foreach (var ws in p.Workbook.Worksheets)
                    {
                        if (ws.Dimension == null) continue;
                        ws.Cells[ws.Dimension.Address].AutoFitColumns();
                        for (int col = 1; col <= ws.Dimension.End.Column; col++)
                        {
                            if (ws.Column(col).Width > 40)
                                ws.Column(col).Width = 40;
                        }
                    }

                    // ---- Force Excel to recalculate on open, in case cached values go stale ----
                    p.Workbook.CalcMode = ExcelCalcMode.Automatic;
                    p.Workbook.FullCalcOnLoad = true;
                }
                p.Workbook.Calculate();
                var outputFilePath = templateBasePath + "\\RestroOrder_Daily_Report_AsOf_" + safeDate + ".xlsx";
                Byte[] bin = p.GetAsByteArray();
                File.WriteAllBytes(outputFilePath, bin);
            }
        }

        private void AddEmails(MailMessage mail, string csvEmails, string AddIn)
        {
            MailAddressCollection emails = new MailAddressCollection();
            string[] mails = csvEmails.Split(',');
            for (int i = 0; i < mails.Length; i++)
            {
                switch (AddIn)
                {
                    case "TO":
                        mail.To.Add(new MailAddress(mails[i]));
                        break;
                    case "CC":
                        mail.CC.Add(new MailAddress(mails[i]));
                        break;
                    case "BCC":
                        mail.Bcc.Add(new MailAddress(mails[i]));
                        break;
                }
            }
        }

        public string encrypt(string encryptString)
        {
            string EncryptionKey = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            byte[] clearBytes = Encoding.Unicode.GetBytes(encryptString);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] {
            0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76
        });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    encryptString = Convert.ToBase64String(ms.ToArray());
                }
            }
            return encryptString;
        }

        public string Decrypt(string cipherText)
        {
            string EncryptionKey = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            cipherText = cipherText.Replace(" ", "+");
            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] {
            0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76
        });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }

        public void SendMail(string date, string templateBasePath)
        {
            if (!Directory.Exists(templateBasePath))
                Directory.CreateDirectory(templateBasePath);
            string logPath = Path.Combine(templateBasePath, "MailLog.txt");

            DateTime reportDate;
            string[] formats = { "yyyyMMdd", "yyyy-MM-dd", "MM/dd/yyyy", "M/d/yyyy", "dd/MM/yyyy" };
            if (!DateTime.TryParseExact(date, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out reportDate))
            {
                reportDate = DateTime.Today;
                File.AppendAllText(logPath,
                    "[" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "] WARNING: SendMail could not parse '" + date + "', using today (" + reportDate.ToString("yyyyMMdd") + ").\n");
            }
            else
            {
                File.AppendAllText(logPath,
                    "[" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "] SendMail called with date: '" + date + "' -> parsed as " + reportDate.ToString("yyyyMMdd") + "\n");
            }
            string safeDate = reportDate.ToString("yyyyMMdd");

            List<companyInfo> companies = restroOrderProvider.getCompanyInfo();
            string companyName = (companies != null && companies.Count > 0) ? companies[0].Name : "RestroOrder";
            string safeCompanyName = Regex.Replace(companyName, @"[^\w\s\-\.]", "").Trim();

            var MailKey = Decrypt(dailyReportProvider.Mailkey("MailKey"));
            var MailVal = Decrypt(dailyReportProvider.MailValue("MailValue"));

            var attachmentPath = Path.Combine(templateBasePath, "RestroOrder_Daily_Report_AsOf_" + safeDate + ".xlsx");
            if (!File.Exists(attachmentPath))
            {
                File.AppendAllText(logPath,
                    "[" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "] File not found, generating: " + attachmentPath + "\n");
                try
                {
                    GenerateXlsxFile(safeDate, templateBasePath);
                    File.AppendAllText(logPath,
                        "[" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "] File generated successfully.\n");
                }
                catch (Exception genEx)
                {
                    File.AppendAllText(logPath,
                        "[" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "] ERROR generating file: " + genEx.Message + "\n");
                    throw;
                }
            }

            decimal totalSales = 0, cash = 0, card = 0, eSewa = 0, fonePay = 0;
            try
            {
                List<SummaryReport> s = GenerateDailySummaryReport(safeDate);
                if (s.Count > 0)
                {
                    totalSales = s[0].TotalSales;
                    cash = s[0].Cash;
                    card = s[0].Card;
                    eSewa = s[0].eSewa;
                    fonePay = s[0].FonePay;
                }
            }
            catch { /* non-fatal – mail still sends even if summary fails */ }

            string body = "<html><body style='font-family:Arial,sans-serif;font-size:14px;color:#1B2A4A;'>"
                + "<p>Dear Owner,</p>"
                + "<p>Please find the attached <strong>Daily Report for " + reportDate.ToString("dd MMM yyyy") + "</strong> from <strong>" + safeCompanyName + "</strong>.</p>"
                + "<table style='border-collapse:collapse;margin:12px 0;min-width:300px;'>"
                + "<tr style='background:#1B2A4A;color:#fff;'>"
                + "<th style='padding:8px 16px;text-align:left;'>Payment Mode</th>"
                + "<th style='padding:8px 16px;text-align:right;'>Amount (Rs.)</th>"
                + "</tr>"
                + "<tr style='background:#D6E8F5;'><td style='padding:6px 16px;'>Cash</td><td style='padding:6px 16px;text-align:right;'>" + cash.ToString("N2") + "</td></tr>"
                + "<tr><td style='padding:6px 16px;'>Card</td><td style='padding:6px 16px;text-align:right;'>" + card.ToString("N2") + "</td></tr>"
                + "<tr style='background:#D6E8F5;'><td style='padding:6px 16px;'>eSewa</td><td style='padding:6px 16px;text-align:right;'>" + eSewa.ToString("N2") + "</td></tr>"
                + "<tr><td style='padding:6px 16px;'>FonePay</td><td style='padding:6px 16px;text-align:right;'>" + fonePay.ToString("N2") + "</td></tr>"
                + "<tr style='background:#1B2A4A;color:#fff;font-weight:bold;'>"
                + "<td style='padding:8px 16px;'>Total Sales</td>"
                + "<td style='padding:8px 16px;text-align:right;'>" + totalSales.ToString("N2") + "</td>"
                + "</tr>"
                + "</table>"
                + "<p>Full details in the attached Excel report.</p>"
                + "<p style='color:#888;font-size:12px;'>Regards,<br/>" + safeCompanyName + " — RestroOrder System</p>"
                + "</body></html>";

            const int maxRetries = 3;
            const int delaySeconds = 30;
            Exception lastEx = null;

            for (int attempt = 1; attempt <= maxRetries; attempt++)
            {
                SmtpClient smtp = new SmtpClient
                {
                    Host = "smtp.gmail.com",
                    Port = 587,
                    EnableSsl = true,
                    DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network,
                    UseDefaultCredentials = false,
                    Credentials = new System.Net.NetworkCredential(MailVal, MailKey)
                };
                MailMessage mail = new MailMessage();
                try
                {
                    mail.From = new MailAddress(MailVal, safeCompanyName);
                    mail.Subject = safeCompanyName + " - RestroOrder Daily Report - " + reportDate.ToString("dd MMM yyyy");
                    mail.Body = body;
                    mail.IsBodyHtml = true;

                    mail.Headers.Add("X-Mailer", "RestroOrder System");
                    mail.Headers.Add("Message-ID", "<" + safeDate + "." + Guid.NewGuid().ToString("N") + "@restroorder.com>");
                    mail.Priority = MailPriority.Normal;

                    AddEmails(mail, System.Configuration.ConfigurationManager.AppSettings["MailTo"].ToString(), "TO");

                    string cc = System.Configuration.ConfigurationManager.AppSettings["MailCC"] ?? "";
                    if (cc.Length > 5)
                        AddEmails(mail, cc, "CC");

                    mail.Attachments.Add(new Attachment(attachmentPath));
                    smtp.Send(mail);

                    File.AppendAllText(logPath,
                        "[" + DateTime.Now.ToString() + "] Mail sent OK for " + safeDate + " (attempt " + attempt.ToString() + ") from " + safeCompanyName + "\r\n");
                    return;
                }
                catch (Exception ex)
                {
                    lastEx = ex;
                    File.AppendAllText(logPath,
                        "[" + DateTime.Now.ToString() + "] Attempt " + attempt.ToString() + "/" + maxRetries.ToString() + " FAILED for " + safeDate + ": " + ex.Message + "\r\n");
                    if (attempt < maxRetries)
                        System.Threading.Thread.Sleep(delaySeconds * 1000);
                }
                finally
                {
                    mail.Dispose();
                    smtp.Dispose();
                }
            }
            throw new Exception("Mail failed after " + maxRetries.ToString() + " attempts for " + safeDate + ". See MailLog.txt.", lastEx);
        }

        public List<SalesReport> GenerateDailySalesReport(string period)
        {
            return dailyReportProvider.GenerateDailySalesReport(period);
        }

        public List<StockReport> GenerateDailyStockReport(string period)
        {
            return dailyReportProvider.GenerateDailyStockReport(period);
        }

        public List<SummaryReport> GenerateDailySummaryReport(string period)
        {
            return dailyReportProvider.GenerateDailySummaryReport(period);
        }

        public List<CreditorBalanceReport> GenerateDailyCreditorsReport()
        {
            return dailyReportProvider.GenerateDailyCreditorsReport();
        }

        public List<CreditorBalanceReport> GenerateDailyVendorsReport()
        {
            return dailyReportProvider.GenerateDailyVendorsReport();
        }

        public List<CreditPayReport> getCreditPayReportByDates(DateTime sdate, DateTime edate, bool? isCustomer)
        {
            return dailyReportProvider.getCreditPayReportByDates(sdate, edate, isCustomer);
        }

        public List<dailyreport> getdailyReportByReportNumber(DateTime startdate, DateTime enddate, int ReportNum)
        {
            return dailyReportProvider.getdailyReportByReportNumber(startdate, enddate, ReportNum);
        }

        public List<providersReport> getAllProvidersReport(DateTime startDate, DateTime endDate, int paymentMode, int provider)
        {
            return dailyReportProvider.getAllProvidersReport(startDate, endDate, paymentMode, provider);
        }

        public List<ItemSalesReport> GetDailyItemSalesForMail(string period)
        {
            return dailyReportProvider.GetDailyItemSalesForMail(period);
        }
    }
}