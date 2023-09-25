<%@ WebService Language="C#" CodeBehind="~/App_Code/RoWebService.cs" Class="RoWebService" %>
using System;
using System.Web.Services;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using Newtonsoft.Json;

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

    public RoWebService()
    {

    }

    [WebMethod]
    public void SaveRoomType(RoomType restroroomtype)
    {
        RestrOrderController con = new RestrOrderController();
        con.saveRoomType(restroroomtype);
    }
    [WebMethod]
    public int GetDependency(int roomtypeid)
    {
        RestrOrderController con = new RestrOrderController();
        return con.GetRoomByRoomTypeId(roomtypeid).Count;
    }
    [WebMethod]
    public void DeleteRoomType(int roomtypeid)
    {
        RestrOrderController con = new RestrOrderController();
        con.deleteRoomType(Convert.ToString(roomtypeid));
    }
    [WebMethod]
    public void deleteRoomAndTables(int roomtypeid)
    {
        RestrOrderController con = new RestrOrderController();
        con.deleteDependentRoomsAndTables(roomtypeid,2);
    }
    [WebMethod]
    public string GetRoomType()
    {
        RestrOrderController roc = new RestrOrderController();
        List<RoomType> room = roc.getRoomType();
        return JsonConvert.SerializeObject(room);
    }


    [WebMethod]
    public string DoesRoomTypeExist(string roomType)
    {
        RestrOrderController controller = new RestrOrderController();
        return controller.DoesRoomTypeExist(roomType);

    }


}

