<%@ WebService Language="C#" Class="SalesPaymentMode" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using SageFrame.CostCenter;
using System.Drawing.Printing;
using System.Text;
using System.Drawing;
/// <summary>
/// Summary description for OrderItemWebserviceSaveOrderIntoDataBase
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class SalesPaymentMode : System.Web.Services.WebService
{
    public SalesPaymentMode()
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
    public void SPMSaveTodatabase(ItemsClass ItemsInf)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.ItemSaveTodatabase(ItemsInf);

        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<ItemsClass> GetSPMfromDatabase()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetItemFromDatabase();

        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public void SPMDelete(int ItemID)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.ItemDelete(ItemID);
        }
        catch (Exception ex)
        {
            throw ex;

        }
    }
}