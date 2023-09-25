<%@ WebService Language="C#" Class="wsDashboardSummary" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using Newtonsoft.Json;

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
        return con.GenerateDayClosingReport(DateTime.Now.ToString(), false);
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
        {
            throw new Exception("Period is not provided");
        }
        string reportDate = (period == null || period == "") ? DateTime.Now.ToString("yyyyMMdd", System.Globalization.CultureInfo.GetCultureInfo("en-US")) : period;
        string templateBasePath = System.IO.Path.GetFullPath(Server.MapPath(@"~/Documents/XLSX"));
        Hangfire.BackgroundJob.Enqueue(() => dailyController.SendMail(reportDate, templateBasePath));
        
        //dailyController.SendMail(reportDate, templateBasePath);
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