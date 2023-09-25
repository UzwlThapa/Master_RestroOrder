<%@ WebService Language="C#" Class="BillsReportService" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using Newtonsoft.Json;


/// <summary>
/// Summary description for BillsReportService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class BillsReportService : System.Web.Services.WebService {

    public BillsReportService () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }
    [WebMethod]
    public string GetProviderList()
    {
        RestrOrderController roc = new RestrOrderController();
        List<CardProvider> provider = roc.getCardProvider();
        return JsonConvert.SerializeObject(provider);
    }
    [WebMethod]
    public string getAllProvidersReport(DateTime startDate, DateTime endDate, int paymentMode, int provider)
    {
        RestrOrderController roc = new RestrOrderController();
        List<providersReport> allreport = roc.getAllProvidersReport(startDate, endDate, paymentMode, provider);
        return JsonConvert.SerializeObject(allreport);
    }
    [WebMethod]
    public string getDayProvidersReport(DateTime startDate, DateTime endDate, int paymentMode, int provider)
    {
        RestrOrderController roc = new RestrOrderController();
        List<providersReport> dayreport = roc.getDayProvidersReport(startDate, endDate, paymentMode, provider);
        return JsonConvert.SerializeObject(dayreport);
    }
    [WebMethod]
    public string getSummaryProvidersReport(DateTime startDate, DateTime endDate, int paymentMode, int provider)
    {
        RestrOrderController roc = new RestrOrderController();
        List<providersReport> summary = roc.getSummaryProvidersReport(startDate, endDate, paymentMode, provider);
        return JsonConvert.SerializeObject(summary);
    }

    [WebMethod]
    public string getCompanyInfo()
    {
        RestrOrderController roc = new RestrOrderController();
        List<companyInfo> company = roc.getcompanyInfo();
        return JsonConvert.SerializeObject(company.FirstOrDefault());
       
    }


}
