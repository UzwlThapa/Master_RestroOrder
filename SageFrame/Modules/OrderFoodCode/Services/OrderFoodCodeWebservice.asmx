<%@ WebService Language="C#" Class="OrderFoodCodeWebservice" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using SageFrame.RestroOrder; 
using SageFrame.RestoLoyalty;
/// <summary>
/// Summary description for OrderItemWebservice
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class OrderFoodCodeWebservice : System.Web.Services.WebService
{
    [WebMethod]
    public int SaveSalesBill(SalesMaster salesMaster, List<SalesDetails> salesDetail, int splited, List<customerBilling> billingTerm, flatorperdiscount flatorperdiscount, SalesPayment payment)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            int salesMasterId = roc.saveSalesBill(salesMaster, salesDetail, splited, billingTerm, flatorperdiscount);

            payment.salesMasterId = salesMasterId;
            roc.UpdateSalesPayMode(payment);

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
    public List<CardProvider> GetProviderList()
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.getCardProvider();
    }
    [WebMethod]
    public SalesBill GetDataForSalesBill(int orderMasterId)
    {
        try
        {
            SalesBill salesBill = new SalesBill();
            RestrOrderController roc = new RestrOrderController();
            salesBill.orderDetail = roc.getOrderDetailByOrderMasterId(orderMasterId);
            salesBill.billingTerm = roc.getActiveBILLTERM();

            if (System.Configuration.ConfigurationManager.AppSettings["ServChargeInTakeAway"] == "false")
            {
                salesBill.billingTerm.RemoveAll(p => p.BillTerm == "Service Charge");
            }
            salesBill.cuscenter = roc.getdiscountfromcostcenter();
            salesBill.RoomBooking = roc.getRoomBookingInfoByOrderMasterID(orderMasterId);
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
    public BillData GetBill(int SalesMasterID)
    {
        BillData bill = new BillData();
        RestrOrderController roc = new RestrOrderController();
        List<OrderDetailClass> ord = roc.GetdataforViewBill(SalesMasterID);
        foreach (OrderDetailClass item in ord)
        {
            int characLimit = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["ItemCharacterLimit"]);
            if (item.ITName.Length > characLimit)
            {
                item.ITName = item.ITName.Substring(0, characLimit) + "...";
            }
            item.BillNo = ord[0].GetBillNo();
        }

        bill.orderDetail = ord;
        bill.companyInfo = roc.getcompanyInfo();
        bill.billingTerm = roc.getbillingTermbySalesMasterID(SalesMasterID.ToString());
        bill.cuscenter = roc.getdiscountfromcostcenter();
        bill.AmntInWord = NumberConverter.DecimalToWord(bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount);
        bill.discount = roc.getflatorperdiscount(ord[0].OrderMasterId).FirstOrDefault();
        if (ord[0].IsTable == false)
        {
            //decimal roomdis = 0;
            //if (bill.discount.isflatdis == false) {
            //        roomdis = (ord[0].RoomCharge * (Convert.ToDecimal(bill.discount.roomdis) / 100));
            //    } else {
            //        roomdis = Convert.ToDecimal(bill.discount.roomdis);
            //    }
            ord[0].BasicAmount = (bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount) - ord[0].AdvancePayment;
            bill.AmntInWord = NumberConverter.DecimalToWord((bill.billingTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount) - ord[0].AdvancePayment);
        }
        bill.splitCostCenter = (System.Configuration.ConfigurationManager.AppSettings["SplitCostCenterInBill"] == "false" ? false : true);

        return bill;
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
            return rocobj.GetCategoriesBymenuID(MenuId, 0);

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
            return rocobj.GetItemByCategoryID(CategoriesID, 0);

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
    public string SaveOrderIntoDataBase(OrderMasterClass orderMasterInfo)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            List<OrderDetailClass> orderDetailList = new List<OrderDetailClass>();
            orderDetailList = orderMasterInfo.OrderDetailsList;
            orderMasterInfo.Date = DateTime.Now;
            decimal BasicAmount = 0;
            string status = string.Empty;

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
                orderDetail.Rate = Convert.ToDecimal(itemList[0].SRate);
                orderDetail.Amount = orderDetail.Rate * Convert.ToDecimal(orderDetailList[i].Quantity);
                BasicAmount += orderDetail.Amount;

            }
            //status += orderDetailList[0].Status;
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


            //  var json1 = JsonConvert.DeserializeObject<OrderMasterClass>(json);
            FiscalYear fyear = rocobj.GetRONumberByFiscalYear();
            orderMasterInfo.BillNo = "RO" + orderMasterInfo.Date.ToString().Replace("/", "").Replace("PM", "").Replace("AM", "").Replace(":", "").Replace(" ", "");
            orderMasterInfo.BasicAmount = BasicAmount;
            //orderMasterInfo.TermAmount = BasicAmount;
            //if (orderMasterInfo.BillPaid == null)
            //{
            //    orderMasterInfo.BillPaid = 0;
            //}
            orderMasterInfo.Status = status;
            if (String.IsNullOrEmpty(orderMasterInfo.Remarks))
                orderMasterInfo.Remarks = "Fine";

            var repeateditem = new List<OrderDetailClass>();
            List<OrderDetailClass> lst = new List<OrderDetailClass>();
            lst = rocobj.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID);
            foreach (OrderDetailClass item in lst)
            {
                repeateditem.Add(new OrderDetailClass { IsCombo = item.IsCombo, ItemId = item.ROI_ItemId, Quantity = item.Quantity, IsRunningOrder = item.IsRunningOrder, IsSplit = item.IsSplit, SeatNo = item.SeatNo });
            }

            //rocobj.DeleteOrderDetailByMaster(orderMasterInfo.OrderMasterID, orderMasterInfo.ArchivedBy);
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
                    //if (newOrders.Count < 1)
                    if (newOrders == null || newOrders.Count == 0)
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

            Token toke = new Token();
            toke = rocobj.getOrderNobyOrderMasterId(ordermasterid);
            if (toke == null)
            {
                toke = new Token() { OrderNo = 0, CustomerName = "", Phone = "" };
            }

            OrderPrint print = new OrderPrint();
            string printSuccessful = ordermasterid.ToString();
            if (System.Configuration.ConfigurationManager.AppSettings["FoodCourtOrderPrinting"] == "true")
            {
                restroTable table = new restroTable();
                if (orderMasterInfo.TableId != "0")
                {

                    table = rocobj.GetTableNoBYId(Convert.ToInt32(orderMasterInfo.TableId));
                }
                if (orderMasterInfo.IsCancelled == true)
                {
                    status = "Cancelled";
                    //status cancelled==Integer value 2 sent
                    printSuccessful += print.PrintOrders(orderMasterInfo.OrderDetailsList, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, "Cancelled", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                    //GetDataForPrint(orderMasterInfo.OrderDetailsList, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, 2, ordermasterid);
                }
                else
                {
                    if (table.restrotableTitle == null)
                    {
                        status = "Pick Order";
                        printSuccessful += print.PrintOrders(addedOrders, "Take Away", orderMasterInfo.Date, orderMasterInfo.UserName, "Added", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                        //GetDataForPrint(addedOrders, "Take Away", orderMasterInfo.Date, orderMasterInfo.UserName, orderMasterInfo.OrderMasterID, ordermasterid);
                    }
                    else
                    {
                        if (addedOrders.Count > 0)
                        {
                            status = "Added";
                            printSuccessful += print.PrintOrders(addedOrders, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, "Added", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                            //GetDataForPrint(addedOrders, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, orderMasterInfo.OrderStatus, ordermasterid);
                        }
                        if (cancelledOrders.Count > 0)
                        {
                            status = "Cancelled";
                            printSuccessful += print.PrintOrders(cancelledOrders, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, "Running", ordermasterid, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
                            //return GetDataForPrint(cancelledOrders, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, 1, ordermasterid);
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
    public void CancelOrderIntoDataBase(OrderMasterClass orderMasterInfo)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            List<OrderDetailClass> orderList = rocobj.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID);
            rocobj.CancelOrder(orderMasterInfo);
            restroTable table = rocobj.GetTableNoBYId(Convert.ToInt32(orderMasterInfo.TableId));
            Token toke = rocobj.getOrderNobyOrderMasterId(Convert.ToInt32(orderMasterInfo.OrderMasterID));
            if (System.Configuration.ConfigurationManager.AppSettings["FoodCourtOrderPrinting"] == "true")
            {
                OrderPrint print = new OrderPrint();
                print.PrintOrders(orderList, table.restrotableTitle == null ? "Table" : table.restrotableTitle, DateTime.Now, orderMasterInfo.UserName, "Cancelled", orderMasterInfo.OrderMasterID, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
            }
        }
        catch (Exception)
        {
            throw;
        }

    }

    [WebMethod]
    public List<CategoriesClass> txtSearchForItem(string ItemName, int languageid)
    {
        RestrOrderController roc = new RestrOrderController();
        return roc.txtSearchForItem(ItemName, languageid);
    }

    [WebMethod]
    public List<MvPurchaseDetails> GetItemForSearch()
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
