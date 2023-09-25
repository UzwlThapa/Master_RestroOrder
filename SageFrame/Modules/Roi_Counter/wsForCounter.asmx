<%@ WebService Language="C#" Class="wsForCounter" %>

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
public class wsForCounter : System.Web.Services.WebService
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
    public List<openBalance> getOpenBalance()
    {
        NoteController objCon = new NoteController();
        return objCon.getOpenBalance();
    }

    [WebMethod]
    public void saveCounter(CTransaction counter)
    {
        NoteController objCon = new NoteController();
        objCon.saveCounter(counter);
    }

    [WebMethod]
    public List<CTotal> getNumberOfCounter(int id)
    {
        NoteController objCon = new NoteController();
        return objCon.getNumberOfCounter(id);
    }

    [WebMethod]
    public List<CTransaction> getCounterTotal()
    {
        NoteController objCon = new NoteController();
        return objCon.getCounterTransaction();
    }
}