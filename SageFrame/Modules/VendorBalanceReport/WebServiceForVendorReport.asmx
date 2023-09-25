<%@ WebService Language="C#"  Class="WebServiceForVendorReport" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestoLoyalty;
using SageFrame.RestroOrder;
    using Newtonsoft.Json;

/// <summary>
/// Summary description for WebServiceForVendorReport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class WebServiceForVendorReport : System.Web.Services.WebService {

    public WebServiceForVendorReport () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

  
    [WebMethod]
    public string getVendorName()
    {
        try
        {

            RestrOrderController dcobj = new RestrOrderController();
            List<CardProvider> card = dcobj.getVendorName();
            return JsonConvert.SerializeObject(card);
        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public string GetVenderReportByDate(string DateFrom, string DateTo, string VenderId)
    {
        try
        {

            RestrOrderController rc = new RestrOrderController();
            List<CardProvider> bydate = rc.GetVenderReportByDate(DateFrom, DateTo,Convert.ToInt32(VenderId));
            return JsonConvert.SerializeObject(bydate);
        }
        catch (Exception)
        {

            throw;
        }
    }


    [WebMethod]

    public string getdailyVendorReportByMonthly(string year, string month)
    {
        RestrOrderController rc = new RestrOrderController();
        List<CardProvider> bymonthly = rc.getdailyVendorReportByMonthly(year, month);
        return JsonConvert.SerializeObject(bymonthly);
    }

    [WebMethod]

    public string getdailyVendorReportByYearly(string year)
    {

        RestrOrderController rc = new RestrOrderController();
        List<CardProvider> byYear = rc.getdailyVendorReportByYearly(year);
        return JsonConvert.SerializeObject(byYear);
    }
}
