<%@ WebService Language="C#" Class="RestroWebService" %>

using System;
using System.Web.Services;
using System.Web.Script.Serialization;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class RestroWebService : System.Web.Services.WebService
{

    RestrOrderController roController = new RestrOrderController();
    JavaScriptSerializer serializer = new JavaScriptSerializer();

    [WebMethod]
    public string GetAllUserRoles()
    {
        List<PinUser> userroles = roController.GetAllUserRoles();
        return JsonConvert.SerializeObject(userroles);
    }

    [WebMethod]
    public string GetPinSettings()
    {
        List<PinUser> rolePinSettings = roController.GetPinSettings();
        return JsonConvert.SerializeObject(rolePinSettings);
    }

    [WebMethod]
    public string CheckPinCodeMatch(string PinCode, string username)
    {
        string available = roController.CheckPinCodeMatch(PinCode, username);
        return JsonConvert.SerializeObject(available);
    }

    [WebMethod]
    public string shiftItems(string json)
    {
        var shiftItems = serializer.Deserialize<ShiftItems>(json);
        try
        {
            //List<OrderDetailClass> orderList = roController.GetOrderDetailsByMaster(shiftItems.OrderMasterID);
            //if (System.Configuration.ConfigurationManager.AppSettings["PrintOrderShiftBill"] == "true")
            //{
            //    OrderPrint print = new OrderPrint();
            //    print.PrintShiftBill(orderList, "", DateTime.Now, shiftItems.fromTableTitle, shiftItems.toTableTitle, shiftItems.shiftedBy, "Ordered", shiftItems.OrderMasterID, shiftItems.OrderNo, 0, "", "");
            //}

            roController.shiftItems(shiftItems);
            return JsonConvert.SerializeObject(new { Success = true, Message = "Items shifted successfully" });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { Success = false, Message = "Shift failed: " + ex.Message });
        }
    }

    [WebMethod]
    public string shiftItemsWeb(ShiftItems shiftItems)
    {
        try
        {
            List<OrderDetailClass> orderList = roController.GetOrderDetailsByMaster(shiftItems.OrderMasterID);
            List<OrderDetailClass> shiftOrderList = new List<OrderDetailClass>();
            decimal basicAmount = 0;
            
            shiftItems.itemList.ForEach((sitem) =>
            {
                var item = orderList.Find((itm) => itm.ItemId == sitem.ItemId);
                if (item != null)
                {
                    item.Quantity = sitem.Quantity;
                    shiftOrderList.Add(item);
                    basicAmount += (decimal)sitem.Quantity * item.Rate;
                }
            });

            // Send KOT Print for shift items
            if (System.Configuration.ConfigurationManager.AppSettings["PrintOrderShiftBill"] == "true")
            { 
                OrderPrint print = new OrderPrint();
                print.PrintShiftBill(shiftOrderList, "", DateTime.Now, shiftItems.fromTableTitle, shiftItems.toTableTitle, shiftItems.shiftedBy, "Ordered", shiftItems.OrderMasterID, shiftItems.OrderNo, 0, "", "");
            }
            
            shiftItems.BasicAmount = basicAmount;
            roController.shiftItems(shiftItems);
            
            return JsonConvert.SerializeObject(new { Success = true, Message = "Items shifted successfully" });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { Success = false, Message = "Shift failed: " + ex.Message });
        }
    }

    [WebMethod]
    public string getDataForShift(int orderMasterId)
    {
        List<RestroRoom> rooms = roController.getRestroRoom();
        return JsonConvert.SerializeObject(roController.getOrderDetailByOrderMasterId(orderMasterId));
    }
    [WebMethod]
    public string getRooms()
    {
        return serializer.Serialize(roController.getRestroRoom());
    }
    [WebMethod]
    public string getTablesData()
    {
        return serializer.Serialize(roController.getTablesDataWithCurrentSplitNo());
    }
    [WebMethod]
    public int SaveSales(SalesMaster salesMaster, List<SalesDetails> salesDetail, int splited, List<customerBilling> billingTerm, flatorperdiscount flatorperdiscount, SalesPayment payment, bool isFoodCourt)
    {
        int salesMasterId = roController.saveSalesBill(salesMaster, salesDetail, splited, billingTerm, flatorperdiscount);
        if (isFoodCourt)
        {
            payment.salesMasterId = salesMasterId;
            roController.UpdateSalesPayMode(payment);
        }
        return salesMasterId;
    }
    [WebMethod]
    public string SendToCBMS(int salesMasterId)
    {
        bool result = roController.SendToCBMS(salesMasterId);
        if (result)
        {
            CBMS cbms = new CBMS();
            cbms.sendSales(salesMasterId);
        }
        return result.ToString();
    }


}