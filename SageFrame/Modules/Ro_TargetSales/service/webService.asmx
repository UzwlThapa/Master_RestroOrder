<%@ WebService Language="C#" Class="wsRoomGroup" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.RestroOrder;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsRoomGroup : System.Web.Services.WebService
{
    [WebMethod]
    public List<TargetSales> getTargetSales(DateTime date)
    {
        RestrOrderController ctl = new RestrOrderController();
        return ctl.getTargetSales(date);
    }
    [WebMethod]
    public List<itemsales> getSalesDetailsByDate(DateTime date)
    {
        RestrOrderController ctl = new RestrOrderController();
        return ctl.getSalesDetailsByDate(date);
    }
}
