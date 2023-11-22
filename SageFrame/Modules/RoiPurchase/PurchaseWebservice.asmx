 <%@ WebService Language="C#" Class="PurchaseWebservice" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using SageFrame.RestoLoyalty;
using SageFrame.Security;
using SageFrame.Security.Entities;
using Newtonsoft.Json;


/// <summary>
/// Summary description for PurchaseWebservice
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class PurchaseWebservice : System.Web.Services.WebService
{

    public PurchaseWebservice()
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
    public int RestroPurchaseOrder(purchaseMain PurchaseObject, bool goodReceived, string PoNO, int StID, MemberInfo memberInfo, decimal extradiscount, List<PurchasePayment> purchasePayment)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            int purchase = roc.RestroPurchaseOrder(PurchaseObject);
            if (goodReceived == true)
            {
                goodsReceiveMain goodReceive = new goodsReceiveMain();
                List<goodsReceiveMain> data = roc.GoodReceiveAutoNumber();
                List<goodsReceiveMain> goodReceiveList = roc.getGoodsReceive(PoNO);
                goodReceive.PurchaseObjItemBal = new List<itemBal>();
                goodReceive.RecquistionObjectDetails = new List<RecquistionDetails>();
                foreach (goodsReceiveMain item in goodReceiveList)
                {
                    itemBal itm = new itemBal();
                    itm.ITId = item.ItemID;
                    itm.STId = StID;
                    itm.PDId = item.PurchaseDetailsID;
                    itm.CLBal = Convert.ToDecimal(item.Quentity) * item.Conversion;
                    itm.Qnty = Convert.ToDecimal(item.RemainingQnty);
                    itm.Rate = item.UnitRate;
                    itm.Total = Convert.ToDecimal(item.Total);
                    itm.OPBal = 0;
                    itm.Discount = Convert.ToDecimal(item.Discount);
                    itm.IsVat = Convert.ToBoolean(Convert.ToInt32(item.IsVat));
                    goodReceive.PurchaseObjItemBal.Add(itm);
                }

                foreach (goodsReceiveMain item in data)
                {
                    goodReceive.GMNo = item.GMNo;
                }

                foreach (goodsReceiveMain item in goodReceiveList)
                {
                    RecquistionDetails req = new RecquistionDetails();
                    req.RecqDetailId = item.RecqDetailId;
                    req.RecqId = item.RecqId;
                    req.IssueQuantity = (float)Convert.ToDecimal(item.Total);
                    goodReceive.RecquistionObjectDetails.Add(req);
                }
                goodReceive.STId = StID;
                goodReceive.PostedBy = PurchaseObject.PostedBy;
                goodReceive.InvoiceNo = PurchaseObject.IvNo;
                goodReceive.InvoiceDate = PurchaseObject.PbDate;
                goodReceive.vendorId = PurchaseObject.Vid;
                goodReceive.paymentMode = PurchaseObject.SPMID;
                goodReceive.ExtraDiscount = Convert.ToDecimal(extradiscount);
                roc.GoodsReceivedss(goodReceive, memberInfo, purchasePayment);
            }
            return purchase;
        }
        catch (Exception)
        {

            throw;
        }

    }
    [WebMethod]
    //public List<ROInvItem> getitemfromdatabase()
    public string getitemfromdatabase()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<purchaseDetails> itemfromdb = roc.GetItemForOpenBalance();
            return JsonConvert.SerializeObject(itemfromdb);

        }
        catch (Exception)
        {

            throw;
        }

    }
    [WebMethod]
    public string GetUnitOfItemByID(int ids)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<purchaseDetails> unitbyId = roc.getUnitsWithConvertion(ids);
            return JsonConvert.SerializeObject(unitbyId);
        }
        catch (Exception)
        {
            throw;
        }
    }
    [WebMethod]
    public string SaveIssueToDatabase(issueMain IssueObject)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.IssueSave(IssueObject);

        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public string getIssueToDDl()
    {
        try
        {

            RestrOrderController roc = new RestrOrderController();
            List<roistore> ddl = roc.getIssueToDDl();
            return JsonConvert.SerializeObject(ddl);

        }
        catch (Exception)
        {

            throw;
        }

    }

    [WebMethod]
    public List<roistore> getStoreForDDL()
    {
        try
        {

            RestrOrderController roc = new RestrOrderController();
            return roc.getIssueToDDlHirerchy();

        }
        catch (Exception)
        {

            throw;
        }

    }
    [WebMethod]
    public List<purchaseDetails> getPurchaseDetails()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.getPurchaseDetails();

        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<purchaseDetails> getgoodreceiveforissue()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.getgoodreceiveforissue();

        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public int GoodsReceivedss(goodsReceiveMain GoodReived, MemberInfo memberInfo, List<PurchasePayment> purchasePayment)
    { 
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.GoodsReceivedss(GoodReived, memberInfo, purchasePayment);

        }
        catch (Exception)
        {

    throw;
}
    }
    [WebMethod]
