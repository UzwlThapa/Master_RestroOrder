<%@ WebService Language="C#" CodeBehind="~/App_Code/RoWebService.cs" Class="RoWebService" %>
using System;
using System.Web.Services;
using SageFrame.RestroOrder;
using System.Collections.Generic;
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
    //public string modulePath = string.Empty;
    //public int userModuleID = 0;
    public RoWebService()
    {

    }

    [WebMethod]
    public string GetRooms()
    {
      
        RestrOrderController con = new RestrOrderController();
         List<RestroRoom> info1  = con.getRestroRoom();
        foreach (RestroRoom room in info1)
        {
            if (room.RoomTypeID > 0)
            {
                //RestrOrderController roc = new RestrOrderController();
                RoomType roomType = con.getRoomTypeByID(room.RoomTypeID);
                room.RoomType = roomType.Title;
            }
            else
            {
                room.RoomType = "Open";
            }
        }
        return JsonConvert.SerializeObject(info1);
    }

    [WebMethod]
    public void SaveRoom(RestroRoom restroroom)
    {
        RestrOrderController con = new RestrOrderController();
        con.saveRoom(restroroom);
    }
    [WebMethod]
    public int GetDependency(int roomid)
    {
        RestrOrderController con = new RestrOrderController();
        return con.GetTableByRoomId(roomid).Count;
    }
    [WebMethod]
    public void DeleteRoom(int roomid)
    {
        RestrOrderController con = new RestrOrderController();
        con.deleteRoom(roomid);
    }
    [WebMethod]
    public void deleteRoomAndTables(int roomid)
    {
        RestrOrderController con = new RestrOrderController();
        con.deleteDependentRoomsAndTables(roomid,1);
    }

    [WebMethod]
    public string GetRoomType()
    {
        RestrOrderController roc = new RestrOrderController();
        List<RoomType> room = roc.getRoomType();
        return JsonConvert.SerializeObject(room);
    }

    [WebMethod]
    public string DoesRoomNameExist(string roomName)
    {
        RestrOrderController controller = new RestrOrderController();
        return controller.DoesRoomNameExist(roomName);

    }


}

