<%@ WebService Language="C#" Class="wsBalanceSheet" %>

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
public class wsBalanceSheet  : System.Web.Services.WebService {

    [WebMethod]
    public string getAllFinancialAcForGrid(string startdate, string enddate)
    {
        AccountController con = new AccountController();
        return con.getBalanceSheet(startdate,enddate);
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
        List<companyInfo> info = con.getcompanyInfo();
        return JsonConvert.SerializeObject(info);
    }

    
}