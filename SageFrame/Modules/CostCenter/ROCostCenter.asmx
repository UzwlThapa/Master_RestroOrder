<%@ WebService Language="C#" CodeBehind="~/App_Code/RoWebService.cs" Class="RoWebService" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using Newtonsoft.Json;
using SageFrame.Security;
using SageFrame.Security.Entities;
using SageFrame.Common;
//using SageFrame.Framework;
using System.Web.Services;
using System.Web.Script.Serialization;
using SageFrame.Security.Helpers;
using SageFrame.RestroOrder;
using System.Web.Script.Services;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using Newtonsoft.Json.Linq;
using System.Web.Mvc;
using SageFrame.CostCenter;

/// <summary>
/// Summary description for PoWebService
/// </summary>
[WebService]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class RoWebService : System.Web.Services.WebService
{
    public static int userid=0;
    //public string modulePath = string.Empty;
    //public int userModuleID = 0;
    public RoWebService()
    {
        //modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        //userModuleID = int.Parse(SageUserModuleID);
        ////Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public  void CostCenter()
    {
        try
        {
            //string statususer = loginuser(json);
            string jsonString = "";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            CostCenterController roc = new CostCenterController();
            List<CostCenterInfo> restroCostCenter = roc.GetCostCenter();

            jsonString = jss.Serialize(restroCostCenter);

            var parsedJson = JsonConvert.DeserializeObject(jsonString);
            dynamic jsonFormatted = JsonConvert.SerializeObject(parsedJson, Formatting.Indented);
            //Object obj = JsonConvert.DeserializeObject(jsonString);
            //Object obj = jsonFormatted;
            //dynamic cycleJson = JObject.Parse(@jsonFormatted);
            //obj = cycleJson;


            string path = "/Modules/CostCenter/RestroCostCenter.Json";
            string fullPath = Server.MapPath(path);
            using (var file = new StreamWriter(fullPath, false))
            {
                file.Flush();
                file.Write(jsonFormatted);
                file.Close();
                file.Dispose();
            }

            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write(jsonFormatted);

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    [WebMethod]
    public object GetStores()
    {
        RestrOrderController roc = new RestrOrderController();
        List<roistore> stores = roc.getIssueToDDl();

        List<CostCenterGroup> groups = roc.GetCostCenterGroup();

        List<string> printerList = new List<string>();
        foreach (string printer in System.Drawing.Printing.PrinterSettings.InstalledPrinters)
        {
            printerList.Add(printer);
        }

        var data = new
        {
            Stores = stores,
            Printers = printerList,
            CostCenterGroup = groups
        };

        return data;



    }

    [WebMethod]
    public string SaveCostCenter(CostCenterInfo dataObj)
    {

        try
        {
                CostCenterController controller = new CostCenterController();
        controller.SaveCostCenter(dataObj);
                return "Success";
        }
        catch (Exception)
        {

            throw;
        }
        
        
    }








    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public void RoomList()
    //{
    //    try
    //    {
    //        //string statususer = loginuser(json);
    //        string jsonString = "";
    //        JavaScriptSerializer jss = new JavaScriptSerializer();
    //        RestrOrderController roc = new RestrOrderController();
    //        List<RestroRoom> restroRoom = roc.GetRoomWithTable();

    //        jsonString = jss.Serialize(restroRoom);

    //        var parsedJson = JsonConvert.DeserializeObject(jsonString);
    //        dynamic jsonFormatted = JsonConvert.SerializeObject(parsedJson, Formatting.Indented);
    //        //Object obj = JsonConvert.DeserializeObject(jsonString);
    //        //Object obj = jsonFormatted;
    //        //dynamic cycleJson = JObject.Parse(@jsonFormatted);
    //        //obj = cycleJson;


    //        string path = "/Modules/RORestroTable/RestroRoom.Json";
    //        string fullPath = Server.MapPath(path);
    //        using (var file = new StreamWriter(fullPath, false))
    //        {
    //            file.Flush();
    //            file.Write(jsonFormatted);
    //            file.Close();
    //            file.Dispose();
    //        }

    //        Context.Response.Clear();
    //        Context.Response.ContentType = "application/json";
    //        Context.Response.Write(jsonFormatted);

    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //}

}

    