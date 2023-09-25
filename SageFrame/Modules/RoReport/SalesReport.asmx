  <%@ WebService Language="C#" CodeBehind="~/App_Code/SalesReport.cs" Class="SalesReport" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using SageFrame.RestoLoyalty;
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
    public void SaveTotalCashPaid(MemberInfo MemberInfo)
    {
        try
        {
            RestoLoyaltyController dfcobj = new RestoLoyaltyController();
            RestoLoyaltyProvider dfpobj = new RestoLoyaltyProvider();
            dfcobj.SaveTotalCashPaid(MemberInfo);

        }
        catch (Exception)
        {

            throw;
        }

    }
    [WebMethod]
    public List<MemberInfo> getsdatass(int customer)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        return dfcobj.getmembershiplist(customer);

    }
    [WebMethod]
    public List<CardProvider> GetProviderList()
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.getCardProvider();
    }
    [WebMethod]
    public List<MemberInfo> GetCusOnChange(int MembershipID)
    {
        try
        {

            RestoLoyaltyController dcobj = new RestoLoyaltyController();
            return dcobj.GetCusOnChange(MembershipID);
        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public void SaveCustomerAmount(MemberInfo MemberInfo)
    {
        try
        {
            RestoLoyaltyController dfcobj = new RestoLoyaltyController();
            RestoLoyaltyProvider dfpobj = new RestoLoyaltyProvider();
            dfcobj.SaveCustomerAmount(MemberInfo);

        }
        catch (Exception)
        {

            throw;
        }

    }
    [WebMethod]
    public void UpdateSalesPayMode(SalesPayment salesPayment)
    {
        try
        {
            RestrOrderController dfcobj = new RestrOrderController();
            dfcobj.UpdateSalesPayMode(salesPayment);
        }
        catch (Exception)
        {

            throw;
        }

    }


    [WebMethod]

    public BillData GetBill(int SalesMasterID)
    {
        BillData bill = new BillData();
        RestrOrderController roc = new RestrOrderController();

        List<OrderDetailClass> ord = roc.GetdataforViewBill(SalesMasterID);
        BillInfo billInfo = roc.getbillInfo(SalesMasterID);
        foreach (OrderDetailClass item in ord)
        {
            int characLimit = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["ItemCharacterLimit"]);
            if (item.ITName.Length > characLimit)
            {
                item.ITName = item.ITName.Substring(0, characLimit) + "...";
            }
            //item.BillNo = ord[0].GetBillNo();
            item.orderExtraItem = roc.GetExtraSalesForItem(SalesMasterID).Where(p => p.ItemID == item.ItemId && !item.IsCombo).ToList();
        }

        bill.orderDetail = ord;
        bill.billInfo = billInfo;
        bill.companyInfo = roc.getcompanyInfo();
        bill.billingTerm = roc.getbillingTermbySalesMasterID(SalesMasterID.ToString());
        bill.cuscenter = roc.getdiscountfromcostcenter();
        bill.AmntInWord = NumberConverter.DecimalToWord(bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount);
        bill.discount = roc.getflatorperdiscount(SalesMasterID).FirstOrDefault();
        ord[0].BasicAmount = (bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount);
        if (ord[0].IsTable == false)
        {
            ord[0].BasicAmount = (bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount) - ord[0].AdvancePayment;
            bill.AmntInWord = NumberConverter.DecimalToWord((bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount) - ord[0].AdvancePayment);
        }
        bill.splitCostCenter = (System.Configuration.ConfigurationManager.AppSettings["SplitCostCenterInBill"] == "false" ? false : true);
        bill.costCenterGroup = roc.GetCostCenterGroup();
        bill.VATforBill = (bill.companyInfo[0].IsPan ? false : true);
        return  bill;
    }

    [WebMethod]
    public BillData GetCakeBill(int SalesMasterID, string SalesType)
    {
        BillData bill = new BillData();
        RestrOrderController roc = new RestrOrderController();

        List<OrderDetailClass> ord = roc.GetdataforViewCakeBill(SalesMasterID, SalesType);
        //BillInfo billInfo = roc.getbillInfo(SalesMasterID);
        //foreach (OrderDetailClass item in ord)
        //{
        //    int characLimit = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["ItemCharacterLimit"]);
        //    if(item.ITName.Length > characLimit){
        //        item.ITName = item.ITName.Substring(0, characLimit) + "...";
        //    }
        //    //item.BillNo = ord[0].GetBillNo();
        //    item.orderExtraItem = roc.GetExtraSalesForItem(SalesMasterID).Where(p => p.ItemID == item.ItemId && !item.IsCombo).ToList();
        //}

        bill.orderDetail = ord;
        //bill.billInfo = billInfo;
        bill.companyInfo = roc.getcompanyInfo();
        bill.billingTerm = roc.getcakebillingTermbySalesMasterID(SalesMasterID.ToString(), SalesType);
        bill.cuscenter = roc.getdiscountfromcostcenter();
        bill.AmntInWord = NumberConverter.DecimalToWord(bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount);
        bill.discount = roc.getcakediscount(SalesMasterID).FirstOrDefault();
        //ord[0].BasicAmount = (bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount);
        //if (ord[0].IsTable == false)
        //{
        //    ord[0].BasicAmount = (bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount) - ord[0].AdvancePayment;
        //    bill.AmntInWord = NumberConverter.DecimalToWord((bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount) - ord[0].AdvancePayment);
        //}
        bill.splitCostCenter = (System.Configuration.ConfigurationManager.AppSettings["SplitCostCenterInBill"] == "false" ? false : true);
        return bill;
    }

    [WebMethod]
    public string savePrintCount(int Printcount, string BillNo, string PrintedBy, string SalesType = "")
    {
        RestrOrderController rocc = new RestrOrderController();
        if (BillNo != "")
        {
            return rocc.SavePrintCountDetail(Printcount, BillNo, PrintedBy, SalesType);
        }
        return "";

    }
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string getdailyReport(DateTime dateTime)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> dailyreport = rc.getdailyReport(dateTime);
        return JsonConvert.SerializeObject(dailyreport);
    }

    [WebMethod]
    public string getSalesReport(DateTime startDate, DateTime endDate, string PaymentMode, int Status, int OrdertypeID, string CustName)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreports> salesrep = rc.getSalesReport(startDate, endDate, PaymentMode, Status, OrdertypeID, CustName);
        return JsonConvert.SerializeObject(salesrep);
    }

    [WebMethod]
    public string getAccSalesReport(DateTime startDate, DateTime endDate, string PaymentMode, int Status, int OrdertypeID, string CustName)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreports> salesrep = rc.getAccSalesReport(startDate, endDate, PaymentMode, Status, OrdertypeID, CustName);
        return JsonConvert.SerializeObject(salesrep);
    }

    [WebMethod]
    public string GetCostCenterDiscountReport(string startDate, string endDate)
    {
        RestrOrderController rc = new RestrOrderController();
        var res = rc.GetCostCenterDiscountReport(startDate, endDate);
        return JsonConvert.SerializeObject(res);
    }

    [WebMethod]

    public string getiemsalesreport(DateTime Start, DateTime EndDate)
    {
        RestrOrderController rc = new RestrOrderController();
        List<itemsales> salesreport = rc.getiemsalesreport(Start, EndDate);
        return JsonConvert.SerializeObject(salesreport);
    }

    [WebMethod]
    public string getdailyReportByWeekly(DateTime dateTime)
    {
        RestrOrderController rc = new RestrOrderController();

        List<dailyreport> dailyreport = rc.getdailyReportByWeekly(dateTime);
        return JsonConvert.SerializeObject(dailyreport);
    }

    [WebMethod]
    public string getdailyReportByMonthly(string year, string month)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> rep = rc.getdailyReportByMonthly(year, month);
        return JsonConvert.SerializeObject(rep);
    }

    [WebMethod]
    public string getdailyReportByYearly(string year)
    {

        RestrOrderController rc = new RestrOrderController();
        List<dailyreport> rep = rc.getdailyReportByYearly(year);
        return JsonConvert.SerializeObject(rep);
    }
    [WebMethod]
    public string getDailyItemSalesReport(DateTime startDate, DateTime endDate, int costCenterID, int pitid)
    {

        RestrOrderController rc = new RestrOrderController();
        List<itemsales> rep = rc.getDailyItemSalesReport(startDate, endDate, costCenterID, pitid);
        return JsonConvert.SerializeObject(rep);
    }

    [WebMethod]
    public string getSummaryItemSalesReport(DateTime startDate, DateTime endDate, int costCenterID, int pitid)
    {

        RestrOrderController rc = new RestrOrderController();
        List<itemsales> rep = rc.getSummaryItemSalesReport(startDate, endDate, costCenterID, pitid);
        return JsonConvert.SerializeObject(rep);
    }

    [WebMethod]
    public List<dailyreport> getdailyReportBySum(DateTime dateTime)
    {
        RestrOrderController rc = new RestrOrderController();
        return rc.getdailyReportBySum(dateTime);
    }

    [WebMethod]
    public List<dailyreport> getweeklysumbyDate(DateTime dateTime)
    {
        RestrOrderController rc = new RestrOrderController();
        return rc.getweeklysumbyDate(dateTime);
    }

    [WebMethod]
    public void CancelBillWithReason(int id, string userName, string reason, string date, bool restoreOrder)
    {
        RestrOrderController rc = new RestrOrderController();
        rc.CancelBillWithReason(id, userName, reason, restoreOrder);

        CBMS cbms = new CBMS();
        cbms.returnSales(id, date, reason);
    }

    [WebMethod]
    public void CancelBill(int id, string userName, string reason, string date, bool restoreOrder)
    {
        RestrOrderController rc = new RestrOrderController();
        rc.CancelBill(id, userName, reason, restoreOrder);

        CBMS cbms = new CBMS();
        cbms.CancelSales(id, date, reason);
    }

    [WebMethod]
    public void ChangePayMode(List<SalesPayment> SalesPayment)
    {
        RestrOrderController rc = new RestrOrderController();
        rc.ChangePaymentMode(SalesPayment);
    }

    [WebMethod]
    public List<MaterializedReport> MaterializedReportView(DateTime StartDate, DateTime EndDate, int Valid)
    {
        RestrOrderController rc = new RestrOrderController();
        return rc.MaterializedReportView(StartDate, EndDate, Valid);
    }

    [WebMethod]
    public string SaleReportByBillNo(int startBillNo, int endBillNo, int Status)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreports> report = rc.SaleReportByBillNo(startBillNo, endBillNo, Status);
        return JsonConvert.SerializeObject(report);
    }

    [WebMethod]
    public List<companyInfo> getcompanyInfo()
    {
        RestrOrderController con = new RestrOrderController();
        return con.getcompanyInfo();
    }
    [WebMethod]
    public List<OrderDetailClass> getBillBody(int SalesMasterID)
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.getBillBody(SalesMasterID);
    }
    [WebMethod]
    public string DecimalToWord(decimal number)
    {
        return NumberConverter.DecimalToWord(number);
    }
    [WebMethod]
    public List<usedBillingTermInfo> GetUsedBillingTerm(int SalesMasterID)
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.GetUsedBillingTerm(SalesMasterID);
    }
    [WebMethod]
    public string GetCostCenter()
    {
        RestrOrderController roc = new RestrOrderController();
        List<costCenter> costcenter = roc.getcostcenter();
        return JsonConvert.SerializeObject(costcenter);
    }

    [WebMethod]
    public string GetCategoryHirerchy(int categorylevel)
    {
        RestrOrderController roc = new RestrOrderController();
        List<ROInvItem> top = roc.GetCategoryHirerchy(categorylevel);
        return JsonConvert.SerializeObject(top);
    }


    [WebMethod]
    public PinUser GetRolesByUsername(string username)
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.GetRolesByUsername(username);
    }

    [WebMethod]
    public string GetOrderType()
    {
        RestrOrderController roc = new RestrOrderController();
        List<ordertype> order = roc.GetOrderType();
        return JsonConvert.SerializeObject(order);
    }

    [WebMethod]
    public void UpdateAcc()
    {
        RestrOrderController roc = new RestrOrderController();
        roc.UpdateAcc();
    }


}
