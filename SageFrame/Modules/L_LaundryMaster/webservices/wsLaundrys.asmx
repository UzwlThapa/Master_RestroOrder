<%@ WebService Language="C#" Class="wsLaundrys" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.Laundry;
using SageFrame.RestoLoyalty;
using SageFrame.RestroOrder;
//using System.IO;
//using Newtonsoft.Json;
//using System.Web.Script.Serialization;
//using System.Web.Script.Services;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsLaundrys : System.Web.Services.WebService
{
    [WebMethod]
    public List<L_LaundryMasterInfo> getLaundry()
    {
        LaundryController ctl = new LaundryController();
        return ctl.LoadLaundry();
    }
    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public void Laundry()
    //{
    //    try
    //    {
    //        //string statususer = loginuser(json);
    //        string jsonString = "";
    //        JavaScriptSerializer jss = new JavaScriptSerializer();
    //        LaundryController roc = new LaundryController();
    //        List<L_LaundryMasterInfo> launry = roc.LoadLaundry();

    //        jsonString = jss.Serialize(launry);

    //        var parsedJson = JsonConvert.DeserializeObject(jsonString);
    //        dynamic jsonFormatted = JsonConvert.SerializeObject(parsedJson, Formatting.Indented);
    //        //Object obj = JsonConvert.DeserializeObject(jsonString);
    //        //Object obj = jsonFormatted;
    //        //dynamic cycleJson = JObject.Parse(@jsonFormatted);
    //        //obj = cycleJson;


    //        string path = "/Modules/L_LaundryMaster/laundry.Json";
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
    [WebMethod]
    public int SaveLaundry(L_LaundryMasterInfo laundry)
    {
        LaundryController obj = new LaundryController();
        return obj.SaveLaundry(laundry);
    }
    [WebMethod]
    public void deleteLaundry(int laundryMasterID)
    {
        LaundryController obj = new LaundryController();
        obj.deleteLaundry(laundryMasterID);
    }
    [WebMethod]
    public decimal getRatebyId(int cloth, int Ltype)
    {
        LaundryController obj = new LaundryController();
        return obj.getRatebyId(cloth, Ltype);
    }
    [WebMethod]
    public List<L_LaundryDetailsInfo> getLaundryByID(int laundryMasterID)
    {
        LaundryController con = new LaundryController();
        return con.getLaundryByID(laundryMasterID);
    }

    [WebMethod]
    public List<MemberInfo> getsdatass(int customer)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        return dfcobj.getmembershiplist(customer);

    }
    [WebMethod]
    public List<L_LaundryMasterInfo> getRoomNoByRoomType(int RoomTypeID)
    {
        LaundryController dfcobj = new LaundryController();
        return dfcobj.getRoomNoByRoomType(RoomTypeID);
    }

    [WebMethod]
    public List<companyInfo> getcompanyInfo()
    {
        RestrOrderController con = new RestrOrderController();
        return con.getcompanyInfo();
    }
    [WebMethod]
    public void updateisdelivered(int laundryMasterID)
    {
        LaundryController ctl = new LaundryController();
        ctl.updateisdelivered(laundryMasterID);
    }
    [WebMethod]
    public void updateldisdelivered(int laundryDetailsID)
    {
        LaundryController ctl = new LaundryController();
        ctl.updateldisdelivered(laundryDetailsID);
    }
    [WebMethod]
    public List<L_LaundryTypeInfo> getLaundryType(int cloth)
    {
        LaundryController con = new LaundryController();
        return con.LoadLaundryTypeList(cloth);
    }
}