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
    public void EnumSaveTodatabase(EnumClass EnumInf)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.EnumSaveTodatabase(EnumInf);
        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<EnumClass> GetEnumfromDatabase()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetEnumFromDatabase();

        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public void EnumDelete(int EnumID)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.EnumDelete(EnumID);
        }
        catch(Exception ex) 
        {
            throw ex;
            
        }
    }

}

    