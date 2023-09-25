<%@ WebService Language="C#" Class="LoyalityCardWebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestoLoyalty;
using Newtonsoft.Json;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class LoyalityCardWebService  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

      RestoLoyaltyController prov = new RestoLoyaltyController();

        [WebMethod]
    public void SaveLoyalityCard(CardInfo CardInfo)
    {
        try
        {

            prov.SaveLoyalityCard(CardInfo );
        }
        catch (Exception)
        {

            throw;
        }
    }
    

        
    [WebMethod]
    public void DeleteLoyalityCardType(int CardTypeID)
    {
        prov.DeleteLoyalityCardType(CardTypeID);
    }


          [WebMethod]
    public string GetLoyalityCardType()
    {
        try
        {
            List<CardInfo> list =  prov.getLoyalityCardType();
            return JsonConvert.SerializeObject(list);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}