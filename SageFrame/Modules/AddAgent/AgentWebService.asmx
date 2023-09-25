<%@ WebService Language="C#" Class="WebServiceOfRestoLoyalty" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestoLoyalty;
using Newtonsoft.Json;
using SageFrame.RestroOrder;

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
    public void SaveAgent(AgentInfo MemberInfo)
    {
        try
        {
            RestoLoyaltyController relco = new RestoLoyaltyController();
            relco.SaveAgent(MemberInfo);
        }
        catch(Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public string getsdatass(int customer)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        List<MemberInfo> list = dfcobj.getmembershiplist(customer);
        return JsonConvert.SerializeObject(list);
    }

    [WebMethod]
    public string getAgents(int agent)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        List<AgentInfo> list = dfcobj.getAgentList(agent);
        return JsonConvert.SerializeObject(list);
    }

    [WebMethod]
    public int deletemember(int RId, string deletedby)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        return dfcobj.deletemember(RId, deletedby);
    }

    [WebMethod]
    public int deleteAgent(int RId, string deletedby)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        return dfcobj.deleteAgent(RId, deletedby);
    }

    [WebMethod]
    public string sendSMS(string to, string text)
    {
        SMS sms = new SMS();
        //return jss.Serialize(sms.PostSMS(to, text));
        return sms.PostSMS(to, text);
    }

    [WebMethod]
    public string getmembershiplistbyId(int memberid)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        List<MemberInfo> list = dfcobj.getmembershiplistbyId(memberid);
        return JsonConvert.SerializeObject(list);
    }

    [WebMethod]
    public PinUser GetRolesByUsername(string username)
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.GetRolesByUsername(username);
    }

    [WebMethod]
    public string GetLoyalityCardType()
    {
        try
        {
            RestoLoyaltyController prov = new RestoLoyaltyController();
            List<CardInfo> list =  prov.getLoyalityCardType();
            return JsonConvert.SerializeObject(list);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string GetLoyalityDiscountByCard(int CardTypeID)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        List<CardInfo>  list = dfcobj.GetLoyalityDiscountByCard(CardTypeID);
        return JsonConvert.SerializeObject(list);
    }

}
