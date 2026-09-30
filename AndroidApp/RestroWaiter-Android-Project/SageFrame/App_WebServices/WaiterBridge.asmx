<%@ WebService Language="C#" Class="WaiterBridge" %>
using System;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService] // Enables JSON POST identical to DashBoardWebService.asmx
public class WaiterBridge : System.Web.Services.WebService {

    [WebMethod(EnableSession = true)]
    public void RegisterPrinter(string ip, int port, string name) {
        string user = User.Identity.IsAuthenticated ? User.Identity.Name : "DefaultWaiter";
        Session["WaiterPrinter_" + user] = ip + ":" + port + "|" + name;
    }

    [WebMethod(EnableSession = true)]
    public string GetMyPrinter() {
        string user = User.Identity.IsAuthenticated ? User.Identity.Name : "DefaultWaiter";
        return (string)Session["WaiterPrinter_" + user] ?? "";
    }

    [WebMethod]
    public string Ping() {
        return "PONG_SAGEFRAME_IIS_READY";
    }
}