public String changeCurrencyToWords(String numb)
{
    NumberToEnglish nte = new NumberToEnglish();
    return nte.changeCurrencyToWords(numb);
}
[WebMethod]
public List<purchaseDetails> getitemidbyname(string itemname)
{
    RestrOrderController roc = new RestrOrderController();
    return roc.getitemidbyname(itemname);
}


[WebMethod]
public string getGoodsReceive(string PoNO)
{
    RestrOrderController roc = new RestrOrderController();
    List<goodsReceiveMain> recieve = roc.getGoodsReceive(PoNO);
    return JsonConvert.SerializeObject(recieve);
}

[WebMethod]
public void GoodsDelete(int GMId)
{
    RestrOrderController roc = new RestrOrderController();
    roc.GoodsDelete(GMId);
}

[WebMethod]
public List<purchaseDetails> GETITEMIDPOIDBYNAME(string ItemName)
{
    RestrOrderController roc = new RestrOrderController();
    return roc.GETITEMIDPOIDBYNAME(ItemName);
}

[WebMethod]
public string getVender()
{
    RestrOrderController objCon = new RestrOrderController();
    List<MemberInfo> vendorlist = objCon.getVender();
    return JsonConvert.SerializeObject(vendorlist);
}

[WebMethod]
public List<purchaseMains> getPurchaseDetailsbyID(int mainId)
{
    RestrOrderController objCon = new RestrOrderController();
    return objCon.getPurchaseDetailsbyID(mainId);
}
[WebMethod]
public void SaveAdjsment(adjustmentMain AdjustMain)
{
    try
    {
        RestrOrderController roc = new RestrOrderController();
        roc.SaveAdjsment(AdjustMain);

    }
    catch (Exception)
    {

        throw;
    }
}
[WebMethod]
public string getPurchaseList(string startDate, string endDate)
{
    RestrOrderController roc = new RestrOrderController();
    List<purchaseMains> purchase = roc.getPurchaseList(startDate,endDate);
    return JsonConvert.SerializeObject(purchase);
}

[WebMethod]
public List<adjustmentMain> getadjustment()
{
    RestrOrderController res = new RestrOrderController();
    return res.getadjustment();
}

[WebMethod]
public void ajustdelete(int AMId)
{
    RestrOrderController roc = new RestrOrderController();
    roc.ajustdelete(AMId);
}

[WebMethod]
public string getissuemain()
{
    RestrOrderController roc = new RestrOrderController();
    List<issueMain> main = roc.getissuemain();
    return JsonConvert.SerializeObject(main);
}

[WebMethod]
public void DELETEissue(int IMId)
{
    RestrOrderController roc = new RestrOrderController();
    roc.DELETEissue(IMId);

}

[WebMethod]
public void deletePurchase(int mainId, int detailsId)
{
    RestrOrderController roc = new RestrOrderController();
    roc.deletePurchase(mainId, detailsId);

}


[WebMethod]
public void deleteAfterEdit(int idForDelete, int MainIdForDelete)
{
    RestrOrderController roc = new RestrOrderController();
    roc.deleteAfterEdit(idForDelete, MainIdForDelete);

}

