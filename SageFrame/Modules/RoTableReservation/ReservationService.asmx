<%@ WebService Language="C#" Class="ReservationService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using SageFrame.RestoLoyalty;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ReservationService  : System.Web.Services.WebService {

    RestrOrderController roc = new RestrOrderController();
    RestoLoyaltyController dfcobj = new RestoLoyaltyController();

    [WebMethod]
    public string GetRoomByRoomTypeId(int RoomTypeID)
    {
        return JsonConvert.SerializeObject(roc.GetRoomByRoomTypeId(RoomTypeID));
    }


    [WebMethod]
    public string GetTableByRoomTypeId(int RoomId)
    {
        List<restroTable> restroTableList = roc.GetTableByRoomTypeId(RoomId);
        return JsonConvert.SerializeObject(restroTableList);
    }

    [WebMethod]
    public int saveTableReservation(TableReservation table)
    {
        return roc.saveTableReservation(table);
    }

    [WebMethod]
    public string getReservedTableList()
    {
        List<TableReservation> TableList = roc.getReservedTableList();
        return JsonConvert.SerializeObject(TableList);
    }

    [WebMethod]
    public void ConfirmReservation(int reserveid, string confirmedby)
    {
        roc.ConfirmReservation(reserveid, confirmedby);
    }

    [WebMethod]
    public void CancelReservation(int reserveid, string cancelledby)
    {
        roc.CancelReservation(reserveid, cancelledby);
    }

    [WebMethod]
    public string getReservedTableListReport(string StartDate, string EndDate, string CustomerName, int TableId)
    {
        List<TableReservation> report = roc.getReservedTableListReport(StartDate, EndDate, CustomerName, TableId);
        return JsonConvert.SerializeObject(report);
    }
   [WebMethod]
    public string getsdatass(int customer)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        return JsonConvert.SerializeObject(dfcobj.getmembershiplist(customer));
    }

 [WebMethod]
    public string getRestroTable()
    {
        RestrOrderController roc = new RestrOrderController();
        List<restroTable> table = roc.getRestroTable();
        return JsonConvert.SerializeObject(table);

    }

}