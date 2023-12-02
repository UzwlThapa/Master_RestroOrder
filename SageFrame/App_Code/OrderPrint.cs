using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using SageFrame.CakeOrder;
using SageFrame.RestroOrder;
/// <summary>
/// Summary description for OrderPrint
/// </summary>
public class OrderPrint
{
    public string PrintOrders(List<OrderDetailClass> orderDetailList, string tableId, DateTime time, string userName, string OrderStatus, int orderMasterID, int OrderNo, int TokenNo, string CustomerName, string Phone)
    {
        string printSuccessful = "";
        RestrOrderController rocobj = new RestrOrderController();
        List<costCenter> coc = rocobj.getcostcenter();
        foreach (OrderDetailClass orderDetail in orderDetailList)
        {
            orderDetail.OrderMasterId = orderMasterID;
            int itemID = (orderDetail.ItemId == 0 ? orderDetail.ROI_ItemId : orderDetail.ItemId);
            if (itemID == -1)
            {
                itemID = orderDetail.ROI_ItemId;
            }
            ROInvItem item = rocobj.GetItemDetail(itemID, orderDetail.IsCombo);
            orderDetail.ItemName = item.ITName;
            orderDetail.CostCenterId = item.ItemCostCentreID;
            orderDetail.Rate = (decimal)item.SRate;
        }

        Printer print = new Printer();

        KOT kot = new KOT();
        kot.OrderMasterId = orderMasterID.ToString();
        kot.TableId = tableId;
        kot.Date = time.ToShortDateString();
        kot.Time = time.ToLongTimeString();
        kot.Waiter = userName;
        kot.Status = OrderStatus;
        kot.OrderNo = OrderNo;
        kot.TokenNo = TokenNo;
        kot.Customer = CustomerName;
        kot.Contact = Phone;

        var billingPrinter = coc[2].DefaultPrinter;

        foreach (costCenter cc in coc)
        {
            List<OrderDetailClass> order = orderDetailList.Where(p => p.CostCenterId == cc.CostCenterID).ToList();

            var DBPrint = bool.Parse(ConfigurationManager.AppSettings["DBPrinting"]);
            var printer = ConfigurationManager.AppSettings[cc.CostCenterName] == null ? "" : ConfigurationManager.AppSettings[cc.CostCenterName].ToString();

            if (order != null && order.Count > 0)
            {

                kot.KOTItems = order;
                kot.CostCenterTitle = cc.CostCenterName + " Order";
                try
                {

                    int kotcount = int.Parse(ConfigurationManager.AppSettings["KOTPRINTCOUNT"].ToString());
                    for (int i = 0; i < kotcount; i++)
                    {
                        if (DBPrint)
                        {
                            print.PrintKOT(cc.DefaultPrinter, kot);
                        }
                        else
                        {
                            print.PrintKOT(printer, kot);
                        }

                    }

                }
                catch (Exception)
                {
                    printSuccessful += "_" + cc.CostCenterName;
                }

            }
        }

        //bool orderestimate = bool.Parse(ConfigurationManager.AppSettings["FoodCourtEstimateOrders"].ToString());
        //if (tableId == "FoodCourt" && orderestimate)
        //{
        //    print.PrintBill(billingPrinter, kot, orderDetailList);

        //}
        return printSuccessful;

    }

    public void PrintBill(SalesBill bill)
    {
        try
        {
            Printer print = new Printer();
            RestrOrderController rocobj = new RestrOrderController();
            List<costCenter> coc = rocobj.getcostcenter();
            var billingPrinter = coc[2].DefaultPrinter;
            print.PrintViewBill(billingPrinter, bill);
        }
        catch (Exception)
        {

            throw;
        }
    }

    public string PrintCakeOrders(List<CakeOrderList> CakeOrderList, string tableId, DateTime time, string userName, string OrderStatus, int orderMasterID, int OrderNo, int TokenNo, string CustomerName, string Phone)
    {
        string printSuccessful = "";
        RestrOrderController rocobj = new RestrOrderController();
        CakeOrderController cor = new CakeOrderController();
        List<costCenter> coc = rocobj.getcostcenter();
        foreach (CakeOrderList orderDetail in CakeOrderList)
        {
            orderDetail.OrderMasterId = orderMasterID;
            int itemID = (orderDetail.ItemId == 0 ? orderDetail.ROI_ItemId : orderDetail.ItemId);
            if (itemID == -1)
            {
                itemID = orderDetail.ROI_ItemId;
            }
            ROInvItem item = rocobj.GetItemDetail(itemID, orderDetail.IsCombo);
            orderDetail.ItemName = item.ITName;
            orderDetail.CostCenterId = item.ItemCostCentreID;
        }

        Printer print = new Printer();

        KOT kot = new KOT();
        kot.OrderMasterId = orderMasterID.ToString();
        kot.TableId = tableId;
        kot.Date = time.ToShortDateString();
        kot.Time = time.ToLongTimeString();
        kot.Waiter = userName;
        kot.Status = OrderStatus;
        kot.OrderNo = OrderNo;
        kot.TokenNo = TokenNo;
        kot.Customer = CustomerName;
        kot.Contact = Phone;



        foreach (costCenter cc in coc)
        {
            var DBPrint = bool.Parse(ConfigurationManager.AppSettings["DBPrinting"]);
            var printer = ConfigurationManager.AppSettings[cc.CostCenterName] == null ? "" : ConfigurationManager.AppSettings[cc.CostCenterName].ToString();

            List<CakeOrderList> order = CakeOrderList.Where(p => p.CostCenterId == cc.CostCenterID).ToList();
            if (order != null && order.Count > 0)
            {
                kot.KOTItem = order;
                kot.CostCenterTitle = cc.CostCenterName + " Order";
                try
                {
                    if (DBPrint)
                    {
                        print.PrintKOT(cc.DefaultPrinter, kot);
                    }
                    else
                    {
                        print.PrintKOT(printer, kot);
                    }
                }
                catch (Exception)
                {
                    printSuccessful += "_" + cc.CostCenterName;
                }

            }
        }
        return printSuccessful;
    }

}