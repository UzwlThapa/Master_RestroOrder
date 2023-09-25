<%@ WebService Language="C#" Class="WSforClosingReport3_Monthly" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WSforClosingReport3_Monthly : System.Web.Services.WebService
{

    [WebMethod]
    public string getDataByDates(DateTime startdate,DateTime enddate)
    {
        RestrOrderController con = new RestrOrderController();
        //return con.MaterializedReportView(startdate);
        List<ClosingReport> getdata = con.ClosingMonthlyReportView(startdate, enddate);
        return JsonConvert.SerializeObject(getdata);
    }

    [WebMethod]
    public string getStatementDataByDates(DateTime startdate, DateTime enddate)
    {
        RestrOrderController con = new RestrOrderController();
        //return con.MaterializedReportView(startdate);
        List<StatementInfo> getStatement = con.StatementMonthlyReportView(startdate, enddate);
        List<CostCenterGroup> getCostcenterGroup = con.GetCostCenterGroupClosing(startdate, enddate);
            var d = new
            {
                getStatement = getStatement,
                getCostcenterGroup = getCostcenterGroup

            };
        return JsonConvert.SerializeObject(d);
    }

    [WebMethod]
    public string getStatementDatewise(DateTime startdate, DateTime enddate)
    {
        RestrOrderController con = new RestrOrderController();
        //return con.MaterializedReportView(startdate);
        List<StatementInfo> getDatewise = con.StatementMonthlyReportDatewise(startdate, enddate);
        return JsonConvert.SerializeObject(getDatewise);
    }


}