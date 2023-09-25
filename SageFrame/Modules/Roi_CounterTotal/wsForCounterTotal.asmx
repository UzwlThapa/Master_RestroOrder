<%@ WebService Language="C#" Class="wsForCounterTotal" %>

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
public class wsForCounterTotal : System.Web.Services.WebService
{

    [WebMethod]
    public List<counter> getCostCenterlist()
    {
        NoteController conObj = new NoteController();
        return conObj.getCostCenterlist();
    }

    [WebMethod]
    public List<counter> getUserlist()
    {
        NoteController conObj = new NoteController();
        return conObj.getUserlist();
    }

    [WebMethod]
    public List<NoteInfo> getopenDrawerList(int id)
    {
        NoteController objCon = new NoteController();
        return objCon.getopenDrawerList(id);
    }

    [WebMethod]
    public List<openBalance> getOpenBalance(int cid, int ccid)
    {
        NoteController objCon = new NoteController();
        return objCon.getOpenBalanceForCounterTotal(cid, ccid);
    }

    [WebMethod]
    public void saveCounterTotal(counter counter)
    {
        NoteController objCon = new NoteController();
        objCon.saveCounterTotal(counter);

    }

    [WebMethod]
    public List<CTotal> getCounterTotal()
    {
        NoteController objCon = new NoteController();
        return objCon.getCounterTotal();
    }
    
    [WebMethod]
    public List<CTotal> getNumberOfCounter(int id)
    {
        NoteController objCon = new NoteController();
        return objCon.getNumberOfCounter(id);
    }

    [WebMethod]
    public List<CTotal> DoesopeningExistOfCounterTotal(int ccid,int cid)
    {
        NoteController conObj = new NoteController();
        return conObj.DoesopeningExistOfCounterTotal(ccid, cid);
    }

    [WebMethod]
    public List<CTotal> DoesClosingExistOfCounterTotal(int ccid, int cid)
    {
        NoteController conObj = new NoteController();
        return conObj.DoesClosingExistOfCounterTotal(ccid,cid);
    }

    [WebMethod]
    public List<CTotal> getVaultViewForBills(string date, int ccid, int cid)
    {
        NoteController objCon = new NoteController();
        return objCon.getCounterTotalForBillsUpdate(date,ccid,cid);
    }

    [WebMethod]
    public List<CTotal> getVaultViewForCoin(string date, int ccid, int cid)
    {
        NoteController objCon = new NoteController();
        return objCon.getCounterTotalForCoinUpdate(date,ccid,cid);
    }

    [WebMethod]
    public List<VaultView> getshowNote(int id)
    {
        NoteController objCon = new NoteController();
        return objCon.getshowNote(id);
    }

}