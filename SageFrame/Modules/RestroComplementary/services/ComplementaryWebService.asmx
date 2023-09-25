<%@ WebService Language="C#" Class="ComplementaryWebService" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using SageFrame.CostCenter;
using SageFrame.RestoLoyalty;
using Newtonsoft.Json;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ComplementaryWebService  : System.Web.Services.WebService
{

    public ComplementaryWebService()
    {
        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
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
    public SalesBill GetDataForSalesBill(int CompMasterID)
    {
        try
        {
            SalesBill salesBill = new SalesBill();
            RestrOrderController roc = new RestrOrderController();
            salesBill.orderDetail = roc.GetCompDetailsByMaster(CompMasterID);
            List<OrderExtraItem> extra = roc.GetOrderedExtraItemByCompMaster(CompMasterID);
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
            // salesBill.RoomBooking = roc.getRoomBookingInfoByOrderMasterID(orderMasterId);
            salesBill.VATforBill = (System.Configuration.ConfigurationManager.AppSettings["VATforBill"] == "true" ? true : false);
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
    public string CheckPinCodeMatch(string PinCode,string username)
    {
        RestrOrderController controller = new RestrOrderController();
        return JsonConvert.SerializeObject(controller.CheckPinCodeMatch(PinCode,username));

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
        return rocobj.GetOrderedExtraItemByOrderMaster(orderMasterID);

    }

    [WebMethod]
    public int SaveOrderIntoDataBase(OrderMasterClass orderMasterInfo, List<OrderExtraItem> orderExtraItem)
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
                orderMasterInfo.Remarks = "Fine";

            List<OrderDetailClass> lst = new List<OrderDetailClass>();
            lst = rocobj.GetCompDetailsByMaster(orderMasterInfo.CompMasterID);

            List<OrderDetailClass> addedOrders = new List<OrderDetailClass>();
            List<OrderDetailClass> cancelledOrders = new List<OrderDetailClass>();
            if (lst.Count > 0)
            {
                foreach (OrderDetailClass ord in orderMasterInfo.OrderDetailsList)
                {
                    List<OrderDetailClass> prevOrders = lst.Where(p => p.ItemId == ord.ItemId && p.IsCombo == ord.IsCombo && p.Status == "Ordered").ToList();
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
                    List<OrderDetailClass> newOrders = orderMasterInfo.OrderDetailsList.Where(p => p.ItemId == ord.ItemId && p.IsCombo == ord.IsCombo).ToList();
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
            int CompId = rocobj.CompMasterSaveTodatabase(orderMasterInfo, addedOrders, cancelledOrders);

            List<OrderExtraItem> addedExtra = CheckExtraItems(orderExtraItem, true, orderMasterInfo.CompMasterID, CompId);
            List<OrderExtraItem> removedExtra = CheckExtraItems(orderExtraItem, false, orderMasterInfo.CompMasterID, CompId);
            List<OrderDetailClass> toppingOnly = new List<OrderDetailClass>();
            rocobj.SaveExtraCompItem(addedExtra, removedExtra);

            bool printCall;
            printCall = System.Configuration.ConfigurationManager.AppSettings["OrderPrinting"] == "true" ? true : false;

            if (printCall)
            {
                foreach (OrderExtraItem ext in addedExtra)
                {
                    List<OrderDetailClass> ord = addedOrders.Where(p => p.ItemId == ext.ItemID && p.IsCombo == false).ToList();
                    if (ord.Count == 0)
                    {
                        OrderDetailClass topping = new OrderDetailClass();
                        topping.ItemName = ext.ExtraItem;
                        topping.Quantity = ext.Quantity;
                        topping.Note = lst.Where(p => p.ItemId == ext.ItemID && p.IsCombo == false).First().ROI_ItemName;

                        toppingOnly.Add(topping);
                    }
                }
                foreach (OrderExtraItem ext in removedExtra)
                {
                    List<OrderDetailClass> ord = cancelledOrders.Where(p => p.ItemId == ext.ItemID && p.IsCombo == false).ToList();
                    if (ord.Count == 0)
                    {
                        OrderDetailClass topping = new OrderDetailClass();
                        topping.ItemName = ext.ExtraItem;
                        topping.Quantity = (-ext.Quantity);
                        topping.Note = lst.Where(p => p.ItemId == ext.ItemID && p.IsCombo == false).First().ROI_ItemName;

                        toppingOnly.Add(topping);
                    }
                }
                foreach (OrderDetailClass ord in addedOrders)
                {
                    List<OrderExtraItem> ext = addedExtra.Where(p => p.ItemID == ord.ItemId && ord.IsCombo == false).ToList();
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
                    List<OrderExtraItem> ext = removedExtra.Where(p => p.ItemID == ord.ItemId && ord.IsCombo == false).ToList();
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
                if (orderMasterInfo.IsCancelled == true)
                {
                    status = "Cancelled";

                    GetDataForPrint(orderMasterInfo.OrderDetailsList, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, 2, CompId);
                }
                else
                {
                    if (table.restrotableTitle == null)
                    {
                        status = "Pick Order";
                        GetDataForPrint(addedOrders, "Take Away", orderMasterInfo.Date, orderMasterInfo.UserName, orderMasterInfo.OrderMasterID, CompId);
                    }
                    else
                    {
                        if (addedOrders.Count > 0)
                        {
                            status = "Added";
                            GetDataForPrint(addedOrders, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, orderMasterInfo.OrderStatus, CompId);
                        }
                        if (cancelledOrders.Count > 0)
                        {
                            status = "Cancelled";
                            return GetDataForPrint(cancelledOrders, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, 1, CompId);
                        }
                        if (toppingOnly.Count > 0)
                        {
                            PrintExtra(toppingOnly, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, 1, CompId);
                        }
                    }
                }
            }
            return CompId;

        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

    protected List<OrderExtraItem> CheckExtraItems(List<OrderExtraItem> extra, bool added, int CompMasterID, int newCompMasterID)
    {
        List<OrderExtraItem> newlist = new List<OrderExtraItem>();
        if (added && extra.Count > 0)
        {
            RestrOrderController rocobj = new RestrOrderController();
            foreach (OrderExtraItem ext in extra)
            {
                List<OrderExtraItem> prevList = rocobj.GetOrderedExtraItemByCompMaster(CompMasterID).Where(p => p.ItemID == ext.ItemID && p.ExtraItemID == ext.ExtraItemID).ToList();
                int prevQnty = (prevList.Count > 0 ? prevList.FirstOrDefault().Quantity : 0);
                if (ext.Quantity > prevQnty)
                {
                    OrderExtraItem itm = new OrderExtraItem();
                    itm.ItemID = ext.ItemID;
                    itm.CompMasterID = newCompMasterID;
                    itm.Quantity = ext.Quantity - prevQnty;
                    itm.ExtraPrice = ext.ExtraPrice;
                    itm.ExtraItemID = ext.ExtraItemID;
                    itm.ExtraItem = ext.ExtraItem;
                    newlist.Add(itm);
                }
            }
        }
        if (!added)
        {
            if (CompMasterID > 0)
            {
                RestrOrderController rocobj = new RestrOrderController();
                foreach (OrderExtraItem ext in extra)
                {
                    List<OrderExtraItem> prevList = rocobj.GetOrderedExtraItemByCompMaster(CompMasterID).Where(p => p.ItemID == ext.ItemID && p.ExtraItemID == ext.ExtraItemID).ToList();
                    int prevQnty = (prevList.Count > 0 ? prevList.FirstOrDefault().Quantity : 0);
                    if (ext.Quantity < prevQnty)
                    {
                        OrderExtraItem itm = new OrderExtraItem();
                        itm.ItemID = ext.ItemID;
                        itm.OrderMasterId = newCompMasterID;
                        itm.Quantity = prevQnty - ext.Quantity;
                        itm.ExtraPrice = ext.ExtraPrice;
                        itm.ExtraItemID = ext.ExtraItemID;
                        itm.ExtraItem = ext.ExtraItem;

                        newlist.Add(itm);
                    }
                }
                List<OrderExtraItem> prevLists = rocobj.GetOrderedExtraItemByCompMaster(CompMasterID).ToList();
                foreach (OrderExtraItem ext in prevLists)
                {
                    List<OrderExtraItem> newList = extra.Where(p => p.ItemID == ext.ItemID && p.ExtraItemID == ext.ExtraItemID).ToList();
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
            List<OrderDetailClass> orderList = rocobj.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID);
            rocobj.CancelOrder(orderMasterInfo);
            restroTable table = rocobj.GetTableNoBYId(Convert.ToInt32(orderMasterInfo.TableId));
            // GetDataForPrint(orderList, table.restrotableTitle == null ? "Table" : table.restrotableTitle, DateTime.Now, "Superuser", 2, orderMasterInfo.OrderMasterID);

        }
        catch (Exception)
        {
            throw;
        }

    }




    public int GetDataForPrint(List<OrderDetailClass> orderDetailList, string tableId, DateTime time, string userName, int OrderStatus, int CompMasterID)
    {
        RestrOrderController rocobj = new RestrOrderController();
        CostCenterController coc = new CostCenterController();
        List<OrderDetailClass> orderForKitchen = new List<OrderDetailClass>();
        List<OrderDetailClass> OrderForBar = new List<OrderDetailClass>();
        List<OrderDetailClass> OrderForBakery = new List<OrderDetailClass>();
        foreach (OrderDetailClass orderDetail in orderDetailList)
        {
            orderDetail.CompMasterID = CompMasterID;
            int itemID = (orderDetail.ItemId == 0 ? orderDetail.ROI_ItemId : orderDetail.ItemId);
            if (itemID == -1)
            {
                itemID = orderDetail.ROI_ItemId;
            }
            ROInvItem item = rocobj.GetItemDetail(itemID, orderDetail.IsCombo);
            orderDetail.ItemName = item.ITName;
            orderDetail.CostCenterId = item.ItemCostCentreID;
            if (orderDetail.CostCenterId == 1)
            {
                orderForKitchen.Add(orderDetail);
            }
            else if (orderDetail.CostCenterId == 2)
            {
                OrderForBar.Add(orderDetail);
            }
            else
            {
                OrderForBakery.Add(orderDetail);
            }

        }


        KOT kot = new KOT();
        kot.CompMasterID = CompMasterID;
        kot.TableId = tableId;
        kot.Date = time.ToShortDateString();
        kot.Time = time.ToShortTimeString();
        kot.Waiter = userName;
        kot.Customer = "";
        Printer print = new Printer();


        if (OrderStatus == 0)
        {
            kot.Status = "Added";
        }
        else if (OrderStatus == 2)
        {
            kot.Status = "Cancelled";
        }
        else if (OrderStatus == 1)
        {
            kot.Status = "Running";
        }
        try
        {
            if (orderForKitchen.Count > 0)
            {
                kot.KOTItems = orderForKitchen;
                kot.CostCenterTitle = "Kitchen Order";
                CostCenterInfo ccInfo = coc.GetCostCenterById(1);
                print.PrintKOT(ccInfo.DefaultPrinter, kot);
            }
            if (OrderForBar.Count > 0)
            {
                kot.KOTItems = OrderForBar;
                kot.CostCenterTitle = "Bar Order";
                CostCenterInfo ccInfo1 = coc.GetCostCenterById(2);
                print.PrintKOT(ccInfo1.DefaultPrinter, kot);
            }
            if (OrderForBakery.Count > 0)
            {
                kot.KOTItems = OrderForBakery;
                kot.CostCenterTitle = "Bakery Order";
                CostCenterInfo ccInfo2 = coc.GetCostCenterById(95);
                print.PrintKOT(ccInfo2.DefaultPrinter, kot);
            }
            return CompMasterID;
        }
        catch (Exception)
        {
            return CompMasterID;
        }
    }


    public int PrintExtra(List<OrderDetailClass> orderDetailList, string tableId, DateTime time, string userName, int OrderStatus, int CompMasterID)
    {
        CostCenterController coc = new CostCenterController();
        Printer print = new Printer();
        KOT kot = new KOT();
        kot.CompMasterID = CompMasterID;
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
            return CompMasterID;
        }
        catch (Exception)
        {
            return CompMasterID;
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

    [WebMethod]
    public List<RoomType> getRoomType()
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.getRoomType();
    }

    [WebMethod]
    public List<RestroRoom> GetRoomByRestroTypeId(int RoomTypeID)
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.GetRoomByRestroTypeId(RoomTypeID);
    }

    [WebMethod]

    public string getComplementsalesreport(DateTime Start, DateTime EndDate, int tableid, int roomid, string itemname)
    {
        RestrOrderController rc = new RestrOrderController();
        List<itemsales> salesreport = rc.getComplementsalesreport(Start, EndDate, tableid, roomid, itemname);
        return JsonConvert.SerializeObject(salesreport);
    }


    [WebMethod]
    public string getRestroRoom()
    {

        RestrOrderController roc = new RestrOrderController();
        List<RestroRoom> room = roc.getRestroRoom();
        return JsonConvert.SerializeObject(room);
    }

    [WebMethod]
    public string getRestroTable()
    {
        RestrOrderController roc = new RestrOrderController();
        List<restroTable> table = roc.getRestroTable();
        return JsonConvert.SerializeObject(table);

    }

    [WebMethod]
    public string getRestroTableByRoomID(int restroRoomId)
    {
        RestrOrderController roc = new RestrOrderController();
        List<restroTable>  restroTable = roc.getRestroTableByRoomID(restroRoomId);
        return JsonConvert.SerializeObject(restroTable);
    }

    [WebMethod]
    public string getCompanyInfo()
    {
        RestrOrderController roc = new RestrOrderController();
        List<companyInfo> company = roc.getcompanyInfo();
        return JsonConvert.SerializeObject(company.FirstOrDefault());

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

}