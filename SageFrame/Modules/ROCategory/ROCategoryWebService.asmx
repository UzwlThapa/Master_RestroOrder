<%@ WebService Language="C#" CodeBehind="~/App_Code/RoWebService.cs" Class="RoWebService" %>

using System;
using System.Collections.Generic;
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
    public void CategoriesSaveTodatabase(CategoriesClass CategoriesInf)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.CategoriesSaveTodatabase(CategoriesInf);

        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<CategoriesClass> GetCategoriesfromDatabase()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetCategoriesFromDatabase();
        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public void CategoriesDelete(int CategoriesID)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.CategoriesDelete(CategoriesID);
        }
        catch(Exception ex) 
        {
            throw ex;
            
        }
    }


    [WebMethod]
    public List<MenuClass> getMenu()
    {
        try
        {
            RestrOrderController rcobj = new RestrOrderController();
            return rcobj.GetMenuFromDatabase();

        }
        catch (Exception)
        {

            throw;
        }
    }



}

    