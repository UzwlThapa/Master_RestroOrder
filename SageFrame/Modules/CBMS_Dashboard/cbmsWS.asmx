<%@ WebService Language="C#" Class="cbmsWS" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class cbmsWS  : System.Web.Services.WebService {

    RestrOrderController con = new RestrOrderController();
    JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
    
    [WebMethod]
    public CbmsData getCbmsData()
    {
        return con.getCbmsData();
    }

    [WebMethod]
    public List<CbmsSyncedData> getCbmsSyncedData(int days)
    {
        return con.getCbmsSyncedData(days);        
    }
    
    [WebMethod]
    public void SyncAllSales()
    {
        CBMS.syncSales();
    }
    [WebMethod]
    public string getCompanyInfo()
    {
        return jsSerializer.Serialize(con.getcompanyInfo().FirstOrDefault());
    }
    [WebMethod]
    public string GetSalesBook(string fromDate, string toDate)
    {
        return jsSerializer.Serialize(con.GetSalesBook(fromDate, toDate));
    }
    [WebMethod]
    public string GetReturnedSalesBook(string fromDate, string toDate)
    {
        return jsSerializer.Serialize(con.GetReturnedSalesBook(fromDate, toDate ));
    }
}