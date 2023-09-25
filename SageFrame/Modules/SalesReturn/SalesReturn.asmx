<%@ WebService Language="C#" Class="SalesReturn" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using SageFrame.RestoLoyalty;
using Newtonsoft.Json;

/// <summary>
/// Summary description for SalesReturn
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class SalesReturn : System.Web.Services.WebService
{

    public SalesReturn()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string getSalesReport(DateTime startDate, DateTime endDate, string billNo)
    {
        RestrOrderController rc = new RestrOrderController();
        List<dailyreports> salesrep = rc.getSalesReportForSalesReturn(startDate, endDate, billNo);
        return JsonConvert.SerializeObject(salesrep);
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

        bill.orderDetail = ord;
        //bill.billInfo = billInfo;
        bill.companyInfo = roc.getcompanyInfo();
        bill.billingTerm = roc.getcakebillingTermbySalesMasterID(SalesMasterID.ToString(), SalesType);
        bill.cuscenter = roc.getdiscountfromcostcenter();
        bill.AmntInWord = NumberConverter.DecimalToWord(bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount);
        bill.discount = roc.getcakediscount(SalesMasterID).FirstOrDefault();

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
    public void SalesReturnWithReason(int id, string userName, string reason, string date, bool restoreOrder)
    {
        RestrOrderController rc = new RestrOrderController();
        rc.CancelBillWithReason(id, userName, reason, restoreOrder);

        CBMS cbms = new CBMS();
        cbms.returnSales(id, date, reason);
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
    public PinUser GetRolesByUsername(string username)
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.GetRolesByUsername(username);
    }

    [WebMethod]
    public void UpdateAcc()
    {
        RestrOrderController roc = new RestrOrderController();
        roc.UpdateAcc();
    }

}
