<%@ WebService Language="C#" Class="wsDashboardSummary" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using Newtonsoft.Json;
using System.Globalization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsDashboardSummary : System.Web.Services.WebService
{
    RestrOrderController con = new RestrOrderController();
    DailyReportController dailyController = new DailyReportController();
        

    [WebMethod]
    public List<SalesChart> getSalesChart()
    {
        return con.getSalesChart();
    }


    [WebMethod]
    public DailyClosingReport GenerateDayClosingReport()
    {
        return con.GenerateDayClosingReport(DateTime.Now.ToString("yyyy-MM-dd"), false);
    }

    [WebMethod]
    public void CloseTheDay(int financialID, string period, decimal cashSettlement, decimal cashinCounter, decimal closingBalance, decimal totalexpenses, string remarks)
    {
        con.CloseTheDay(financialID, cashSettlement, cashinCounter, closingBalance, totalexpenses, remarks);
        GenerateXLDashboard(period);
    }

    [WebMethod]
    public void GenerateXLDashboard(string period)
    {
        if (string.IsNullOrEmpty(period))
            throw new Exception("Period is not provided");

        DateTime parsedDate;
        string[] formats = { "yyyyMMdd", "yyyy-MM-dd", "MM/dd/yyyy", "M/d/yyyy", "dd/MM/yyyy" };
        if (!DateTime.TryParseExact(period, formats, CultureInfo.InvariantCulture, DateTimeStyles.None, out parsedDate))
        {
            // Log the error (optional) and fallback to today
            parsedDate = DateTime.Today;
            // You could also log to a file or event log, but we'll just use today.
        }
        string safeDate = parsedDate.ToString("yyyyMMdd");

        string templateBasePath = System.IO.Path.GetFullPath(Server.MapPath(@"~/Documents/XLSX"));
        Hangfire.BackgroundJob.Enqueue(() => dailyController.SendMail(safeDate, templateBasePath));
    }

    // wsDashboardSummary.asmx — add this WebMethod
    [WebMethod]
    public string ResendDailyReport(string date)
    {
        try
        {
            if (string.IsNullOrEmpty(date))
                date = DateTime.Today.ToString("yyyyMMdd");

            string templateBasePath = System.IO.Path.GetFullPath(Server.MapPath(@"~/Documents/XLSX"));
            
            // Enqueue as a new Hangfire background job
            string jobId = Hangfire.BackgroundJob.Enqueue(
                () => dailyController.SendMail(date, templateBasePath));

            // REPLACED interpolation with concatenation (C# 5 compatible)
            return "Resend job queued. Job ID: " + jobId;
        }
        catch (Exception ex)
        {
            return "Error: " + ex.Message;
        }
    }

    [WebMethod]
    public string CheckPinCodeMatch(string PinCode,string username)
    {
        RestrOrderController controller = new RestrOrderController();
        string available = controller.CheckPinCodeMatch(PinCode,username);
        return available;
    }

    [WebMethod]
    public void SaveCashDenomination(CashDenomination cash)
    {
        con.SaveCashDenomination(cash);
    }

    [WebMethod]
    public string ClosDayReport(string fromDate, string toDate)
    {
        List<DailyClosingReport> report = con.ClosDayReport(fromDate, toDate);
        return JsonConvert.SerializeObject(report);
    }

    [WebMethod]
    public string getOccupiedTableList()
    {
        FrontPageController fnt = new FrontPageController();
        List<OccupiedTables> tables = fnt.getOccupiedTableList();
        return JsonConvert.SerializeObject(tables);
    }
}