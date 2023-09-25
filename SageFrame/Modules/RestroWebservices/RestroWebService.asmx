 <%@ WebService Language="C#" Class="RestroWebService" %>
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
using Hangfire;
using System.Configuration;
using System.Net;

/// <summary>
/// Summary description for RestroWebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class RestroWebService : System.Web.Services.WebService {

    public RestroWebService () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void FullRestroRoomData()
    {
        try
        {
            //string statususer = loginuser(json);
            string jsonString = "";
            //JavaScriptSerializer jss = new JavaScriptSerializer();
            RestrOrderController roc = new RestrOrderController();
            List<RoomType> restroFullDetail = roc.GetrestroFullDetail();
            jsonString = "{statusCode:200, message:\"Success\", data: " + JsonConvert.SerializeObject(restroFullDetail, Formatting.Indented) + "}";

            //string path = "/Modules/RestroWebservices/RestroFullDetail.Json";
            //string fullPath = Server.MapPath(path);
            //using (var file = new StreamWriter(fullPath, false))
            //{
            //    file.Flush();
            //    file.Write(jsonString);
            //    file.Close();
            //    file.Dispose();
            //}

            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write(jsonString);

        }
        catch (Exception ex)
        {
            Context.Response.Write("{statusCode:100, message:\""+ex.Message+"\"}");
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void StoreMergeTable(string json)
    {
        try
        {
            //string statususer = loginuser(json);
            //JavaScriptSerializer jss = new JavaScriptSerializer();
            RestrOrderController roc = new RestrOrderController();


            JavaScriptSerializer jss = new JavaScriptSerializer();
            var MergeList = jss.Deserialize<MergeList>(json);
            List<MergeTableInfo> mergeTableList = new List<MergeTableInfo>();
            mergeTableList =MergeList.MergeTableInfo;

                List<string> lst = new List<string>();

            roc.SaveMergeTable(mergeTableList, lst.ToArray());
            dynamic parsedJson = JsonConvert.DeserializeObject(json);

            string status = "{statusCode:200, message:\"Success\"}";

            //string path = "/Modules/RestroWebservices/MergeTable.Json";
            //string fullPath = Server.MapPath(path);
            //using (var file = new StreamWriter(fullPath, false))
            //{
            //    file.Flush();
            //    file.Write(parsedJson);
            //    file.Close();
            //    file.Dispose();
            //}

            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write(status);

        }
        catch (Exception ex)
        {
            Context.Response.Write("{statusCode:100, message:\""+ex.Message+"\"}");
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void AllRestroRoomData()
    {
        try
        {
            //string statususer = loginuser(json);
            string jsonString = "";
            //JavaScriptSerializer jss = new JavaScriptSerializer();
            RestrOrderController roc = new RestrOrderController();
            List<restroTable> restroTableList = roc.getRestroTable();
            jsonString = "{statusCode:200, message:\"Success\", data:{ " + JsonConvert.SerializeObject(restroTableList, Formatting.Indented) + "}}";

            //string path = "/Modules/RestroWebservices/RestroFullDetail.Json";
            //string fullPath = Server.MapPath(path);
            //using (var file = new StreamWriter(fullPath, false))
            //{
            //    file.Flush();
            //    file.Write(jsonString);
            //    file.Close();
            //    file.Dispose();
            //}

            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write(jsonString);

        }
        catch (Exception ex)
        {
            Context.Response.Write("{statusCode:100, message:\""+ex.Message+"\"}");
        }
    }




    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void KitchenOrderApi()
    {
        try
        {
            string jsonString = "";
            RestrOrderController rec = new RestrOrderController();
            List<costCenter> rtinfo = rec.KitchenOrderApi();
            jsonString = "{statusCode:200, message:\"Success\",data:" + JsonConvert.SerializeObject(rtinfo, Formatting.Indented) + "}";

            //string path = "/Modules/RestroWebservices/KitchenOrderApi.Json";
            //string fullPath = Server.MapPath(path);
            //using (var file = new StreamWriter(fullPath, false))
            //{
            //    file.Flush();
            //    file.Write(jsonString);
            //    file.Close();
            //    file.Dispose();
            //}

            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write(jsonString);

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void KitchenOrderApiForEvents(string json)
    {

        string jsonString = "";
        try
        {
            //string statususer = loginuser(json);
            JavaScriptSerializer jss = new JavaScriptSerializer();
            var json1 = jss.Deserialize<OrderDetailClass>(json);
            //jsonString = JsonConvert.SerializeObject(json1, Formatting.Indented);

            List<OrderDetailClass> list = new List<OrderDetailClass>();
            RestrOrderController con = new RestrOrderController();
            list = con.inprocess(Convert.ToInt32(json1.OrderDetailsID), Convert.ToInt32(json1.ItemStatus));

            if (ConfigurationManager.AppSettings["Notification"] == "true")
            {
                if (Convert.ToInt32(json1.ItemStatus) == 3)
                {
                    WaiterCallInfo wait = new WaiterCallInfo();
                    wait = con.callWaiter(Convert.ToInt32(json1.OrderDetailsID));
                    if (wait != null && wait.WaiterName != "superuser")
                    {
                        if (wait.WaiterIP == "")
                        {
                            WaiterCallInfo wait1 = con.GetWaiterLog().FirstOrDefault();
                            if (wait1 != null)
                            {
                                wait.WaiterIP = wait1.WaiterIP;
                                wait.WaiterName = wait1.WaiterName;
                            }
                        }
                        if (wait.WaiterIP != "")
                        {
                            callWaiter(wait);
                        }
                    }
                }
            }
            jsonString = "{statusCode:200, message:\"Success\"}";
            //string path = "/Modules/RestroWebservices/KitchenOrderApiForEvents.Json";
            //string fullPath = Server.MapPath(path);
            //using (var file = new StreamWriter(fullPath, false))
            //{
            //    file.Flush();
            //    jsonString ="{'status':'Success'}";
            //    file.Close();
            //    file.Dispose();
            //}


        }
        catch (Exception ex)
        {
            jsonString = "{statusCode:100, message:\""+ex.Message+"\"}";
        }
        finally
        {
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write(jsonString);

        }
    }


    [WebMethod]
    public List<WaiterCallInfo> GetWaiterLog()
    {
        try
        {
            RestrOrderController dfcobj = new RestrOrderController();
            return dfcobj.GetWaiterLog();
        }
        catch (Exception)
        {

            throw;
        }
    }


    [WebMethod]
    public void callWaiter(WaiterCallInfo Waiter)
    {
        try
        {
            BackgroundJob.Enqueue(() => WaiterNotification.CallWaiter(Waiter));

        }
        catch (Exception)
        {
            throw;
        }
    }
}