[WebMethod]
public void DeleteAdjustmentType(int id, string Username)
{
    //int empId = 0;
    //if (!int.TryParse(id, out empId))
    //{
    //    empId = -1;// or some invalid Id which won't appear in DB
    //}
    RestrOrderController roc = new RestrOrderController();
    roc.DeleteAdjustmentType(id, Username);

}
[WebMethod]
public string stockreport(int storeID, string searchText)
{
    RestrOrderController roc = new RestrOrderController();
    List<stockReport> report = roc.stockreport(storeID, searchText);
    return JsonConvert.SerializeObject(report);
}
[WebMethod]
public string stockreportdaily(DateTime TodayDate)
{
    RestrOrderController roc = new RestrOrderController();
    List<stockReport> dailystock = roc.stockreportdaily(TodayDate);
    return JsonConvert.SerializeObject(dailystock);
}

[WebMethod]
public string stockreportWeekly(DateTime TodayDate)
{
    RestrOrderController roc = new RestrOrderController();
    List<stockReport> weeklystock = roc.stockreportWeekly(TodayDate);
    return JsonConvert.SerializeObject(weeklystock);

}
[WebMethod]
public string stockreportMonthly(string year, string month)
{
    RestrOrderController roc = new RestrOrderController();
    List<stockReport> monthlystock = roc.stockreportMonthly(year, month);
    return JsonConvert.SerializeObject(monthlystock);
}

[WebMethod]
public string stockreportYear(string year)
{
    RestrOrderController roc = new RestrOrderController();
    List<stockReport> yearstock = roc.stockreportYear(year);
    return JsonConvert.SerializeObject(yearstock);
}

[WebMethod]
public string stockreportRange(DateTime StartDate, DateTime EndDate)
{
    RestrOrderController roc = new RestrOrderController();
    List<stockReport> rangestock = roc.stockreportRange(StartDate, EndDate);
    return JsonConvert.SerializeObject(rangestock);
}

[WebMethod]
public List<AdjustmentType> getadjustmentType()
{
    RestrOrderController roc = new RestrOrderController();
    return roc.getadjustmentType();

}

[WebMethod]
public AdjustmentType GettypedatabyId(int TypeId)
{
    RestrOrderController roc = new RestrOrderController();
    return roc.GettypedatabyId(TypeId);

}

[WebMethod]
public void EditAdjustmentType(int TypeId, string Name, Boolean IsActive, string Username)
{
    RestrOrderController roc = new RestrOrderController();
    roc.EditAdjustmentType(TypeId, Name, IsActive, Username);
}

[WebMethod]
public List<FiscalYear> getTodayFiscalYr()
{
    RestrOrderController roc = new RestrOrderController();
    return roc.getTodayFiscalYr();
}

[WebMethod]
public List<AdjustmentDetails> GetdataByPurchaseOrderId(int Id)
{
    RestrOrderController roc = new RestrOrderController();
    return roc.GetdataByPurchaseOrderId(Id);
}

