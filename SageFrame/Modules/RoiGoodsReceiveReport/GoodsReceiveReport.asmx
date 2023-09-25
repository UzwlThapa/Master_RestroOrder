getGoodsReceiveReport
<%@ WebService Language="C#" Class="GoodsReceiveReport" %>

using System;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class GoodsReceiveReport : System.Web.Services.WebService
{


    [WebMethod]
    public string getGoodsReceiveReport(string startDate, string endDate, string PoNO, string GmNo, string itemname,string paymentID)
    {
        RestrOrderController roc = new RestrOrderController();
        List<goodsReceiveMain> report = roc.getGoodsReceiveReport(startDate, endDate, PoNO, GmNo, itemname,int.Parse(paymentID));
        return JsonConvert.SerializeObject(report);
    }

    [WebMethod]
    public string getCompanyInfo()
    {
        RestrOrderController roc = new RestrOrderController();
        List<companyInfo> company = roc.getcompanyInfo();
        return JsonConvert.SerializeObject(company.FirstOrDefault());

    }

    [WebMethod]
    public string GetGoodsDetailsbygmID(int gmID)
    {
        PurchaseData purchase = new PurchaseData();
        RestrOrderController roc = new RestrOrderController();
        purchase.goodsMain = roc.GetGoodsDetailsbygmID(gmID);
        purchase.companyInfo = roc.getcompanyInfo();
        return JsonConvert.SerializeObject(purchase);

    }

    [WebMethod]
    public string GetGoodReceivedPO()
    {
        RestrOrderController objCon = new RestrOrderController();
        List<goodsReceiveMain> goods = objCon.GetGoodRecievedPO();
        return JsonConvert.SerializeObject(goods);
    }

    [WebMethod]
    public string getPurchaseList(string startDate, string endDate)
    {
        RestrOrderController roc = new RestrOrderController();
        List<purchaseMains> purchase = roc.getPurchaseList(startDate, endDate);
        return JsonConvert.SerializeObject(purchase);
    }
}