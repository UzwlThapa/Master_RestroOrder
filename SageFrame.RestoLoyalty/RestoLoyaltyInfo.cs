using System;
using System.Collections.Generic;

namespace SageFrame.RestoLoyalty
{
    public class RestoLoyaltyInfo
    {
    }

    public class itemsalesReport
    {
        public string BillDate { get; set; }
        public string CostCenterName { get; set; }
        public string ITName { get; set; }
        public int QTY { get; set; }
        public decimal rate { get; set; }
        public decimal NetAmount { get; set; }
        public bool IsCombo { get; set; }
        
    }

    public class BalanceTransaction
    {
        public int MemberPayID { get; set; }
        public int MemberID { get; set; }
        public decimal RemainingAmount { get; set; }
        public decimal PayAmount { get; set; }
        public decimal CreditAmount { get; set; }
        public decimal SettlementAmount { get; set; }
        public string AddedOn { get; set; }
        public string AddedBy { get; set; }
        public bool IsActive { get; set; }
        public bool IsCancelled { get; set; }
        public int status { get; set; }
        public string billNo { get; set; }
        public int iscustomer { get; set; }
        public int salesMasterId { get; set; }
        public string Remarks { get; set; }
        public string SalesType { get; set; }
    }
    public class MemberInfo
    {
        public int CusCreditID { get; set; }
        public string Addresss { get; set; }
        public string Name { get; set; }
        public int MembershipID { get; set; }
        public int VendorID { get; set; }
        public string Fname { get; set; }
        public string Lname { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string TelHome { get; set; }
        public string TelWork { get; set; }
        public string TelMobile { get; set; }
        public string Email { get; set; }
        public string Occupation { get; set; }
        public string Company { get; set; }
        public string Birthday { get; set; }
        public string Anniversary { get; set; }
        public string CardNumber { get; set; }
        public string DateOfIssue { get; set; }
        public string DateOfExpire { get; set; }
        public decimal discount { get; set; }
        public string PAN { get; set; }
        public bool IsCustomer { get; set; }
        public decimal RemainingBalance { get; set; }

        public decimal UptoNowPaid { get; set; }
        public decimal PayAmount { get; set; }
        public decimal SettlementAmount { get; set; }
        public string AddedBy { get; set; }
        public bool IsVat { get; set; }
        public int GoodReceivedMainId { get; set; }
        public decimal OpeningBalance { get; set; }
    }

    public class AgentInfo
    {
        public int CusCreditID { get; set; }
        public string Addresss { get; set; }
        public string Name { get; set; }
        public int MembershipID { get; set; }
        public int VendorID { get; set; }
        public string Fname { get; set; }
        public string Lname { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        //public string TelHome { get; set; }
        public string TelWork { get; set; }
        public string TelMobile { get; set; }
        public string Email { get; set; }
        //public string Occupation { get; set; }
        public string Company { get; set; }
        //public string Birthday { get; set; }
        //public string Anniversary { get; set; }
       // public string CardNumber { get; set; }
        public string DateOfIssue { get; set; }
        public string DateOfExpire { get; set; }
        public decimal Commission { get; set; }
        public string PAN { get; set; }
        public bool IsAgent { get; set; }
        public decimal RemainingBalance { get; set; }

        public decimal UptoNowPaid { get; set; }
        public decimal PayAmount { get; set; }
        public decimal SettlementAmount { get; set; }
        public string AddedBy { get; set; }
        public bool IsVat { get; set; }
        public int GoodReceivedMainId { get; set; }
    }

    public class PickInfo
    {
        public int OrderID { get; set; }
        public string ItemName { get; set; }
        public string Name { get; set; }
        public string OrderDate { get; set; }
        public string OrderTime { get; set; }
        public string AppoinmentReceiveTime { get; set; }
        public string AppoinmentReceiveDate { get; set; }
        public string OrderModulID { get; set; }
    }

    //public class roistore
    //{
    //    public int StoreId { get; set; }
    //    public int PSTId { get; set; }
    //    public string StName { get; set; }
    //    public int STId { get; set; }
    //    public string text { get; set; }
    //    public string PName { get; set; }
    //}

    public class ItemInfo
         {
        public int ItemRateID { get; set; }
        public int ITId { get; set; }

        public string itemName { get; set; }

        public string ITName { get; set; }
        public int ItemId { get; set; }

        public string UnitDescription { get; set; }

        public int UnitId { get; set; }

        public string Particulars { get; set; }


        public int RId { get; set; }
       
       
        public decimal PRate { get; set; }
        public decimal SRate { get; set; }
        public string ValidFrom { get; set; }
        public string PostedBy { get; set; }
        public DateTime PostedOn { get; set; }

         

    }

    public class BalanceInfo
    {
        public int ItemBalID { get; set; }
        public int ITId { get; set; }
        public int PDId { get; set; }
        public int STId { get; set; }
        public int OPBal { get; set; }
        public int CLBal { get; set; }
        public string ITName { get; set; }
        public string StName { get; set; }
        public string UnitDescription { get; set; }
        public int LargeUnit { get; set; }
        public string Symbol { get; set; }
        public decimal OPRate { get; set; }
        public decimal TotalValue { get; set; }

    }
    public class ExtraBilling
    {
        public int ExtraBillingID { get; set; }
        public string CustomerName { get; set; }
        public string IssueDate { get; set; }
        public string Pan { get; set; }
        public string NetTotal { get; set; }
        public string Vat { get; set; }
        public string GrandTotal { get; set; }
        public string Item { get; set; }
        public string Rate { get; set; }
        public string Quantity { get; set; }
        public string Discount { get; set; }
        public string Total { get; set; }
        public List<extraBillingDetails> ExtrabillingObjectDetails { get; set; }

    }
    public class extraBillingDetails
    {
      //  public int ExtraBillingDetailsID { get; set; }
        public int BillingID { get; set; }

        public string Item { get; set; }

        public string Rate { get; set; }

        public string Quantity { get; set; }

        public string Total { get; set; }

    }

    public class CreditPayment
    {
        public int MemberPayId { get; set; }
        public int MemberID { get; set; }
        public int PaymentModeID { get; set; }
        public int ProviderID { get; set; }
        public string TransactionNo { get; set; }
        public decimal PayAmount { get; set; }
        public string VoucherNo { get; set; }
        public int TransactionId { get; set; }
        public string ProviderName { get; set; }
        public decimal SettlementAmount { get; set; }
        public string AddedOn { get; set; }
        public string CustomerName { get; set; }


    }

    public class CardInfo
    {
        public int CardTypeID { get; set; }
        public string CardName { get; set; }
        public string Description { get; set; }
        public decimal discount { get; set; }

    }

}
