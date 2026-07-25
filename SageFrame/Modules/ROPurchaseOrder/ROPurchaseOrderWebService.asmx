<%@ WebService Language="C#" Class="RoWebService" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Web.Services;
using System.Web.Script.Serialization;
using SageFrame.RestroOrder;
using System.Web.Script.Services;
using Newtonsoft.Json;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.parser;
using System.Diagnostics;
using System.Text;
using SageFrame.CostCenter;
using System.Drawing;
using System.Drawing.Printing;
using TheArtOfDev.HtmlRenderer;
using SageFrame.FiscalYear;

//using System.Drawing.Printing.PrintDocument;
/// <summary>
/// Summary description for PoWebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class RoWebService : System.Web.Services.WebService
{
    public static int userid = 0;
    //private StreamReader streamToPrint;
    //private System.Drawing.Font printFont;
    string newFileName;
    string dateString;

    //public string modulePath = string.Empty;
    //public int userModuleID = 0;
    public RoWebService()
    {
        //modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        //userModuleID = int.Parse(SageUserModuleID);
        ////Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }
    public class CancelledOrder
    {
        public List<OrderDetailCancel> cancelledOrderItems { get; set; }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void CancelOrderIntoDataBase(string json)
    {
        try
        {
            // Log raw incoming JSON for debugging
            string logPath = Server.MapPath("/App_Data/OrderLogs/");
            if (!Directory.Exists(logPath))
                Directory.CreateDirectory(logPath);
            string logFile = Path.Combine(logPath, "CancelOrderLog_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".txt");
            File.WriteAllText(logFile, "Raw JSON:\n" + json + "\n\nTimestamp: " + DateTime.Now + "\n");

            JavaScriptSerializer jss = new JavaScriptSerializer();
            OrderMasterClass orderMasterInfo;
            
            try
            {
                orderMasterInfo = jss.Deserialize<OrderMasterClass>(json);
            }
            catch (Exception ex)
            {
                throw new Exception("JSON Deserialization failed: " + ex.Message);
            }

            // Sanitize UserName - remove extra quotes
            if (!string.IsNullOrEmpty(orderMasterInfo.UserName))
            {
                orderMasterInfo.UserName = orderMasterInfo.UserName.Trim().Trim('\"');
            }

            RestrOrderController rocobj = new RestrOrderController();
            List<OrderDetailClass> orderList = rocobj.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID).Where(p => p.Status == "Ordered" && p.SeatNo == orderMasterInfo.GuestNo).ToList();
            restroTable table = rocobj.GetTableNoBYId(Convert.ToInt32(orderMasterInfo.TableId));
            Token toke = rocobj.getOrderNobyOrderMasterId(Convert.ToInt32(orderMasterInfo.OrderMasterID));
            List<OrderDetailCancel> CancelItems = new List<OrderDetailCancel>();
            foreach (OrderDetailClass ord in orderList)
            {
                OrderDetailCancel cancelItm = new OrderDetailCancel();

                cancelItm.orderMasterID = orderMasterInfo.OrderMasterID;
                cancelItm.Item = ord.ROI_ItemName;
                cancelItm.Quantity = ord.Quantity;
                cancelItm.Reason = orderMasterInfo.CancelReason;
                cancelItm.Responsible = "Customer";
                cancelItm.CanceledBy = orderMasterInfo.CancelBy;
                cancelItm.OrderBy = orderMasterInfo.UserName;
                cancelItm.tableId = table.restrotableId;

                CancelItems.Add(cancelItm);
            }
            Context.Response.ContentType = "application/json";
            try
            {
                rocobj.CancelOrder(orderMasterInfo);
                rocobj.SaveCanceledItems(CancelItems);
                string printed = "";
                if (System.Configuration.ConfigurationManager.AppSettings["OrderPrinting"] == "true")
                {
                    OrderPrint print = new OrderPrint();
                    printed = print.PrintOrders(orderList, table.restrotableTitle == null ? "Table" : table.restrotableTitle, DateTime.Now, orderMasterInfo.CancelBy, "Cancelled", orderMasterInfo.OrderMasterID, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                }
                else
                {
                    printed = "Success";
                }

                if (printed != null && printed != "")
                {
                    Context.Response.Write("{\"success\": true, \"statusCode\": 200, \"message\": \"Success\"}");
                }
                else
                {
                    Context.Response.Write("{\"success\": false, \"statusCode\": 100, \"message\": \"Print Failed\"}");
                }

            }
            catch (Exception ex)
            {
                // Log exception
                string errorLogFile = Path.Combine(logPath, "CancelOrderError_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".txt");
                File.WriteAllText(errorLogFile, "Exception:\n" + ex.ToString() + "\nRaw JSON:\n" + json + "\n\nTimestamp: " + DateTime.Now + "\n");
                
                Context.Response.Write("{\"success\": false, \"statusCode\": 100, \"message\": \"" + ex.Message.Replace("\"", "\\\"") + "\"}");
            }

        }
        catch (Exception ex)
        {
            // Log outer exception
            string logPath = Server.MapPath("/App_Data/OrderLogs/");
            if (!Directory.Exists(logPath))
                Directory.CreateDirectory(logPath);
            string logFile = Path.Combine(logPath, "CancelOrderOuterError_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".txt");
            File.WriteAllText(logFile, "Outer Exception:\n" + ex.ToString() + "\nRaw JSON:\n" + json + "\n\nTimestamp: " + DateTime.Now + "\n");
            
            Context.Response.Write("{\"success\": false, \"statusCode\": 100, \"message\": \"" + ex.Message.Replace("\"", "\\\"") + "\"}");
        }

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void SaveCanceledItems(string json)
    {
        // Log raw incoming JSON for debugging
        string logPath = Server.MapPath("/App_Data/OrderLogs/");
        if (!Directory.Exists(logPath))
            Directory.CreateDirectory(logPath);
        string logFile = Path.Combine(logPath, "SaveCanceledItemsLog_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".txt");
        File.WriteAllText(logFile, "Raw JSON:\n" + json + "\n\nTimestamp: " + DateTime.Now + "\n");

        JavaScriptSerializer jss = new JavaScriptSerializer();
        CancelledOrder CancelItems;
        
        try
        {
            CancelItems = jss.Deserialize<CancelledOrder>(json);
        }
        catch (Exception ex)
        {
            // Log deserialization error
            string errorLogFile = Path.Combine(logPath, "SaveCanceledItemsError_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".txt");
            File.WriteAllText(errorLogFile, "Deserialization Exception:\n" + ex.ToString() + "\nRaw JSON:\n" + json + "\n\nTimestamp: " + DateTime.Now + "\n");
            
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write("{\"success\": false, \"statusCode\": 100, \"message\": \"" + ex.Message.Replace("\"", "\\\"") + "\"}");
            return;
        }
        
        try
        {
            RestrOrderController controller = new RestrOrderController();
            controller.SaveCanceledItems(CancelItems.cancelledOrderItems);
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write("{\"success\": true, \"statusCode\": 200, \"message\": \"Success\"}");
        }
        catch (Exception ex)
        {
            // Log exception
            string errorLogFile = Path.Combine(logPath, "SaveCanceledItemsExecError_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".txt");
            File.WriteAllText(errorLogFile, "Execution Exception:\n" + ex.ToString() + "\nRaw JSON:\n" + json + "\n\nTimestamp: " + DateTime.Now + "\n");
            
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write("{\"success\": false, \"statusCode\": 100, \"message\": \"" + ex.Message.Replace("\"", "\\\"") + "\"}");
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void PurchaseOrder(string json)
    {
        try
        {
            // Log raw incoming JSON for debugging tablet issues
            string logPath = Server.MapPath("/App_Data/OrderLogs/");
            if (!Directory.Exists(logPath))
                Directory.CreateDirectory(logPath);
            
            string logFile = Path.Combine(logPath, "OrderLog_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".txt");
            File.WriteAllText(logFile, "Raw JSON:\n" + json + "\n\nTimestamp: " + DateTime.Now + "\n");

            int ordered = CheckOrder(json);
            
            string status = "";
            if (ordered == 1)
            {
                status = "{\"success\": true, \"statusCode\": 200, \"message\": \"Success\"}";
            }
            else
            {
                status = "{\"success\": false, \"statusCode\": 100, \"message\": \"Printing Failed\"}";
            }
            Context.Response.Clear();
            Context.Response.ContentType = "application/json";
            Context.Response.Write(status);
            return;

        }
        catch (Exception ex)
        {
            // Log exception details
            string logPath = Server.MapPath("/App_Data/OrderLogs/");
            if (!Directory.Exists(logPath))
                Directory.CreateDirectory(logPath);
            string logFile = Path.Combine(logPath, "OrderError_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".txt");
            File.WriteAllText(logFile, "Exception:\n" + ex.ToString() + "\nRaw JSON:\n" + json + "\n\nTimestamp: " + DateTime.Now + "\n");
            
            Context.Response.Write("{\"success\": false, \"statusCode\": 100, \"message\": \"" + ex.Message.Replace("\"", "\\\"") + "\"}");
        }
    }


    private int CheckOrder(string json)
    {
        RestrOrderController rocobj = new RestrOrderController();
        JavaScriptSerializer jss = new JavaScriptSerializer();
        
        // Strict JSON parsing with error handling
        OrderMasterClass json1;
        try
        {
            json1 = jss.Deserialize<OrderMasterClass>(json);
        }
        catch (Exception ex)
        {
            throw new Exception("JSON Deserialization failed: " + ex.Message);
        }

        // Validate critical fields
        if (string.IsNullOrEmpty(json1.UserName))
        {
            throw new Exception("UserName is required");
        }
        
        // Sanitize UserName - remove extra quotes if tablet sends "\"Test\"" instead of "Test"
        json1.UserName = json1.UserName.Trim().Trim('\"');
        
        // Validate OrderDetailsList
        if (json1.OrderDetailsList == null || json1.OrderDetailsList.Count == 0)
        {
            throw new Exception("OrderDetailsList cannot be empty");
        }

        // Validate each order detail
        for (int i = 0; i < json1.OrderDetailsList.Count; i++)
        {
            var item = json1.OrderDetailsList[i];
            
            // Validate ItemId
            if (item.ItemId <= 0)
            {
                throw new Exception("Invalid ItemId at index " + i + ": " + item.ItemId);
            }
            
            // Validate Quantity
            if (item.Quantity <= 0)
            {
                throw new Exception("Invalid Quantity at index " + i + ": " + item.Quantity);
            }
            
            // Convert literal "null" strings to empty strings for Note field
            if (!string.IsNullOrEmpty(item.Note) && item.Note.Trim().ToLower() == "null")
            {
                item.Note = string.Empty;
            }
            
            // Convert literal "null" strings to empty strings for ExtraItem field
            if (!string.IsNullOrEmpty(item.ExtraItem) && item.ExtraItem.Trim().ToLower() == "null")
            {
                item.ExtraItem = string.Empty;
            }
        }
        
        // Validate and sanitize orderExtraItem if present
        if (json1.orderExtraItem != null)
        {
            for (int i = 0; i < json1.orderExtraItem.Count; i++)
            {
                var extra = json1.orderExtraItem[i];
                
                // Convert literal "null" strings to empty strings for ExtraItem field
                if (!string.IsNullOrEmpty(extra.ExtraItem) && extra.ExtraItem.Trim().ToLower() == "null")
                {
                    extra.ExtraItem = string.Empty;
                }
            }
        }

        json1.Date = DateTime.Now;

        decimal BasicAmount = 0;
        string status = string.Empty;
        List<OrderDetailClass> orderDetailList = json1.OrderDetailsList;
        restroTable table = rocobj.GetTableNoBYId(Convert.ToInt32(json1.TableId));

        for (int i = 0; i < orderDetailList.Count; i++)
        {
            OrderDetailClass orderDetail = new OrderDetailClass();
            List<ROInvItem> itemList = new List<ROInvItem>();
            if (orderDetailList[i].IsCombo)
            {
                itemList = rocobj.getitemwithRateForCombo(orderDetailList[i].ItemId);
            }
            else
            {
                itemList = rocobj.getitemwithRate(orderDetailList[i].ItemId);
            }
            
            // Validate item exists in database
            if (itemList == null || itemList.Count == 0)
            {
                throw new Exception("Item not found in database: ItemId=" + orderDetailList[i].ItemId);
            }
            
            orderDetail.SeatNo = (orderDetail.SeatNo <= json1.GuestNo ? orderDetail.SeatNo : json1.GuestNo);
            orderDetail.Rate = Convert.ToDecimal(itemList[0].SRate);
            orderDetail.Amount = orderDetail.Rate * Convert.ToDecimal(orderDetailList[i].Quantity);
            BasicAmount += orderDetail.Amount;

        }

        RestroRoom room = new RestroRoom();
        if (json1.RoomId == 0)
        {
            if (json1.OID == 0)
            {
                if (json1.TableId != "0")
                {
                    room = rocobj.GetRoomByTable(Convert.ToInt32(json1.TableId));

                }
                else
                {
                    room = rocobj.getRestroRoomById(Convert.ToInt32(json1.RoomId));
                }
                json1.RoomId = room.restroRoomId;
                json1.restroRoom = room.restroRoom;
            }
        }

        json1.BillNo = "RO" + json1.Date.ToString().Replace("/", "").Replace("PM", "").Replace("AM", "").Replace(":", "").Replace(" ", "");
        json1.BasicAmount = BasicAmount;
        json1.TermAmount = BasicAmount;
        if (json1.BillPaid == null)
        {
            json1.BillPaid = 0;
        }
        json1.Status = status;
        if (String.IsNullOrEmpty(json1.Remarks))
            json1.Remarks = "Fine";
        List<OrderDetailClass> lst = new List<OrderDetailClass>();
        lst = rocobj.GetOrderDetailsByMaster(json1.OrderMasterID);

        List<OrderDetailClass> addedOrders = new List<OrderDetailClass>();
        List<OrderDetailClass> cancelledOrders = new List<OrderDetailClass>();
        if (lst.Count > 0)
        {
            foreach (OrderDetailClass ord in json1.OrderDetailsList)
            {
                List<OrderDetailClass> prevOrders = lst.Where(p => p.ItemId == ord.ItemId && p.IsCombo == ord.IsCombo && p.SeatNo == ord.SeatNo && p.Status == "Ordered").ToList();
                if (prevOrders.Count > 0)
                {
                    if (ord.Quantity > prevOrders.Sum(p => p.Quantity))
                    {
                        ord.Quantity = ord.Quantity - prevOrders.Sum(p => p.Quantity);
                        ord.Note = ord.Note.Substring(ord.Note.LastIndexOf(';') + 1);
                        ord.Status = "Ordered";
                        addedOrders.Add(ord);
                    }
                    else if (ord.Quantity < prevOrders.Sum(p => p.Quantity))
                    {
                        ord.OrderDetailsID = 0;
                        ord.Quantity = prevOrders.Sum(p => p.Quantity) - ord.Quantity;
                        ord.Status = "Ordered";
                        cancelledOrders.Add(ord);
                    }
                }
                else
                {
                    ord.Quantity = ord.Quantity - prevOrders.Sum(p => p.Quantity);
                    ord.Status = "Ordered";
                    addedOrders.Add(ord);
                }
            }
            List<OrderDetailClass> OrdersList = lst.Where(p => p.Status == "Ordered").ToList();
            foreach (OrderDetailClass ord in OrdersList)
            {
                List<OrderDetailClass> newOrders = json1.OrderDetailsList.Where(p => p.ItemId == ord.ItemId && p.SeatNo == ord.SeatNo && p.IsCombo == ord.IsCombo).ToList();
                if (newOrders.Count < 1)
                {
                    cancelledOrders.Add(ord);
                }
            }
        }
        else
        {
            foreach (OrderDetailClass ord in json1.OrderDetailsList)
            {
                ord.Status = "Ordered";
            }
            addedOrders = json1.OrderDetailsList;
        }

        int ordermasterid = rocobj.SaveOrderIntoDataBase(json1, addedOrders, cancelledOrders);
        Token toke = rocobj.getOrderNobyOrderMasterId(ordermasterid);
        List<OrderDetailClass> toppingOnly = new List<OrderDetailClass>();

        List<OrderExtraItem> addedExtra = CheckExtraItems(json1.orderExtraItem, true, json1.OrderMasterID, ordermasterid);
        List<OrderExtraItem> removedExtra = CheckExtraItems(json1.orderExtraItem, false, json1.OrderMasterID, ordermasterid);
        rocobj.SaveExtraOrderedItem(addedExtra, removedExtra);

        if (System.Configuration.ConfigurationManager.AppSettings["OrderPrinting"] == "true")
        {
            foreach (OrderExtraItem ext in addedExtra)
            {
                List<OrderDetailClass> ord = addedOrders.Where(p => p.ItemId == ext.ItemID && p.SeatNo == ext.SeatNo && p.IsCombo == false).ToList();
                if (ord.Count == 0)
                {
                    OrderDetailClass topping = new OrderDetailClass();
                    topping.ItemName = ext.ExtraItem;
                    topping.Quantity = ext.Quantity;
                    topping.Note = lst.Where(p => p.ItemId == ext.ItemID && p.SeatNo == ext.SeatNo && p.IsCombo == false).First().ROI_ItemName;
                    toppingOnly.Add(topping);
                }
            }
            foreach (OrderExtraItem ext in removedExtra)
            {
                List<OrderDetailClass> ord = cancelledOrders.Where(p => p.ItemId == ext.ItemID && p.SeatNo == ext.SeatNo && p.IsCombo == false).ToList();
                if (ord.Count == 0)
                {
                    OrderDetailClass topping = new OrderDetailClass();
                    topping.ItemName = ext.ExtraItem;
                    topping.Quantity = (-ext.Quantity);
                    topping.Note = lst.Where(p => p.ItemId == ext.ItemID && p.SeatNo == ext.SeatNo && p.IsCombo == false).First().ROI_ItemName;
                    toppingOnly.Add(topping);
                }
            }
            foreach (OrderDetailClass ord in addedOrders)
            {
                List<OrderExtraItem> ext = addedExtra.Where(p => p.ItemID == ord.ItemId && p.SeatNo == ord.SeatNo && ord.IsCombo == false).ToList();
                if (ext.Count > 0)
                {
                    string note = "Extra : ";
                    foreach (OrderExtraItem e in ext)
                    {
                        note += (e.ExtraItem + " (" + e.Quantity.ToString() + ")");
                    }
                    ord.Note += note;
                }
            }
            foreach (OrderDetailClass ord in cancelledOrders)
            {
                List<OrderExtraItem> ext = removedExtra.Where(p => p.ItemID == ord.ItemId && p.SeatNo == ord.SeatNo && ord.IsCombo == false).ToList();
                if (ext.Count > 0)
                {
                    string note = "Extra : ";
                    foreach (OrderExtraItem e in ext)
                    {
                        note += (e.ExtraItem + " (" + e.Quantity.ToString() + ")");
                    }
                    ord.Note += note;
                }
            }
            OrderPrint print = new OrderPrint();

            string printSuccessful = ordermasterid.ToString();
            try
            {
                if (json1.IsCancelled == true)
                {
                    status = "Cancelled";
                    printSuccessful += print.PrintOrders(orderDetailList, table.restrotableTitle, json1.Date, json1.UserName, "Cancelled", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                }
                else
                {
                    if (addedOrders.Count > 0)
                    {
                        status = "Added";
                        printSuccessful += print.PrintOrders(addedOrders, table.restrotableTitle, json1.Date, json1.UserName, "Added", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                    }
                    if (cancelledOrders.Count > 0)
                    {
                        status = "Cancelled";
                        printSuccessful += print.PrintOrders(cancelledOrders, table.restrotableTitle, json1.Date, json1.UserName, "Cancelled", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                    }
                    if (toppingOnly.Count > 0)
                    {
                        PrintExtra(toppingOnly, table.restrotableTitle, json1.Date, json1.UserName, 1, ordermasterid);
                    }
                }
                return 1;
            }
            catch (Exception)
            {
                return 0;
            }
        }
        return 1;
    }
    protected List<OrderExtraItem> CheckExtraItems(List<OrderExtraItem> extra, bool added, int ordermasterid, int newOrdermasterid)
    {
        List<OrderExtraItem> newlist = new List<OrderExtraItem>();
        if (extra != null)
        {
            if (added && extra.Count > 0)
            {
                RestrOrderController rocobj = new RestrOrderController();
                foreach (OrderExtraItem ext in extra)
                {
                    List<OrderExtraItem> prevList = rocobj.GetOrderedExtraItemByOrderMaster(ordermasterid).Where(p => p.ItemID == ext.ItemID && p.SeatNo == ext.SeatNo && p.ItemStatus == "Ordered" && p.ExtraItemID == ext.ExtraItemID).ToList();
                    int prevQnty = (prevList.Count > 0 ? prevList.FirstOrDefault().Quantity : 0);
                    if (ext.Quantity > prevQnty)
                    {
                        OrderExtraItem itm = new OrderExtraItem();
                        itm.ItemID = ext.ItemID;
                        itm.OrderMasterId = newOrdermasterid;
                        itm.Quantity = ext.Quantity - prevQnty;
                        itm.ExtraPrice = ext.ExtraPrice;
                        itm.ExtraItemID = ext.ExtraItemID;
                        itm.ExtraItem = ext.ExtraItem;
                        itm.SeatNo = ext.SeatNo;
                        newlist.Add(itm);
                    }
                }
            }
            if (!added && extra.Count > 0)
            {
                if (ordermasterid > 0)
                {
                    RestrOrderController rocobj = new RestrOrderController();
                    foreach (OrderExtraItem ext in extra)
                    {
                        List<OrderExtraItem> prevList = rocobj.GetOrderedExtraItemByOrderMaster(ordermasterid).Where(p => p.ItemID == ext.ItemID && p.SeatNo == ext.SeatNo && p.ItemStatus == "Ordered" && p.ExtraItemID == ext.ExtraItemID).ToList();
                        int prevQnty = (prevList.Count > 0 ? prevList.FirstOrDefault().Quantity : 0);
                        if (ext.Quantity < prevQnty)
                        {
                            OrderExtraItem itm = new OrderExtraItem();
                            itm.ItemID = ext.ItemID;
                            itm.OrderMasterId = newOrdermasterid;
                            itm.Quantity = prevQnty - ext.Quantity;
                            itm.ExtraPrice = ext.ExtraPrice;
                            itm.ExtraItemID = ext.ExtraItemID;
                            itm.ExtraItem = ext.ExtraItem;
                            itm.SeatNo = ext.SeatNo;

                            newlist.Add(itm);
                        }
                    }
                    List<OrderExtraItem> prevLists = rocobj.GetOrderedExtraItemByOrderMaster(ordermasterid).Where(p=> p.ItemStatus=="Ordered").ToList();
                    foreach (OrderExtraItem ext in prevLists)
                    {
                        List<OrderExtraItem> newList = extra.Where(p => p.ItemID == ext.ItemID && p.SeatNo == ext.SeatNo && p.ExtraItemID == ext.ExtraItemID).ToList();
                        if (newList.Count < 1)
                        {
                            newlist.Add(ext);
                        }
                    }

                }
            }
        }

        return newlist;
    }
    public int PrintExtra(List<OrderDetailClass> orderDetailList, string tableId, DateTime time, string userName, int OrderStatus, int orderMasterID)
    {
        CostCenterController coc = new CostCenterController();
        Printer print = new Printer();

        KOT kot = new KOT();
        kot.OrderMasterId = orderMasterID.ToString();
        kot.TableId = tableId;
        kot.Date = time.ToShortDateString();
        kot.Time = time.ToShortTimeString();
        kot.Waiter = userName;
        kot.Status = "Updated";
        try
        {
            kot.KOTItems = orderDetailList;
            kot.CostCenterTitle = "Topping";
            CostCenterInfo ccInfo = coc.GetCostCenterById(1);
            print.PrintKOT(ccInfo.DefaultPrinter, kot);
            return orderMasterID;
        }
        catch (Exception)
        {
            return orderMasterID;
        }
    }
    //private class
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void UpdateOrder(string json)
    {
        try
        {
            //SecurityPolicy objSecurity = new SecurityPolicy();
            //string statusOrder =
            RestrOrderController roc = new RestrOrderController();
            JavaScriptSerializer jss = new JavaScriptSerializer();
            RestrOrderInfo tableInfo = jss.Deserialize<RestrOrderInfo>(json);
            OrderMasterClass orderMaster = new OrderMasterClass();
            RoomBookingsInfo info = new RoomBookingsInfo();
            restroTable table = roc.getTableInfo(Convert.ToInt32(tableInfo.TableId));
            if (table.IsTable)
            {
                orderMaster = roc.GetOrderDetailsFromDatabase(tableInfo.TableId);
            }
            else
            {
                orderMaster = roc.GetOrderDetailsFromDatabase(tableInfo.TableId,table.OrderMasterId);
                info = roc.getRoomBookingInfoByOrderMasterID(table.OrderMasterId);
                orderMaster.RoomBookedDays = info.BookedDays;
                orderMaster.RoomRate = info.Rate;
                orderMaster.RoomTotal = info.TotalAmount;
                orderMaster.AdvancePaid = info.AdvancePayment;
            }


            if (orderMaster == null || orderMaster.BillPaid == 1 || orderMaster.IsCancelled == true ||
                orderMaster.TableId == null)
            {
                //orderMaster = null;
                //string jsonFormat = "{\"Status\": \"Empty\"}";
                Context.Response.Clear();
                Context.Response.ContentType = "application/json";
                Context.Response.Write("");
            }
            else
            {

                //List<OrderDetailClass> orderDetailList = new List<OrderDetailClass>(roc.GetOrderDetailsByMaster(orderMaster.OrderMasterID));

                List<OrderDetailClass> orderDetailList = roc.GetOrderDetailWithStatus(orderMaster.OrderMasterID);


                List<OrderExtraItem> extra = roc.GetOrderedExtraItemByOrderMaster(orderMaster.OrderMasterID);

                int ccid = 0;
                int ccg = 0;

                foreach (OrderDetailClass ord in orderDetailList){

                    /*
                    Tablet Takes 
                    CostCenter Id KOT as 1
                    CostCenter Id BAR as 2
                    CostCenter Id Cake(Bakery) as 95
                    CostCenter Id Pizza as 97
                    */

                    //Solution for Total Amt in Costcenter
                    if (ord.GroupId == ccg)
                    {
                        ord.CostCenterId = ccid;
                    }
                    else
                    {
                        ccid = ord.CostCenterId;
                        ccg = ord.GroupId;
                    }


                    //Solution for Discount and Total Amt of Cost Center
                    //if (ord.GroupId == 1) //Kitchen Group
                    //{
                    //    ord.CostCenterId = 1;

                    //}else if(ord.GroupId == 2)//Bar Group
                    //{
                    //    ord.CostCenterId = 2;

                    //} else if(ord.GroupId == 3)//Bakery Group
                    //{
                    //    ord.CostCenterId = 95;
                    //}




                    ord.orderExtraItem = extra.Where(p => p.ItemID == ord.ROI_ItemId && p.SeatNo == ord.SeatNo && ord.Status==p.ItemStatus && ord.IsCombo == false).ToList();
                }
                orderMaster.OrderDetailsList = orderDetailList;
                //OrderMasterClass orderMaster= roc.GetOrderDetailsFromDatabase(tableId);
                string orderJson = jss.Serialize(orderMaster);
                dynamic parsedJson = JsonConvert.DeserializeObject(orderJson);
                var jsonFormatted = JsonConvert.SerializeObject(parsedJson, Formatting.Indented);
                Context.Response.Clear();
                Context.Response.ContentType = "application/json";
                Context.Response.Write(jsonFormatted);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void RoomOrderByRoomType(string json)
    {
        RestrOrderController roc = new RestrOrderController();
        JavaScriptSerializer jss = new JavaScriptSerializer();
        RestrOrderInfo tableInfo = jss.Deserialize<RestrOrderInfo>(json);
        List<RestroRoom> rooms = new List<RestroRoom>();
        string jsonString = "";
        try
        {
            rooms = roc.GetRoomByRoomTypeId(tableInfo.RoomTypeID);
            jsonString = "{statusCode:200, message:\"\",Data:" + JsonConvert.SerializeObject(rooms, Formatting.Indented) + "}";
        }
        catch(Exception ex)
        {
            jsonString = "{statusCode:100, message:\"" + ex.Message + "\"}";
        }
        //string jsonString = "";
        //jsonString = JsonConvert.SerializeObject(rooms, Formatting.Indented);
        //string path = "/Modules/ROPurchaseOrder/RestroRoomOrderByRoomType.Json";
        //string fullPath = Server.MapPath(path);
        //using (var file = new StreamWriter(fullPath, false))
        //{
        //    file.Flush();
        //    file.Write(jsonString);
        //    file.Close();
        //    file.Dispose();
        //}

        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Write(jsonString);


    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void getGlobalizedMenu(int languageid)
    {
        RestrOrderController roc = new RestrOrderController();
        List<MenuClass> itemlist = roc.getGlobalizedMenu(languageid);

        string jsonString = "";
        jsonString = JsonConvert.SerializeObject(itemlist, Formatting.Indented);
        string path = "/Modules/ROPurchaseOrder/RestroTableOrderByRoom.Json";
        string fullPath = Server.MapPath(path);
        using (var file = new StreamWriter(fullPath, false))
        {
            file.Flush();
            file.Write(jsonString);
            file.Close();
            file.Dispose();
        }

        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Write(jsonString);
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void TableOrderByRoom(string json)
    {
        RestrOrderController roc = new RestrOrderController();
        JavaScriptSerializer jss = new JavaScriptSerializer();
        RestrOrderInfo tableInfo = jss.Deserialize<RestrOrderInfo>(json);
        List<restroTable> rooms = new List<restroTable>();
        rooms = roc.GetTableByRoomTypeId(tableInfo.restroRoomId);
        foreach (restroTable table in rooms)
        {
            if (table.MergeTableList > 0)
            {
                table.BillPaid = rooms.Where(p => p.restrotableId == table.MergeTableList).FirstOrDefault().BillPaid;
                table.IsCancelled = rooms.Where(p => p.restrotableId == table.MergeTableList).FirstOrDefault().IsCancelled;
                table.restrotablesStatusID = (table.BillPaid == 1 || table.IsCancelled == 1 ? 6 : 7);
            }
           // if (!table.IsTable)
           // {
                if (table.OrderMasterId > 0)
                {
                    table.restrotablesStatusID = 7;
                }
                else
                {
                    table.restrotablesStatusID = 6;
                    table.BillPaid = 0;
                }
           // }
        }
        string jsonString = "";
        jsonString = JsonConvert.SerializeObject(rooms, Formatting.Indented);
        string path = "/Modules/ROPurchaseOrder/RestrogetGlobalizedMenu.Json";
        string fullPath = Server.MapPath(path);
        using (var file = new StreamWriter(fullPath, false))
        {
            file.Flush();
            file.Write(jsonString);
            file.Close();
            file.Dispose();
        }

        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Write(jsonString);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void GetCategoriesBymenuID(int MenuId, int languageid)
    {
        RestrOrderController roc = new RestrOrderController();
        List<CategoriesClass> menu = roc.GetCategoriesBymenuID(MenuId, languageid);
        string jsonString = "";
        jsonString = JsonConvert.SerializeObject(menu, Formatting.Indented);
        string path = "/Modules/ROPurchaseOrder/RestroGetCategoriesBymenuID.Json";
        string fullPath = Server.MapPath(path);
        using (var file = new StreamWriter(fullPath, false))
        {
            file.Flush();
            file.Write(jsonString);
            file.Close();
            file.Dispose();
        }

        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Write(jsonString);
    }


    [WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void TableTransfer(string json)
    {

        RestrOrderController roc = new RestrOrderController();
        JavaScriptSerializer jss = new JavaScriptSerializer();
        ShifTable shiftTable = jss.Deserialize<ShifTable>(json);
        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        try
        {
            roc.shiftTable(shiftTable.fromOrderMasterId, shiftTable.toTable, shiftTable.fromSplitNo, shiftTable.toSplitNo, shiftTable.shiftedBy);
            Context.Response.Write("{statusCode:200, message:\"Success\", data:{ oldTable:" + shiftTable.fromTable + ",  newTable\": " + shiftTable.toTable + "}}");

        }
        catch(Exception ex)
        {
            Context.Response.Write("{\"statusCode:100, \"message\":\""+ex.Message+"\"}");
        }
    }
    //public void TableTransfer(int OldTable, int NewTable)
    //{
    //    RestrOrderController roc = new RestrOrderController();
    //    JavaScriptSerializer jss = new JavaScriptSerializer();
    //    ////RestrOrderInfo tableInfo = jss.Deserialize<RestrOrderInfo>(json);
    //    //List<restroTable> rooms = new List<restroTable>();
    //    roc.TransfterTableForOrder(OldTable, NewTable);
    //    string jsonString = "{\"OldTable\":" + OldTable + ",  \"NewTable\": " + NewTable + "}";
    //    //jsonString = JsonConvert.SerializeObject(rooms, Formatting.Indented);
    //    string path = "/Modules/ROPurchaseOrder/TableTransfer.Json";
    //    string fullPath = Server.MapPath(path);
    //    using (var file = new StreamWriter(fullPath, false))
    //    {
    //        file.Flush();
    //        file.Write(jsonString);
    //        file.Close();
    //        file.Dispose();
    //    }

    //    Context.Response.Clear();
    //    Context.Response.ContentType = "application/json";
    //    Context.Response.Write(jsonString);
    //}

    [WebMethod]
    public billingTermAndCostcenter getActiveBillTerm()
    {
        billingTermAndCostcenter obj = new billingTermAndCostcenter();
        RestrOrderController roc = new RestrOrderController();
        obj.billingTerm = roc.getActiveBillTerm();
        companyInfo compInf = roc.getcompanyInfo().FirstOrDefault();
        if (compInf.IsPan)
        {
            obj.billingTerm.RemoveAll(d => d.Name == "VAT");
        }
        obj.costCenter = roc.getcostcenter();
        return obj;
    }


    public void SaveWaiterDetailForNotification(UserClass user)
    {
        RestrOrderController.SaveWaiterDetailForNotification(user);
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public void CheckPin(string pin)
    {
        RestrOrderController roc = new RestrOrderController();
        JavaScriptSerializer jss = new JavaScriptSerializer();
        PinUser info = roc.CheckPin(pin);
        string jsonString = "";
        if (info != null)
        {
            info.Message = "Success";
            var parsedJson = JsonConvert.DeserializeObject(jsonString);
            jsonString =  "{statusCode:200, message: \"Success\", data:"+jss.Serialize(info)+"}";

        }
        else
        {
            jsonString = "{statusCode:100, message: \"Invalid Pin\"}";
        }
        //jsonString = JsonConvert.SerializeObject(rooms, Formatting.Indented);
        //string path = "/Modules/ROPurchaseOrder/PinChekUser.Json";
        //string fullPath = Server.MapPath(path);
        //using (var file = new StreamWriter(fullPath, false))
        //{
        //    file.Flush();
        //    file.Write(jsonString);
        //    file.Close();
        //    file.Dispose();
        //}

        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        Context.Response.Write(jsonString);
    }


    [WebMethod]
    public void APIforPay(int tableID)
    {
        var id = tableID;
        decimal amount;
        decimal bevrage;
        decimal totaldiscount;
        decimal kotdis;
        decimal bevdis;
        RestrOrderController roc = new RestrOrderController();
        List<OrderMasterClass> orderMasterList = roc.GetAllOrder(0, false, tableID.ToString());
        List<OrderDetailClass> lst = roc.GettabledataById((tableID));
        totaldiscount = 0;
        if (lst.Count != 0)
        {
            if (lst[0].OrderDetailsID != 0)
            {
                amount = decimal.Parse("0");
                bevrage = decimal.Parse("0");
                foreach (var amt in lst)
                {
                    if (amt.Amount != null)
                        amount += amt.Amount + (amt.Amount == decimal.Parse("0") ? 0 : (amt.ExtraCharge * Convert.ToDecimal(amt.Quantity)));
                }
                foreach (var bev in lst)
                {
                    if (bev.Amount != null)
                        bevrage += bev.Bevrage + (bev.Bevrage == decimal.Parse("0") ? 0 : (bev.ExtraCharge * Convert.ToDecimal(bev.Quantity)));
                }
                List<costCenter> cuscenter = roc.getdiscountfromcostcenter();
                kotdis = 0;
                bevdis = 0;
                decimal kotdisamount = cuscenter[0].coDiscount;
                decimal bevdisamount = cuscenter[1].coDiscount;
                if (amount != 0)
                    kotdis = amount - (amount * kotdisamount / 100);
                if (bevrage != 0)
                    bevdis = bevrage - (bevrage * bevdisamount / 100);
                totaldiscount = (amount * kotdisamount / 100) + (bevrage * bevdisamount / 100);
                decimal sum = kotdis + bevdis;
                List<customerBilling> term = roc.getActiveBILLTERM();
                StringBuilder sb = new StringBuilder();
                int count = 0;
                decimal total = 0;
                total = sum;
                foreach (customerBilling item in term)
                {
                    if (id == 0)
                    {
                        if (item.BillTerm != "Service Charge")
                        {
                            term[count].Amount = Convert.ToDecimal((total * item.Rate / 100).ToString("0.00"));
                            if (item.IsAdd)
                            {
                                total += (total * item.Rate / 100);
                            }
                            else
                                total -= (total * item.Rate / 100);
                        }
                        count = count + 1;
                    }
                    else
                    {
                        term[count].Amount = Convert.ToDecimal((total * item.Rate / 100).ToString("0.00"));
                        if (item.IsAdd)
                            total += (total * item.Rate / 100);
                        else
                            total -= (total * item.Rate / 100);
                        count = count + 1;
                    }
                }
                var net = new customerBilling()
                {
                    ID = 1,
                    BillTerm = "NetAmount",
                    Rate = 0,
                    Amount = Convert.ToDecimal((total).ToString("0.00")),
                };
                term.Add(net);
                SalesMaster sm = new SalesMaster();
                List<SalesDetails> sd = new List<SalesDetails>();
                sm.billNo = "";
                sm.BillDate = (DateTime.Now);
                sm.BasicAmount = lst[0].BasicAmount - totaldiscount;
                sm.RoomId = orderMasterList[0].RoomId;
                sm.TableId = int.Parse(orderMasterList[0].TableId);
                sm.OrderMasterId = orderMasterList[orderMasterList.Count - 1].OrderMasterID;
                sm.totaldiscount = totaldiscount;
                sm.TermAmount = 0;
                count = 0;
                List<customerBilling> bt = new List<customerBilling>();
                term.Count();
                foreach (customerBilling item in term)
                {
                    if (orderMasterList[0].TableId == "0")
                    {
                        if (item.BillTerm != "Service Charge")
                        {
                            if (count != term.Count() - 1)
                            {
                                sm.TermAmount += term[count].Amount;
                                count++;
                            }
                            var bts = new customerBilling
                            {
                                ID = Convert.ToInt32(item.ID),
                                Amount = item.Amount,
                                Rate = item.Rate
                            };
                            bt.Add(bts);
                        }
                    }
                    else
                    {
                        if (count != term.Count() - 1)
                        {
                            sm.TermAmount += term[count].Amount;
                            count++;
                        }
                        var bts = new customerBilling
                        {
                            ID = Convert.ToInt32(item.ID),
                            Amount = item.Amount,
                            Rate = item.Rate
                        };
                        bt.Add(bts);
                    }
                }
                sm.NetAmount = total;
                sm.CusName = "";
                sm.Address = "";
                sm.PAN = "";
                sm.ChequeNo = "";
                sm.TransactionNo = "";
                sm.CusID = 0;
                sm.sumKot = kotdis;
                sm.sumBev = bevdis;
                sm.Waiter = "";
                sm.SPMID = 0;
                foreach (OrderDetailClass ord in lst)
                {
                    var itm = new SalesDetails
                    {
                        ItemId = ord.ROI_ItemId,
                        qty = ord.Quantity,
                        rate = ord.SRate,
                        Amount = ord.Amount,
                        NetAmount = ord.Amount,
                        OrderDetailsID = ord.OrderDetailsID,
                        CostCenterId = ord.CostCenterId,
                        IsCombo = ord.IsCombo
                    };
                    sd.Add(itm);
                }
                var splited = 0;
                {
                    sm.IsSplit = 0;
                    sm.SeatNo = 1;
                    splited = 0;
                }
                sm.AddedBy = "";

                flatorperdiscount fl = new flatorperdiscount();
                fl.SalesMasterId = sm.salesMasterId;
                fl.kotdis = kotdisamount.ToString();
                fl.bardis = bevdisamount.ToString();
                fl.isflatdis = false;
                fl.isLoyalty = false;
                fl.loyaltydis = "0";
                fl.roomdis = "0";

                roc.saveflatorperdis(fl);
                roc.saveSalesBill(sm, sd, splited, bt);
                billHtml(tableID);
            }
        }
        else
        {
            Context.Response.Write("{statusCode:100, message: \"No order in this table\"}");
        }
    }

    [WebMethod]
    public void checkOrder(string json)
    {
        RestrOrderController roc = new RestrOrderController();
        SalesMaster order = JsonConvert.DeserializeObject<SalesMaster>(json);
        Context.Response.Clear();
        Context.Response.ContentType = "application/json";
        try
        {
            List<CheckBill> Checkbill= roc.checkOrder(order.OrderMasterId, order.SeatNo, order.TableId);
            Context.Response.Write("{statusCode:200, message:\"Success\", data: " + JsonConvert.SerializeObject(Checkbill, Formatting.Indented) + "}");
        }
        catch (Exception ex)
        {
            Context.Response.Write("{statusCode:100, message:\""+ex.Message+"\"}");
        }
    }



    private void billHtml(int OrderedId)
    {
        string hosturl = string.Empty;
        SageFrame.RestroOrder.NumberToEnglish num = new NumberToEnglish();
        StringBuilder sb = new StringBuilder();
        RestrOrderController rocc = new RestrOrderController();
        List<companyInfo> list = rocc.getcompanyInfo();
        sb.Append("<div id='customer-bill' style='text-align:center;width:100%;font-family:Arial;'>");
        sb.Append(" <img src='~/ROCompanyInfo/logo/" + list[0].Logo + "'/>");
        //Context.Response.Write("<img src='~/Modules/ROCompanyInfo/logo/" + list[0].Logo + "'/>");
        // sb.Append(" <img src='" + hosturl + "/Modules/ROCompanyInfo/logo/" + list[0].Logo + "'/>");
        sb.Append("<table style='margin-bottom:5px;text-align:center;border-bottom:1px dotted;'>");
        sb.Append("<tr>");
        sb.Append("<td style='font-size:46px;text-align:center;font-weight:bold;'>" + list[0].Name + "</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='font-size:38px;text-align:center'>" + list[0].Address + "</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='font-size:37px;text-align:center'>" + list[0].PhoneNo + "</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='font-size:37px;text-align:center;'><b>TAX INVOICE</b></td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='font-size:36px;text-align:left;'>VAT No. : " + list[0].PAN + "</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("</tr>");
        sb.Append("</table>");
        sb.Append("</div>");
        string InvoiceBillHtml = string.Empty;
        // InvoiceBillHtml += sb1;
        InvoiceBillHtml = ("<div id='customer-bill' style='text-align:center;width:100%;'>");
        InvoiceBillHtml += (" <img src='" + hosturl + "/Modules/ROCompanyInfo/logo/" + list[0].Logo + "' style='width:100px;'/>");
        InvoiceBillHtml += ("<table style='width:100%;padding-bottom:5px;text-align:center;border-bottom:1px dotted;'>");
        InvoiceBillHtml += ("<tr>");
        InvoiceBillHtml += ("<td style='font-size:24px;text-align:center;'>" + list[0].Name + "</td>");
        InvoiceBillHtml += ("</tr>");
        InvoiceBillHtml += ("<tr>");
        InvoiceBillHtml += ("<td style='font-size:22px;text-align:center;'>" + list[0].Address + "</td>");
        InvoiceBillHtml += ("</tr>");
        InvoiceBillHtml += ("<tr>");
        InvoiceBillHtml += ("<td style='font-size:21px;text-align:center;'>" + list[0].PhoneNo + "</td>");
        InvoiceBillHtml += ("</tr>");
        InvoiceBillHtml += ("<tr>");
        InvoiceBillHtml += ("<td style='font-size:21px;text-align:center;'><b>INVOICE</b></td>");
        InvoiceBillHtml += ("</tr>");
        InvoiceBillHtml += ("<tr>");
        InvoiceBillHtml += ("<td style='font-size:16px;text-align:left;'>VAT No.:" + list[0].PAN + "</td>");
        InvoiceBillHtml += ("</tr>");
        InvoiceBillHtml += ("</table>");
        InvoiceBillHtml += ("</div>");
        //StringBuilder sb = new StringBuilder();
        // sb.Append(InvoiceBillHtml);
        RestrOrderController roc = new RestrOrderController();
        List<OrderDetailClass> lst = new List<OrderDetailClass>();
        lst = roc.GetDataforPrint((OrderedId));
        // sb1.Append("<div align='left' style='margin: 0;padding: 0;'>");
        if (lst.Count != 0)
        {
            DateTime time = Convert.ToDateTime(lst[0].Date);
            decimal amtafterdiscount = lst[0].BasicAmount - lst[0].totaldiscount;
            List<customerBilling> term = new List<customerBilling>();
            List<flatorperdiscount> fl = roc.getflatorperdiscount(lst[0].OrderMasterId);
            sb.Append("<table id='customer-bill1' style='width:100%;'>");
            sb.Append("<tr>");
            sb.Append("<td style='font-size:32px;'>");
            sb.Append("Customer:");
            sb.Append("</td>");
            if (lst[0].CusName == "")
            {
                sb.Append("<td style='text-align:left;font-size:38px;'> CASH </td>");
            }
            else
                sb.Append("<td style='text-align:left;font-size:38px;'>" + lst[0].CusName + "</td>");
            string BillNoForPrint = lst[0].salesMasterId.ToString();
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td style='font-size:32px;'>");
            sb.Append("PAN:");
            sb.Append("</td>");
            sb.Append("<td style='text-align:left;font-size:32px;'>" + lst[0].PAN + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td style='font-size:32px;'>");
            sb.Append("Address:");
            sb.Append("</td>");
            sb.Append("<td style='text-align:left;font-size:32px;'>" + lst[0].Address + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td style='font-size:32px;'>");
            sb.Append("Invoice No:");
            sb.Append("</td>");
            sb.Append("<td style='text-align:left;font-size:34px;font-weight:bold;'>" + lst[0].GetBillNo() + "</td>");
            sb.Append("<td style='font-size:32px;'>");
            sb.Append("Time:");
            sb.Append("</td>");
            sb.Append("<td style='text-align:left;font-size:34px;'>" + DateTime.Parse(lst[0].Date).ToShortTimeString() + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td style='font-size:32px;'>");
            sb.Append("Date:");
            sb.Append("</td>");
            sb.Append("<td style='text-align:left;font-size:34px;'>" + DateTime.Parse(lst[0].Date).ToShortDateString() + "</td>");
            sb.Append("<td style='font-size:32px;'>");
            sb.Append("Table:");
            sb.Append("</td>");
            sb.Append("<td style='text-align:left;font-size:34px;'><label id='txtTableId'>" + lst[0].restrotableTitle + "</label></td>");
            sb.Append("</tr>");
            sb.Append("</table>");
            sb.Append("<table id='customer-bill2' style='width:50%;'>");
            sb.Append("<tr>");
            sb.Append("<td colspan=5 style='text-align:right;font-size:24px;'>");
            sb.Append("</td></tr>");
            sb.Append("<tr>");
            sb.Append("<td style='width:40px;font-weight:bold;text-align:center;border-bottom:1px dotted;border-top:1px dotted;font-size:30px;'>");
            sb.Append("SN");
            sb.Append("</td>");
            sb.Append("<td style='width:120px;font-weight:bold;border-bottom:1px dotted;border-top:1px dotted;font-size:30px;'>");
            sb.Append("Item");
            sb.Append("</td>");
            sb.Append("<td style='font-weight:bold;width:40px;text-align:center;border-bottom:1px dotted;border-top:1px dotted;font-size:30px;'>");
            sb.Append("Qty");
            sb.Append("</td>");
            sb.Append("<td style='font-weight:bold;width:50px;border-bottom:1px dotted;border-top:1px dotted;font-size:30px;'>");
            sb.Append("Rate(Rs)");
            sb.Append("</td>");
            sb.Append("<td style='font-weight:bold;width:20px;text-align:center;border-bottom:1px dotted;border-top:1px dotted;font-size:30px;'>");
            sb.Append("Food(Rs)");
            sb.Append("</td>");
            sb.Append("<td style='font-weight:bold;width:20px;text-align:center;border-bottom:1px dotted;border-top:1px dotted;font-size:30px;'>");
            sb.Append("Beverage(Rs)");
            sb.Append("</td>");
            sb.Append("</tr>");
            int count = 1;
            foreach (OrderDetailClass item in lst)
            {
                sb.Append("<tr>");
                sb.Append("<td style='width:20px;text-align:center;font-size:30px;'>" + count + "</td>");
                sb.Append("<td style='font-size:30px;'>" + GetAmountName(item.ITName, item.ExtraCharge, item.Note) + "</td>");
                sb.Append("<td style='text-align:center;font-size:30px;'>" + item.Quantity + "</td>");
                sb.Append("<td style='text-align:center;font-size:30px;'>" + (item.Rate) + "</td>");
                sb.Append("<td style='text-align:center;font-size:30px;'>" + Getreqiredamount(item.Amount.ToString(), item.ExtraCharge.ToString(), item.Quantity.ToString()) + "</td>");
                sb.Append("<td style='text-align:center;font-size:30px;'>" + Getreqiredamount(item.Bevrage.ToString(), item.ExtraCharge.ToString(), item.Quantity.ToString()) + "</td>");
                sb.Append("</tr>");
                count = count + 1;
            }
            sb.Append("<tr>");
            sb.Append("<td colspan=6 style='text-align:right;border-bottom:1px dotted;font-size:30px;'>");
            decimal amount = 0;
            foreach (var amt in lst)
            {
                amount += amt.Amount + (amt.Amount == decimal.Parse("0") ? 0 : (amt.ExtraCharge * Convert.ToDecimal(amt.Quantity)));
            }
            decimal bevrage = 0;
            foreach (var bev in lst)
            {
                bevrage += bev.Bevrage + (bev.Bevrage == decimal.Parse("0") ? 0 : (bev.ExtraCharge * Convert.ToDecimal(bev.Quantity)));
            }
            List<costCenter> cuscenter;
            cuscenter = roc.getdiscountfromcostcenter();
            decimal fooddis = amount * cuscenter[0].coDiscount / 100;
            decimal bardis = bevrage * cuscenter[1].coDiscount / 100;
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td style='border:none;border-bottom:1px dotted;font-size:24px;'>" + "</td>");
            sb.Append("<td style='border:none;border-bottom:1px dotted;font-size:24px;'>" + "</td>");
            sb.Append("<td colspan=2 style='font-weight:bold;text-align:right;border-bottom:1px dotted;font-size:30px;'>");
            sb.Append("Sub Total:");
            sb.Append("</td>");
            sb.Append("<td style='text-align:center;border-bottom:1px dotted;font-size:32px;'>Rs." + amount + "</td>");
            sb.Append("<td style='text-align:center;border-bottom:1px dotted;font-size:32px;'>Rs." + bevrage + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td colspan=4 style='text-align:right;font-size:30px'>Discount(Bar: 0 %,Food: 0 %)</td>");
            sb.Append("<td style='text-align:center;font-size:32px;'>");
            sb.Append("Rs." + (amount) + "");
            sb.Append("</td>");
            sb.Append("<td style='text-align:center;font-size:32px;'>");
            sb.Append("Rs." + (bevrage) + "");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td colspan=4 style='font-weight:bold;text-align:right;font-size:24px;'>Amount (After Discount)</td>");
            sb.Append("<td style='text-align:center;font-size:30px;'>");
            sb.Append("Rs." + (amount) + "");
            sb.Append("</td>");
            sb.Append("<td style='text-align:center;font-size:30px;'>");
            sb.Append("Rs." + (bevrage) + "");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td colspan=5 style='font-weight:bold;text-align:right;border-top:1px dotted;font-size:30px;'>");
            sb.Append("Total:");
            sb.Append("</td>");
            sb.Append("<td style='text-align:center;border-top:1px dotted;font-size:32px;'>");
            sb.Append("Rs." + ((amount) + (bevrage)) + "");
            sb.Append("</td>");
            sb.Append("</tr>");
            decimal perdisamount = ((amount) + (bevrage));
            term = roc.getbillingTermbySalesMasterID(Convert.ToString(lst[0].salesMasterId));
            foreach (customerBilling cb in term)
            {
                if (cb.Amount != 0)
                {
                    if (cb.Rate != 0)
                    {
                        sb.Append("<tr>");
                        sb.Append("<td colspan=4 style='text-align:right;font-size:30px;'>" + cb.BillTerm + "</td>");
                        sb.Append("<td style='text-align:right;font-size:30px;'>(" + cb.Rate.ToString() + "%" + ")" + ":" + "</td>");
                        if (cb.IsAdd)
                            sb.Append("<td style='text-align:center;font-size:32px;'>Rs." + cb.Amount + "</td>");
                        else
                            sb.Append("<td style='text-align:center;font-size:32px;'>Rs.(" + cb.Amount + ")</td>");
                        sb.Append("</tr>");
                    }
                    else
                    {
                        sb.Append("<tr>");
                        sb.Append("<td></td>");
                        sb.Append("<td colspan=4 style='text-align:right;font-weight:Bold;font-size:30px;'>" + cb.BillTerm + "</td>");
                        if (cb.IsAdd)
                            sb.Append("<td style='text-align:center;font-size:32px;'>Rs." + cb.Amount + "</td>");
                        else
                            sb.Append("<td style='text-align:center;font-size:32px;'>Rs.(" + cb.Amount + ")</td>");
                        sb.Append("</tr>");
                    }
                }
            }
            sb.Append("<tr>");
            sb.Append("<td colspan=6 style='text-align:right;border-bottom:1px dotted;font-size:30px;'>");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("<tr style='font-size:32px;'>");
            List<customerBilling> netamount = term.Where(p => p.BillTerm == "NetAmount").ToList();
            sb.Append("<td colspan=6 style='text-align:left;font-size:30px;'>" + "In Words" + ":" + NumberConverter.DecimalToWord(netamount[0].Amount) + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td colspan=3 style='text-align:left'>" + "Cashier: " + lst[0].Cashier + "</td>");
            sb.Append("<td colspan=3 style='text-align:left' id='divPrintedOn'>" + "PrintedOn: " + DateTime.Now.ToString() + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td></td>");
            sb.Append("<td></td>");
            sb.Append("<td></td>");
            sb.Append("<td></td>");
            sb.Append("<td colspan=2 style='border-bottom:1px dotted'></td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td colspan=6 style='text-align:right;font-weight:Bold;font-size:30px;'>For :" + list[0].Name + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td colspan=6 style='text-align:center;font-size:30px;'>");
            sb.Append("**Thank You**");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");
            // sb1.Append("</div>");
            // string HTMLCode = InvoiceBillHtml + sb.ToString();
            string HTMLCode =sb.ToString();
            string status = "{\"Status\": \"Success\"}";
            Context.Response.Write(status);

            CostCenterController coc = new CostCenterController();
            CostCenterInfo ccInfo = coc.GetCostCenterById(96);
            string KitchenPrinterName = ccInfo.DefaultPrinter;
            newFileName = "SalesBill" + DateTime.Now.ToLongTimeString().Replace(":", "").Replace(" ", "") + ".pdf";
            //PrintFunction(HTMLCode, newFileName, "SalesBill");
            string oldfilepath = AppDomain.CurrentDomain.BaseDirectory + @"Modules\ROPurchaseOrder\SalesBill\" + dateString + @"\" + newFileName;
            //string newpath = @"F:\SharedFolder\Kitchen\";
            //SendToPrinter(newFileName, oldfilepath, newpath, KitchenPrinterName);
        }
        else
        {
            sb.Append("<h2>Alert! You Have Paid This Bill</h2>");
        }
    }

    private string GetAmountName(string Name, decimal extra, string Note)
    {
        string result = "";
        if (extra == decimal.Parse("0"))
        {
            result = Name;
        }
        else
        {
            result = Name + "(Note: Extra " + extra + " for " + Note + ")";
        }
        return result;
    }

    public string Getreqiredamount(string amount, string extra, string quantity)
    {
        if (decimal.Parse(amount) == decimal.Parse("0"))
        {
            return "0";
        }
        else
        {
            decimal result = Decimal.Parse(amount) + Decimal.Parse(extra == "0" ? "0" : (decimal.Parse(extra) * decimal.Parse(quantity)).ToString());
            return result.ToString();
        }

    }
}