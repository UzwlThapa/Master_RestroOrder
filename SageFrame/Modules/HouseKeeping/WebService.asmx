Fg<%@ WebService Language="C#" Class="WebService" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.Housekeeping;
using SageFrame.RestroOrder;
//using SageFrame.Laundry;

/// <summary>
/// Summary description for WebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    public WebService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public void SaveMainHouseKeeping(HouseInfo obj)
    {
        try
        {
            new HouseController().SaveMainHouseKeeping(obj);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public List<HouseInfo> GetMainHouseKeepingInfo(string Status, string AssignTo)
    {
        try
        {
            HouseController clt = new HouseController();
            return clt.GetMainHouseKeepingInfo(Status, AssignTo);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    [WebMethod]

    public void DeleteMainHouseKeepingDetails(int HK_ID)
    {
        try
        {
            new HouseController().DeleteMainHouseKeepingDetails(HK_ID);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    [WebMethod]
    public List<HouseInfo> GetStatus()
    {
        HouseController clt = new HouseController();
        return clt.GetStatus();
    }

    [WebMethod]
    public List<HouseInfo> GetUsers()
    {
        HouseController clt = new HouseController();
        return clt.GetUsers();
    }
    //[WebMethod]
    //public List<RoomClassInfo> getRoomClassList()
    //{
    //    LaundryController clt = new LaundryController();
    //    return clt.getRoomClassList();
    //}

    [WebMethod]
    public List<HouseInfo> GetRooms()
    {
        HouseController clt = new HouseController();
        return clt.GetRooms();
    }
    [WebMethod]
    public List<HouseInfo> GetRoomsByRoomID(int restroRoomID)
    {
        try
        {
            HouseController clt = new HouseController();
            return clt.GetRoomsByRoomID(restroRoomID);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public List<HouseInfo> GetRoomName()
    {
        try
        {
            HouseController clt = new HouseController();
            return clt.GetRoomName();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public List<HouseInfo> GetRoomNameByID(int Roomvalue)
    {
        try
        {
            HouseController clt = new HouseController();
            return clt.GetRoomNameByID(Roomvalue);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]

    public void SaveLostAndFound(HouseInfo obj)
    {
        try
        {
            new HouseController().SaveLostAndFound(obj);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]

    public List<HouseInfo> GetLostAndFound()
    {
        try
        {
            HouseController clt = new HouseController();
            return clt.GetLostAndFound();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]

    public void DeleteLostAndFound(int LF_ID)
    {
        try
        {
            new HouseController().DeleteLostAndFound(LF_ID);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]

    public List<HouseInfo> getLostNFoundreport(string StartDate, string EndDate)
    {
        HouseController prov = new HouseController();
        return prov.getLostNFoundreport(StartDate, EndDate);
    }

    [WebMethod]
    public List<companyInfo> getcompanyInfo()
    {
        RestrOrderController con = new RestrOrderController();
        return con.getcompanyInfo();
    }

    [WebMethod]
    public void SaveOutOfOrder(HouseInfo obj)
    {
        try
        {
            new HouseController().SaveOutOfOrder(obj);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public List<HouseInfo> GetOutOfOrder()
    {
        try
        {
            HouseController clt = new HouseController();
            return clt.GetOutOfOrder();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public List<HouseInfo> getOOReport(int RoomID, int RoomTypeID, string RoomClass, string StartDate, int IsOutOfOrder, int IsOutOfService)
    {
        HouseController clt = new HouseController();
        return clt.getOOReport(RoomID, RoomTypeID, RoomClass, StartDate, IsOutOfOrder, IsOutOfService);
    }
        
    [WebMethod]
    public List<HouseInfo> GetOrderItemByID(int OutOfOrderID)
    {
        try
        {
            HouseController clt = new HouseController();
            return clt.GetOrderItemByID(OutOfOrderID);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]

    public void DeleteOutOfOrder(int Oid)
    {
        try
        {
            new HouseController().DeleteOutOfOrder(Oid);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}
