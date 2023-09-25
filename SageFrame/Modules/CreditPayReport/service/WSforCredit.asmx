<%@ WebService Language="C#" Class="WSforCredit" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using SageFrame.Common;
using Newtonsoft.Json;
using SageFrame.RestoLoyalty;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WSforCredit : System.Web.Services.WebService {

    [WebMethod]
    public string getCreditPayReportByDates(DateTime sdate,DateTime edate, string customer, bool? isCustomer)
    {
        RestrOrderController con = new RestrOrderController();
        //return con.MaterializedReportView(startdate);
        List<CreditPayReport> credit = con.getCreditPayReportByDates(sdate,edate, customer, isCustomer);
        return JsonConvert.SerializeObject(credit);
    }


    [WebMethod]
    public string getMixedPayReportByDates(DateTime sdate, DateTime edate, string customer, bool? isCustomer)
    {
        RestrOrderController con = new RestrOrderController();
        //return con.MaterializedReportView(startdate);
        List<CreditPayReport> credit = con.getMixedPayReportByDates(sdate, edate, customer, isCustomer);
        return JsonConvert.SerializeObject(credit);
    }




    [WebMethod]
    public string getmembershiplist(int customer)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        List<MemberInfo> list = dfcobj.getmembershiplist(customer);
        return JsonConvert.SerializeObject(list);
    }

    [WebMethod]
    public string getCreditReports(DateTime sdate, DateTime edate, string customer, bool? isCustomer)
    {
        RestrOrderController con = new RestrOrderController();
        List<CreditPayReport> creditlist = con.getCreditReport(sdate, edate, customer, isCustomer);
        return JsonConvert.SerializeObject(creditlist);
    }

    [WebMethod]
    public string GetGoodsReceivedDetailsByGMId(int gmid)
    {
        RestrOrderController rc = new RestrOrderController();
        List<goodReceiveDetails> goods = rc.GetGoodsReceivedDetailsByGMId(gmid);
        return JsonConvert.SerializeObject(goods);
    }


    [WebMethod]
    public string getcustomerbalanceReceipt(int memberpayid)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        List<CreditPayment> payment = dfcobj.getcustomerbalanceReceipt(memberpayid);
        return JsonConvert.SerializeObject(payment);
    }


}