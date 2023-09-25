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

/// <summary>
/// Summary description for PoWebService
/// </summary>
[WebService]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class RoWebService : System.Web.Services.WebService
{
    public static int userid = 0;
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
    public void TableName()
    {
        try
        {
            //string statususer = loginuser(json);
            string jsonString = "";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            RestrOrderController roc = new RestrOrderController();
            List<restroTable> restroTable = roc.getRestroTable();

            jsonString = jss.Serialize(restroTable);

            var parsedJson = JsonConvert.DeserializeObject(jsonString);
            dynamic jsonFormatted = JsonConvert.SerializeObject(parsedJson, Formatting.Indented);
            //Object obj = JsonConvert.DeserializeObject(jsonString);
            //Object obj = jsonFormatted;
            //dynamic cycleJson = JObject.Parse(@jsonFormatted);
            //obj = cycleJson;


            string path = "/Modules/RORestroTable/RestroTable.Json";
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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void RoomList()
    {
        try
        {
            //string statususer = loginuser(json);
            string jsonString = "";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            RestrOrderController roc = new RestrOrderController();
            List<RestroRoom> restroRoom = roc.GetRoomWithTable();

            jsonString = jss.Serialize(restroRoom);

            var parsedJson = JsonConvert.DeserializeObject(jsonString);
            dynamic jsonFormatted = JsonConvert.SerializeObject(parsedJson, Formatting.Indented);
            //Object obj = JsonConvert.DeserializeObject(jsonString);
            //Object obj = jsonFormatted;
            //dynamic cycleJson = JObject.Parse(@jsonFormatted);
            //obj = cycleJson;


            string path = "/Modules/RORestroTable/RestroRoom.Json";
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
    public string DoesTableNameExist(string tableName)
    {
    RestrOrderController controller = new RestrOrderController();
    return controller.DoesTableNameExist(tableName);

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void UnMergeTable(int tableId)
    {
        try
        {
            //string statususer = loginuser(json);
            //string jsonString = "";
            //JavaScriptSerializer jss = new JavaScriptSerializer();
            RestrOrderController roc = new RestrOrderController();
            
            roc.UnMergeTable(tableId);

          
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write("{\"Status\":\"Success\"}");

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }




    //[WebMethod]
    //public int CheckDuplicate(string TableName)
    //{
    //    int RetVal = 0;
    //    string connn = (System.Configuration.ConfigurationManager.ConnectionStrings["SageFrameConnectionString"].ToString());
    //    string strQuery = "SELECT COUNT(*) FROM RO_restroTable WHERE restrotableTitle = '@TableName'";
    //    System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(connn);
    //    System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(strQuery, con);
    //    con.Open();
    //    System.Data.SqlClient.SqlDataReader rd = cmd.ExecuteReader();

    //    while (rd.Read())
    //    {
    //        rd.Close();
    //        cmd.Parameters.AddWithValue("restrotableTitle", TableName);

    //        RetVal = (int)cmd.ExecuteScalar();

    //        if (RetVal == 1)
    //        {
    //            return RetVal;

    //        }


    ////    }
    ////    return RetVal;
    ////}
    }

