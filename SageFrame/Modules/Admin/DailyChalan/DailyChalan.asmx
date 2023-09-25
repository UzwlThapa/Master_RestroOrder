<%@ WebService Language="C#" Class="DailyChalan" %>


using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.DailyChalan;

/// <summary>
/// Summary description for DailyChalan
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class DailyChalan : System.Web.Services.WebService {

    public DailyChalan () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    
    [WebMethod]
    public List<DailyChalanInfo> GetDropDown()
    {
        DailyChalanController obj = new DailyChalanController();
        return obj.GetDropDown();
    }
    
    [WebMethod]
    public void ChalanSaveTodatabase(DailyChalanInfo chalan)
    {
        DailyChalanController obj = new DailyChalanController();
        obj.ChalanSaveTodatabase(chalan);

    }
    
    [WebMethod]
    public void ChalanUpdateTodatabase(DailyChalanInfo chalan)
    {
        DailyChalanController obj = new DailyChalanController();
        obj.ChalanUpdateTodatabase(chalan);

    }
    [WebMethod]
    public List<DailyChalanInfo> GetDataFromDatabase()
    {
        DailyChalanController obj = new DailyChalanController();
        return obj.GetDataFromDatabase();
    }
    
    [WebMethod]
    public List<DailyChalanIssue> GetIssuedDetails(int DailyChalanId)
    {
        DailyChalanController obj = new DailyChalanController();
        return obj.GetIssuedDetails(DailyChalanId);
    }

    [WebMethod]
    public List<DailyChalanReturn> GetReturnedDetails(int DailyChalanId)
    {
        DailyChalanController obj = new DailyChalanController();
        return obj.GetReturnedDetails(DailyChalanId);
    }
}
