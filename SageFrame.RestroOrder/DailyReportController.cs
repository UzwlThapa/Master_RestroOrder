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
        public DailyReportController()
        {
            dailyReportProvider = new DailyReportProvider();
            restroOrderProvider = new RestrOrderProvider();
        }
        public void GenerateXlsxFile(string date, string templateBasePath)
        {
            StringBuilder sb = new StringBuilder();
            foreach (Match m in Regex.Matches(date, @"\d"))
            {
                sb.Append(m);
            }
            string result = sb.ToString();
            //string date = DateTime.Now.AddMonths(-2).AddDays(-1).ToString("yyyyMMdd", System.Globalization.CultureInfo.GetCultureInfo("en-US"));
            DateTime reportDate = new DateTime(
                Convert.ToInt32(result.Substring(0, 4)),
                Convert.ToInt32(result.Substring(4, 2)),
                Convert.ToInt32(result.Substring(6, 2))
                );
            var templatePath = templateBasePath + "\\RestroOrder_Daily_Report_AsOf_Template.xlsx";
            using (ExcelPackage p = new ExcelPackage())
            {
                using (FileStream stream = new FileStream(templatePath, FileMode.Open))
                {
                    p.Load(stream);
                    ExcelWorksheet worksheetTOC = p.Workbook.Worksheets["Table Of Contents"];
                    worksheetTOC.Cells["D6"].Value = reportDate.ToLongDateString();
                    ExcelWorksheet worksheetSummary = p.Workbook.Worksheets["Summary"];
                    //worksheetSummary.Cells["D6"].Value = DateTime.Now.AddMonths(-2).AddDays(-1).ToLongDateString();
                    ExcelWorksheet worksheetCard = p.Workbook.Worksheets["Card Transactions"];
                    ExcelWorksheet worksheetCheque = p.Workbook.Worksheets["Cheque Transactions"];
                    ExcelWorksheet worksheetCredit = p.Workbook.Worksheets["Cheque Transactions"];
                    ExcelWorksheet worksheetSales = p.Workbook.Worksheets["Daily Sales Report"];
                    //worksheetSummary.Cells["D5"].Value = DateTime.Now.AddMonths(-2).AddDays(-1).ToLongDateString();
                    ExcelWorksheet worksheetStocks = p.Workbook.Worksheets["Daily Stock Report"];
                    ExcelWorksheet worksheetCreditors = p.Workbook.Worksheets["Customers"];
                    ExcelWorksheet worksheetVendors = p.Workbook.Worksheets["Vendors"];
                    ExcelWorksheet worksheetPurchase = p.Workbook.Worksheets["Daily Purchase Report"];
                    ExcelWorksheet worksheetCreditCollection = p.Workbook.Worksheets["Credit Collection"];
                    List<CreditPayReport> creditCollectionList = getCreditPayReportByDates(DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), true);
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
                    //Border
                    using (ExcelRange Rng = worksheetCreditCollection.Cells[10, 4, rowIdex, 8])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8)); //Do this first
                    }
                    //Bold
                    using (ExcelRange Rng = worksheetCreditCollection.Cells[rowIdex, 4, rowIdex, 8])
                    {
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 10)); //Do this first
                        dataFont.Bold = true;
                    }
                    if (creditCollectionList.Count > 0)
                    {
                        worksheetCreditCollection.Cells["D" + rowIdex].Value = "Total";
                        worksheetCreditCollection.Cells["G" + (rowIdex).ToString()].Formula = "SUM(G10:G" + (rowIdex - 1).ToString() + ")";
                        worksheetCreditCollection.Cells["G" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                    }
                    List<dailyreport> purchaseList = getdailyReportByReportNumber(DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), 4); //4 for purchase report
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
                    //Border
                    using (ExcelRange Rng = worksheetPurchase.Cells[10, 4, rowIdex, 16])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8)); //Do this first
                    }
                    //Bold
                    using (ExcelRange Rng = worksheetPurchase.Cells[rowIdex, 4, rowIdex, 16])
                    {
                        //Rng.Value = "Welcome to Everyday be coding - tutorials for beginners";
                        //Rng.Style.Font.Size = 30;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 10)); //Do this first
                        dataFont.Bold = true;
                    }
                    if (purchaseList.Count > 0)
                    {
                        worksheetPurchase.Cells["D" + rowIdex].Value = "Total";
                        worksheetPurchase.Cells["M" + (rowIdex).ToString()].Formula = "SUM(M10:M" + (rowIdex - 1).ToString() + ")";
                        worksheetPurchase.Cells["M" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                    }



                    List<SalesReport> salesList = GenerateDailySalesReport(date);
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
                    //Border
                    using (ExcelRange Rng = worksheetSales.Cells[10, 4, rowIdex, 18])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8)); //Do this first
                    }
                    //Bold
                    using (ExcelRange Rng = worksheetSales.Cells[rowIdex, 4, rowIdex, 18])
                    {
                        //Rng.Value = "Welcome to Everyday be coding - tutorials for beginners";
                        //Rng.Style.Font.Size = 30;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 10)); //Do this first
                        dataFont.Bold = true;
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

                    List<SalesReport> dayPartSalesList = dailyReportProvider.GetDayPartWiseSalesReport(date);
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

                    List<providersReport> cardSalesList = getAllProvidersReport(DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), 3, 0);
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

                    //Border
                    using (ExcelRange Rng = worksheetCard.Cells[10, 4, rowIdex, 12])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8)); //Do this first
                    }

                    //Bold
                    using (ExcelRange Rng = worksheetCard.Cells[rowIdex, 4, rowIdex, 12])
                    {
                        //Rng.Value = "Welcome to Everyday be coding - tutorials for beginners";
                        //Rng.Style.Font.Size = 30;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 10)); //Do this first
                        dataFont.Bold = true;
                    }
                    if (cardSalesList.Count > 0)
                    {
                        worksheetCard.Cells["D" + rowIdex].Value = "Total";
                        worksheetCard.Cells["L" + (rowIdex).ToString()].Formula = "SUM(L10:L" + (rowIdex - 1).ToString() + ")";
                        worksheetCard.Cells["L" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                    }
                    List<providersReport> chequeSalesList = getAllProvidersReport(DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), 2, 0);
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
                    //Border
                    using (ExcelRange Rng = worksheetCheque.Cells[10, 4, rowIdex, 12])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8)); //Do this first
                    }
                    //Bold
                    using (ExcelRange Rng = worksheetCheque.Cells[rowIdex, 4, rowIdex, 11])
                    {
                        //Rng.Value = "Welcome to Everyday be coding - tutorials for beginners";
                        //Rng.Style.Font.Size = 30;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 10)); //Do this first
                        dataFont.Bold = true;
                    }
                    if (chequeSalesList.Count > 0)
                    {
                        worksheetCheque.Cells["D" + rowIdex].Value = "Total";
                        worksheetCheque.Cells["L" + (rowIdex).ToString()].Formula = "SUM(L10:L" + (rowIdex - 1).ToString() + ")";
                        worksheetCheque.Cells["L" + (rowIdex).ToString()].Style.Numberformat.Format = "###,###,##0.00";
                    }
                    List<StockReport> stockList = GenerateDailyStockReport(date);
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
                    //Border and font
                    using (ExcelRange Rng = worksheetStocks.Cells[10, 4, rowIdex, 9])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8)); //Do this first
                    }

                    List<SummaryReport> summaryReportList = GenerateDailySummaryReport(date);
                    rowIdex = 9;
                    foreach (SummaryReport row in summaryReportList)
                    {
                        worksheetSummary.Cells["E9"].Value = row.OpeningBalance;
                        worksheetSummary.Cells["E9"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E10"].Value = row.Cash;
                        worksheetSummary.Cells["E11"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E12"].Value = row.Card;
                        worksheetSummary.Cells["E10"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E11"].Value = row.Cheque;
                        worksheetSummary.Cells["E12"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E13"].Value = row.Credit;
                        worksheetSummary.Cells["E13"].Style.Numberformat.Format = "###,###,##0.00";
                        
                        worksheetSummary.Cells["E14"].Value = row.eSewa;
                        worksheetSummary.Cells["E14"].Style.Numberformat.Format = "###,###,##0.00";
                        
                        worksheetSummary.Cells["E15"].Value = row.FonePay;
                        worksheetSummary.Cells["E15"].Style.Numberformat.Format = "###,###,##0.00";
                        
                        worksheetSummary.Cells["E16"].Value = row.SurplusDeficit;
                        worksheetSummary.Cells["E16"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E17"].Value = row.CreditCollectedInCash;
                        worksheetSummary.Cells["E17"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E18"].Value = row.CreditCollectedInCard;
                        worksheetSummary.Cells["E18"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E19"].Value = row.CreditCollectedInCheque;
                        worksheetSummary.Cells["E19"].Style.Numberformat.Format = "###,###,##0.00";

                        worksheetSummary.Cells["E20"].Value = row.CreditCollectedIneSewa;
                        worksheetSummary.Cells["E20"].Style.Numberformat.Format = "###,###,##0.00";

                        worksheetSummary.Cells["E21"].Value = row.CreditCollectedInFonePay;
                        worksheetSummary.Cells["E21"].Style.Numberformat.Format = "###,###,##0.00";

                        worksheetSummary.Cells["E22"].Value = row.AdvanceCollectedInCash;
                        worksheetSummary.Cells["E22"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E23"].Value = row.AdvanceCollectedInCard;
                        worksheetSummary.Cells["E23"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E24"].Value = row.AdvanceCollectedInCheque;
                        worksheetSummary.Cells["E24"].Style.Numberformat.Format = "###,###,##0.00";

                        worksheetSummary.Cells["E25"].Value = row.AdvanceCollectedIneSewa;
                        worksheetSummary.Cells["E25"].Style.Numberformat.Format = "###,###,##0.00";

                        worksheetSummary.Cells["E26"].Value = row.AdvanceCollectedInFonePay;
                        worksheetSummary.Cells["E26"].Style.Numberformat.Format = "###,###,##0.00";

                        worksheetSummary.Cells["E27"].Value = row.TotalCashReceived;
                        worksheetSummary.Cells["E27"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E28"].Value = row.TotalExpenses;
                        worksheetSummary.Cells["E28"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E29"].Value = row.CashInCounter;
                        worksheetSummary.Cells["E29"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E30"].Value = row.CashSettlement;
                        worksheetSummary.Cells["E30"].Style.Numberformat.Format = "###,###,##0.00";
                        worksheetSummary.Cells["E31"].Value = row.ClosingBalance;
                        worksheetSummary.Cells["E31"].Style.Numberformat.Format = "###,###,##0.00";
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


                    List<providersReport> summaryProviders = restroOrderProvider.getSummaryProvidersReport(DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), 0, 0); //roc.getSummaryProvidersReport(startDate, endDate, paymentMode, provider);
                    rowIdex = 10;
                    foreach (providersReport row in summaryProviders)
                    {
                        worksheetSummary.Cells["L" + rowIdex].Value = row.ProviderName;
                        worksheetSummary.Cells["M" + rowIdex].Value = row.payAmount;
                        worksheetSummary.Cells["M" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        rowIdex++;
                    }
                    //Border and font
                    using (ExcelRange Rng = worksheetSummary.Cells[10, 12, rowIdex, 13])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8)); //Do this first
                    }


                    List<costCenterReport> summaryCostCenter = restroOrderProvider.getSummaryCostCenterReport(DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), DateTime.ParseExact(date, "yyyyMMdd", CultureInfo.InvariantCulture), 0); 
                    rowIdex = 10;
                    foreach (costCenterReport row in summaryCostCenter)
                    {
                        worksheetSummary.Cells["O" + rowIdex].Value = row.CostCenterName;
                        worksheetSummary.Cells["P" + rowIdex].Value = row.Total;
                        worksheetSummary.Cells["P" + rowIdex].Style.Numberformat.Format = "###,###,##0.00";
                        rowIdex++;
                    }
                    //Border and font
                    using (ExcelRange Rng = worksheetSummary.Cells[10, 15, rowIdex, 16])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8)); //Do this first
                    }

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
                    //Border and font
                    using (ExcelRange Rng = worksheetCreditors.Cells[10, 4, rowIdex, 11])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8)); //Do this first
                    }
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
                    //Border and font
                    using (ExcelRange Rng = worksheetVendors.Cells[10, 4, rowIdex, 11])
                    {
                        var border = Rng.Style.Border;
                        border.Top.Style = border.Left.Style = border.Bottom.Style = border.Right.Style = ExcelBorderStyle.Thin;
                        var dataFont = Rng.Style.Font;
                        dataFont.SetFromFont(new Font("Calibri", 8)); //Do this first
                    }
                }
                p.Workbook.Calculate();
                var outputFilePath = templateBasePath + "\\RestroOrder_Daily_Report_AsOf_" + date + ".xlsx";
                Byte[] bin = p.GetAsByteArray();
                System.IO.File.WriteAllBytes(outputFilePath, bin);
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
                        mail.To.Add(new MailAddress(mails[i]));
                        break;
                    case "BCC":
                        mail.To.Add(new MailAddress(mails[i]));
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
            List<companyInfo> companies = new List<companyInfo>();
            companies = restroOrderProvider.getCompanyInfo();
             
            MailMessage mail = new MailMessage(); 
            var MailKey = dailyReportProvider.Mailkey("MailKey");
            var MailVal = dailyReportProvider.MailValue("MailValue");
            MailKey = Decrypt(MailKey);
            MailVal = Decrypt(MailVal);
            SmtpClient smtp = new SmtpClient
            {
                Host = "smtp.gmail.com",
                Port = 587,
                EnableSsl = true,
                DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(MailVal, MailKey)
            };
        
            try
            {
                mail.From = new MailAddress(MailVal.ToString()); 
                AddEmails(mail, System.Configuration.ConfigurationManager.AppSettings["MailTo"].ToString(), "TO");

                if (System.Configuration.ConfigurationManager.AppSettings["MailCC"].ToString() != "" && System.Configuration.ConfigurationManager.AppSettings["MailCC"].ToString().Length > 5)
                {
                    AddEmails(mail, System.Configuration.ConfigurationManager.AppSettings["MailCC"].ToString(), "CC");
                }
                mail.Subject = companies[0].Name +" - RestroOrder Daily Report - " + date;
                string Body = "Please find the daily reports attached in this mail.<br /><br />Regards,<br />RestroOrder Team.";
                mail.Body = Body;
                mail.IsBodyHtml = true;
                var attachmentPath = templateBasePath + "\\RestroOrder_Daily_Report_AsOf_" + date + ".xlsx";
                if (!(System.IO.File.Exists(attachmentPath)))
                {
                    GenerateXlsxFile(date, templateBasePath);
                }
                mail.Attachments.Add(new Attachment(attachmentPath));
                
                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                mail.Dispose();
                smtp.Dispose();
            }
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
    }
}
