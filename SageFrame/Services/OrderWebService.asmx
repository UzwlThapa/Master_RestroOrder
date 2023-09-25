 <%@ WebService Language="C#" Class="OrderWebService"  %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using System.Web.Script.Serialization;
using System.Linq;
using System.Collections.Generic;
using SageFrame.CostCenter;
using SageFrame.RestoLoyalty;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class OrderWebService : System.Web.Services.WebService
{

    JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
    RestrOrderController roController = new RestrOrderController();
    RestoLoyaltyController rlController = new RestoLoyaltyController();

    [WebMethod]
    public string GetCompanyInfoLogo()
    {
        return jsSerializer.Serialize(roController.getcompanyInfo().FirstOrDefault());
    }
    [WebMethod]
    public string GetItemForSearch()
    {
        return jsSerializer.Serialize(roController.GetItemForSearch());
    }
    [WebMethod]
    public string GetMenuforOrder()
    {
        return jsSerializer.Serialize(roController.GetMenuFromDatabase());
    }
    [WebMethod]
    public string GetCategoriesBymenuID(int MenuId, int languageid)
    {
        return jsSerializer.Serialize(roController.GetCategoriesBymenuID(MenuId, languageid));
    }
    [WebMethod]
    public string GetItemByCategoryID(int CategoriesID, int LanguageID)
    {
        return jsSerializer.Serialize(roController.GetItemByCategoryID(CategoriesID, LanguageID));
    }
    [WebMethod]
    public string getitemforcumbo()
    {
        return jsSerializer.Serialize(roController.getcumbolist(true));
    }
    [WebMethod]
    public string GetExtraItemsByItem()
    {
        return jsSerializer.Serialize(roController.getExtraItemforItem().Where(p => p.IsActive == true && p.IsDeleted == false).ToList());
    }
    [WebMethod]
    public string CheckPinCodeMatch(string PinCode,string username)
    {
        return jsSerializer.Serialize(roController.CheckPinCodeMatch(PinCode,username));
    }
    [WebMethod]
    public void SaveCanceledItems(List<OrderDetailCancel> CancelItems)
    {
        roController.SaveCanceledItems(CancelItems);
    }
    [WebMethod]
    public string SaveOrderIntoDataBase(OrderMasterClass orderMasterInfo, List<OrderExtraItem> orderExtraItem, bool foodCourtOrder)
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
                    //ord.orderExtraItem = orderExtraItem.Where(p => p.ItemID == ord.ItemId).ToList();


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
                orderMasterInfo.Remarks = "Fine";

            List<OrderDetailClass> lst = new List<OrderDetailClass>();
            lst = rocobj.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID);

            //rocobj.DeleteOrderDetailByMaster(orderMasterInfo.OrderMasterID, orderMasterInfo.ArchivedBy);
            List<OrderDetailClass> addedOrders = new List<OrderDetailClass>();
            List<OrderDetailClass> cancelledOrders = new List<OrderDetailClass>();
            if (lst.Count > 0)
            {
                foreach (OrderDetailClass ord in orderMasterInfo.OrderDetailsList)
                {
                    List<OrderDetailClass> prevOrders = lst.Where(p => p.ItemId == ord.ItemId && p.SeatNo == ord.SeatNo && p.IsCombo == ord.IsCombo && p.Status == "Ordered").ToList();
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
                    List<OrderDetailClass> newOrders = orderMasterInfo.OrderDetailsList.Where(p => p.ItemId == ord.ItemId && p.SeatNo == ord.SeatNo && p.IsCombo == ord.IsCombo).ToList();
                    if (newOrders.Count < 1)
                    {
                        cancelledOrders.Add(ord);
                    }
                }
            }
            else
            {
                foreach (OrderDetailClass ord in orderMasterInfo.OrderDetailsList)
                {
                    ord.Status = "Ordered";
                }
                addedOrders = orderMasterInfo.OrderDetailsList;
            }

            //List<OrderDetailClass> orderList = rocobj.OrderMasterSaveTodatabase(orderMasterInfo, repeateditem);
            int ordermasterid = rocobj.SaveOrderIntoDataBase(orderMasterInfo, addedOrders, cancelledOrders);

            List<OrderExtraItem> addedExtra = CheckExtraItems(orderExtraItem, true, orderMasterInfo.OrderMasterID, ordermasterid);
            List<OrderExtraItem> removedExtra = CheckExtraItems(orderExtraItem, false, orderMasterInfo.OrderMasterID, ordermasterid);
            List<OrderDetailClass> toppingOnly = new List<OrderDetailClass>();
            rocobj.SaveExtraOrderedItem(addedExtra, removedExtra);
            string printSuccessful = ordermasterid.ToString();

            bool printCall;
            if (foodCourtOrder)
            {
                printCall = System.Configuration.ConfigurationManager.AppSettings["FoodCourtOrderPrinting"] == "true" ? true : false;
            }
            else
            {
                printCall = System.Configuration.ConfigurationManager.AppSettings["OrderPrinting"] == "true" ? true : false;
            }
            if (printCall)
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
                restroTable table = new restroTable();
                if (orderMasterInfo.TableId != "0")
                {

                    table = rocobj.GetTableNoBYId(Convert.ToInt32(orderMasterInfo.TableId));
                }

                Token toke = new Token();
                toke = rocobj.getOrderNobyOrderMasterId(ordermasterid);

                OrderPrint print = new OrderPrint();
                if (orderMasterInfo.IsCancelled == true)
                {
                    status = "Cancelled";
                    //printSuccessful += print.PrintOrders(orderMasterInfo.OrderDetailsList, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, "Cancelled", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                    printSuccessful += print.PrintOrders(orderMasterInfo.OrderDetailsList, orderMasterInfo.OrderTypeID == 4 ? "FoodDelivery" : (orderMasterInfo.OrderTypeID == 3 ? "FoodCourt" : (orderMasterInfo.OrderTypeID == 2 ? "Take Away" : table.restrotableTitle)), orderMasterInfo.Date, orderMasterInfo.UserName, "Cancelled", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                }
                else
                {
                    //if (table.restrotableTitle == null)
                    //{
                    //    status = "Pick Order";
                    //    // printSuccessful += print.PrintOrders(addedOrders, "Take Away", orderMasterInfo.Date, orderMasterInfo.UserName, "Added", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                    //    printSuccessful += print.PrintOrders(addedOrders, orderMasterInfo.OrderTypeID  == 4 ? "FoodDelivery" : (orderMasterInfo.OrderTypeID  == 3 ? "FoodCourt" : (orderMasterInfo.OrderTypeID == 2 ? "Take Away" : table.restrotableTitle)), orderMasterInfo.Date, orderMasterInfo.UserName, "Added", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                    //}
                    //else
                    //{
                    if (addedOrders.Count > 0)
                    {
                        status = "Added";
                        // printSuccessful += print.PrintOrders(addedOrders, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, "Added", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                        printSuccessful += print.PrintOrders(addedOrders, orderMasterInfo.OrderTypeID == 4 ? "FoodDelivery" : (orderMasterInfo.OrderTypeID == 3 ? "FoodCourt" : (orderMasterInfo.OrderTypeID == 2 ? "TakeAway" : table.restrotableTitle)), orderMasterInfo.Date, orderMasterInfo.UserName, "Added", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                    }
                    if (cancelledOrders.Count > 0)
                    {
                        status = "Cancelled";
                        // printSuccessful += print.PrintOrders(cancelledOrders, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, "Cancelled", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                        printSuccessful += print.PrintOrders(cancelledOrders, orderMasterInfo.OrderTypeID == 4 ? "FoodDelivery" : (orderMasterInfo.OrderTypeID == 3 ? "FoodCourt" : (orderMasterInfo.OrderTypeID == 2 ? "Take Away" : table.restrotableTitle)), orderMasterInfo.Date, orderMasterInfo.UserName, "Cancelled", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                    }
                    if (toppingOnly.Count > 0)
                    {
                        // PrintExtra(toppingOnly, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, 1, ordermasterid);
                        PrintExtra(toppingOnly, orderMasterInfo.OrderTypeID == 4 ? "FoodDelivery" : (orderMasterInfo.OrderTypeID == 3 ? "FoodCourt" : (orderMasterInfo.OrderTypeID == 2 ? "Take Away" : table.restrotableTitle)), orderMasterInfo.Date, orderMasterInfo.UserName, 1, ordermasterid);
                    }
                    //}
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
    public string GetDataForSalesBill(int orderMasterId)
    {
        try
        {
            SalesBill salesBill = new SalesBill();
            companyInfo compInf = roController.getcompanyInfo().FirstOrDefault();
            salesBill.orderDetail = roController.getOrderDetailByOrderMasterId(orderMasterId);
            List<OrderExtraItem> extra = roController.GetAllExtraItemByOrderMaster(orderMasterId);
            foreach (OrderDetailClass ord in salesBill.orderDetail)
            {
                if (!ord.IsCombo)
                {
                    ord.orderExtraItem = extra.Where(p => p.ItemID == ord.ROI_ItemId).ToList();
                }
            }
            salesBill.billingTerm = roController.getActiveBILLTERM();

            //if (System.Configuration.ConfigurationManager.AppSettings["ServChargeInTakeAway"] == "false")
            //{
            //  salesBill.billingTerm.RemoveAll(p => p.BillTerm == "Service Charge");
            //}
            salesBill.cuscenter = roController.getdiscountfromcostcenter();
            salesBill.RoomBooking = roController.getRoomBookingInfoByOrderMasterID(orderMasterId);
            salesBill.VATforBill = (compInf.IsPan ? false : true);
            salesBill.Token = roController.getOrderTokenByOrderMasterId(orderMasterId);
            salesBill.costCenterGroups = roController.GetCostCenterGroup();
            return jsSerializer.Serialize(salesBill);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
        [WebMethod]
    public string GetDataForPOSSalesBill(int orderMasterId)
    {
        try
        {
            SalesBill salesBill = new SalesBill();
            companyInfo compInf = roController.getcompanyInfo().FirstOrDefault();
            salesBill.orderDetail = roController.getOrderDetailByOrderMasterId(orderMasterId);
            List<OrderExtraItem> extra = roController.GetAllExtraItemByOrderMaster(orderMasterId);
            foreach (OrderDetailClass ord in salesBill.orderDetail)
            {
                if (!ord.IsCombo)
                {
                    ord.orderExtraItem = extra.Where(p => p.ItemID == ord.ROI_ItemId).ToList();
                }
            }
            salesBill.billingTerm = roController.getActiveBILLTERM();

            //if (System.Configuration.ConfigurationManager.AppSettings["ServChargeInTakeAway"] == "false")
            //{
            //  salesBill.billingTerm.RemoveAll(p => p.BillTerm == "Service Charge");
            //}
            salesBill.cuscenter = roController.getdiscountfromcostcenter();
            salesBill.RoomBooking = roController.getRoomBookingInfoByOrderMasterID(orderMasterId);
            salesBill.VATforBill = (compInf.IsPan ? false : true);
            salesBill.Token = roController.getOrderTokenByOrderMasterId(orderMasterId);
            salesBill.costCenterGroups = roController.GetPOSCostCenterGroup();
            return jsSerializer.Serialize(salesBill);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public string GetCustomerDatas(int customer)
    {
        return jsSerializer.Serialize(rlController.getmembershiplist(customer));

    }
    [WebMethod]
    public int SaveSalesBill(SalesMaster salesMaster, List<SalesDetails> salesDetail, int splited, List<customerBilling> billingTerm, flatorperdiscount flatorperdiscount)
    {
        int salesMasterId = roController.saveSalesBill(salesMaster, salesDetail, splited, billingTerm, flatorperdiscount);

        CBMS cbms = new CBMS();
        cbms.sendSales(salesMasterId);
        return salesMasterId;
    }
    [WebMethod]
    public string savePrintCount(int Printcount, string BillNo, string PrintedBy)
    {
        if (BillNo != "")
        {
            return roController.SavePrintCountDetail(Printcount, BillNo, PrintedBy);
        }
        return "";

    }
    [WebMethod]
    public void CancelOrderIntoDataBase(OrderMasterClass orderMasterInfo)
    {
        try
        {
            List<OrderDetailClass> orderList = roController.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID).Where(p => p.Status == "Ordered" && p.SeatNo == orderMasterInfo.GuestNo).ToList();
            roController.CancelOrder(orderMasterInfo);
            restroTable table = roController.GetTableNoBYId(Convert.ToInt32(orderMasterInfo.TableId));
            Token toke = roController.getOrderNobyOrderMasterId(Convert.ToInt32(orderMasterInfo.OrderMasterID));
            if (System.Configuration.ConfigurationManager.AppSettings["OrderPrinting"] == "true")
            {
                OrderPrint print = new OrderPrint();
                print.PrintOrders(orderList, table.restrotableTitle == null ? "Table" : table.restrotableTitle, DateTime.Now, orderMasterInfo.UserName, "Cancelled", orderMasterInfo.OrderMasterID, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
            }

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
            roController.SaveCanceledItems(CancelItems);
        }
        catch (Exception)
        {
            throw;
        }

    }
    [WebMethod]
    public string txtSearchForItem(string ItemName, int languageid)
    {
        return jsSerializer.Serialize(roController.txtSearchForItem(ItemName, languageid));
    }
    public class ItemsList
    {
        public List<ItemsClass> CompOrders { get; set; }
        public List<ItemsClass> InPrgOrders { get; set; }
        public List<ItemsClass> OrderedOrders { get; set; }
        public List<ItemsClass> AllOrders { get; set; }
        public List<OrderExtraItem> orderedExtraItems { get; set; }
    }
    [WebMethod]
    public ItemsList GetPreviousItemByID(int Id, int OID)
    {
        try
        {
            ItemsList itemlists = new ItemsList();
            List<ItemsClass> itemList = new List<ItemsClass>();

            restroTable table = new restroTable();
            RoomBookingsInfo info = new RoomBookingsInfo();
            RestroRoom room = new RestroRoom();
            if (Id != 0)
            {
                itemList = roController.GetPreviousItemByID(Id);
                table = roController.GetTableNoBYId(Id);
            }
            else if (OID > 0)
            {
                itemList = roController.GetPreviousItemByOrderMasterId(OID);
                info = roController.getRoomBookingInfoByOrderMasterID(OID);
                table = roController.GetTableNoBYId(info.TableId);
            }
            if (itemList.Count > 0)
            {
                foreach (ItemsClass item in itemList)
                {
                    item.restrotableTitle = (table != null ? table.restrotableTitle : "Take Away");

                    if (room != null)
                    {
                        if (String.IsNullOrEmpty(room.restroRoom))
                        {
                            room = roController.GetRoomByTable(item.TableId);
                        }
                    }
                    item.room = (room != null ? room.restroRoom : "");
                }
            }
            else
            {
                ItemsClass item = new ItemsClass();
                item.restrotableTitle = (table != null ? table.restrotableTitle : "Take Away");
                item.TableId = (Id > 0 ? Id : 0);
                item.TableId = (OID > 0 ? (info != null ? info.TableId : 0) : item.TableId);

                if (String.IsNullOrEmpty(room.restroRoom))
                {
                    if (Id > 0)
                    {
                        room = roController.GetRoomByTable(Id);
                    }
                    if (OID > 0)
                    {
                        room = roController.GetRoomByTable((info != null ? info.TableId : 0));
                        item.OrderMasterId = OID;
                    }
                }
                item.room = (room != null ? room.restroRoom : "");
                itemList.Add(item);
            }
            itemlists.AllOrders = itemList;
            itemlists.CompOrders = itemList.Where(p => p.ItemStatus == "Complete").ToList();
            itemlists.InPrgOrders = itemList.Where(p => p.ItemStatus == "InProgress").ToList();
            itemlists.OrderedOrders = itemList.Where(p => p.ItemStatus == "Ordered").ToList();
            //itemlists.orderedExtraItems = new List<OrderExtraItem>();
            List<OrderExtraItem> extraList = roController.GetOrderedExtraItemByOrderMaster(itemList[0].OrderMasterId).Where(p => p.ItemStatus == "Ordered").ToList();
            itemlists.orderedExtraItems = extraList;
            return itemlists;
        }
        catch (Exception)
        {
            throw;
        }

    }
    [WebMethod]
    public string SaveFoodCourtSalesBillWithPayment(SalesMaster salesMaster, List<SalesDetails> salesDetail, int splited, List<customerBilling> billingTerm, flatorperdiscount flatorperdiscount,List<SalesPayment> salesPaymentList)
    {
        try
        {
            int salesMasterId = roController.saveSalesBill(salesMaster, salesDetail, splited, billingTerm, flatorperdiscount);

            foreach(SalesPayment sp in salesPaymentList)
            {
                sp.salesMasterId = salesMasterId;
            }

            roController.UpdateSalesPayMode(salesPaymentList);

            CBMS cbmsObj = new CBMS();
            cbmsObj.sendSales(salesMasterId);
            return JsonConvert.SerializeObject(salesMasterId);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
        [WebMethod]
    public string SaveFoodCourtSalesPOSBillWithPayment(SalesMaster salesMaster, List<SalesDetails> salesDetail, int splited, List<customerBilling> billingTerm, flatorperdiscount flatorperdiscount,List<SalesPayment> salesPaymentList)
    {
        try
        {
            int salesMasterId = roController.savePOSSalesBill(salesMaster, salesDetail, splited, billingTerm, flatorperdiscount);

            foreach(SalesPayment sp in salesPaymentList)
            {
                sp.salesMasterId = salesMasterId;
            }

            roController.UpdateSalesPayMode(salesPaymentList);

            CBMS cbmsObj = new CBMS();
            cbmsObj.sendSales(salesMasterId);
            return JsonConvert.SerializeObject(salesMasterId);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public int SaveFoodCourtSalesBill(SalesMaster salesMaster, List<SalesDetails> salesDetail, int splited, List<customerBilling> billingTerm, flatorperdiscount flatorperdiscount, SalesPayment payment)
    {
        try
        {
            int salesMasterId = roController.saveSalesBill(salesMaster, salesDetail, splited, billingTerm, flatorperdiscount);

            payment.salesMasterId = salesMasterId;
            roController.UpdateSalesPayMode(payment);

            CBMS cbmsObj = new CBMS();
            cbmsObj.sendSales(salesMasterId);

            return salesMasterId;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public string GetProviderList()
    {
        return jsSerializer.Serialize(roController.getCardProvider());
    }
    [WebMethod]
    public string IsFoodCourtAutoBilling()
    {
        return roController.IsFoodCourtAutoBilling();
    }
    [WebMethod]
    public string GetPaymentModesAndProviders(int salesMasterId)
    {
        return jsSerializer.Serialize(roController.GetPaymentModesAndProviders(salesMasterId));
    }        
    [WebMethod]
    public void SavePayment(List<SalesPayment> salesPaymentList)
    {
        roController.UpdateSalesPayMode(salesPaymentList);

    }


    [WebMethod]
    public string getMemberDetailsbyinfo(string info)
    {
        return jsSerializer.Serialize(rlController.getMemberDetailsbyinfo(info));

    }
    [WebMethod]
    public string getLanguage()
    {
        RestrOrderController roc = new RestrOrderController();
        List<LanguageMenu> list = roc.getLanguage();
        return JsonConvert.SerializeObject(list);
    }

    [WebMethod]
    public string getGlobalizedMenu(int languageid)
    {
        RestrOrderController roc = new RestrOrderController();
        List<MenuClass> itemlist = roc.getGlobalizedMenu(languageid);
        return JsonConvert.SerializeObject(itemlist);
    }

    [WebMethod]
    public string getmembershiplistbyId(int memberid)
    {
        List<MemberInfo> memberlist = rlController.getmembershiplistbyId(memberid);
        return JsonConvert.SerializeObject(memberlist);
    }
    [WebMethod]
    public string GetSalesMasterDtll(int salesMasterId)
    {
        return jsSerializer.Serialize(roController.GetSalesMasterDtll(salesMasterId));
    }
}