<%@ WebService Language="C#" Class="FrontPageWebservice" %>
using System;
using SageFrame.Services;
using System.Web.Services;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using System.Web.Script.Serialization;
using Newtonsoft.Json;

/// <summary>
/// Summary description for FrontPageWebservice
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class FrontPageWebservice : System.Web.Services.WebService
{

    FrontPageController foc = new FrontPageController();
    RestrOrderController prov = new RestrOrderController();
    JavaScriptSerializer serialize = new JavaScriptSerializer();


    public FrontPageWebservice()
    {

    }

    [WebMethod]
    public string getFrontpageStatus()
    {
        List<FrontPage> page = foc.getFrontpageStatus();
        return serialize.Serialize(page);
    }

    [WebMethod]
    public string getcompanyInfo()
    {

        List<companyInfo> company = prov.getcompanyInfo();
        return serialize.Serialize(company);
    }

    [WebMethod]
    public string getOccupiedTableList()
    {

        List<OccupiedTables> table = foc.getOccupiedTableList();
        return JsonConvert.SerializeObject(table);
    }


}