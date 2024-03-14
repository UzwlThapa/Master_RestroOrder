<%@ WebService Language="C#" Class="ProductionHouse" %>

using System;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using Newtonsoft.Json;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ProductionHouse  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }


    [WebMethod]
    public void SaveProduction(ProductionMain production)
    {
        RestrOrderController roc = new RestrOrderController();
        roc.SaveProduction(production);
    }

    [WebMethod]
    public string GetInventoryItemWithSmallUnit()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<MvPurchaseDetails> invwithUnit =  roc.GetInventoryItemWithSmallUnit();
            return JsonConvert.SerializeObject(invwithUnit);
        }
        catch (Exception)
        {
            throw;
        }

    }

    [WebMethod]
    public string getIssueToDDlHirerchy()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<roistore> store = roc.getIssueToDDlHirerchy();
            return JsonConvert.SerializeObject(store);
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public string getPreviousProduction()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<ProductionMain> PrevProd = roc.getPreviousProduction();
            return JsonConvert.SerializeObject(PrevProd);
        }
        catch (Exception)
        {
            throw;
        }
    }

       [WebMethod]
    public string getPreviousProductionDetails(int ProductionId)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<ProductionDetails> PrevProd = roc.getPreviousProductionDetailsById(ProductionId);
            return JsonConvert.SerializeObject(PrevProd);
        }
        catch (Exception)
        {
            throw;
        }
    }

        

    [WebMethod]
    public string getProductionMain(DateTime fromDate, DateTime toDate, int storeid)
    {
        RestrOrderController roc = new RestrOrderController();
        List<ProductionMain> main = roc.getProductionMain(fromDate, toDate, storeid);
        return JsonConvert.SerializeObject(main);
    }


    [WebMethod]
    public string GetProductionDetailsByID(int id)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            List<ProductionDetails> pdID = roc.GetProductionDetailsByID(id);
            return JsonConvert.SerializeObject(pdID);
        }
        catch (Exception)
        {
            throw;
        }
    }
}