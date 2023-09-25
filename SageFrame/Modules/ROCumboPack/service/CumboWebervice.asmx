<%@ WebService Language="C#" Class="CumboWebervice" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.CostCenter;
using SageFrame.RestroOrder;
using Newtonsoft.Json;
/// <summary>
/// Summary description for CumboWebervice
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
//To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CumboWebervice : System.Web.Services.WebService
{

    public CumboWebervice()
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
    public string GetCostCenter()
    {
        try
        {
            CostCenterController rcobj = new CostCenterController();
            List<CostCenterInfo> costcenter = rcobj.GetCostCenter();
            return JsonConvert.SerializeObject(costcenter);
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public string GetItemsfromDatabase()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            List<ItemsClass> itemsCumbo = rocobj.getitemforcumbo();
            return JsonConvert.SerializeObject(itemsCumbo);
        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<ItemsClass> getItemRateByItem(string ItemName)
    {

        RestrOrderController rocobj = new RestrOrderController();
        return rocobj.getItemRateByItem(ItemName);

    }
    [WebMethod]
    public int restroCombo(cumbomain comboorder)
    {
        RestrOrderController rocobj = new RestrOrderController();
        return rocobj.comboorder(comboorder);
    }

    [WebMethod]
    public string getcumbolist()
    {
        RestrOrderController rocobj = new RestrOrderController();
        List<cumbomain> list = rocobj.getcumbolist(true);
        return JsonConvert.SerializeObject(list);
    }

    [WebMethod]
    public string getInactivecumbolist()
    {
        RestrOrderController rocobj = new RestrOrderController();
        List<cumbomain> list = rocobj.getcumbolist(false);
        return JsonConvert.SerializeObject(list);
    }

    [WebMethod]
    public void DELETECOMBO(int comboid, string UserName)
    {
        RestrOrderController rocobj = new RestrOrderController();
        rocobj.DELETECOMBO(comboid, UserName);
    }
    [WebMethod]
    public string getcombodatabyid(int comboid)
    {
        RestrOrderController rocobj = new RestrOrderController();
        List<cumbomainDetails>  list = rocobj.getcombodatabyid(comboid);
        return JsonConvert.SerializeObject(list);

    }
    [WebMethod]
    public void updateisactive(int ComboID)
    {
        RestrOrderController rocobj = new RestrOrderController();
        rocobj.updateisactive(ComboID);
    }

    [WebMethod]
    public void InactiveCombo()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();

            rocobj.InactiveCombo();

        }
        catch (Exception)
        {

            throw;
        }

    }

    [WebMethod]
    public string getUpcomingcumbolist()
    {
        RestrOrderController rocobj = new RestrOrderController();
        List<cumbomain> list = rocobj.getUpcomingcumbolist();
        return JsonConvert.SerializeObject(list);
    }

    [WebMethod]
    public string getCancelledcumbolist()
    {
        RestrOrderController rocobj = new RestrOrderController();
        List<cumbomain> list = rocobj.getCancelledcumbolist();
        return JsonConvert.SerializeObject(list);
    }
}

