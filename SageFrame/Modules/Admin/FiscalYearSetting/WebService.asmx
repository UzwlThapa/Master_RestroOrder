<%@ WebService Language="C#" Class="WebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.FiscalYear;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    public System.Collections.Generic.List<FiscalYearInfo> GetAllFiscalYear()
    {
        FicalYearController obj = new FicalYearController();
        return obj.GetAllFiscalYear();
    }
    [WebMethod]
    public void SaveFiscalYear(FiscalYearInfo info)
    {
        FicalYearController obj = new FicalYearController();
        obj.SaveFiscalYear(info);
    }

}