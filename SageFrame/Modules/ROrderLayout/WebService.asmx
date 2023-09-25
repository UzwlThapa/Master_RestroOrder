<%@ WebService Language="C#" Class="RO_layoutWebService" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using SageFrame.RestroOrder;
using System.Collections.Generic;
using Newtonsoft.Json;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class RO_layoutWebService  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

    RestrOrderController roc = new RestrOrderController();

    [WebMethod]
    public string getTable()
    {
        List<restroTable> RestroLayoutList = roc.getRestroTable();
        return JsonConvert.SerializeObject(RestroLayoutList);
    }



    [WebMethod]
    public string GetRoomByRoomTypeId(int RoomTypeID)
    {
        return JsonConvert.SerializeObject(roc.GetRoomByRoomTypeId(RoomTypeID));
    }


    [WebMethod]
    public string GetTableByRoomTypeId(int RoomId)
    {
        List<restroTable> restroTableList = roc.GetTableByRoomTypeId(RoomId);
        return JsonConvert.SerializeObject(restroTableList);
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
            return JsonConvert.SerializeObject(salesBill);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string getRoomType()
    {
        List<RoomType> roomtype = roc.getRoomType();
        return JsonConvert.SerializeObject(roomtype);
    }

    [WebMethod]
    public PinUser GetRolesByUsername(string username)
    {
        return roc.GetRolesByUsername(username);
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
    public void shiftTable(int fromordermasterid, int totableID, int fromSeatNo, int toSeatNo, string shiftedby)
    {
        roc.shiftTable(fromordermasterid, totableID, fromSeatNo, toSeatNo, shiftedby);
    }

}