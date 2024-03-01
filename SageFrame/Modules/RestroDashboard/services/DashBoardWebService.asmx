<%@ WebService Language="C#" Class="DashBoardWebService" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using SageFrame.RestoLoyalty;
using Hangfire;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using Newtonsoft.Json;


/// <summary>
/// Summary description for DashBoardWebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class DashBoardWebService : System.Web.Services.WebService
{
    JavaScriptSerializer jss = new JavaScriptSerializer();
    RestrOrderController roc = new RestrOrderController();
    RestoLoyaltyController dfcobj = new RestoLoyaltyController();

    [WebMethod]
    public void SaveRoomBoking(RoomBookingsInfo roomBooking, OrderMasterClass orderMaster)
    {
        try
        {
            roc.SaveRoomBoking(roomBooking, orderMaster);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public List<restroTable> GetOccupiedTables(bool isTable)
    {
        try
        {
            return roc.GetOccupiedTables(isTable);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public List<restroTable> GetComplimentaryOccupiedTables(bool isTable)
    {
        try
        {
            return roc.GetComplimentaryOccupiedTables(isTable);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public List<restroTable> GetTakeAwayOrders()
    {
        try
        {
            return roc.GetTakeAwayOrders();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public string GetOccupiedRooms()
    {
        try
        {
            return JsonConvert.SerializeObject(roc.GetOccupiedRooms().Where(p => DateTime.Now >= Convert.ToDateTime(p.BookedFrom)).ToList());
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public string GetBookedRooms()
    {
        try
        {
            return JsonConvert.SerializeObject(roc.GetOccupiedRooms().Where(p => Convert.ToDateTime(p.BookedFrom) > DateTime.Now).ToList());
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public string CheckAvailability(string startDate, string endDate, int roombookDetailId, int tableId)
    {
        try
        {
            return JsonConvert.SerializeObject(roc.CheckAvailability(startDate, endDate, roombookDetailId, tableId));
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public string GetDataForPrint(int orderMasterId)
    {
        try
        {
            OrderPrint print = new OrderPrint();
            SalesBill salesBill = new SalesBill();
            companyInfo compInf = roc.getcompanyInfo().FirstOrDefault();
            salesBill.orderDetail = roc.getOrderDetailByOrderMasterId(orderMasterId).Where(p => p.IsCancelled == false).ToList();
            List<OrderExtraItem> extra = roc.GetAllExtraItemByOrderMaster(orderMasterId);
            foreach (OrderDetailClass ord in salesBill.orderDetail)
            {
                if (!ord.IsCombo)
                {
                    ord.orderExtraItem = extra.Where(p => p.ItemID == ord.ROI_ItemId && p.SeatNo == ord.SeatNo).ToList();
                }
            }
            salesBill.billingTerm = roc.getActiveBILLTERM();
            salesBill.cuscenter = roc.getdiscountfromcostcenter();
            salesBill.RoomBooking = roc.getRoomBookingInfoByOrderMasterID(orderMasterId);
            salesBill.VATforBill = (compInf.IsPan ? false : true);
            salesBill.Token = roc.getOrderTokenByOrderMasterId(orderMasterId);
            print.PrintBill(salesBill);
            return ("Printed SuccessFully !!");
        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public string GetDataForSalesBill(int orderMasterId)
    {
        try
        {
            SalesBill salesBill = new SalesBill();
            companyInfo compInf = roc.getcompanyInfo().FirstOrDefault();
            salesBill.orderDetail = roc.getOrderDetailByOrderMasterId(orderMasterId).Where(p => p.IsCancelled == false).ToList();

            List<OrderExtraItem> extra = roc.GetAllExtraItemByOrderMaster(orderMasterId);

            foreach (OrderDetailClass ord in salesBill.orderDetail)
            {


                if (!ord.IsCombo)
                {
                    ord.orderExtraItem = extra.Where(p => p.ItemID == ord.ROI_ItemId && p.SeatNo == ord.SeatNo).ToList();
                }
            }
            salesBill.billingTerm = roc.getActiveBILLTERM();
            salesBill.cuscenter = roc.getdiscountfromcostcenter();
            salesBill.RoomBooking = roc.getRoomBookingInfoByOrderMasterID(orderMasterId);
            salesBill.VATforBill = (compInf.IsPan ? false : true);
            salesBill.Token = roc.getOrderTokenByOrderMasterId(orderMasterId);
            salesBill.costCenterGroups = roc.GetCostCenterGroup();
            return JsonConvert.SerializeObject(salesBill);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public string GetComplimentaryOrders(int orderMasterId)
    {
        try
        {
            List<ComplimentaryOrder> complimentaryOrders = new List<ComplimentaryOrder>();
            companyInfo compInf = roc.getcompanyInfo().FirstOrDefault();
            //complimentaryOrders = roc.getComplimentaryOrderDetailByOrderMasterId(orderMasterId).Where(p => p.IsCancelled == false).ToList();
            complimentaryOrders = roc.getComplimentaryOrderDetailByOrderMasterId(orderMasterId).ToList();
            return JsonConvert.SerializeObject(complimentaryOrders);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    [WebMethod]
    public string GetDataForTakeAwaySalesBill(int orderMasterId)
    {
        try
        {
            SalesBill salesBill = new SalesBill();
            companyInfo compInf = roc.getcompanyInfo().FirstOrDefault();
            salesBill.orderDetail = roc.getOrderDetailByOrderMasterId(orderMasterId).Where(p => p.IsCancelled == false).ToList();
            List<OrderExtraItem> extra = roc.GetAllExtraItemByOrderMaster(orderMasterId);
            foreach (OrderDetailClass ord in salesBill.orderDetail)
            {
                if (!ord.IsCombo)
                {
                    ord.orderExtraItem = extra.Where(p => p.ItemID == ord.ROI_ItemId && p.SeatNo == ord.SeatNo).ToList();
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
            salesBill.costCenterGroups = roc.GetCostCenterGroup();
            return JsonConvert.SerializeObject(salesBill);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string SaveSalesBill(SalesMaster salesMaster, List<SalesDetails> salesDetail, int splited, List<customerBilling> billingTerm, flatorperdiscount flatorperdiscount)
    {
        try
        {
            int salesMasterId = roc.saveSalesBill(salesMaster, salesDetail, splited, billingTerm, flatorperdiscount);

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
    public string savePrintCount(int Printcount, string BillNo, string PrintedBy)
    {
        if (BillNo != "")
        {
            return JsonConvert.SerializeObject(roc.SavePrintCountDetail(Printcount, BillNo, PrintedBy));
        }
        return "";

    }
    [WebMethod]
    public void UnMergeTable(int tableId)
    {
        try
        {
            roc.UnMergeTable(tableId);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public void CancelOrderIntoDataBase(OrderMasterClass orderMasterInfo)
    {
        try
        {
            List<OrderDetailClass> orderList = roc.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID).Where(p => p.Status == "Ordered" && p.SeatNo == orderMasterInfo.GuestNo).ToList();
            roc.CancelOrder(orderMasterInfo);
            restroTable table = roc.GetTableNoBYId(Convert.ToInt32(orderMasterInfo.TableId));
            Token toke = roc.getOrderNobyOrderMasterId(Convert.ToInt32(orderMasterInfo.OrderMasterID));
            if (System.Configuration.ConfigurationManager.AppSettings["OrderPrinting"] == "true")
            {
                OrderPrint print = new OrderPrint();
                print.PrintOrders(orderList, table == null ? "Table" : table.restrotableTitle, DateTime.Now, orderMasterInfo.UserName, "Cancelled", orderMasterInfo.OrderMasterID, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
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
            roc.SaveCanceledItems(CancelItems);
        }
        catch (Exception)
        {
            return;
        }

    }
    [WebMethod]
    public string getsdatass(int customer)
    {
        return JsonConvert.SerializeObject(dfcobj.getmembershiplist(customer));

    }
    [WebMethod]
    public string GetCusOnChange(int MembershipID)
    {
        try
        {

            return JsonConvert.SerializeObject(dfcobj.GetCusOnChange(MembershipID));
        }
        catch (Exception)
        {

            throw;
        }
    }
    [WebMethod]
    public void SaveCustomerAmount(MemberInfo MemberInfo)
    {
        try
        {
            dfcobj.SaveCustomerAmount(MemberInfo);

        }
        catch (Exception)
        {

            throw;
        }

    }
    [WebMethod]
    public void MergeTables(List<MergeTableInfo> mergeTableList, string[] occupiedTableIds)
    {
        roc.SaveMergeTable(mergeTableList, occupiedTableIds);
    }

    [WebMethod]
    public string GetMergedTables(int tableId)
    {
        return JsonConvert.SerializeObject(roc.GetMergedTables(tableId));
    }

    [WebMethod]
    public void ClearMergeList(int tableId)
    {
        roc.ClearMergeList(tableId);
    }

    [WebMethod]
    public string GetProviderList()
    {
        return JsonConvert.SerializeObject(roc.getCardProvider());
    }

    [WebMethod]
    public void UpdateSalesPayMode(SalesPayment salesPayment)
    {
        try
        {
            roc.UpdateSalesPayMode(salesPayment);

        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public void SaveTotalCashPaid(MemberInfo MemberInfo)
    {
        try
        {
            dfcobj.SaveTotalCashPaid(MemberInfo);

        }
        catch (Exception)
        {

            throw;
        }
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public string GetUnpaidBills()
    {
        return JsonConvert.SerializeObject(roc.GetUnpaidBills().Where(p => p.OrderTypeID != 4).ToList());
    }

    [WebMethod]
    public string Gettabledataforshift()
    {
        return JsonConvert.SerializeObject(roc.Gettabledataforshift());
    }

    [WebMethod]
    public void shiftTable(int fromordermasterid, int totableID, int fromSeatNo, int toSeatNo, string shiftedby, string fromTableTitle, string toTableTitle, int OrderNo)
    {
        List<OrderDetailClass> orderList = roc.GetOrderDetailsByMaster(fromordermasterid);
        // Send Kot Print for shift items
        if (System.Configuration.ConfigurationManager.AppSettings["PrintOrderShiftBill"] == "true")
        {
            OrderPrint print = new OrderPrint();
            print.PrintShiftBill(orderList, "", DateTime.Now, fromTableTitle, toTableTitle, shiftedby, "Ordered", fromordermasterid, OrderNo, 0, "", "");
        }
        roc.shiftTable(fromordermasterid, totableID, fromSeatNo, toSeatNo, shiftedby);
    }

    [WebMethod]
    public string GetRoomByRoomTypeId(int RoomTypeID)
    {
        return JsonConvert.SerializeObject(roc.GetRoomByRoomTypeId(RoomTypeID));
    }

    [WebMethod]
    public void SaveSplittedData(List<OrderDetailClass> ItemsArray)
    {
        roc.SaveSplittedData(ItemsArray);
    }

    [WebMethod]
    public string GetTableByRoomTypeId(int RoomId)
    {
        List<restroTable> restroTableList = roc.GetTableByRoomTypeId(RoomId);

        return JsonConvert.SerializeObject(restroTableList);
    }


    [WebMethod]
    public string GettabledataByIdforMenu(int TableId)
    {

        List<OrderDetailClass> lst = roc.GettabledataByIdforMenu(TableId);
        if (lst != null && lst.Count > 0)
        {
            List<OrderExtraItem> extra = roc.GetOrderedExtraItemByOrderMaster(lst[0].OrderMasterId);
            if (extra != null && extra.Count > 0)
            {
                foreach (OrderDetailClass ord in lst)
                {
                    ord.orderExtraItem = extra.Where(p => p.ItemID == ord.ItemId && p.SeatNo == ord.SeatNo && ord.IsCombo == false).ToList();
                }
            }
        }

        return JsonConvert.SerializeObject(lst);
    }

    public class RoomBooking
    {
        public restroTable RoomInfo { get; set; }
        public List<RoomBookingsInfo> RoomBookingDetails { get; set; }
    }

    [WebMethod]
    public RoomBooking GetroomdataByIdforMenu(int tableId)
    {
        RoomBooking obj = new RoomBooking();
        obj.RoomBookingDetails = roc.GetroomdataByIdforMenu(tableId);
        obj.RoomInfo = roc.getTableInfo(tableId);
        return obj;
    }


    [WebMethod]
    public string SaveCus(Cusinfo Cusinfo)
    {
        try
        {

            int id = roc.SaveCus(Cusinfo);
            return JsonConvert.SerializeObject(id);

        }
        catch (Exception)
        {
            throw;
        }

    }

    [WebMethod]
    public string CheckLoyaltyForDiscount(string MembershipID, string TelMobile)
    {
        try
        {
            return JsonConvert.SerializeObject(roc.CheckLoyaltyForDiscount(MembershipID, TelMobile));
        }
        catch (Exception)
        {

            throw;
        }

    }

    [WebMethod]
    public string GetWaiterLog()
    {
        try
        {
            return JsonConvert.SerializeObject(roc.GetWaiterLog());
        }
        catch (Exception)
        {

            throw;
        }

    }

    [WebMethod]
    public void callWaiter(string WaiterIp)
    {
        try
        {
            BackgroundJob.Enqueue(() => WaiterNotification.CallWaiter(WaiterIp));
        }
        catch (Exception)
        {

            throw;
        }

    }
    [WebMethod]
    public string GetBookDataForEditing(int orderMasterId)
    {
        return jss.Serialize(roc.GetOccupiedRooms().Where(p => p.OrderMasterId == orderMasterId).FirstOrDefault());
    }

    [WebMethod]
    public PinUser GetRolesByUsername(string username)
    {
        return roc.GetRolesByUsername(username);
    }

    [WebMethod]
    public PinUser CheckPin(string pin)
    {
        return roc.CheckPin(pin);
    }

    [WebMethod]
    public string getMemberDetailsbyinfo(string info)
    {
        //return JsonConvert.SerializeObject(dfcobj.getMemberDetailsbyinfo(info));
        List<MemberInfo> getdetails = dfcobj.getMemberDetailsbyinfo(info);
        return JsonConvert.SerializeObject(getdetails);

    }

    [WebMethod]
    public string GetPaymentModesAndProvidersForAdvancePayment()
    {
        return JsonConvert.SerializeObject(roc.GetPaymentModesAndProvidersForAdvancePayment());
    }

    [WebMethod]
    public string getmembershiplistbyId(int memberid)
    {
        List<MemberInfo> memberlist = dfcobj.getmembershiplistbyId(memberid);
        return JsonConvert.SerializeObject(memberlist);
    }
    [WebMethod]
    public string getTable()
    {
        List<restroTable> RestroLayoutList = roc.getRestroTable();
        return JsonConvert.SerializeObject(RestroLayoutList);
    }

    [WebMethod]
    public void saveTableLayout(List<SaveLayoutTable> table)
    {
        roc.saveTableLayout(table);
    }

    [WebMethod]
    public string getLayoutTable(int UserModuleID)
    {
        List<restroTable> RestroLayoutList = roc.getLayoutTable(UserModuleID);
        return JsonConvert.SerializeObject(RestroLayoutList);
    }

    [WebMethod]
    public string getRoomType()
    {
        List<RoomType> roomtype = roc.getRoomType();
        return JsonConvert.SerializeObject(roomtype);
    }


    [WebMethod]
    public string checkOrder(int orderMasterId, int seatNo, int tableId)
    {
        List<CheckBill> Checkbill = roc.checkOrder(orderMasterId, seatNo, tableId);
        return JsonConvert.SerializeObject(Checkbill);
    }

    [WebMethod]
    public void OpenDrawer()
    {
        RestrOrderController rocobj = new RestrOrderController();
        List<costCenter> coc = rocobj.getcostcenter();
        var billingPrinter = coc[2].DefaultPrinter;
        const string ESC = "\u001B";
        const string p = "\u0070";
        const string m = "\u0000";
        const string t1 = "\u0025";
        const string t2 = "\u0250";
        const string openTillCommand = ESC + p + m + t1 + t2;

        CashDrawer.SendStringToPrinter(billingPrinter, openTillCommand);
    }

}



