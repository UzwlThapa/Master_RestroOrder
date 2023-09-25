<%@ WebService Language="C#" Class="AdvanceReportService" %>

using System.Web.Services;
using SageFrame.RestroOrder;
using System.Collections.Generic;
using SageFrame.RestoLoyalty;
using Newtonsoft.Json;
using System;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class AdvanceReportService  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
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
    public string getsdatass(int customer)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();

        List<MemberInfo> customerlist = dfcobj.getmembershiplist(customer);
        return JsonConvert.SerializeObject(customerlist);
    }


    [WebMethod]
    public string GetPaymentModes()
    {
        RestrOrderController roc = new RestrOrderController();
        List<PaymentModes> payment = roc.GetPaymentModes();
        return JsonConvert.SerializeObject(payment);
    }

    [WebMethod]
    public string getCardProvider()
    {
        RestrOrderController roc = new RestrOrderController();
        List<CardProvider> card = roc.getCardProvider();
        return JsonConvert.SerializeObject(card);
    }

    [WebMethod]
    public string GetCustomerForReport()
    {
        RestrOrderController roc = new RestrOrderController();
        List<SalesSummaryReport> cust = roc.GetCustomerForReport();
        return JsonConvert.SerializeObject(cust);
    }

    [WebMethod]
    public string GetWaiterForReport()
    {
        RestrOrderController roc = new RestrOrderController();
        List<SalesSummaryReport> waiter =  roc.GetWaiterForReport();
        return JsonConvert.SerializeObject(waiter);
    }


    [WebMethod]
    public string GetCashierForReport()
    {
        RestrOrderController roc = new RestrOrderController();
        List<SalesSummaryReport> cashier = roc.GetCashierForReport();
        return JsonConvert.SerializeObject(cashier);
    }


    [WebMethod]
    public string getRestroTableByRoomID(int restroRoomId)
    {
        RestrOrderController roc = new RestrOrderController();
        List<restroTable>  restroTable = roc.getRestroTableByRoomID(restroRoomId);
        return JsonConvert.SerializeObject(restroTable);
    }


    [WebMethod]
    public string getSalesSummaryReport(string room, string table, int invoiceno, string customer, string waiter, string cashier, int paymentmodeid, string provider, DateTime datefrom, DateTime dateTo, int timefrom, int timeTo)
    {
        RestrOrderController roc = new RestrOrderController();
        List<SalesSummaryReport> salesreport = roc.getSalesSummaryReport(room, table, invoiceno, customer, waiter, cashier, paymentmodeid, provider, datefrom, dateTo, timefrom, timeTo);
        return JsonConvert.SerializeObject(salesreport);
    }
}