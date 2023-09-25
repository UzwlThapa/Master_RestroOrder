using SageFrame.RestroOrder;
using System.Net;

/// <summary>
/// Summary description for WaiterNotification
/// </summary>
public static class WaiterNotification
{
    public static void CallWaiter(string WaiterIp)
    {
        WebRequest webRequest = WebRequest.Create(WaiterIp + "/?Department=web&ItemName=Immediate&TableName=Here");
        webRequest.Proxy = null;
        WebResponse webResp = webRequest.GetResponse();
    }

    public static void CallWaiter(WaiterCallInfo Waiter)
    {
        WebRequest webRequest = WebRequest.Create(Waiter.WaiterIP + "/?Department=" + Waiter.Department + "&ItemName=" + Waiter.ItemName + "&TableName=" + Waiter.TableName + "");
        webRequest.Proxy = null;
        WebResponse webResp = webRequest.GetResponse();
    }
}