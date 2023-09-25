<%@ WebService Language="C#" Class="wsFinancialAc" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.ChartOfAccount;
using Newtonsoft.Json;

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
    public void saveFinancialAc(AccountInfo info)
    {
        AccountController con = new AccountController();
        con.saveFinancialAc(info);
    }

    [WebMethod]
    public List<AccountInfo> getAllFinancialAcForGrid()
    {
        AccountController con = new AccountController();
        return con.getAllFinancialAcForGrid();
    }
    [WebMethod]
    public void deleteFinancialAcByID(int id, string username)
    {
        AccountController con = new AccountController();
        con.deleteFinancialAcByID(id, username);
    }


    [WebMethod]
    public string getVoucharType()
    {
        AccountController con = new AccountController();
        List<Voucher> vtype = con.getVoucharType();
        return JsonConvert.SerializeObject(vtype);
    }

    [WebMethod]
    public bool CheckForDisplayChequeNo(int FinancialAcID)
    {
        AccountController con = new AccountController();
        return con.CheckForDisplayChequeNo(FinancialAcID);
    }

    [WebMethod]
    public int SaveTransaction(Transaction Transaction)
    {
        AccountController con = new AccountController();
        return con.SaveTransaction(Transaction);
    }

    [WebMethod]
    public string getTempTransactionList(string startDate, string endDate)
    {
        AccountController con = new AccountController();
        List<Transaction> templist = con.getTempTransactionList(startDate,endDate);
        return JsonConvert.SerializeObject(templist);
    }

    [WebMethod]
    public List<TransactionDetails> getTransactionByID(int transactionID)
    {
        AccountController con = new AccountController();
        return con.getTransactionByID(transactionID);
    }

    [WebMethod]
    public void DeleteTempTransactionByID(int transactionID,string username)
    {
        AccountController con = new AccountController();
        con.DeleteTempTransactionByID(transactionID,username);
    }

    [WebMethod]
    public string getFinancialAc()
    {
        AccountController con = new AccountController();
        List<AccountInfo> finance = con.getFinancialAc();
        return JsonConvert.SerializeObject(finance);
    }

    [WebMethod]
    public string getPaymentMethods()
    {
        AccountController con = new AccountController();
        List<PaymentModes> obj = con.getPaymentMethods();
        return JsonConvert.SerializeObject(obj);
    }

    [WebMethod]
    public void SavePaymentReceiveVoucher(PaymentReceiveVoucher obj)
    {
        AccountController con = new AccountController();
        con.SavePaymentReceiveVoucher(obj);
    }

}