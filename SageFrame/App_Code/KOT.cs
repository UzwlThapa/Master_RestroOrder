
using System.Collections.Generic;
using SageFrame.CakeOrder;
using SageFrame.RestroOrder;

/// <summary>
/// Summary description for KOT
/// </summary>
public class KOT
{
    public string CompanyName { get; set; }

    public string CostCenterTitle { get; set; }
    public int CompMasterID { get; set; }
    public string OrderMasterId { get; set; }
    public string TableId { get; set; }
    public string Date { get; set; }
    public string Time { get; set; }
    public string Waiter { get; set; }
    public string Status { get; set; }
    public int TokenNo { get; set; }
    public int OrderNo { get; set; }
    public string Customer { get; set; }
    public string Contact { get; set; }
    public List<OrderDetailClass> KOTItems { get; set; }
    public List<OrderDetailClass> BillItems { get; set; }
    public List<CakeOrderList> KOTItem { get; set; }


    public KOT()
    {
    }
    public KOT(string companyName, string costCenterTitle,string orderMasterId, string tableId, string date, string time, string waiter, string status, List<OrderDetailClass> KOTItems, List<OrderDetailClass> BillItems, int TokenNo, int OrderNo, string CustomerName, string Phone)
    {
        this.CompanyName = CompanyName;
        this.CostCenterTitle = costCenterTitle;
        this.OrderMasterId = orderMasterId;
        this.TableId = tableId;
        this.Date = date;
        this.Waiter = waiter;
        this.Status = status;
        this.TokenNo = TokenNo;
        this.OrderNo = OrderNo;
        this.Customer = CustomerName;
        this.Contact = Phone;
        this.KOTItems = KOTItems;
        this.BillItems = BillItems;
    }
}