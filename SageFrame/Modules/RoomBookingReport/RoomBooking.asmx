<%@ WebService Language="C#" Class="RoomBooking" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using System.Collections.Generic;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class RoomBooking  : System.Web.Services.WebService {

    [WebMethod]
    public string getRestroTable()
    {
        RestrOrderController roc = new RestrOrderController();
        List<restroTable> table = roc.getRestroTable();
        return JsonConvert.SerializeObject(table);
    }


    [WebMethod]
    public string getCustomerNameFromRoomBooking()
    {
        RestrOrderController con = new RestrOrderController();
        List<RoomBookingsInfo> list = con.getCustomerNameFromRoomBooking();
        return JsonConvert.SerializeObject(list);
    }


    [WebMethod]
    public string getRoomBookingReport(string startDate, string endDate, string customer, string table)
    {
        RestrOrderController con = new RestrOrderController();
       List <RoomBookingsInfo> roomlist = con.getRoomBookingReport(startDate, endDate, customer, table);
        return JsonConvert.SerializeObject(roomlist);
    }

}