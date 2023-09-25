using System;

namespace SageFrame.Sales
{
    public class customerBilling1
        {
            public float IsAdd { get; set; }
            public int ID { get; set; }
            public string BillTerm { get; set; }
            public decimal Rate { get; set; }
            public decimal Amount { get; set; }
        }
        public class SalesMaster1
        {

            public string TransactionNo { get; set; }
            public string ChequeNo { get; set; }
            public string PAN { get; set; }
            public int salesMasterId { get; set; }
            public string billNo
            {
                get;
                set;
            }
            public string GetBillNo()
            {
                return "RO" + fiscalYear + "-" + salesMasterId;
            }
            public string fiscalYear { get; set; }
            public DateTime BillDate { get; set; }
            public int RoomId { get; set; }
            public int TableId { get; set; }
            public decimal BasicAmount { get; set; }
            public decimal TermAmount { get; set; }
            public decimal NetAmount { get; set; }
            public int OrderMasterId { get; set; }
            public string Waiter { get; set; }
            public decimal totaldiscount { get; set; }
            public decimal sumKot { get; set; }
            public decimal sumKotBev { get; set; }
            public decimal sumBev { get; set; }
            public decimal disKot { get; set; }
            public decimal disBar { get; set; }

            public int SPMID { get; set; }
            public int ProviderID { get; set; }
            public int SeatNo { get; set; }
            public int IsSplit { get; set; }
            public decimal CashSales { get; set; }
            public decimal CheckSales { get; set; }
            public decimal SwapSales { get; set; }
            public decimal ProviderName { get; set; }
            public string CusName { get; set; }
            public int CusID { get; set; }
            public string AddedBy { get; set; }
            public string Address { get; set; }
        }
        public class SalesDetails1
        {
            public int salesMasterId { get; set; }
            public int ItemId { get; set; }
            public int qty { get; set; }
            public decimal rate { get; set; }
            public decimal Amount { get; set; }
            public decimal NetAmount { get; set; }
            public int CostCenterId { get; set; }
            public int OrderDetailsID { get; set; }

            public string CusName { get; set; }
            public int CusID { get; set; }
            public bool IsCombo { get; set; }
        }

        public partial class OrderDetailClass1
        {
            public string Note { get; set; }
            public int salesMasterId { get; set; }
            public bool IsCombo { get; set; }
            public int OrderDetailsID { get; set; }
            public int Quantity { get; set; }
            public decimal Rate { get; set; }
            public decimal SRate { get; set; }

            public decimal Amount { get; set; }

            public Decimal Bevrage { get; set; }
            public bool IsCancelled { get; set; }
            public int ItemId { get; set; }
            public string ItemName { get; set; }
            public int OrderMasterId { get; set; }
            public int SeatNo { get; set; }
            public string ExtraItem { get; set; }
            public decimal ExtraCharge { get; set; }
            public bool IsHomeDelivery { get; set; }
            public int HomeDeliveyNumber { get; set; }
            public int BillPaid { get; set; }
            public string Status { get; set; }
            public decimal BasicAmount { get; set; }
            public int restrotableId { get; set; }
            public string restrotableTitle { get; set; }
            public int restroRoomId { get; set; }
            public string restroRoom { get; set; }
            public string BillNo { get; set; }
            public string fiscalYear { get; set; }
            public string GetBillNo()
            {
                return "RO" + fiscalYear + "-" + BillNo;
            }
            public string Date { get; set; }
            public string ItemDescription { get; set; }
            public string ItemStatus { get; set; }

            public string AmountinWords { get; set; }
            public decimal totaldiscount { get; set; }
            public string billtime { get; set; }
            public decimal Price { get; set; }
            public int CostCenterId { get; set; }
            public int IsRunningOrder { get; set; }
            public int IsSplit { get; set; }
            public int HomePackQty { get; set; }
            public int PrintCount { get; set; }
            public int ROI_ItemId { get; set; }
            public string ROI_ItemName { get; set; }
            public string ITName { get; set; }
            public string ImagePath { get; set; }
            public string CusName { get; set; }
            public string PAN { get; set; }
            public string Address { get; set; }
            public string Cashier { get; set; }
            //public string restroRoom { get; set; }
            // public decimal NetAmount { get; set; }
        }
}
