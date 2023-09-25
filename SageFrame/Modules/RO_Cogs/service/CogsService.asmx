<%@ WebService Language="C#" Class="CogsService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using System.Linq;
using System.Collections.Generic;
using Newtonsoft.Json;
using SageFrame.CostCenter;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CogsService  : System.Web.Services.WebService {

    RestrOrderController con = new RestrOrderController();

    [WebMethod]
    public string getItemIngreident(int costCenter, int itemID, int categoryID)
    {
        List<ROInvItem> itemList = con.getIngredientsList(costCenter, itemID, categoryID);
        return JsonConvert.SerializeObject(itemList);
    }

    [WebMethod]
    public string getItemList(int costCenter)
    {
        List<ROInvItem> getlist = con.getItemIngreident(costCenter);
        return JsonConvert.SerializeObject(getlist);
    }
    [WebMethod]
    public List<ROInvItem> getItemCogs(int costCenter, int itemID, int categoryID, decimal minCogs, decimal maxCogs)
    {
        List<ROInvItem> items = con.getIngredientsList(costCenter, itemID, categoryID);
        return items.Where(p => (p.COGS > minCogs && p.COGS <= maxCogs || minCogs == maxCogs)).ToList();
    }
    [WebMethod]
    public string GetCategoryName()
    {
        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> parent = roc.GetPareintItem();
        return JsonConvert.SerializeObject(parent);
    }

    [WebMethod]
    public string GetItemNameByCatgeoryID(int pitid)
    {
        List<ROInvItem> listbyID = con.GetItemNameByCatgeoryID(pitid);
        return JsonConvert.SerializeObject(listbyID);
    }

    [WebMethod]
    public string GetCostCenter()
    {
        CostCenterController ccon = new CostCenterController();
        List<CostCenterInfo> costinfo = ccon.GetCostCenter();
        return JsonConvert.SerializeObject(costinfo);
    }

    [WebMethod]
    public string getItemDailyProfit(DateTime startDate, DateTime endDate, int itemId)
    {
        List<CogsReport> report = con.getItemDailyProfit(startDate, endDate, itemId);
        return JsonConvert.SerializeObject(report);
    }


}