[WebMethod]
public string GetCusOnChange(int MembershipID)
{
    try
    {

        RestoLoyaltyController dcobj = new RestoLoyaltyController();
        List<MemberInfo> cusOnChange = dcobj.GetCusOnChange(MembershipID);
        return JsonConvert.SerializeObject(cusOnChange);
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
public List<issueMain> GetIssueDetailsbyId(int imid)
{
    RestrOrderController roc = new RestrOrderController();
    return roc.GetIssueDetailsbyId(imid);
}


[WebMethod]
public List<purchaseMain> getAutoNumber()
{
    RestrOrderController roc = new RestrOrderController();
    return roc.getAutoNumber();
}

[WebMethod]
public string GetGoodReceivedPO()
{
    RestrOrderController objCon = new RestrOrderController();
    List<goodsReceiveMain> goods = objCon.GetGoodRecievedPO();
    return JsonConvert.SerializeObject(goods);
}


[WebMethod]
public List<goodsReceiveMain> getGoodReceived(int detailsId)
{
    RestrOrderController roc = new RestrOrderController();
    return roc.getGoodReceived(detailsId);
}


[WebMethod]
public string getPurchaseDetailsFor(int purchaseid)
{
    RestrOrderController roc = new RestrOrderController();
    List<purchaseMains> edit = roc.getPurchaseDetailsFor(purchaseid);
    return JsonConvert.SerializeObject(edit);
}

[WebMethod]
public void SaveAdjustmentType(AdjustmentType type)
{
    RestrOrderController roc = new RestrOrderController();
    roc.SaveAdjustmentType(type);

}

[WebMethod]
public List<adjustmentMain> getAdjustmentAutoNumber()
{
    RestrOrderController roc = new RestrOrderController();
    return roc.getAdjustmentAutoNumber();
}


[WebMethod]
public string getPoDetailsFromVendor(int vendorid)
{
    RestrOrderController roc = new RestrOrderController();
    List<purchaseMains> vendor = roc.getPoDetailsFromVendor(vendorid);
    return JsonConvert.SerializeObject(vendor);
}

[WebMethod]
public virtual SageFrameUserCollection GetAllUsers()
{
    MembershipController mhc = new MembershipController();
    return (mhc.GetAllUsers());
}

[WebMethod]
public string ReceiptNo()
{
    RestrOrderController roc = new RestrOrderController();
    List<goodsReceiveMain> data = roc.GoodReceiveAutoNumber();
    return data[0].GMNo;
}

[WebMethod]
public string GetPurchaseDetailsbypurchaseID(int purchasemainID)
{
    PurchaseData purchase = new PurchaseData();
    RestrOrderController roc = new RestrOrderController();
    purchase.purchaseMain = roc.GetPurchaseDetailsbypurchaseID(purchasemainID);
    purchase.companyInfo = roc.getcompanyInfo();
    return JsonConvert.SerializeObject(purchase);

}

[WebMethod]
public string GetGoodsDetailsbygmID(int gmID)
{
    PurchaseData purchase = new PurchaseData();
    RestrOrderController roc = new RestrOrderController();
    purchase.goodsMain = roc.GetGoodsDetailsbygmID(gmID);
    purchase.companyInfo = roc.getcompanyInfo();
    return JsonConvert.SerializeObject(purchase);

}


[WebMethod]
public string getIssueReport(string startDate, string endDate, string ISNo, string itemname)
{
    RestrOrderController roc = new RestrOrderController();
    List<issueMain> report = roc.getIssueReportDetails(startDate, endDate, ISNo, itemname);
    return JsonConvert.SerializeObject(report);
}

[WebMethod]
public string getCompanyInfo()
{
    RestrOrderController roc = new RestrOrderController();
    List<companyInfo> company = roc.getcompanyInfo();
    return JsonConvert.SerializeObject(company.FirstOrDefault());

}

[WebMethod]
public string GetGoodsRecieveFromPurchaseID(int purchasemainID)
{
    PurchaseData purchase = new PurchaseData();
    RestrOrderController roc = new RestrOrderController();
    purchase.goodsMain = roc.GetGoodsRecieveFromPurchaseID(purchasemainID);
    purchase.companyInfo = roc.getcompanyInfo();
    return JsonConvert.SerializeObject(purchase);

}

[WebMethod]
public string GetPurchaseBook(string FromDate, string ToDate)
{
    RestrOrderController roc = new RestrOrderController();
    List<goodsReceiveMain> purchasebook = roc.GetPurchaseBook(FromDate, ToDate);
    return JsonConvert.SerializeObject(purchasebook);
}

[WebMethod]
public string GetItemList()
{
    RestrOrderController roc = new RestrOrderController();
    List<ROInvItem> invItem = roc.GetItemList();
    return JsonConvert.SerializeObject(invItem);
}



[WebMethod]
public string GetInventoryItemList()
{
    RestrOrderController roc = new RestrOrderController();
    List<ROInvItem> invItem = roc.GetInventoryItemList();
    return JsonConvert.SerializeObject(invItem);
}

[WebMethod]
public string GetPaymentModesAndProvider()
{
    RestrOrderController roc = new RestrOrderController();
    return JsonConvert.SerializeObject(roc.GetPaymentModesAndProvidersForAdvancePayment());
}


    [WebMethod]
    public string getStockDetailByItem(StockDetailItem obj)
    {
        RestrOrderController roc = new RestrOrderController();
        return JsonConvert.SerializeObject(roc.getStockDetailByItem(obj));
    }


}
