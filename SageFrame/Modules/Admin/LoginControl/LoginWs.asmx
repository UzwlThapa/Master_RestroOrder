<%@ WebService Language="C#" Class="LoginWs" %>

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
public class LoginWs  : System.Web.Services.WebService {

    [WebMethod]
    public companyInfo GetCompanyInfo()
    {
        RestrOrderController controller = new RestrOrderController();
        return controller.getcompany();
    }
    [WebMethod]
    public List<UserInfos> CheckPinCodeMatch(string PinCode)
    {
        RestrOrderController controller = new RestrOrderController();
        return controller.getUNameNpwdByPIN(PinCode);
    }
}