<%@ WebService Language="C#" Class="WebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class WebService : System.Web.Services.WebService
{

    [WebMethod]
    public List<ActivityLog> GetActivityLog(DateTime StartDate, DateTime EndDate, string User)
    {
        RestrOrderController obj = new RestrOrderController();
        return obj.GetActivityLog(StartDate, EndDate, User);
    }

}