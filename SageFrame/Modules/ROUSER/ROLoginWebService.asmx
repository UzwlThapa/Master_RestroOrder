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
using System.Configuration;
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
    [ScriptMethod(UseHttpGet = true, ResponseFormat = ResponseFormat.Json)]
    public void Login(string Username, string Password)
    {

        //json = json.Replace("-",":");
        UserClass usp = new UserClass();
        usp.Username = Username;
        usp.Password = Password;
        usp.OrderMenuListType = ConfigurationManager.AppSettings["OrderMenuListType"];
        usp.OrderMenuImageshow = ConfigurationManager.AppSettings["OrderMenuImageshow"];
        string test = JsonConvert.SerializeObject(usp);
        UserClass user = LoginUser(test);


        string jsonString = "";
        JavaScriptSerializer jss = new JavaScriptSerializer();
        //UserClass user = LoginUser(json);
        string success = user.Status;

        jsonString = jss.Serialize(user);

        var parsedJson = JsonConvert.DeserializeObject(jsonString);
        Object jsonFormatted = JsonConvert.SerializeObject(parsedJson, Formatting.Indented);

        //string path = "/Modules/ROUSER/RestrUser.Json";
        //string fullPath = Server.MapPath(path);
        //using (var file = new StreamWriter(fullPath, false))
        //{
        //    file.Flush();
        //    file.Write(jsonFormatted);
        //    file.Close();
        //    file.Dispose();
        //}
        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Write(jsonFormatted);
        //if (json != null)
        //{
        //    rsp = new UserClass()
        //    {
        //        Status = "success"
        //    };
        //}
        //else
        //{
        //    rsp = new UserClass()
        //    {
        //        Status = "unsuccess"
        //    };
        //}
        //return JsonConvert.SerializeObject(rsp); 

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void TestLogin()
    {
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void CheckLogin(string json)
    {
        try
        {
            //string statususer = loginuser(json);
            string jsonString = "";
            JavaScriptSerializer jss = new JavaScriptSerializer();
            UserClass user = LoginUser(json);
            string success = user.Status;

            jsonString = jss.Serialize(user);

            var parsedJson = JsonConvert.DeserializeObject(jsonString);
            dynamic jsonFormatted = JsonConvert.SerializeObject(parsedJson, Formatting.Indented);
            //Object obj = JsonConvert.DeserializeObject(jsonString);
            //Object obj = jsonFormatted;
            //dynamic cycleJson = JObject.Parse(@jsonFormatted);
            //obj = cycleJson;


            //string path = "/Modules/ROUSER/RestrUser.Json";
            //string fullPath = Server.MapPath(path);
            //using (var file = new StreamWriter(fullPath, false))
            //{
            //    file.Flush();
            //    file.Write(jsonFormatted);
            //    file.Close();
            //    file.Dispose();
            //}

            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write(jsonFormatted);

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    #region login

    public void SaveWaiterDetailForNotification(UserClass user)
    {
        RestrOrderController.SaveWaiterDetailForNotification(user);
    }




    private UserClass LoginUser(string json)
    {

        string jsonString = null;
        //string json = "";
        JavaScriptSerializer jss = new JavaScriptSerializer();
        UserClass userClass = new UserClass();
        userClass = jss.Deserialize<UserClass>(json);
        MembershipController member = new MembershipController();
        RoleController role = new RoleController();
        UserInfo user = member.GetUserDetails(1, userClass.Username);
        if (user.UserExists)
        {
            List<UserInfo> UserDetail = RestrOrderController.GetUsersDetail(user.UserID, user.UserName);
            string Roles = string.Empty;
            foreach (UserInfo item in UserDetail)
            {
                if (Roles == "")
                {
                    Roles = item.RoleNames;
                }
                else
                {
                    Roles = Roles + "," + item.RoleNames;
                }

            }
            user.RoleNames = Roles;
            //HttpContext.Current.Session[SessionKeys.IsLoginClick] = false;
            userClass.RoleNames = Roles;
        }


        //userClass.Username = userName;
        //userClass.Password = password;
        if (user.UserExists && user.IsApproved)
        {
            if (PasswordHelper.ValidateUser(user.PasswordFormat, userClass.Password, user.Password, user.PasswordSalt))
            {
                userid += 1;
                userClass.UserID = userid;
                //login is successfull SucessFullLogin(user);
                if (userClass.RoleNames != "KitchenOrder")
                {
                    SaveWaiterDetailForNotification(userClass);
                }
                userClass.Status = "Success";


            }
            else
            {
                userClass.Status = "Failed";
            }
        }
        else
        {
            userClass.Status = "Failed";
        }
        userClass.Password = "Encrypted";
        userClass.OrderMenuListType = ConfigurationManager.AppSettings["OrderMenuListType"];
        userClass.OrderMenuImageshow = ConfigurationManager.AppSettings["OrderMenuImageshow"];
        //var test = JObject.Parse(JsonConvert.SerializeObject(userClass)); ;
        //return test;
        // return userClass;
        jsonString = jss.Serialize(userClass);
        return userClass;

    }
    #endregion


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void LoggedOut(string json)
    {
        //string json = "";
        UserClass userClass = new UserClass();
        JavaScriptSerializer jss = new JavaScriptSerializer();
        userClass = jss.Deserialize<UserClass>(json);

        MembershipController member = new MembershipController();
        RoleController role = new RoleController();
        role.LoggoutUser(userClass.Username);

        // WaiterCallInfo info = RestrOrderController.DeleteWaiterFromLog(userClass.Username);
        //RestrOrderController.DeleteWaiterFromLog(userClass.Username);

    }
    [WebMethod]
    public void getWaiterList()
    {
        try
        {
            RestrOrderController con = new RestrOrderController();
            List<WaiterCallInfo> wait = con.GetWaiterLog();
            string jsonString = "";
            jsonString = Newtonsoft.Json.JsonConvert.SerializeObject(wait, Newtonsoft.Json.Formatting.Indented);
            //string path = "/Modules/ROUSER/WaiterCall.Json";
            //string fullPath = Server.MapPath(path);
            //using (var file = new System.IO.StreamWriter(fullPath, false))
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
        catch (Exception)
        {
            throw;
        }
    }
    public class PinLogin
    {
        public string pin { get; set; }
        public string WaiterIP { get; set; }

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void LoginPin(string json)
    {
        RestrOrderController roc = new RestrOrderController();
        JavaScriptSerializer jss = new JavaScriptSerializer();
        PinLogin loginClass = new PinLogin();
        loginClass = jss.Deserialize<PinLogin>(json);
        UserClass userClass = new UserClass();
        PinUser info = roc.CheckPin(loginClass.pin);
        string jsonString = "";
        //string success = user.Status;
        //jsonString = jss.Serialize(user);

        if (info != null)
        {

            info.Message = "Success";
            info.OrderMenuListType = ConfigurationManager.AppSettings["OrderMenuListType"];
            info.OrderMenuImageshow = ConfigurationManager.AppSettings["OrderMenuImageshow"];
            jsonString = jss.Serialize(info);
            userClass.Username = info.UserName;
            userClass.WaiterIP = loginClass.WaiterIP;

            if (info.Roles != "KitchenOrder")
            {
                SaveWaiterDetailForNotification(userClass);
            }

            var parsedJson = JsonConvert.DeserializeObject(jsonString);
            jsonString = "{statusCode:200, message: \"Success\", data:"+ JsonConvert.SerializeObject(parsedJson, Formatting.Indented)+"}";

        }
        else
        {
            jsonString = "{statusCode:100, message:\"Invalid PIN Code.\"}";
        }
        //jsonString = JsonConvert.SerializeObject(rooms, Formatting.Indented);
        //string path = "/Modules/ROUSER/PinLoginUser.Json";
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
}

    