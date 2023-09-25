<%@ WebService Language="C#" Class="CostCenterwiseService" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using Newtonsoft.Json;

/// <summary>
/// Summary description for CostCenterwiseService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CostCenterwiseService : System.Web.Services.WebService
{
    public CostCenterwiseService()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }
    [WebMethod]
    public string GetCostCenter()
    {
        RestrOrderController roc = new RestrOrderController();
        List<costCenter> costcenter = roc.getcostcenter();
        return JsonConvert.SerializeObject(costcenter);
    }
    [WebMethod]
    public string getAllCostCenterReport(DateTime startDate, DateTime endDate, int costCenter)
    {
        RestrOrderController roc = new RestrOrderController();
        List<costCenterReport> allreport = roc.getAllCostCenterReport(startDate, endDate,costCenter);
        return JsonConvert.SerializeObject(allreport);
    }
    [WebMethod]
    public string getDailyCostCenterReport(DateTime startDate, DateTime endDate, int costCenter)
    {
        RestrOrderController roc = new RestrOrderController();
        List<costCenterReport> dailyreport = roc.getDailyCostCenterReport(startDate, endDate, costCenter);
        return JsonConvert.SerializeObject(dailyreport);
    }
    [WebMethod]
    public string getSummaryCostCenterReport(DateTime startDate, DateTime endDate, int costCenter)
    {
        RestrOrderController roc = new RestrOrderController();
        List<costCenterReport> summary = roc.getSummaryCostCenterReport(startDate, endDate, costCenter);
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