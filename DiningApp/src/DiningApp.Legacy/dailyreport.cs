using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SageFrame.RestroOrder
{
    public class dailyreport
    {
        public Decimal NetAmount { get; set; }
        public string Waiter { get; set; }
        public string restroRoom { get; set; }
        public string restrotableTitle { get; set; }
        public string BillDate { get; set; }
        public int OrderMasterId { get; set; }
        public string billNo { get; set; }
        public string CusName { get; set; }
        public string UptoNowPaid { get; set; }
        public string RemainingBalance { get; set; }
        public string BillTerm { get; set; }
        public Decimal Amount { get; set; }
        public Decimal sumAmount { get; set; }
        public int salesMasterId { get; set; }
        public string ArchivedBy { get; set; }
        public string Reasons { get; set; }
        public bool IsArchived { get; set; }
        public string ArchivedOn { get; set; }
        public int PurchaseMainID { get; set; }
        public string VenderName { get; set; }
        public int MembershipID { get; set; }
        public string Address { get; set; }
        public string PostedOn { get; set; }
        public string PostedBy { get; set; }
        public string ITName { get; set; }
        public decimal Qnty { get; set; }
        public string UnitName { get; set; }
        public string BatchNo { get; set; }
        public string ExpDate { get; set; }
        public string LotNo { get; set; }
        public decimal UnitRate { get; set; }
        public int AMId { get; set; }
        public string fyName { get; set; }
        public string StName { get; set; }
        public string AdjustmentTypeName { get; set; }
        public string AMNo { get; set; }
        public string PuNo { get; set; }
        public int SPMID { get; set; }
        public decimal SubTotal { get; set; }
        public decimal totaldiscount { get; set; }
        public decimal BasicAmount { get; set; }
        public decimal ServiceCharge { get; set; }
        public decimal Vat { get; set; }
        public int PrintCount { get; set; }
        public string Fname { get; set; }
        public string Lname { get; set; }
        public string CancelReason { get; set; }
        public string CancelDate { get; set; }
        public string CancelBy { get; set; }
        public bool IsVat { get; set; }
        
    }
}
