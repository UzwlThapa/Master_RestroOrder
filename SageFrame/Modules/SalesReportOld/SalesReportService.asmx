<%@ WebService Language="C#" Class="SalesReportService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using SageFrame.RestoLoyalty;
using Newtonsoft.Json;
using SageFrame.Common;
using SageFrame.Web.Utilities;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class SalesReportService : System.Web.Services.WebService
{



    [WebMethod]
    public string getSalesReportOld(string StartDate, string EndDate)
    {
        SQLHandler sqlHandler = new SQLHandler();
        try
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", StartDate));
            Param.Add(new KeyValuePair<string, object>("@ToDate", EndDate));
            var ds = sqlHandler.ExecuteAsDataSet("[dbo].[usp_restro_getsalesrecord_old]", Param);
            return JsonConvert.SerializeObject(ds);
        }
        catch (Exception e)
        {
            throw e;

        }

    }


}