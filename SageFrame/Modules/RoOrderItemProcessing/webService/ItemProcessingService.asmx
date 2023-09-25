<%@ WebService Language="C#" Class="ItemProcessingService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Configuration;
using Hangfire;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ItemProcessingService  : System.Web.Services.WebService 
{
    RestrOrderController con = new RestrOrderController();
    
    public class ProcessingItems
    {
        public List<OrderDetailClass> OrderedItems { get; set; }
        public List<OrderDetailClass> InProgressItems { get; set; }
        public List<OrderDetailClass> CompletedItems { get; set; }
        public List<OrderDetailClass> CancelledItems { get; set; }
        public List<OrderDetailClass> ComplementaryItems { get; set; }
    }
    
    [WebMethod]
    public ProcessingItems GetOrderItemsProcessingList(int costcenter)
     {
        ProcessingItems itemsList = new ProcessingItems();
        List<OrderDetailClass> info = con.getitemprocessing(costcenter);
        List<OrderDetailClass> infos = con.getCompitemprocessing(costcenter);

        itemsList.OrderedItems = info.Where(p => p.ItemStatus == "Ordered" && p.IsCancelled == false).OrderBy(p => p.billtime).ToList();
        itemsList.InProgressItems = info.Where(p => p.ItemStatus == "InProgress" && p.IsCancelled == false).OrderBy(p => p.billtime).ToList();
        itemsList.CompletedItems = info.Where(p => p.ItemStatus == "Complete" && p.IsCancelled == false).OrderByDescending(p => p.billtime).ToList();
        itemsList.CancelledItems = info.Where(p => p.IsCancelled == true).OrderByDescending(p => p.billtime).ToList();
        itemsList.ComplementaryItems = infos.Where(p => p.ItemStatus == "Ordered" && p.IsCancelled == false).OrderByDescending(p => p.billtime).ToList();
                        
        return itemsList;
    }

    //[WebMethod]
    //public List<OrderDetailClass> getCompitemprocessing(int costcenter)
    //{   
    //return con.getCompitemprocessing(costcenter);
        
    //}
    
    [WebMethod]
    public void ChangeOrderStatus(int orderDetailId, int StatusID)
    {
        List<OrderDetailClass> ord = new List<OrderDetailClass>();
        con.ChangeOrderStatus(orderDetailId, StatusID);

        if (ConfigurationManager.AppSettings["Notification"] == "true")
        {
            if (StatusID == 3)
            {
                WaiterCallInfo wait = new WaiterCallInfo();
                wait = con.callWaiter(orderDetailId);
                if (wait != null && wait.WaiterName != "superuser")
                {
                    if (wait.WaiterIP == "")
                    {
                        WaiterCallInfo wait1 = con.GetWaiterLog().FirstOrDefault();
                        if (wait1 != null)
                        {
                            wait.WaiterIP = wait1.WaiterIP;
                            wait.WaiterName = wait1.WaiterName;
                        }
                    }
                    if (wait.WaiterIP != "")
                    {
                        callWaiter(wait);
                    }
                }
            }
        }
    }


    [WebMethod]
    public void ChangeCompOrderStatus(int CompId, int StatusID)
    {
        List<OrderDetailClass> ord = new List<OrderDetailClass>();
        con.ChangeCompOrderStatus(CompId, StatusID);
   
    }


    [WebMethod]
    public List<WaiterCallInfo> GetWaiterLog()
    {
        try
        {
            RestrOrderController dfcobj = new RestrOrderController();                   
            return dfcobj.GetWaiterLog();
        }
        catch (Exception)
        {

            throw;
        }
    }

    
    [WebMethod]
    public void callWaiter(WaiterCallInfo Waiter)
    {
        try
        {
            BackgroundJob.Enqueue(() => WaiterNotification.CallWaiter(Waiter));
                 
        }
        catch (Exception)
        {
            throw;
        }
    }

   
}