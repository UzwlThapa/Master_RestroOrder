<%@ WebService Language="C#" CodeBehind="~/App_Code/WebServiceForCusBalanceReport.cs" Class="WebServiceForCusBalanceReport" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestoLoyalty;
using SageFrame.RestroOrder;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using Newtonsoft.Json;

/// <summary>
/// Summary description for WebServiceForCusBalanceReport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebServiceForCusBalanceReport : System.Web.Services.WebService
{

    JavaScriptSerializer jss = new JavaScriptSerializer();

    [WebMethod]
    public List<dailyreport> getCustomerBalanceReport(DateTime startDate, DateTime endDate, int CustomerName)
    {
        try
        {
            RestrOrderController dcobj = new RestrOrderController();
            return dcobj.getCustomerBalanceReport(startDate, endDate, CustomerName);
        }
        catch (Exception)
        {
            throw;
        }
    }

    public WebServiceForCusBalanceReport()
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
    public List<CardProvider> getCusName(int IsCustomer)
    {
        try
        {

            RestrOrderController dcobj = new RestrOrderController();
            return dcobj.getCusName(IsCustomer);
        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public List<dailyreport> GetMemberReport(int MembershipID)
    {
        try
        {

            RestrOrderController rc = new RestrOrderController();
            return rc.GetMemberReport(MembershipID);
        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public MemberInfo GetCusOnChange(int MembershipID)
    {
        try
        {

            RestoLoyaltyController dcobj = new RestoLoyaltyController();
            return dcobj.GetCusOnChange(MembershipID).FirstOrDefault();
        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<BalanceTransaction> getCustomerTransactionbyID(int MembershipID)
    {
        try
        {

            RestoLoyaltyController dcobj = new RestoLoyaltyController();
            return dcobj.getCustomerTransactionbyID(MembershipID);
        }
        catch (Exception)
        {

            throw;
        }
    }




    [WebMethod]

    public List<dailyreport> getdailyCusReportByMonthly(string year, string month)
    {
        RestrOrderController rc = new RestrOrderController();
        return rc.getdailyCusReportByMonthly(year, month);
    }
    [WebMethod]

    public List<dailyreport> getdailyCusReportByYearly(string year)
    {

        RestrOrderController rc = new RestrOrderController();
        return rc.getdailyCusReportByYearly(year);
    }
    [WebMethod]
    public string GetProviderList()
    {
        RestrOrderController rc = new RestrOrderController();
        return jss.Serialize(rc.getCardProvider());
    }

    public class Receipt
    {
        public companyInfo company { get; set; }
        public MemberInfo member { get; set; }
        public CreditPayment paymentMode { get; set; }
        public string amountInWords { get; set; }
    }
    [WebMethod]
    public string SaveCustomerAmount(MemberInfo MemberInfo, CreditPayment payment)
    {
        try
        {
            RestrOrderController rc = new RestrOrderController();
            RestoLoyaltyController dfcobj = new RestoLoyaltyController();
            string voucherNo = dfcobj.UPDATE_MembershipBalance(MemberInfo, payment);
            Receipt receiptData = new Receipt();
            receiptData.company = rc.getcompanyInfo().FirstOrDefault();

            receiptData.member = GetCusOnChange(MemberInfo.MembershipID);

            if (receiptData.member.IsCustomer)
            {
                receiptData.member.PayAmount = MemberInfo.PayAmount;
                receiptData.member.SettlementAmount = MemberInfo.SettlementAmount;

                receiptData.paymentMode = payment;
                receiptData.paymentMode.VoucherNo = (receiptData.member.IsCustomer ? "RV-" : "PV-") + voucherNo;

                receiptData.amountInWords = NumberConverter.DecimalToWord(MemberInfo.PayAmount);
                return jss.Serialize(receiptData);
            }
            else
            {
                return "";
            }
        }
        catch (Exception)
        {

            throw;
        }

    }

    [WebMethod]
    public string GetGoodsReceivedDetailsByGMId(int gmid)
    {
        RestrOrderController rc = new RestrOrderController();
        return jss.Serialize(rc.GetGoodsReceivedDetailsByGMId(gmid));
    }
    [WebMethod]
    public string sendSMS(string to, string text)
    {
        SMS sms = new SMS();
        return sms.PostSMS(to, text);
    }

    [WebMethod]
    public string savePrintCount(int Printcount, string BillNo, string PrintedBy)
    {
        RestrOrderController rocc = new RestrOrderController();
        if (BillNo != "")
        {
            return rocc.SavePrintCountDetail(Printcount, BillNo, PrintedBy);
        }
        return "";
    }

    [WebMethod]
    public string getcustomerbalanceReceipt(int memberpayid)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        List<CreditPayment> payment = dfcobj.getcustomerbalanceReceipt(memberpayid);
        return JsonConvert.SerializeObject(payment);
    }

    [WebMethod]
    public void CreditCancelWithReason(int id, int memberId, string userName, string reason, string date)
    {
        RestrOrderController rc = new RestrOrderController();
        rc.CreditCancelWithReason(id, memberId, userName, reason, date);
    }
}
