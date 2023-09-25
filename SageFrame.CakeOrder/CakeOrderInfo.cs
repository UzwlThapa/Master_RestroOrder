using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SageFrame.CakeOrder
{

    public class WholeSaleOrderMaster
    {
        public int OrderMasterID { get; set; }

        public string BillNo { get; set; }
        public int OrderNo { get; set; }

        public DateTime Date { get; set; }

        public string Remarks { get; set; }

        public int CustomerId { get; set; }

        public string CustomerName { get; set; }

        public string Phone { get; set; }

        public string Address { get; set; }

        public string PAN { get; set; }

        public int StatusId { get; set; }

        public string CancelReason { get; set; }

        public string AddedBy { get; set; }

        public DateTime AddedOn { get; set; }

        public string UpdatedBy { get; set; }

        public DateTime UpdatedOn { get; set; }

        public string SalesType { get; set; }

        public decimal TotalAmount { get; set; }

        public bool VATforBill { get; set; }
        public string TableId { get; set; }
        public bool IsCancelled { get; set; }
        public int OrderTypeID { get; set; }
        public string UserName { get; set; }
        public int TokenNo { get; set; }

        public List<WholeSaleOrderList> WholeSaleOrderList { get; set; }
        public List<CustomerBilling> billingTerm { get; set; }
    }

    public class WholeSaleOrderList
    {
        public int OrderDetailsID { get; set; }

        public int OrderMasterId { get; set; }

        public int ItemId { get; set; }

        public string ItemName { get; set; }

        public double Quantity { get; set; }

        public decimal Rate { get; set; }

        public decimal Amount { get; set; }

        public string AddedBy { get; set; }

        public DateTime AddedOn { get; set; }

        public bool IsUpdated { get; set; }

        public string UpdatedBy { get; set; }

        public DateTime UpdatedOn { get; set; }

        public bool IsArchived { get; set; }

        public string ArchivedBy { get; set; }

        public DateTime ArchivedOn { get; set; }

        public string SalesType { get; set; }

        public int CustomerId { get; set; }

        public string CustomerName { get; set; }

        public string Phone { get; set; }

        public string Address { get; set; }

        public string PAN { get; set; }

        //public int OrderMasterID { get; set; }

        public string BillNo { get; set; }

        public DateTime Date { get; set; }

        public string Remarks { get; set; }

        public int StatusId { get; set; }

        public decimal AdvanceAmount { get; set; }

        public DateTime? DeliveryTime { get; set; }

        public string DeliveryService { get; set; }

        public string CancelReason { get; set; }

        public int SeatNo { get; set; }

        public bool IsCombo { get; set; }
        public string Note { get; set; }
        public string Status { get; set; }
        public string ROI_ItemName { get; set; }
        public int ROI_ItemId { get; set; }
        public int CostCenterId { get; set; }
    }

    public class CakeOrderMaster
    {
        public int OrderMasterID { get; set; }

        public string BillNo { get; set; }

        public DateTime Date { get; set; }

        public string Remarks { get; set; }

        public int CustomerId { get; set; }

        public string CustomerName { get; set; }

        public string Phone { get; set; }

        public string Address { get; set; }

        public string PAN { get; set; }

        public int StatusId { get; set; }

        public decimal AdvanceAmount { get; set; }

        public DateTime ? DeliveryTime { get; set; }

        public string DeliveryService { get; set; }

        public string CancelReason { get; set; }

        public string AddedBy { get; set; }

        public DateTime AddedOn { get; set; }

        public string UpdatedBy { get; set; }

        public DateTime UpdatedOn { get; set; }

        public string SalesType { get; set; }

        public decimal TotalAmount { get; set; }

        public bool VATforBill { get; set; }
        public string TableId { get; set; }
        public bool IsCancelled { get; set; }
        public int OrderTypeID { get; set; }
        public string UserName { get; set; }
        public int TokenNo { get; set; }

        public List<CakeOrderList> CakeOrderList { get; set; }
        public List<CustomerBilling> billingTerm { get; set; }

    }



    public class CakeOrderList
    {
        public int OrderDetailsID { get; set; }

        public int OrderMasterId { get; set; }

        public int ItemId { get; set; }

        public string ItemName { get; set; }

        public double Quantity { get; set; }

        public decimal Rate { get; set; }

        public decimal Amount { get; set; }

        public string AddedBy { get; set; }

        public DateTime AddedOn { get; set; }

        public bool IsUpdated { get; set; }

        public string UpdatedBy { get; set; }

        public DateTime UpdatedOn { get; set; }

        public bool IsArchived { get; set; }

        public string ArchivedBy { get; set; }

        public DateTime ArchivedOn { get; set; }

        public string SalesType { get; set; }

        public int CustomerId { get; set; }

        public string CustomerName { get; set; }

        public string Phone { get; set; }

        public string Address { get; set; }

        public string PAN { get; set; }

        //public int OrderMasterID { get; set; }

        public string BillNo { get; set; }

        public DateTime Date { get; set; }

        public string Remarks { get; set; }
        
        public int StatusId { get; set; }

        public decimal AdvanceAmount { get; set; }

        public DateTime? DeliveryTime { get; set; }

        public string DeliveryService { get; set; }

        public string CancelReason { get; set; }

        public int SeatNo { get; set; }

        public bool IsCombo { get; set; }
        public string Note { get; set; }
        public string Status { get; set; }
        public string ROI_ItemName { get; set; }
        public int ROI_ItemId { get; set; }
        public int CostCenterId { get; set; }
    }

    //public class CakeSalesBill
    //{
    //    public List<CakeOrderMaster> CakeOrderMaster { get; set; }
    //    //public List<CakeOrderDetail> orderDetail { get; set; }
    //    public List<CustomerBilling> billingTerm { get; set; }
    //    //public List<costCenter> cuscenter { get; set; }
    //    //public RoomBookingsInfo RoomBooking { get; set; }
    //    //public List<Token> Token { get; set; }
    //    public bool VATforBill { get; set; }
    //}
    public class CustomerBilling
    {
        public bool IsAdd { get; set; }

        public int ID { get; set; }

        public string BillTerm { get; set; }

        public decimal Rate { get; set; }

        public decimal Amount { get; set; }

        public string SalesType { get; set; }
    }

    public class CakeOrderItems
    {
        public int OrderMasterID { get; set; }

        public string CustomerName { get; set; }

        public string Phone { get; set; }

        public string Address { get; set; }

        public decimal AdvanceAmount { get; set; }

        public DateTime? DeliveryTime { get; set; }

        public string DeliveryService { get; set; }

        public int OrderDetailsID { get; set; }

        public int ItemId { get; set; }

        public string ItemName { get; set; }

        public double Quantity { get; set; }

        public decimal Rate { get; set; }

        public decimal Amount { get; set; }
    }

    public class CakeSalesMaster
    {
        public string BillNo { get; set; }

        public DateTime BillDate { get; set; }

        public int OrderMasterId { get; set; }

        public int CustomerId { get; set; }

        public string CustomerName { get; set; }

        public string ContactNumber { get; set; }

        public string PAN { get; set; }

        public string Address { get; set; }

        public decimal BasicAmount { get; set; }

        public decimal TermAmount { get; set; }

        public decimal NetAmount { get; set; }

        public decimal AdvancePayment { get; set; }

        public string Reasons { get; set; }

        public string NepaliInvoiceDate { get; set; }

        public string AddedBy { get; set; }

        public string SalesType { get; set; }

        public decimal TenderAmount { get; set; }

        public decimal ReturnAmount { get; set; }

        public DateTime DeliveryTime { get; set; }

        //public List<usedBillingTermInfo> usedBillingTerm { get; set; }
    }

    public class CakeSalesDetails
    {
        public int salesMasterId { get; set; }

        public int ItemId { get; set; }

        public string ItemName { get; set; }

        public float Quantity { get; set; }

        public decimal Rate { get; set; }

        public decimal Amount { get; set; }

        public decimal NetAmount { get; set; }

        public int CostCenterId { get; set; }

        public int OrderDetailsID { get; set; }

        public string SalesType { get; set; }
        //public List<SalesDetailExtra> extraSales { get; set; }
    }

    public class SalesPayMode
    {
        public int salesMasterId { get; set; }

        public string SPMID { get; set; }

        public string ChequeNo { get; set; }

        public string TransactionNo { get; set; }

        public string ProviderID { get; set; }

        public string CusID { get; set; }

        public string Customer { get; set; }

        public string Address { get; set; }

        public string PAN { get; set; }

        public decimal PayAmount { get; set; }

        public decimal TenderAmount { get; set; }

        public decimal ReturnAmount { get; set; }

        public string Remarks { get; set; }

        public decimal ReturnPayment { get; set; }

        public string SalesType { get; set; }
    }

    public class Cakeflatorperdiscount
    {
        public int SalesMasterId { get; set; }

        public decimal DiscountValue { get; set; }

        public bool IsFlatDis { get; set; }

        public decimal TotalDiscount { get; set; }

        public decimal BasicAmount { get; set; }

        public string SalesType { get; set; }
    }

    //public partial class Bill
    //{
    //    public int ItemId { get; set; }

    //    public double Quantity { get; set; }

    //    public decimal Rate { get; set; }

    //    public int OrderMasterId { get; set; }

    //    public string Note { get; set; }

    //    public decimal ExtraCharge { get; set; }

    //    public string ITName { get; set; }

    //    public DateTime DATE { get; set; }

    //    public string NepaliInvoiceDate { get; set; }

    //    public decimal BasicAmount { get; set; }

    //    public decimal NetAmount { get; set; }

    //    public decimal TenderAmount { get; set; }

    //    public decimal ReturnAmount { get; set; }

    //    public string PrintCount { get; set; }

    //    public string BillNo { get; set; }

    //    public string fiscalYear { get; set; }

    //    public string CusID { get; set; }

    //    public string Customer { get; set; }

    //    public string ContactNumber { get; set; }

    //    public string PAN { get; set; }

    //    public string Address { get; set; }

    //    public int salesMasterId { get; set; }

    //    public string Cashier { get; set; }

    //    public decimal AdvanceAmount { get; set; }

    //    public DateTime? DeliveryTime { get; set; }

    //    public string DeliveryService { get; set; }
    //}
    public class OrderExtraItems
    {
        public int CompId { get; set; }
        public int CompMasterID { get; set; }
        public int ExtraOrderID { get; set; }
        public int OrderMasterId { get; set; }
        public int OrderDetailsID { get; set; }
        public int ItemID { get; set; }
        public int ExtraItemID { get; set; }
        public int SeatNo { get; set; }
        public string ExtraItem { get; set; }
        public int Quantity { get; set; }
        public decimal ExtraPrice { get; set; }
        public string ItemStatus { get; set; }
    }
    public class Tokens
    {
        public int CustomerID { get; set; }
        public string CustomerName { get; set; }
        public string Phone { get; set; }
        public int TokenNo { get; set; }
        public int OrderNo { get; set; }
        public string Address { get; set; }
        public int OrderMasterId { get; set; }
        public string tableDate { get; set; }
        public decimal discount { get; set; }
        public int GuestNo { get; set; }
        public string TelMobile { get; set; }
    }
}
