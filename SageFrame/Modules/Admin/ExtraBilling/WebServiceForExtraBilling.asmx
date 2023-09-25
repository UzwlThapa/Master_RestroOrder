<%@ WebService Language="C#"  Class="WebServiceForExtraBilling" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestoLoyalty;
using SageFrame.RestroOrder;


/// <summary>
/// Summary description for WebServiceForExtraBilling
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class WebServiceForExtraBilling : System.Web.Services.WebService {

    public WebServiceForExtraBilling () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    
     [WebMethod]
    public List<MemberInfo> getsdatass(int customer)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        return dfcobj.getmembershiplist(customer);
        
    }

     //[WebMethod]
     //public void SaveExtraBilling(adjustmentMain PurchaseObjectItem)
     //{
     //    try
     //    {
     //        RestrOrderController roc = new RestrOrderController();
     //        roc.SaveExtraBilling(PurchaseObjectItem);

     //    }
     //    catch (Exception)
     //    {

     //        throw;
     //    }
     //}

     [WebMethod]
     public int SaveExtraBilling(ExtraBilling PurchaseObjectItem)
     {

         RestoLoyaltyController dfcobj = new RestoLoyaltyController();
         return dfcobj.SaveExtraBilling(PurchaseObjectItem);
     }


     
}
