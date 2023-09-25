<%@ WebService Language="C#" CodeBehind="~/App_Code/RoWebService.cs" Class="RoWebService" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
    using Newtonsoft.Json;

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
    JavaScriptSerializer jss = new JavaScriptSerializer();
    public RoWebService()
    {
        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public void UnitSaveTodatabase(UnitClass UnitInf)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.UnitSaveTodatabase(UnitInf);

        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<Unit> GetUnitfromDatabase()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetUnitFromDatabase();

        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public void UnitDelete(int UnitID)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.UnitDelete(UnitID);
        }
        catch(Exception ex) 
        {
            throw ex;
            
        }
    }
    [WebMethod]
    public void Unit1Save1Todatabase(UnitClass UnitInf)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.Unit1Save1Todatabase(UnitInf);

        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public string GetUnit1fromDatabase()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return jss.Serialize(rocobj.GetUnit1fromDatabase());

        }
        catch (Exception)
        {

            throw;
        }
    }

  
    
    [WebMethod]
    public void UnitDelete1(int UnitID1)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.UnitDelete1(UnitID1);
        }
        catch (Exception ex)
        {
            throw ex;

        }
    }
    [WebMethod]
    public string Unit1Save2Todatabase(UnitClass UnitInf)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.Unit1Save2Todatabase(UnitInf);

        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public string GetUnit2fromDatabase()
    {
        RestrOrderController rocobj = new RestrOrderController();
        List<UnitConversion> unit2 = rocobj.GetUnit2fromDatabase();
            return JsonConvert.SerializeObject(unit2);
    }
   


    [WebMethod]
    public void UnitDelete2(int UnitID2)
    {
        RestrOrderController rocobj = new RestrOrderController();
        rocobj.UnitDelete2(UnitID2);
    }
}

    