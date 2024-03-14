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
    public string getParentFinancialAcName()
    {

        AccountController con = new AccountController();
        List<AccountInfo> parent = con.getFinancialAc();
        return JsonConvert.SerializeObject(parent);
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
        return con.SaveVerifiedTransaction(Transaction);
    }

    [WebMethod]
    public string getTempTransactionList(string startDate, string endDate)
    {
        AccountController con = new AccountController();
        List<Transaction> temptrans = con.getTempTransactionList(startDate, endDate);
        return JsonConvert.SerializeObject(temptrans);
    }

    [WebMethod]
    public List<TransactionDetails> getTransactionByID(int transactionID)
    {
        AccountController con = new AccountController();
        return con.getTransactionByID(transactionID);
    }

    [WebMethod]
    public List<TransactionDetails> getVerifiedTransactionByID(int transactionID, int financialAccountId = 0)
    {
        AccountController con = new AccountController();
        return con.getVerifiedTransactionByID(transactionID, financialAccountId);
    }

    [WebMethod]
    public string getVerifiedTransactionList(string startDate, string endDate)
    {
        AccountController con = new AccountController();
        List<Transaction> verified = con.getVerifiedTransactionList(startDate, endDate);
        return JsonConvert.SerializeObject(verified);
    }
    [WebMethod]
    public void DeleteTempTransactionByID(int transactionID, string username)
    {
        AccountController con = new AccountController();
        con.DeleteTempTransactionByID(transactionID, username);
    }

    [WebMethod]
    public void SaveVerifiedTransactionByID(List<Transaction> Transaction)
    {
        AccountController con = new AccountController();
        con.SaveVerifiedTransactionByID(Transaction);
    }

    [WebMethod]
    public string TempPurchaseDetailExists()
    {
        AccountController con = new AccountController();
        string PuNo = con.TempPurchaseDetailExists();
        return JsonConvert.SerializeObject(new { PuNo = PuNo });
    }
}