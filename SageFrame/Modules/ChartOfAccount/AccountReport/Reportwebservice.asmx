<%@ WebService Language="C#" CodeBehind="~/App_Code/SalesReport.cs" Class="SalesReport" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using SageFrame.AccountReport;
using SageFrame.ChartOfAccount;
using Newtonsoft.Json;


/// <summary>
/// Summary description for SalesReport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class SalesReport : System.Web.Services.WebService
{

    public SalesReport()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string GeneralLedgerReport(DateTime StartDate, DateTime EndDate, string FaIds)
    {
        AccountReportController con = new AccountReportController();
        List<AccountReportInfo> ledgerReport = con.GeneralLedgerReport(StartDate, EndDate, FaIds);
        return JsonConvert.SerializeObject(ledgerReport);
    }

    [WebMethod]
    public string GetLedgerDetail(int transactionID)
    {
        AccountReportController con = new AccountReportController();
        var res = con.GetLedgerDetail(transactionID);
        return JsonConvert.SerializeObject(res);
    }

    [WebMethod]
    public string GetTransactionReport(DateTime From, DateTime To)
    {
        AccountReportController con = new AccountReportController();
        List<TransactionReportInfo> transReport = con.GetTransactionReport(From, To);
        return JsonConvert.SerializeObject(transReport);
    }

    [WebMethod]
    public string GetTransactionDetailReport(DateTime From, DateTime To, int GL_ID)
    {
        AccountReportController con = new AccountReportController();
        List<TransactionReportDetailsInfo> details = con.GetTransactionDetailReport(From, To, GL_ID);
        return JsonConvert.SerializeObject(details);
    }

    [WebMethod]
    public List<AccountReportInfo> TrialBalanceReport(DateTime Date)
    {
        AccountReportController con = new AccountReportController();
        return con.TrialBalanceReport(Date);
    }

    [WebMethod]
    public List<TransactionReportInfo> GetGL_Name()
    {
        AccountReportController con = new AccountReportController();
        return con.GetGL_Name();
    }

    [WebMethod]
    public string getFinancialAc()
    {
        AccountController con = new AccountController();
        List<AccountInfo> ac = con.getFinancialAc();
        return JsonConvert.SerializeObject(ac);
    }

    [WebMethod]
    public string getcompanyInfo()
    {
        RestrOrderController con = new RestrOrderController();
        List<companyInfo> info = con.getcompanyInfo();
        return JsonConvert.SerializeObject(info);
    }
}
