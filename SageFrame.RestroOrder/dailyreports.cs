using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SageFrame.RestroOrder
{
    public class dailyreports
    {
        public int OrderMasterId { get; set; }
        public int salesMasterId { get; set; }
        public int GuestNo { get; set; }
        public string BillDate { get; set; }
        public string billNo { get; set; }
        public string Waiter { get; set; }
        public string restrotableTitle { get; set; }
        public string TableId { get; set; }
        public string restroRoom { get; set; }
        public decimal SubTotal { get; set; }
        public decimal totaldiscount { get; set; }
        public decimal NonTaxable { get; set; }
        public decimal BasicAmount { get; set; }
        public decimal ServiceCharge { get; set; }
        public decimal Vat { get; set; }
        public decimal NetAmount { get; set; }
        public int Status { get; set; }
        public int PrintCount { get; set; }
        public int SPMID { get; set; }
        public string PaymentModes { get; set; }
        public decimal ReceivedAmount { get; set; }
        public decimal SurplusDeficit { get; set; }
        public string DeliveryTime { get; set; }
        public string DeliveredBy { get; set; }
        public string Date { get; set; }
        public string SalesType { get; set; }
        public bool BillCancelled { get; set; }
        public bool IsArchived { get; set; }
        public bool EditBill { get; set; }
    }
}
