<%@ WebService Language="C#" Class="wsLandingSummaries" %>

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
public class wsLandingSummaries : System.Web.Services.WebService
{
    RestrOrderController con = new RestrOrderController();

    [WebMethod]
    public List<top6Item> getTop6Item()
    {
        return con.getTop6Item();
    }

    [WebMethod]
    public List<top6Table> getTop6Table()
    {
        return con.getTop6Table();
    }

    [WebMethod]
    public List<CardProvider> getDueCredit()
    {
        return con.getDueCredit();
    }
    [WebMethod]
    public List<stockReport> getOutOfStockItems()
    {
        return con.getOutOfStockItems(0);
    }
    [WebMethod]
    public List<CustomerEvent> getCustomerEvents()
    {
        return con.getCustomerEvents();
    }
    [WebMethod]
    public string getReservedTable()
    {
        List<TableReservation> table = con.getReservedTable();
        return JsonConvert.SerializeObject(table);
    }
}