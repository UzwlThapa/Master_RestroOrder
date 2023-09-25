<%@ WebService Language="C#" Class="WSforConsumption" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using SageFrame.Common;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WSforConsumption : System.Web.Services.WebService
{

    [WebMethod]
    public string getConsumptionReportByDates(DateTime startdate, DateTime enddate)
    {
        RestrOrderController con = new RestrOrderController();
        List<ConsumptionReport> report = con.getConsumptionReportByDates(startdate, enddate);
        return JsonConvert.SerializeObject(report);
    }
}