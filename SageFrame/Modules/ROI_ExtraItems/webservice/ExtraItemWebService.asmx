<%@ WebService Language="C#" Class="ExtraItemWebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using System.Linq;
using System.Collections.Generic;
using Newtonsoft.Json;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ExtraItemWebService  : System.Web.Services.WebService {

    RestrOrderController con = new RestrOrderController();

    [WebMethod]
    public void SaveExtraItem(extraItem extraItem)
    {
        con.SaveExtraItem(extraItem);
    }

    [WebMethod]
    public string GetExtraItemList()
    {
        List<extraItem> extralist = con.GetExtraItemList().Where(p => p.IsDeleted == false).ToList();
        return JsonConvert.SerializeObject(extralist);
    }

    [WebMethod]
    public void DeleteExtraItem(int extraItemId, string deletedBy)
    {
        con.DeleteExtraItem(extraItemId, deletedBy);
    }

    [WebMethod]
    public  string getIngredientByExtraItemID(int id)
    {
            List<IngredientItems> getingrdientbiId = con.getExtraIngredientsList().Where(p => p.ItemId == id).ToList();
        return JsonConvert.SerializeObject(getingrdientbiId);
    }
}