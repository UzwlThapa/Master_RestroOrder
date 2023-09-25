<%@ WebService Language="C#" Class="OrderDeliveryWB" %>

using System;
using System.Linq;
using System.Web.Services;
using SageFrame.RestroOrder;
using System.Collections.Generic;
using Newtonsoft.Json;
using SageFrame.RestoLoyalty;
    using SageFrame.Security;
using SageFrame.Security.Entities;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class OrderDeliveryWB  : System.Web.Services.WebService {

    RestrOrderController roc = new RestrOrderController();
    RestoLoyaltyController dfcobj = new RestoLoyaltyController();

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }


     [WebMethod]
    public string GetOrderDeliveryList()
    {
        try
        {
            List<Token> deliverylist = roc.GetOrderDeliveryList();
            return JsonConvert.SerializeObject(deliverylist);
        }
        catch (Exception ex)
        {
            throw ex;
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
            salesBill.billingTerm.RemoveAll(p => p.BillTerm == "Service Charge");
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
    public PinUser GetRolesByUsername(string username)
    {
        return roc.GetRolesByUsername(username);
    }

    [WebMethod]
    public string getmembershiplistbyId(int memberid)
    {
        List<MemberInfo> memberlist = dfcobj.getmembershiplistbyId(memberid);
        return JsonConvert.SerializeObject(memberlist);
    }

    [WebMethod]
    public string getsdatass(int customer)
    {
        return JsonConvert.SerializeObject(dfcobj.getmembershiplist(customer));
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
    public string GetUnpaidBills()
    {
        return JsonConvert.SerializeObject(roc.GetUnpaidBills().Where(p => p.OrderTypeID == 4).ToList());
    }


    [WebMethod]
    public string GetOrderDeliveredList()
    {
        return JsonConvert.SerializeObject(roc.GetOrderDeliveredList());
    }


    [WebMethod]
    public void CancelOrderIntoDataBase(OrderMasterClass orderMasterInfo)
    {
        try
        {
            //List<OrderDetailClass> orderList = rocobj.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID);
            List<OrderDetailClass> orderList = roc.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID).Where(p => p.Status == "Ordered" && p.SeatNo == orderMasterInfo.GuestNo).ToList();
            roc.CancelOrder(orderMasterInfo);
            //restroTable table = roc.GetTableNoBYId(Convert.ToInt32(orderMasterInfo.TableId));
            Token toke = roc.getOrderNobyOrderMasterId(Convert.ToInt32(orderMasterInfo.OrderMasterID));
            if (System.Configuration.ConfigurationManager.AppSettings["OrderPrinting"] == "true")
            {
                OrderPrint print = new OrderPrint();
                print.PrintOrders(orderList, Convert.ToInt32(orderMasterInfo.OrderMasterID) == 0? "Food Delivery" : "Food Delivery", DateTime.Now, orderMasterInfo.UserName, "Cancelled", orderMasterInfo.OrderMasterID, toke.OrderNo, toke.TokenNo, toke.CustomerName, toke.Phone);
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
                cancelItm.tableId = Convert.ToInt32(orderMasterInfo.TableId);

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

        
           [WebMethod]
     public virtual SageFrameUserCollection GetAllUsers()
     {
         MembershipController mhc = new MembershipController();
         return (mhc.GetAllUsers());
     }
}