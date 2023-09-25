<%@ WebService Language="C#" Class="GlobalizationMenuService" %>

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
public class GlobalizationMenuService  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

    [WebMethod]
    public string getMenuForGlobalization(int languageid)
    {
        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> itemlist = roc.getMenuForGlobalization(languageid);
        return JsonConvert.SerializeObject(itemlist);
    }

    [WebMethod]
    public string getLanguage()
    {
        RestrOrderController roc = new RestrOrderController();
        List<LanguageMenu> list = roc.getLanguage();
        return JsonConvert.SerializeObject(list);
    }

    [WebMethod]
    public void saveLanguageMenu(int languageid, List<LanguageMenu> LanguageMenu)
    {
        RestrOrderController roc = new RestrOrderController();
        roc.saveLanguageMenu(languageid, LanguageMenu);
    }
}