<%@ WebService Language="C#" CodeBehind="~/App_Code/RoWebService.cs" Class="RoWebService" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;

/// <summary>
/// Summary description for PoWebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class RoWebService : System.Web.Services.WebService
{

    public RoWebService()
    {
        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public void ItemSaveTodatabase(ItemsClass ItemsInf)
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
    public List<ItemsClass> GetItemsfromDatabase()
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
    public void ItemsDelete(int ItemID)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.ItemDelete(ItemID);
        }
        catch(Exception ex) 
        {
            throw ex;
            
        }
    }


    [WebMethod]
    public List<Unit> getUnit()
    {
        try
        {
            RestrOrderController rcobj = new RestrOrderController();
            return rcobj.GetUnitFromDatabase();

        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public List<CategoriesClass> getCategory()
    {
        try
        {
            RestrOrderController rcobj = new RestrOrderController();
            return rcobj.getCategory();

        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public List<ItemsClass> GetItemPaginatedList(int offset, int limit)
    {
        try
        {
            RestrOrderController rcobj = new RestrOrderController();
            return rcobj.GetItemFromDatabaseByPagination(offset, limit);

        }
        catch (Exception)
        {

            throw;
        }
    }

}

    