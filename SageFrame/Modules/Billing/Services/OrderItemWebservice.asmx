<%@ WebService Language="C#" Class="OrderItemWebservice" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using SageFrame.CostCenter;
using System.Drawing.Printing;
using System.Text;
using System.Drawing;
using System.IO;
using SageFrame.RestoLoyalty;
/// <summary>
/// Summary description for OrderItemWebservice
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class OrderItemWebservice : System.Web.Services.WebService
{
    public OrderItemWebservice()
    {
    }

    [WebMethod]
    public List<extraItem> GetExtraItemsByItem()
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.getExtraItemforItem().Where(p => p.IsActive == true && p.IsDeleted == false).ToList();
    }

    [WebMethod]
    public int SaveSalesBill(SalesMaster salesMaster, List<SalesDetails> salesDetail, int splited, List<customerBilling> billingTerm, flatorperdiscount flatorperdiscount)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.saveSalesBill(salesMaster, salesDetail, splited, billingTerm, flatorperdiscount);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public SalesBill GetDataForSalesBill(int orderMasterId)
    {
        try
        {
            SalesBill salesBill = new SalesBill();
            RestrOrderController roc = new RestrOrderController();
            companyInfo compInf = roc.getcompanyInfo().FirstOrDefault();
            salesBill.orderDetail = roc.getOrderDetailByOrderMasterId(orderMasterId);
            List<OrderExtraItem> extra = roc.GetAllExtraItemByOrderMaster(orderMasterId);
            foreach (OrderDetailClass ord in salesBill.orderDetail)
            {
                if (!ord.IsCombo)
                {
                    ord.orderExtraItem = extra.Where(p => p.ItemID == ord.ROI_ItemId).ToList();
                }
            }
            salesBill.billingTerm = roc.getActiveBILLTERM();

            if (System.Configuration.ConfigurationManager.AppSettings["ServChargeInTakeAway"] == "false")
            {
                salesBill.billingTerm.RemoveAll(p => p.BillTerm == "Service Charge");
            }
            salesBill.cuscenter = roc.getdiscountfromcostcenter();
            salesBill.RoomBooking = roc.getRoomBookingInfoByOrderMasterID(orderMasterId);
            salesBill.VATforBill = (compInf.IsPan ? false : true);
            return salesBill;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public List<MemberInfo> getsdatass(int customer)
    {
        RestoLoyaltyController dfcobj = new RestoLoyaltyController();
        return dfcobj.getmembershiplist(customer);

    }

    [WebMethod]
    public string savePrintCount(int Printcount, string BillNo, string PrintedBy)
    {
        RestrOrderController rocc = new RestrOrderController();
        if (BillNo != "")
        {
            return rocc.SavePrintCountDetail(Printcount, BillNo, PrintedBy);
        }
        return "";

    }

    [WebMethod]
    public string CheckPinCodeMatch(string PinCode, string username)
    {
        RestrOrderController controller = new RestrOrderController();
        string available = controller.CheckPinCodeMatch(PinCode, username);
        return available;
    }

    [WebMethod]
    public List<OrderDetailCancel> getOrderDetailByOrderMasterID(int OrderMasterID)
    {
        RestrOrderController controller = new RestrOrderController();
        return controller.getOrderDetailByOrderMasterID(OrderMasterID).Where(p => p.OrderStatus == "1").GroupBy(i => i.Item).Select(g => new OrderDetailCancel
        {
            ItemID = g.First().ItemID,
            Item = g.First().Item,
            Quantity = g.Sum(i => i.Quantity),
            OrderBy = g.First().OrderBy,
            IsCombo = g.First().IsCombo
        }).ToList();
    }

    [WebMethod]
    public void SaveCanceledItems(List<OrderDetailCancel> CancelItems)
    {
        RestrOrderController controller = new RestrOrderController();
        controller.SaveCanceledItems(CancelItems);
    }

    [WebMethod]
    public List<cumbomain> getitemforcumbo()
    {
        RestrOrderController rocobj = new RestrOrderController();
        return rocobj.getcumbolist(true);
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public List<MenuClass> GetMenuforOrder()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetMenuFromDatabase();

        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public List<CategoriesClass> GetCategoriesBymenuID(int MenuId, int languageid)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetCategoriesBymenuID(MenuId, languageid);
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public List<ItemsClass> GetItemByCategoryID(int CategoriesID, int LanguageID)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetItemByCategoryID(CategoriesID, LanguageID);
        }
        catch (Exception)
        {
            throw;
        }
    }

    public class ItemsList
    {
        public List<ItemsClass> CompOrders { get; set; }
        public List<ItemsClass> InPrgOrders { get; set; }
        public List<ItemsClass> OrderedOrders { get; set; }
        public List<ItemsClass> AllOrders { get; set; }
    }

    [WebMethod]
    public ItemsList GetPreviousItemByID(int Id, int RId, int OID)
    {
        try
        {
            ItemsList itemlists = new ItemsList();
            RestrOrderController rocobj = new RestrOrderController();
            List<ItemsClass> itemList = new List<ItemsClass>();

            restroTable table = new restroTable();
            RoomBookingsInfo info = new RoomBookingsInfo();
            RestroRoom room = new RestroRoom();
            if (Id != 0)
            {
                itemList = rocobj.GetPreviousItemByID(Id);
                table = rocobj.GetTableNoBYId(Id);
            }
            else if (RId != 0)
            {
                itemList = rocobj.GetPreviousItemByRoomID(RId);
                room = rocobj.GetRoomNoBYId(RId);
            }
            else if (OID > 0)
            {
                itemList = rocobj.GetPreviousItemByOrderMasterId(OID);
                info = rocobj.getRoomBookingInfoByOrderMasterID(OID);
                table = rocobj.GetTableNoBYId(info.TableId);
            }
            if (itemList.Count > 0)
            {
                foreach (ItemsClass item in itemList)
                {
                    item.restrotableTitle = table.restrotableTitle;

                    if (String.IsNullOrEmpty(room.restroRoom))
                    {
                        room = rocobj.GetRoomByTable(item.TableId);
                    }
                    item.room = room.restroRoom;
                }
            }
            else
            {
                ItemsClass item = new ItemsClass();
                item.restrotableTitle = table.restrotableTitle;
                item.TableId = (Id > 0 ? Id : 0);
                item.TableId = (OID > 0 ? info.TableId : item.TableId);

                if (String.IsNullOrEmpty(room.restroRoom))
                {
                    if (Id > 0)
                    {
                        room = rocobj.GetRoomByTable(Id);
                    }
                    if (OID > 0)
                    {
                        room = rocobj.GetRoomByTable(info.TableId);
                        item.OrderMasterId = OID;
                    }
                }
                item.room = room.restroRoom;
                item.RoomId = RId;
                itemList.Add(item);
            }
            itemlists.AllOrders = itemList;
            itemlists.CompOrders = itemList.Where(p => p.ItemStatus == "Complete").ToList();
            itemlists.InPrgOrders = itemList.Where(p => p.ItemStatus == "InProgress").ToList();
            itemlists.OrderedOrders = itemList.Where(p => p.ItemStatus == "Ordered").ToList();
            return itemlists;
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public List<OrderExtraItem> GetOrderedExtraItemByOrderMaster(int orderMasterID)
    {
        RestrOrderController rocobj = new RestrOrderController();
        return rocobj.GetOrderedExtraItemByOrderMaster(orderMasterID).Where(p => p.ItemStatus == "Ordered").ToList();

    }

    [WebMethod]
    public string SaveOrderIntoDataBase(OrderMasterClass orderMasterInfo, List<OrderExtraItem> orderExtraItem)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            List<OrderDetailClass> orderDetailList = new List<OrderDetailClass>();
            orderDetailList = orderMasterInfo.OrderDetailsList;
            orderMasterInfo.Date = DateTime.Now;

            decimal BasicAmount = 0;
            string status = string.Empty;
            foreach (OrderDetailClass ord in orderDetailList)
            {
                List<ROInvItem> itemList = new List<ROInvItem>();
                if (ord.IsCombo)
                {
                    itemList = rocobj.getitemwithRateForCombo(ord.ItemId);
                }
                else
                {
                    itemList = rocobj.getitemwithRate(ord.ItemId);
                }
                BasicAmount += (Convert.ToDecimal(itemList[0].SRate) * Convert.ToDecimal(ord.Quantity));
            }

            RestroRoom room = new RestroRoom();
            if (orderMasterInfo.TableId != "0")
            {
                if (orderMasterInfo.RoomId == 0)
                {
                    if (orderMasterInfo.OID == 0)
                    {
                        if (orderMasterInfo.TableId != "0")
                        {
                            room = rocobj.GetRoomByTable(Convert.ToInt32(orderMasterInfo.TableId));
                        }
                        else
                        {
                            room = rocobj.getRestroRoomById(Convert.ToInt32(orderMasterInfo.RoomId));
                        }
                        orderMasterInfo.RoomId = room.restroRoomId;
                        orderMasterInfo.restroRoom = room.restroRoom;
                    }
                }
            }

            FiscalYear fyear = rocobj.GetRONumberByFiscalYear();
            orderMasterInfo.BillNo = "RO" + orderMasterInfo.Date.ToString().Replace("/", "").Replace("PM", "").Replace("AM", "").Replace(":", "").Replace(" ", "");
            orderMasterInfo.BasicAmount = BasicAmount;
            orderMasterInfo.Status = status;
            if (String.IsNullOrEmpty(orderMasterInfo.Remarks))
            {
                orderMasterInfo.Remarks = "Fine";
            }

            List<OrderDetailClass> orderInDatabase = rocobj.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID);

            List<OrderDetailClass> addedOrders = new List<OrderDetailClass>();
            List<OrderDetailClass> cancelledOrders = new List<OrderDetailClass>();
            if (orderInDatabase.Count > 0)
            {
                foreach (OrderDetailClass requestOrder in orderMasterInfo.OrderDetailsList)
                {
                    List<OrderDetailClass> prevOrders = orderInDatabase.Where(p => p.ItemId == requestOrder.ItemId && p.SeatNo == requestOrder.SeatNo && p.IsCombo == requestOrder.IsCombo && p.Status == "Ordered").ToList();
                    if (prevOrders.Count > 0)
                    {
                        if (requestOrder.Quantity > prevOrders.Sum(p => p.Quantity))
                        {
                            requestOrder.Quantity = requestOrder.Quantity - prevOrders.Sum(p => p.Quantity);
                            requestOrder.Note = requestOrder.Note.Substring(requestOrder.Note.LastIndexOf(';') + 1);
                            requestOrder.Status = "Ordered";
                            addedOrders.Add(requestOrder);
                        }
                        else if (requestOrder.Quantity < prevOrders.Sum(p => p.Quantity))
                        {
                            requestOrder.OrderDetailsID = 0;
                            requestOrder.Quantity = prevOrders.Sum(p => p.Quantity) - requestOrder.Quantity;
                            requestOrder.Status = "Ordered";
                            cancelledOrders.Add(requestOrder);
                        }
                    }
                    else // new order
                    {
                        //requestOrder.Quantity = requestOrder.Quantity - prevOrders.Sum(p => p.Quantity);
                        requestOrder.Status = "Ordered";
                        addedOrders.Add(requestOrder);
                    }
                }

                //List<OrderDetailClass> orderInDatabaseOrdered = orderInDatabase.Where(p => p.Status == "Ordered").ToList();
                //foreach (OrderDetailClass ord in orderInDatabaseOrdered)
                //{
                //    List<OrderDetailClass> newOrders = orderMasterInfo.OrderDetailsList.Where(p => p.ItemId == ord.ItemId && p.SeatNo == ord.SeatNo && p.IsCombo == ord.IsCombo).ToList();
                //    //if (newOrders.Count < 1)
                //    if (newOrders == null || newOrders.Count == 0)
                //    {
                //        cancelledOrders.Add(ord);
                //    }
                //}
            }
            else
            {
                foreach (OrderDetailClass ord in orderMasterInfo.OrderDetailsList)
                {
                    ord.Status = "Ordered";
                }
                addedOrders = orderMasterInfo.OrderDetailsList;
            }

            int ordermasterid = rocobj.SaveOrderIntoDataBase(orderMasterInfo, addedOrders, cancelledOrders);

            List<OrderExtraItem> addedExtra = CheckExtraItems(orderExtraItem, true, orderMasterInfo.OrderMasterID, ordermasterid);
            List<OrderExtraItem> removedExtra = CheckExtraItems(orderExtraItem, false, orderMasterInfo.OrderMasterID, ordermasterid);
            List<OrderDetailClass> toppingOnly = new List<OrderDetailClass>();
            rocobj.SaveExtraOrderedItem(addedExtra, removedExtra);

            string printSuccessful = ordermasterid.ToString();
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
                        topping.Note = orderInDatabase.Where(p => p.ItemId == ext.ItemID && p.SeatNo == ext.SeatNo && p.IsCombo == false).First().ROI_ItemName;
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
                        topping.Note = orderInDatabase.Where(p => p.ItemId == ext.ItemID && p.SeatNo == ext.SeatNo && p.IsCombo == false).First().ROI_ItemName;

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

                Token toke = rocobj.getOrderNobyOrderMasterId(Convert.ToInt32(orderMasterInfo.OrderMasterID));
                restroTable table = new restroTable();
                if (orderMasterInfo.TableId != "0")
                {
                    table = rocobj.GetTableNoBYId(Convert.ToInt32(orderMasterInfo.TableId));
                }

                OrderPrint print = new OrderPrint();
                if (orderMasterInfo.IsCancelled == true)
                {
                    status = "Cancelled";
                    printSuccessful += print.PrintOrders(orderMasterInfo.OrderDetailsList, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, "Cancelled", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                }
                else
                {
                    if (table.restrotableTitle == null)
                    {
                        status = "Pick Order";
                        printSuccessful += print.PrintOrders(addedOrders, "Take Away", orderMasterInfo.Date, orderMasterInfo.UserName, "Added", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                    }
                    else
                    {
                        if (addedOrders.Count > 0)
                        {
                            status = "Added";
                            printSuccessful += print.PrintOrders(addedOrders, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, "Added", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                        }

                        if (cancelledOrders.Count > 0)
                        {
                            status = "Cancelled";
                            printSuccessful += print.PrintOrders(cancelledOrders, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, "Cancelled", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                        }

                        if (toppingOnly.Count > 0)
                        {
                            PrintExtra(toppingOnly, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, 1, ordermasterid);
                        }
                    }
                }
            }

            return printSuccessful;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    protected List<OrderExtraItem> CheckExtraItems(List<OrderExtraItem> extra, bool added, int ordermasterid, int newOrdermasterid)
    {
        List<OrderExtraItem> newlist = new List<OrderExtraItem>();
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
        if (!added)
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
                List<OrderExtraItem> prevLists = rocobj.GetOrderedExtraItemByOrderMaster(ordermasterid).Where(p => p.ItemStatus == "Ordered").ToList();
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
        return newlist;
    }

    [WebMethod]
    public List<extraItem> GetItemExtraListByItemID(int ItemId)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();

            return rocobj.GetItemExtraListByItemID(ItemId);
        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public List<extraItem> GetItemExtraList()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetExtraItemList().Where(p => p.IsActive = true).ToList();
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public void CancelOrderIntoDataBase(OrderMasterClass orderMasterInfo)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            List<OrderDetailClass> orderList = rocobj.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID).Where(p => p.Status == "Ordered" && p.SeatNo == orderMasterInfo.GuestNo).ToList();
            rocobj.CancelOrder(orderMasterInfo);
            restroTable table = rocobj.GetTableNoBYId(Convert.ToInt32(orderMasterInfo.TableId));
            Token toke = rocobj.getOrderNobyOrderMasterId(Convert.ToInt32(orderMasterInfo.OrderMasterID));
            if (System.Configuration.ConfigurationManager.AppSettings["OrderPrinting"] == "true")
            {
                OrderPrint print = new OrderPrint();
                print.PrintOrders(orderList, table.restrotableTitle == null ? "Table" : table.restrotableTitle, DateTime.Now, orderMasterInfo.UserName, "Cancelled", orderMasterInfo.OrderMasterID, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
            }

            List<OrderDetailCancel> CancelItems = new List<OrderDetailCancel>();
            foreach (OrderDetailClass ord in orderList)
            {
                OrderDetailCancel cancelItm = new OrderDetailCancel();

                cancelItm.Item = ord.ROI_ItemName;
                cancelItm.Quantity = ord.Quantity;
                cancelItm.Reason = orderMasterInfo.CancelReason;
                cancelItm.Responsible = "Customer";
                cancelItm.CanceledBy = orderMasterInfo.CancelBy;
                cancelItm.OrderBy = orderMasterInfo.UserName;
                cancelItm.tableId = table.restrotableId;

                CancelItems.Add(cancelItm);
            }
            rocobj.SaveCanceledItems(CancelItems);
        }
        catch (Exception)
        {
            throw;
        }

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

    [WebMethod]
    public List<CategoriesClass> txtSearchForItem(string ItemName, int languageid)
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.txtSearchForItem(ItemName, languageid);
    }

    [WebMethod]
    public List<purchaseDetails> GetItemForSearch()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            return roc.GetItemForSearch();
        }
        catch (Exception)
        {
            throw;
        }
    }

    [WebMethod]
    public List<companyInfo> GetCompanyInfoLogo()
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.getcompanyInfo();
    }
}
