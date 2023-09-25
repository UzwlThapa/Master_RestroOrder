<%@ WebService Language="C#" Class="WSforMaterializedView" %>

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
public class WSforMaterializedView  : System.Web.Services.WebService {

    [WebMethod]
    public List<ClosingReport> getDataByDates(DateTime startdate)
    {
        RestrOrderController con = new RestrOrderController();
        //return con.MaterializedReportView(startdate);
        return con.ClosingReportView(startdate);
    }
    
    [WebMethod]
    public List<StatementInfo> getStatementDataByDates(DateTime startdate)
    {
        RestrOrderController con = new RestrOrderController();
        //return con.MaterializedReportView(startdate);
        return con.StatementReportView(startdate);
    }
    
}