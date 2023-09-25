<%@ WebService Language="C#" Class="WebServiceOfRestoLoyalty" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestoLoyalty;

/// <summary>
/// Summary description for WebServiceOfRestoLoyalty
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebServiceOfRestoLoyalty : System.Web.Services.WebService
{

    public WebServiceOfRestoLoyalty()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public void SaveMembership(MemberInfo MemberInfo)
    {
        try
        {
            RestoLoyaltyController dfcobj = new RestoLoyaltyController();
            RestoLoyaltyProvider dfpobj = new RestoLoyaltyProvider();
            dfcobj.SaveMembership(MemberInfo);
        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public List<MemberInfo> getsdatass(int customer)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        return dfcobj.getmembershiplist(customer);

    }
   [WebMethod]
    public void deletemember(int RId, string deletedby)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        dfcobj.deletemember(RId, deletedby);

    }
}
