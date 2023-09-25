<%@ WebService Language="C#" Class="wsForCReport" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.Note2;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class wsForCReport  : System.Web.Services.WebService {

    [WebMethod]
    public List<VaultView> getVaultView(string date)
    {
    NoteController objCon=new NoteController();
        return objCon.getVaultView(date);
    }

    [WebMethod]
    public List<VaultView> getCounterView(int counter, string date, int counterNo)
    {
        NoteController objCon = new NoteController();
        return objCon.getCounterView(counter, date, counterNo);
    }
    
    [WebMethod]
    public List<VaultView> getVaultViewClose(string date)
    {
        NoteController objCon = new NoteController();
        return objCon.getVaultViewClose(date);
    }

    [WebMethod]
    public List<VaultView> getCounterViewClose(int counter, string date, int counterNo)
    {
        NoteController objCon = new NoteController();
        return objCon.getCounterViewClose(counter, date, counterNo);
    }
    
    [WebMethod]
    public List<counter> getCostCenterlist()
    {
        NoteController conObj = new NoteController();
        return conObj.getCostCenterlist();
    }
    
    [WebMethod]
    public List<CTotal> getNumberOfCounter(int id)
    {
        NoteController objCon = new NoteController();
        return objCon.getNumberOfCounter(id);
    }
    
}