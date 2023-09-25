<%@ WebService Language="C#" Class="ItemLedgerWebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using System.Collections.Generic;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ItemLedgerWebService  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

    [WebMethod]
    public string  GetItemForSearch()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<purchaseDetails> item = roc.GetItemForOpenBalance();
            return JsonConvert.SerializeObject(item);

        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public string getItemledger(DateTime startDate, DateTime endDate, int itemId)
    {
        RestrOrderController roc = new RestrOrderController();
        List<ItemLedger> ledger = roc.getItemledger(startDate, endDate, itemId);
        return JsonConvert.SerializeObject(ledger);
    }



}