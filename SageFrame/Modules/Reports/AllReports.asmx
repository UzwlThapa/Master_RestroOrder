<%@ WebService Language="C#" CodeBehind="~/App_Code/AllReports.cs" Class="AllReports" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using System.Web.Script.Serialization;
using Newtonsoft.Json;

/// <summary>
/// Summary description for AllReports
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class AllReports : System.Web.Services.WebService {


    JavaScriptSerializer serialize = new JavaScriptSerializer();

    public AllReports () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

    [WebMethod]
    public string getdailyReport(DateTime startdate, DateTime enddate, int ReportNum)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> daily = rc.getdailyReportByReportNumber(startdate,enddate, ReportNum);
        return JsonConvert.SerializeObject(daily);
    }
    //[WebMethod]
    //public List<dailyreport> getdailyReportByWeekly(DateTime dateTime, int ReportNum)
    //{
    //    RestrOrderController rc = new RestrOrderController();
    //    return rc.getdailyReportByWeeklyByReportNumber(dateTime, ReportNum);
    //}
    [WebMethod]

    public string getdailyReportByMonthly(string year, string month, int ReportNum)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> monthly = rc.getdailyReportByMonthlyByReportNumber(year, month, ReportNum);
        return JsonConvert.SerializeObject(monthly);
    }
    [WebMethod]
    public string getdailyReportByYearly(string year, int ReportNum)
    {

        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> yearly = rc.getdailyReportByYearlyByReportNumber(year, ReportNum);
        return JsonConvert.SerializeObject(yearly);
    }
    [WebMethod]
    public List<dailyreport> getdailyReportBySum(DateTime dateTime, int ReportNum)
    {
        RestrOrderController rc = new RestrOrderController();
        return rc.getdailyReportBySumByReportNumber(dateTime, ReportNum);
    }
    [WebMethod]
    public List<dailyreport> getweeklysumbyDate(DateTime dateTime, int ReportNum)
    {
        RestrOrderController rc = new RestrOrderController();
        return rc.getweeklysumbyDateByReportNumber(dateTime, ReportNum);

    }

    [WebMethod]
    public string getOrderVoidReport(DateTime startDate, DateTime endDate)
    {

        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> voidreport = rc.getOrderVoidReport(startDate, endDate);
        return JsonConvert.SerializeObject(voidreport);
    }


    [WebMethod]
    public string getOrderItemCancelReport(DateTime startDate, DateTime endDate, string cancelledby, string orderby, int roomid, int tableid, string responsible, string itemname)
    {

        RestrOrderController rc = new RestrOrderController();
        List<OrderDetailCancel> cancelreport = rc.getOrderItemCancelReport(startDate, endDate, cancelledby, orderby, roomid, tableid, responsible, itemname);
        return JsonConvert.SerializeObject(cancelreport);
    }

    [WebMethod]

    public string getOrderItemReport(DateTime startDate, DateTime endDate)
    {
        RestrOrderController rc = new RestrOrderController();
        List<itemsales> orderreport =  rc.getOrderItemReport(startDate, endDate);
        return JsonConvert.SerializeObject(orderreport);
    }


    [WebMethod]
    public string getItemShiftReport(string itemname, string fromtable, string totable, string shiftedby, DateTime fromdate, DateTime todate)
    {
        RestrOrderController rc = new RestrOrderController();
        List <ItemShiftReport> item = rc.getItemShiftReport(itemname, fromtable, totable, shiftedby, fromdate, todate);

        return JsonConvert.SerializeObject(item);
    }


    [WebMethod]
    public string GetWaiterForReport()
    {
        RestrOrderController roc = new RestrOrderController();
        List<SalesSummaryReport> waiter = roc.GetWaiterForReport();
        return serialize.Serialize(waiter);
    }


    [WebMethod]
    public string GetItemsfromDatabase()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            List<ItemsClass> item = rocobj.getitemforcumbo();
            return JsonConvert.SerializeObject(item);

        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public string getRestroRoom()
    {

        RestrOrderController roc = new RestrOrderController();
        List<RestroRoom> room = roc.getRestroRoom();
        return JsonConvert.SerializeObject(room);
    }

    [WebMethod]
    public string getRestroTable()
    {
        RestrOrderController roc = new RestrOrderController();
        List<restroTable> table = roc.getRestroTable();
        return JsonConvert.SerializeObject(table);

    }

    [WebMethod]
    public string getRestroTableByRoomID(int restroRoomId)
    {
        RestrOrderController roc = new RestrOrderController();
        List<restroTable>  restroTable = roc.getRestroTableByRoomID(restroRoomId);
        return JsonConvert.SerializeObject(restroTable);
    }

    [WebMethod]
    public string GetOrderCancelledBY()
    {
        RestrOrderController roc = new RestrOrderController();
        List<OrderDetailCancel> table = roc.GetOrderCancelledBY();
        return JsonConvert.SerializeObject(table);

    }

    [WebMethod]
    public string GetCancelledOrderBY()
    {
        RestrOrderController roc = new RestrOrderController();
        List<OrderDetailCancel> table = roc.GetCancelledOrderBY();
        return JsonConvert.SerializeObject(table);

    }

    [WebMethod]
    public string GetOrderCancelResponsible()
    {
        RestrOrderController roc = new RestrOrderController();
        List<OrderDetailCancel> table = roc.GetOrderCancelResponsible();
        return JsonConvert.SerializeObject(table);

    }

    [WebMethod]
    public string getCompanyInfo()
    {
        RestrOrderController roc = new RestrOrderController();
        List<companyInfo> company = roc.getcompanyInfo();
        return JsonConvert.SerializeObject(company.FirstOrDefault());

    }

    [WebMethod]
    public string GetCostCenter()
    {
        RestrOrderController roc = new RestrOrderController();
        List<costCenter> costcenter = roc.getcostcenter();
        return JsonConvert.SerializeObject(costcenter);
    }

    [WebMethod]
    public string getAllOrderDetailReport(DateTime startDate, DateTime endDate, int tableid, int costCenter)
    {
        RestrOrderController rc = new RestrOrderController();
        List<OrderDetailClass> order = rc.getAllOrderDetailReport(startDate, endDate, tableid, costCenter);
        return JsonConvert.SerializeObject(order);
    }


    [WebMethod]
    public string getOrderDetailsReportSummary(DateTime startDate, DateTime endDate, int tableid, int costCenter)
    {
        RestrOrderController rc = new RestrOrderController();
        List<OrderDetailClass> order = rc.getOrderDetailsReportSummary(startDate, endDate, tableid, costCenter);
        return JsonConvert.SerializeObject(order);
    }


}

