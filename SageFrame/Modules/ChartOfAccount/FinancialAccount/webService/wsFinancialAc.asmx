<%@ WebService Language="C#" Class="wsFinancialAc" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.ChartOfAccount;
using Newtonsoft.Json;
using SageFrame.RestroOrder;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsFinancialAc : System.Web.Services.WebService
{

    [WebMethod]
    public List<AccountInfo> getParentFinancialAcName()
    {
        AccountController con = new AccountController();
        return con.getParentFinancialAcName();
    }

    [WebMethod]
    public List<AccountInfo> getFinancialSysName()
    {
        AccountController con = new AccountController();
        return con.getFinancialSysName();
    }

    [WebMethod]
    public int saveFinancialAc(AccountInfo info)
    {
        AccountController con = new AccountController();
        return con.saveFinancialAc(info);
    }





    [WebMethod]
    public string getAllFinancialAcForGrid()
    {
        AccountController con = new AccountController();
        List<AccountInfo> allfinance = con.getAllFinancialAcForGrid();
        return JsonConvert.SerializeObject(allfinance);
    }
    [WebMethod]
    public string deleteFinancialAcByID(int id, string username)
    {
        AccountController con = new AccountController();
        string msg = con.deleteFinancialAcByID(id, username);
        return msg;
    }

    [WebMethod]
    public List<bankInfo> getBankInfoByFinancialAcID(int FinancialAcID)
    {
        AccountController con = new AccountController();
        return con.getBankInfoByFinancialAcID(FinancialAcID);
    }

    [WebMethod]
    public string getFinancialAc()
    {
        AccountController con = new AccountController();
        List<AccountInfo> finance = con.getFinancialAc();
        return JsonConvert.SerializeObject(finance);
    }

    [WebMethod]
    public void MergeFinancialAcc(MergerAccDetails obj)
    {
        AccountController con = new AccountController();
        con.MergeFinancialAcc(obj);
    }

    [WebMethod]
    public void AddOpeningBalance(ACOpeningInfo obj)
    {
        AccountController con = new AccountController();
        con.AddOpeningBalance(obj);
    }

        
    [WebMethod]
    public void UpdateOpeningBalance(OpeningBalDetails obj)
    {
        AccountController con = new AccountController();
        con.UpdateOpeningBalance(obj);
    }

        

    [WebMethod]
    public string getOpeningBalanceDetails()
    {
        AccountController con = new AccountController();
        List<OpeningBalDetails> obj = new List<OpeningBalDetails>();
        obj = con.getOpeningBalanceDetails();
        return JsonConvert.SerializeObject(obj);
    }

    [WebMethod]
    public string GetAcOpeningDetails(int id)
    {
        AccountController con = new AccountController();
        OpeningBalDetails obj = con.getOpeningBalanceDetailsById(id);
        return JsonConvert.SerializeObject(obj);
    }

        



}