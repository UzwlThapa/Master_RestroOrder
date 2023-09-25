<%@ WebService Language="C#" CodeBehind="~/App_Code/WebServiceOfRestoItem.cs" Class="WebServiceOfRestoItem" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestoLoyalty;

/// <summary>
/// Summary description for WebServiceOfRestoItem
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class WebServiceOfRestoItem : System.Web.Services.WebService {

    public WebServiceOfRestoItem () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
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
    public List<ItemInfo> GetUnitDropDown()
    {
        try
        {

            RestoLoyaltyController dcobj = new RestoLoyaltyController();
            return dcobj.GetUnitDropDown();
        }
        catch (Exception)
        {

            throw;
        }
    }


    [WebMethod]
    public void SaveRestoItem(ItemInfo ItemInfoobj)
    {
        try
        {
            RestoLoyaltyController dfcobj = new RestoLoyaltyController();

            dfcobj.SaveRestoItem(ItemInfoobj);

        }
        catch (Exception)
        {

            throw;
        }

    }

    [WebMethod]
    public List<ItemInfo> GetRollerItemFromDataBase()
    {
        try
        {

            RestoLoyaltyController dcobj = new RestoLoyaltyController();
            return dcobj.GetRollerItemFromDataBase();
        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public void DeleteItem(int RId)
    {
        try
        {

            RestoLoyaltyController dfpobj = new RestoLoyaltyController();
            dfpobj.DeleteItem(RId);

        }
        catch (Exception)
        {

            throw;
        }

    }
}
