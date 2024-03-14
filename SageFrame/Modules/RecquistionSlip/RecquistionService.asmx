<%@ WebService Language="C#" Class="RecquistionService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.CostCenter;
using SageFrame.RestroOrder;
using System.Collections.Generic;
using SageFrame.RestoLoyalty;
using System.Web.Script.Serialization;
using SageFrame.Security;
using SageFrame.Security.Entities;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class RecquistionService  : System.Web.Services.WebService {

    RestrOrderController con = new RestrOrderController();
    JavaScriptSerializer serialize = new JavaScriptSerializer();
    
    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    
    [WebMethod]
    public string GetStoreList()
    {
        List<roistore> stores = con.getStoreList();
        return serialize.Serialize(stores);
    }
    [WebMethod]
    public string GetOutOfStockItemsByStoreId(int storeId)
    {
        List<stockReport> stockReport = con.getOutOfStockItems(storeId);
        return serialize.Serialize(stockReport);
    }
    [WebMethod]
    public string SendRecquistion(Recquistion recquistion)
    {
        string recquistionNo = con.SendRecquistion(recquistion);
        return recquistionNo;
    }
    [WebMethod]
    public string GetRecquistions(bool isMainStore)
    {
        List<Recquistion> recquistions = con.GetRecquistions(isMainStore);
        return serialize.Serialize(recquistions);
                
    }
    [WebMethod]
    public void DeleteRecquistion(Recquistion recquistion)
    {
        con.DeleteRecquistion(recquistion);
    }
    [WebMethod]
    public List<MvPurchaseDetails> getitemfromdatabase()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.GetItemForOpenBalance();

        }
        catch (Exception)
        {

            throw;
        }

    }
    [WebMethod]
    public List<MvPurchaseDetails> GetUnitOfItemByID(int ids)
    //public List<UnitClass> getunitbyItem(string itemID)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            //return roc.getunitbyItem(itemID);
            return roc.getUnitsWithConvertion(ids);
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public void IssueRecquistions(Recquistion recquistion)
    {
        con.IssueRecquistions(recquistion);
    }

    [WebMethod]
    public List<MemberInfo> getVender()
    {
        RestrOrderController objCon = new RestrOrderController();
        return objCon.getVender();
    }

    
     [WebMethod]
    public void SaveVendorForRecq(List<RecquistionDetails> recquistion)
    {
        RestrOrderController objCon = new RestrOrderController();
        objCon.SaveVendorForRecq(recquistion);
    }

     [WebMethod]
     public virtual SageFrameUserCollection GetAllUsers()
     {
         MembershipController mhc = new MembershipController();
         return (mhc.GetAllUsers());
     }

     [WebMethod]
     public virtual string GetRoleNames(string UserName, int PortalID)
     {
         RoleController rol = new RoleController();
         return (rol.GetRoleNames(UserName, PortalID));
     }


     [WebMethod]
     public string getForVerification(string receivedBy)
     {
         List<issueMain> received = con.getForVerification(receivedBy);
         return serialize.Serialize(received);

     }

     [WebMethod]
     public string GetIssueDetailsbyId(int imid)
     {
         List<issueMain> details = con.GetIssueDetailsbyId(imid);
         return serialize.Serialize(details);
     }

     [WebMethod]
     public void UpdateVerification(int imid)
     {
         RestrOrderController objCon = new RestrOrderController();
         objCon.UpdateVerification(imid);
     }

}