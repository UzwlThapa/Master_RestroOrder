<%@ WebService Language="C#" Class="WebServiceForNote" %>

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
public class WebServiceForNote : System.Web.Services.WebService
{

    [WebMethod]
    public void saveNote(int note, bool iscoin)
    {
        NoteController objCon = new NoteController();
        objCon.saveNote(note, iscoin);
    }

    [WebMethod]
    public List<NoteInfo> getNoteList()
    {
        NoteController objCon = new NoteController();
        return objCon.getNoteList();
    }

}