<%@ WebService Language="C#" Class="WholeSaleWebService" %>

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
using SageFrame.CakeOrder;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WholeSaleWebService : System.Web.Services.WebService
{

    JavaScriptSerializer jsSerializer = new JavaScriptSerializer();
    RestrOrderController roController = new RestrOrderController();
    RestoLoyaltyController rlController = new RestoLoyaltyController();
    CakeOrderController cocobj = new CakeOrderController();

    [WebMethod]
    public string GetCompanyInfoLogo()
    {
        return jsSerializer.Serialize(roController.getcompanyInfo().FirstOrDefault());
    }
    [WebMethod]
    public string GetItemForWholeSaleSearch(string LookUpName)
    {
        List<MvPurchaseDetails> list = roController.GetItemForWholeSaleSearch(LookUpName);
        return jsSerializer.Serialize(list);
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
    public string CheckPinCodeMatch(string PinCode)
    {
        return jsSerializer.Serialize(roController.CheckPinCodeMatch(PinCode,"superuser"));
    }
    [WebMethod]
    public void SaveCanceledItems(List<OrderDetailCancel> CancelItems)
    {
        roController.SaveCanceledItems(CancelItems);
    }
    [WebMethod]
    public string SaveWholeOrderIntoDataBase(CakeOrderMaster cakeOrderMasterInfo, List<OrderExtraItems> orderExtraItems, bool wholesaleorder)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            CakeOrderController cor = new CakeOrderController();
            List<CakeOrderList> cakeOrderDetailList = new List<CakeOrderList>();
            cakeOrderDetailList = cakeOrderMasterInfo.CakeOrderList;
            cakeOrderMasterInfo.Date = DateTime.Now;

            decimal BasicAmount = 0;
            string status = string.Empty;
            foreach (CakeOrderList cod in cakeOrderDetailList)
            {
                List<ROInvItem> itemList = new List<ROInvItem>();

                itemList = rocobj.getitemwithRate(cod.ItemId);
                cod.Rate = Convert.ToDecimal(itemList[0].SRate);
                cod.Amount = Convert.ToDecimal(itemList[0].SRate) * Convert.ToDecimal(cod.Quantity);
                cod.SalesType = cakeOrderMasterInfo.SalesType;
                cod.ItemName = itemList[0].ITName;
                BasicAmount += (Convert.ToDecimal(itemList[0].SRate) * Convert.ToDecimal(cod.Quantity));

            }

            FiscalYear fyear = rocobj.GetRONumberByFiscalYear();
            cakeOrderMasterInfo.BillNo = "";

            if (String.IsNullOrEmpty(cakeOrderMasterInfo.Remarks))
                cakeOrderMasterInfo.Remarks = "Fine";

            List<CakeOrderList> lst = new List<CakeOrderList>();
            lst = cor.GetOrderDetailsByMaster(cakeOrderMasterInfo.OrderMasterID);
            List<CakeOrderList> addedOrders = new List<CakeOrderList>();
            List<CakeOrderList> cancelledOrders = new List<CakeOrderList>();

            if (lst.Count > 0)
            {
                foreach (CakeOrderList ord in cakeOrderMasterInfo.CakeOrderList)
                {
                    List<CakeOrderList> prevOrders = lst.Where(p => p.ItemId == ord.ItemId && p.SeatNo == ord.SeatNo && p.IsCombo == ord.IsCombo && p.Status == "Ordered").ToList();
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
                List<CakeOrderList> OrdersList = lst.Where(p => p.Status == "Ordered").ToList();
                foreach (CakeOrderList ord in OrdersList)
                {
                    List<CakeOrderList> newOrders = cakeOrderMasterInfo.CakeOrderList.Where(p => p.ItemId == ord.ItemId && p.SeatNo == ord.SeatNo && p.IsCombo == ord.IsCombo).ToList();
                    if (newOrders.Count < 1)
                    {
                        cancelledOrders.Add(ord);
                    }
                }
            }
            else
            {
                foreach (CakeOrderList ord in cakeOrderMasterInfo.CakeOrderList)
                {
                    ord.Status = "Ordered";
                }
                addedOrders = cakeOrderMasterInfo.CakeOrderList;
            }

            int ordermasterid = cocobj.SaveCakeOrderIntoDatabase(cakeOrderMasterInfo, cakeOrderDetailList);
            List<OrderExtraItems> addedExtra = CheckExtraItems(orderExtraItems, true, cakeOrderMasterInfo.OrderMasterID, ordermasterid);
            List<OrderExtraItems> removedExtra = CheckExtraItems(orderExtraItems, false, cakeOrderMasterInfo.OrderMasterID, ordermasterid);
            List<CakeOrderList> toppingOnly = new List<CakeOrderList>();
            cor.SaveExtraOrderedItem(addedExtra, removedExtra);
            string printSuccessful = ordermasterid.ToString();

            bool printCall;
            if (wholesaleorder)
            {
                printCall = System.Configuration.ConfigurationManager.AppSettings["WholeSaleOrderPrinting"] == "true" ? true : false;
            }
            else
            {
                printCall = System.Configuration.ConfigurationManager.AppSettings["OrderPrinting"] == "true" ? true : false;
            }

            if (printCall)
            {
                foreach (OrderExtraItems ext in addedExtra)
                {
                    List<CakeOrderList> ord = addedOrders.Where(p => p.ItemId == ext.ItemID && p.SeatNo == ext.SeatNo && p.IsCombo == false).ToList();
                    if (ord.Count == 0)
                    {
                        CakeOrderList topping = new CakeOrderList();
                        topping.ItemName = ext.ExtraItem;
                        topping.Quantity = ext.Quantity;
                        topping.Note = lst.Where(p => p.ItemId == ext.ItemID && p.SeatNo == ext.SeatNo && p.IsCombo == false).First().ROI_ItemName;

                        toppingOnly.Add(topping);
                    }
                }
                foreach (OrderExtraItems ext in removedExtra)
                {
                    List<CakeOrderList> ord = cancelledOrders.Where(p => p.ItemId == ext.ItemID && p.SeatNo == ext.SeatNo && p.IsCombo == false).ToList();
                    if (ord.Count == 0)
                    {
                        CakeOrderList topping = new CakeOrderList();
                        topping.ItemName = ext.ExtraItem;
                        topping.Quantity = (-ext.Quantity);
                        topping.Note = lst.Where(p => p.ItemId == ext.ItemID && p.SeatNo == ext.SeatNo && p.IsCombo == false).First().ROI_ItemName;

                        toppingOnly.Add(topping);
                    }
                }
                foreach (CakeOrderList ord in addedOrders)
                {
                    List<OrderExtraItems> ext = addedExtra.Where(p => p.ItemID == ord.ItemId && p.SeatNo == ord.SeatNo && ord.IsCombo == false).ToList();
                    if (ext.Count > 0)
                    {
                        string note = "Extra : ";
                        foreach (OrderExtraItems e in ext)
                        {
                            note += (e.ExtraItem + " (" + e.Quantity.ToString() + ")");
                        }
                        ord.Note += note;
                    }
                }
                foreach (CakeOrderList ord in cancelledOrders)
                {
                    List<OrderExtraItems> ext = removedExtra.Where(p => p.ItemID == ord.ItemId && p.SeatNo == ord.SeatNo && ord.IsCombo == false).ToList();
                    if (ext.Count > 0)
                    {
                        string note = "Extra : ";
                        foreach (OrderExtraItems e in ext)
                        {
                            note += (e.ExtraItem + " (" + e.Quantity.ToString() + ")");
                        }
                        ord.Note += note;
                    }
                }
                restroTable table = new restroTable();
                if (cakeOrderMasterInfo.TableId != "0")
                {
                    table = rocobj.GetTableNoBYId(Convert.ToInt32(cakeOrderMasterInfo.TableId));
                }

                Tokens toke = new Tokens();
                toke = cor.getOrderNobyOrderMasterId(ordermasterid);

                OrderPrint print = new OrderPrint();
                if (cakeOrderMasterInfo.IsCancelled == true)
                {
                    status = "Cancelled";
                    printSuccessful += print.PrintCakeOrders(cakeOrderMasterInfo.CakeOrderList, cakeOrderMasterInfo.OrderTypeID == 8 ? "Retail" :cakeOrderMasterInfo.OrderTypeID == 7 ? "WholeSales" : cakeOrderMasterInfo.OrderTypeID == 4 ? "FoodDelivery" : (cakeOrderMasterInfo.OrderTypeID == 3 ? "FoodCourt" : (cakeOrderMasterInfo.OrderTypeID == 2 ? "Take Away" : table.restrotableTitle)), cakeOrderMasterInfo.Date, cakeOrderMasterInfo.UserName, "Cancelled", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                }
                else
                {
                    if (addedOrders.Count > 0)
                    {
                        status = "Added";
                        printSuccessful += print.PrintCakeOrders(addedOrders,cakeOrderMasterInfo.OrderTypeID == 8 ? "Retail" :cakeOrderMasterInfo.OrderTypeID == 7 ? "WholeSales" : cakeOrderMasterInfo.OrderTypeID == 4 ? "FoodDelivery" : (cakeOrderMasterInfo.OrderTypeID == 3 ? "FoodCourt" : (cakeOrderMasterInfo.OrderTypeID == 2 ? "TakeAway" : table.restrotableTitle)), cakeOrderMasterInfo.Date, cakeOrderMasterInfo.UserName, "Added", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                    }
                    if (cancelledOrders.Count > 0)
                    {
                        status = "Cancelled";
                        printSuccessful += print.PrintCakeOrders(cancelledOrders,cakeOrderMasterInfo.OrderTypeID == 8 ? "Retail" :cakeOrderMasterInfo.OrderTypeID == 7 ? "WholeSales" : cakeOrderMasterInfo.OrderTypeID == 4 ? "FoodDelivery" : (cakeOrderMasterInfo.OrderTypeID == 3 ? "FoodCourt" : (cakeOrderMasterInfo.OrderTypeID == 2 ? "Take Away" : table.restrotableTitle)), cakeOrderMasterInfo.Date, cakeOrderMasterInfo.UserName, "Cancelled", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                    }
                    if (toppingOnly.Count > 0)
                    {
                        PrintExtra(toppingOnly,cakeOrderMasterInfo.OrderTypeID == 8 ? "Retail" :cakeOrderMasterInfo.OrderTypeID == 7 ? "WholeSales" : cakeOrderMasterInfo.OrderTypeID == 4 ? "FoodDelivery" : (cakeOrderMasterInfo.OrderTypeID == 3 ? "FoodCourt" : (cakeOrderMasterInfo.OrderTypeID == 2 ? "Take Away" : table.restrotableTitle)), cakeOrderMasterInfo.Date, cakeOrderMasterInfo.UserName, 1, ordermasterid);
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

    protected List<OrderExtraItems> CheckExtraItems(List<OrderExtraItems> extra, bool added, int ordermasterid, int newOrdermasterid)
    {
        List<OrderExtraItems> newlist = new List<OrderExtraItems>();
        if (added && extra.Count > 0)
        {
            CakeOrderController cor = new CakeOrderController();
            foreach (OrderExtraItems ext in extra)
            {
                List<OrderExtraItems> prevList = cor.GetOrderedExtraItemByOrderMaster(ordermasterid).Where(p => p.ItemID == ext.ItemID && p.SeatNo == ext.SeatNo && p.ItemStatus == "Ordered" && p.ExtraItemID == ext.ExtraItemID).ToList();
                int prevQnty = (prevList.Count > 0 ? prevList.FirstOrDefault().Quantity : 0);
                if (ext.Quantity > prevQnty)
                {
                    OrderExtraItems itm = new OrderExtraItems();
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
                CakeOrderController cor = new CakeOrderController();
                foreach (OrderExtraItems ext in extra)
                {
                    List<OrderExtraItems> prevList = cor.GetOrderedExtraItemByOrderMaster(ordermasterid).Where(p => p.ItemID == ext.ItemID && p.SeatNo == ext.SeatNo && p.ItemStatus == "Ordered" && p.ExtraItemID == ext.ExtraItemID).ToList();
                    int prevQnty = (prevList.Count > 0 ? prevList.FirstOrDefault().Quantity : 0);
                    if (ext.Quantity < prevQnty)
                    {
                        OrderExtraItems itm = new OrderExtraItems();
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
                List<OrderExtraItems> prevLists = cor.GetOrderedExtraItemByOrderMaster(ordermasterid).Where(p => p.ItemStatus == "Ordered").ToList();
                foreach (OrderExtraItems ext in prevLists)
                {
                    List<OrderExtraItems> newList = extra.Where(p => p.ItemID == ext.ItemID && p.SeatNo == ext.SeatNo && p.ExtraItemID == ext.ExtraItemID).ToList();
                    if (newList.Count < 1)
                    {
                        newlist.Add(ext);
                    }
                }

            }
        }
        return newlist;
    }
    public int PrintExtra(List<CakeOrderList> orderDetailList, string tableId, DateTime time, string userName, int OrderStatus, int orderMasterID)
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
            kot.KOTItem = orderDetailList;
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
    public string GetDataForSalesBill(int orderMasterId, string SalesType)
    {
        try
        {
            CakeOrderMaster cakeOrderMaster = new CakeOrderMaster();
            companyInfo compInf = roController.getcompanyInfo().FirstOrDefault();
            cakeOrderMaster.CakeOrderList = cocobj.getCakeOrderDetailByOrderMasterId(orderMasterId, SalesType);
            cakeOrderMaster.billingTerm = cocobj.getActiveBILLTERM();
            cakeOrderMaster.VATforBill = (compInf.IsPan ? false : true);
            return jsSerializer.Serialize(cakeOrderMaster);
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
    public int saveCakeSalesBill(CakeSalesMaster salesMaster, List<CakeSalesDetails> salesDetail, List<CustomerBilling> billingTerm, SalesPayMode spm, Cakeflatorperdiscount flatorperdiscount)
    {
        int salesMasterId = cocobj.saveCakeSalesBill(salesMaster, salesDetail, billingTerm, spm, flatorperdiscount);

        spm.salesMasterId = salesMasterId;
        //cocobj.UpdateSalesPayMode(spm);
        //CBMS cbms = new CBMS();
        //cbms.sendSales(salesMasterId);
        return salesMasterId;
    }
    [WebMethod]
    public string savePrintCount(int Printcount, string BillNo, string PrintedBy, string SalesType = "")
    {
        if (BillNo != "")
        {
            return roController.SavePrintCountDetail(Printcount, BillNo, PrintedBy, SalesType);
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
}