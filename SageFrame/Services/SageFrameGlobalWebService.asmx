<%@ WebService Language="C#" Class="SageFrameGlobalWebService" %>
using System.Web.Services;
using SageFrame.Web;

/// <summary>
/// Summary description for SageFrameGlobalWebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class SageFrameGlobalWebService : System.Web.Services.WebService
{

    public SageFrameGlobalWebService()
    {
    }

    [WebMethod]
    public string GetLocalizedMessage(string CultureCode, string ModuleName, string MessageType)
    {
        return (SageMessage.ProcessSageMessage(CultureCode, ModuleName, MessageType));
    }
}