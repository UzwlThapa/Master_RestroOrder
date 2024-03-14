<%@ WebService Language="C#" CodeBehind="~/App_Code/WebServiceForItemBalance.cs" Class="WebServiceForItemBalance" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestoLoyalty;
using SageFrame.RestroOrder;

/// <summary>
/// Summary description for WebServiceForItemBalance
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class WebServiceForItemBalance : System.Web.Services.WebService {

    public WebServiceForItemBalance () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public List<MvPurchaseDetails> GetUnitOfItemByID(int ids)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.getUnitsWithConvertion(ids);

        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<MvPurchaseDetails> GetItemForSearch()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.GetItemForOpenBalance();

        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }


    [WebMethod]
    public void SaveBalance(BalanceInfo BalanceInfo)
    {
        try
        {
            RestoLoyaltyController dfcobj = new RestoLoyaltyController();
            dfcobj.SaveBalance(BalanceInfo);
        }
        catch (Exception)
        {

            throw;



        }
    }
    [WebMethod]
    public List<BalanceInfo> GetItemBalance()
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        return dfcobj.GetItemBalance();

    }
    //[WebMethod]
    //public void Deletebalance(int RId)
    //{
    //    RestoLoyaltyController dfcobj = new RestoLoyaltyController();
    //    dfcobj.Deletebalance(RId);

    //}
    [WebMethod]
    public void Deletebalance(int ItemBalID)
    {
        try
        {

            RestoLoyaltyController dfpobj = new RestoLoyaltyController();
            dfpobj.Deletebalance(ItemBalID);

        }
        catch (Exception)
        {

            throw;
        }

    }

    [WebMethod]
    public List<ItemInfo> GetItemDropDown()
    {
        try
        {

            RestoLoyaltyController dcobj = new RestoLoyaltyController();
            return dcobj.GetItemDropDown();
        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<SageFrame.RestroOrder.roistore> GetStoreDropDown()
    {
        try
        {

            RestrOrderController dcobj = new RestrOrderController();
            return dcobj.getStoreList();
        }
        catch (Exception)
        {

            throw;
        }
    }
}
