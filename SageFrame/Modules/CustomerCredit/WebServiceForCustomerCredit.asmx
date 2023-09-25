<%@ WebService Language="C#" CodeBehind="~/App_Code/WebServiceForCustomerCredit.cs" Class="WebServiceForCustomerCredit" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestoLoyalty;

/// <summary>
/// Summary description for WebServiceForCustomerCredit
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class WebServiceForCustomerCredit : System.Web.Services.WebService {

    public WebServiceForCustomerCredit () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }


    [WebMethod]
    public List<MemberInfo> getsdatass()
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        return dfcobj.getmembershipCreditlist();

    }
    
}
