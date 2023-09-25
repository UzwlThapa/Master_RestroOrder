<%@ WebService Language="C#" Class="wsTrailBalance" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.ChartOfAccount;
using SageFrame.RestroOrder;
using Newtonsoft.Json;



[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsTrailBalance : System.Web.Services.WebService
{

    [WebMethod]
    public string getAllFinancialAcForGrid(DateTime Dates)
    {
        AccountController con = new AccountController();
        List<AccountInfo> finance = con.getTrailBalance(Dates);
        return JsonConvert.SerializeObject(finance);
    }
    [WebMethod]
    public string getFinancialAcDetails(int financialAcId, string date)
    {
        AccountController con = new AccountController();
        List<AccountInfo> finance = con.getFinancialAcDetails(financialAcId, date);
        return JsonConvert.SerializeObject(finance);
    }

    [WebMethod]
    public string getcompanyInfo()
    {
        RestrOrderController con = new RestrOrderController();
        List<companyInfo> company = con.getcompanyInfo();
        return JsonConvert.SerializeObject(company);
    }

}