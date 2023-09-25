<%@ WebService Language="C#" Class="WebServiceForCancelledBill" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using SageFrame.RestoLoyalty;
using System.Collections.Generic;
using System.Linq;
using SageFrame.Security;
using SageFrame.Security.Entities;
using Newtonsoft.Json;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebServiceForCancelledBill  : System.Web.Services.WebService {


    [WebMethod]
    public string savePrintCount(int Printcount, string BillNo, string PrintedBy)
    {
        RestrOrderController rocc = new RestrOrderController();
        if (BillNo != "")
        {
            return rocc.SavePrintCountDetail(Printcount, BillNo, PrintedBy);
        }
        return "";

    }
    [WebMethod]
    public string getdailyReport(DateTime startdate, DateTime enddate, string cancelledby)
    {
        try
        {
            RestrOrderController rc = new RestrOrderController();
            List<dailyreport> daily = rc.getdailyReportForCancelledBill(startdate,enddate, cancelledby);
            return JsonConvert.SerializeObject(daily);
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }
    [WebMethod]
    public string getdailyReportByWeekly(DateTime dateTime)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> weekly = rc.getdailyReportByWeeklyForCancelledBill(dateTime);
        return JsonConvert.SerializeObject(weekly);
    }
    [WebMethod]

    public string getdailyReportByMonthly(string year, string month)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> monthly = rc.getdailyReportByMonthlyForCancelledBill(year, month);
        return JsonConvert.SerializeObject(monthly);
    }
    [WebMethod]
    public string getdailyReportByYearly(string year)
    {

        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> yearly = rc.getdailyReportByYearlyForCancelledBill(year);
        return JsonConvert.SerializeObject(yearly);
    }

    [WebMethod]
    public List<dailyreport> getdailyReportBySum(DateTime dateTime)
    {
        RestrOrderController rc = new RestrOrderController();
        return rc.getdailyReportBySum(dateTime);
    }
    [WebMethod]
    public List<dailyreport> getweeklysumbyDate(DateTime dateTime)
    {
        RestrOrderController rc = new RestrOrderController();
        return rc.getweeklysumbyDate(dateTime);
    }

            [WebMethod]
    public string GetOrderCancelledBY()
    {
        RestrOrderController roc = new RestrOrderController();
        List<OrderDetailCancel> table = roc.GetOrderCancelledBY();
        return JsonConvert.SerializeObject(table);

    }

          [WebMethod]
    public virtual SageFrameUserCollection GetAllUsers()
    {
        MembershipController mhc = new MembershipController();
        return (mhc.GetAllUsers());
    }
    [WebMethod]
    public string getCompanyInfo()
    {
        RestrOrderController roc = new RestrOrderController();
        List<companyInfo> company = roc.getcompanyInfo();
        return JsonConvert.SerializeObject(company.FirstOrDefault());
       
    }

}