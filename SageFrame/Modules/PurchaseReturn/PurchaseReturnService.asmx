<%@ WebService Language="C#" Class="PurchaseReturnService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class PurchaseReturnService  : System.Web.Services.WebService {

    [WebMethod]
    public string GetGoodsReceiveMainList()
    {
        RestrOrderController roc = new RestrOrderController();
        List<goodsReceiveMain> goodsReceive = roc.GetGoodsReceiveMainList();
        return JsonConvert.SerializeObject(goodsReceive);
    }

    [WebMethod]
    public string GetGoodsDetailsbyGMNo(string GMNo)
    {
        RestrOrderController roc = new RestrOrderController();
        List<goodReceiveDetails> goodsReceiveDetails = roc.GetGoodsDetailsbyGMNo(GMNo);
        return JsonConvert.SerializeObject(goodsReceiveDetails);
    }


    [WebMethod]
    public string PurchaseReturnAutoNumber()
    {
        RestrOrderController roc = new RestrOrderController();
        List<PurchaseReturnMain> data = roc.PurchaseReturnAutoNumber();
        return JsonConvert.SerializeObject(data);
    }


    [WebMethod]
    public int PurchaseReturn(PurchaseReturnMain PurchaseReturn)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.PurchaseReturn(PurchaseReturn);

        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public string GetPurchaseReturnMainList()
    {
        RestrOrderController roc = new RestrOrderController();
        List<PurchaseReturnMain> goodsReceive = roc.GetPurchaseReturnMainList();
        return JsonConvert.SerializeObject(goodsReceive);
    }

    //[WebMethod]
    //public string GetPurchaseReturnDetailsbyPRNo(string PRNo)
    //{
    //    RestrOrderController roc = new RestrOrderController();
    //    List<PurchaseReturnDetails> PurchaseReturnDetails = roc.GetPurchaseReturnDetailsbyPRNo(PRNo);
    //    return JsonConvert.SerializeObject(PurchaseReturnDetails);
    //}

    [WebMethod]
    public string GetPurchaseReturnDetailsbyPRNo(string PRNo)
    {
        PurchaseData purchase = new PurchaseData();
        RestrOrderController roc = new RestrOrderController();
        purchase.returnDetails = roc.GetPurchaseReturnDetailsbyPRNo(PRNo);
        purchase.companyInfo = roc.getcompanyInfo();
        return JsonConvert.SerializeObject(purchase);

    }

}