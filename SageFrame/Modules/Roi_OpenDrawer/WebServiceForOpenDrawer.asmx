<%@ WebService Language="C#" Class="WebServiceForOpenDrawer" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.Note2;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WebServiceForOpenDrawer  : System.Web.Services.WebService {
    
    [WebMethod]
    public List<NoteInfo> getopenDrawerList(int id)
    {
        NoteController objCon = new NoteController();
        return objCon.getopenDrawerList(id);
    }

    [WebMethod]
    public void saveOpenDrawer(NoteInfo note) {
        try
        {
        NoteController objCon = new NoteController();
        objCon.saveOpenDrawer(note);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public List<openBalance> getOpenBalance()
    {
        NoteController objCon = new NoteController();
        return objCon.getOpenBalance();
    }
    
    [WebMethod]
    public List<counter> getUserlist()
    {
        NoteController conObj = new NoteController();
        return conObj.getUserlist();
    }
    
    [WebMethod]
    public List<counter> getCostCenterlist()
    {
        NoteController conObj = new NoteController();
        return conObj.getCostCenterlist();
    }
    
    [WebMethod]
    public List<VaultView> checkForDataExit()
    {
        NoteController conObj = new NoteController();
        return conObj.checkForDataExit();
    }

    [WebMethod]
    public List<VaultView> DoesopeningExist()
    {
        NoteController conObj = new NoteController();
        return conObj.DoesopeningExist();
    }

    [WebMethod]
    public List<VaultView> DoesClosingExist()
    {
        NoteController conObj = new NoteController();
        return conObj.DoesClosingExist();
    }

    [WebMethod]
    public List<VaultView> getVaultViewForBills(string date)
    {
        NoteController objCon = new NoteController();
        return objCon.getVaultViewForBills(date);
    }

    [WebMethod]
    public List<VaultView> getVaultViewForCoin(string date)
    {
        NoteController objCon = new NoteController();
        return objCon.getVaultViewForCoin(date);
    }
    
}