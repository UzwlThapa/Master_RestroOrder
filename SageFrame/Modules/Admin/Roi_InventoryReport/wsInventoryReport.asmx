<%@ WebService Language="C#" Class="wsInventoryReport" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using SageFrame.RestoLoyalty;
using System.Collections.Generic;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsInventoryReport  : System.Web.Services.WebService {

    [WebMethod]
    public List<purchaseDetails> getPurchaseDetails()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.getPurchaseDetails();

        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<dailyreport> getPurchaseReportByPuNo(string puNo)
    {
        RestrOrderController rc = new RestrOrderController();
        return rc.getPurchaseReportByPuNo(puNo);
    }

    [WebMethod]
    public string getdailyReport(DateTime startdate, DateTime enddate, int ReportNum)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> adjustdaily = rc.getdailyReportByReportNumber(startdate, enddate, ReportNum);
        return JsonConvert.SerializeObject(adjustdaily);
    }


    [WebMethod]
    public List<dailyreport> getdailyReportByWeekly(DateTime dateTime, int ReportNum)
    {
        RestrOrderController rc = new RestrOrderController();
        return rc.getdailyReportByWeeklyByReportNumber(dateTime, ReportNum);
    }
    [WebMethod]

    public List<dailyreport> getdailyReportByMonthly(string year, string month, int ReportNum)
    {
        RestrOrderController rc = new RestrOrderController();
        return rc.getdailyReportByMonthlyByReportNumber(year, month, ReportNum);
    }
    [WebMethod]
    public List<dailyreport> getdailyReportByYearly(string year, int ReportNum)
    {

        RestrOrderController rc = new RestrOrderController();
        return rc.getdailyReportByYearlyByReportNumber(year, ReportNum);
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
    public string getPurchaseReport(string startDate, string endDate, int vendorId, string puNo)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> purchasereport = rc.getPurchaseReport(startDate, endDate, vendorId, puNo);
        return JsonConvert.SerializeObject(purchasereport);
    }



    [WebMethod]
    public string getsdatass(int customer)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        List<MemberInfo> customerlist = dfcobj.getmembershiplist(customer);
        return JsonConvert.SerializeObject(customerlist);
    }

    [WebMethod]
    public string getPurchaseNoForReport()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<purchaseDetails> purchase = roc.getPurchaseNoForReport();
            return JsonConvert.SerializeObject(purchase);
        }
        catch (Exception)
        {

            throw;
        }
    }

    //[WebMethod]
    //public string GetPurchaseDetailsbypurchaseID(int purchasemainID)
    //{
    //    try
    //    {
    //        RestrOrderController roc = new RestrOrderController();
    //        List<purchaseMains> purchaselist = roc.GetPurchaseDetailsbypurchaseID(purchasemainID);
    //        return JsonConvert.SerializeObject(purchaselist);
    //    }
    //    catch(Exception)
    //    {
    //            throw;
    //    }
    //}

        [WebMethod]
    public string GetGoodsRecieveFromPurchaseID(int purchasemainID)
    {
        PurchaseData purchase = new PurchaseData();
        RestrOrderController roc = new RestrOrderController();
        purchase.goodsMain = roc.GetGoodsRecieveFromPurchaseID(purchasemainID);
        purchase.companyInfo = roc.getcompanyInfo();
        return JsonConvert.SerializeObject(purchase);

    }

    [WebMethod]

    public string GetPurchaseDetailsbypurchaseID(int purchasemainID)
    {
        PurchaseData purchase = new PurchaseData();
        RestrOrderController roc = new RestrOrderController();
        purchase.purchaseMain = roc.GetPurchaseDetailsbypurchaseID(purchasemainID);
        purchase.companyInfo = roc.getcompanyInfo();
        return JsonConvert.SerializeObject(purchase);

    }
}

