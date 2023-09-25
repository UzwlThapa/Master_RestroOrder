<%@ WebService Language="C#" Class="wsCounterPerson" %>

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
public class wsCounterPerson  : System.Web.Services.WebService {
    [WebMethod]
    public void SaveCounterPerson(CounterPerson person) {
        NoteController objCon = new NoteController();
        objCon.SaveCounterPerson(person);
    }

    [WebMethod]
    public List<CounterPerson> getCounterPersonList()
    {
        NoteController objCon = new NoteController();
        return objCon.getCounterPersonList();
    }
}