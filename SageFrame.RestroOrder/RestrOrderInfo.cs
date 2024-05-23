using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace SageFrame.RestroOrder
{
    #region
    public class SalesReport
    {
        public string BillNo { get; set; }
        public string BillTime { get; set; }
        public decimal BasicAmount { get; set; }
        public decimal TotalDiscount { get; set; }
        public decimal ServiceCharge { get; set; }
        public decimal VAT { get; set; }
        public decimal NetAmount { get; set; }
        public decimal TenderAmount { get; set; }
        public decimal ReturnAmount { get; set; }
        public decimal ReceivedAmount { get; set; }
        public decimal ChequeAmount { get; set; }
        public decimal CardAmount { get; set; }
        public decimal CreditAmount { get; set; }
        public string PaymentMode { get; set; }
        public string Customer { get; set; }
    }

    public class StockReport
    {
        public string ItemID { get; set; }
        public string ItemName { get; set; }
        public decimal OpeningBalance { get; set; }
        public decimal PurchaseBalance { get; set; }
        public decimal ConsumedBalance { get; set; }
        public decimal ClosingBalance { get; set; }
        public string Symbol { get; set; }
    }
    public class CreditorBalanceReport
    {
        public string MembershipID { get; set; }
        public string Fname { get; set; }
        public string Lname { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string TelHome { get; set; }
        public string TelWork { get; set; }
        public string TelMobile { get; set; }
        public string CardNumber { get; set; }
        public string DateOfIssue { get; set; }
        public string DateOfExpire { get; set; }
        public string PAN { get; set; }
        public string RemainingBalance { get; set; }
    }
    public class SummaryReport
    {
        public decimal OpeningBalance { get; set; }
        public decimal Cash { get; set; }
        public decimal Cheque { get; set; }
        public decimal Card { get; set; }
        public decimal Credit { get; set; }
        public decimal eSewa { get; set; }
        public decimal FonePay { get; set; }
        public decimal TotalCashReceived { get; set; }
        public decimal SurplusDeficit { get; set; }
        public decimal CreditCollectedInCash { get; set; }
        public decimal CreditCollectedIneSewa { get; set; }
        public decimal CreditCollectedInFonePay { get; set; }
        public decimal CreditCollectedInCard { get; set; }
        public decimal CreditCollectedInCheque { get; set; }
        public decimal AdvanceCollectedInCash { get; set; }
        public decimal AdvanceCollectedInCard { get; set; }
        public decimal AdvanceCollectedIneSewa { get; set; }
        public decimal AdvanceCollectedInFonePay { get; set; }
        public decimal AdvanceCollectedInCheque { get; set; }
        public decimal CashInCounter { get; set; }
        public decimal CashSettlement { get; set; }
        public decimal ClosingBalance { get; set; }
        public decimal TotalExpenses { get; set; }
        public decimal TotalSales { get; set; }




    }

    #endregion
    #region CBMS
    public class BillViewModel
    {
        public string username { get; set; }
        public string password { get; set; }
        public string seller_pan { get; set; }
        public string buyer_pan { get; set; }
        public string fiscal_year { get; set; }
        public string buyer_name { get; set; }
        public string invoice_number { get; set; }
        public string invoice_date { get; set; }
        public double total_sales { get; set; }
        public Nullable<double> taxable_sales_vat { get; set; }
        public Nullable<double> vat { get; set; }
        public Nullable<double> excisable_amount { get; set; }
        public Nullable<double> excise { get; set; }
        public Nullable<double> taxable_sales_hst { get; set; }
        public Nullable<double> hst { get; set; }
        public Nullable<double> amount_for_esf { get; set; }
        public Nullable<double> esf { get; set; }
        public Nullable<double> export_sales { get; set; }
        public Nullable<double> tax_exempted_sales { get; set; }
        public bool isrealtime { get; set; }
        public DateTime datetimeClient { get; set; }
    }
    public class BillPostLog
    {
        public int LogID { get; set; }
        public string seller_pan { get; set; }
        public string buyer_pan { get; set; }
        public string fiscal_year { get; set; }
        public string buyer_name { get; set; }
        public string invoice_number { get; set; }
        public string invoice_date { get; set; }
        public double total_sales { get; set; }
        public double taxable_sales_vat { get; set; }
        public double vat { get; set; }
        public double excisable_amount { get; set; }
        public double excise { get; set; }
        public double taxable_sales_hst { get; set; }
        public double hst { get; set; }
        public double amount_for_esf { get; set; }
        public double esf { get; set; }
        public double export_sales { get; set; }
        public double tax_exempted_sales { get; set; }
        public bool isrealtime { get; set; }
        public DateTime datetimeClient { get; set; }
        public int SalesMasterId { get; set; }
        public decimal Qty { get; set; }


    }
    public class BillReturnViewModel
    {
        public string username { get; set; }
        public string password { get; set; }
        public string seller_pan { get; set; }
        public string buyer_pan { get; set; }
        public string fiscal_year { get; set; }
        public string buyer_name { get; set; }
        public string ref_invoice_number { get; set; }
        public string credit_note_number { get; set; }
        public string credit_note_date { get; set; }
        public string reason_for_return { get; set; }
        public double total_sales { get; set; }
        public Nullable<double> taxable_sales_vat { get; set; }
        public Nullable<double> vat { get; set; }
        public Nullable<double> excisable_amount { get; set; }
        public Nullable<double> excise { get; set; }
        public Nullable<double> taxable_sales_hst { get; set; }
        public Nullable<double> hst { get; set; }
        public Nullable<double> amount_for_esf { get; set; }
        public Nullable<double> esf { get; set; }
        public Nullable<double> export_sales { get; set; }
        public Nullable<double> tax_exempted_sales { get; set; }
        public bool isrealtime { get; set; }
        public DateTime datetimeClient { get; set; }
    }
    public class ReturnBillPostLog
    {
        public int ReturnLogID { get; set; }
        public string seller_pan { get; set; }
        public string buyer_pan { get; set; }
        public string fiscal_year { get; set; }
        public string buyer_name { get; set; }
        public string ref_invoice_number { get; set; }
        public string credit_note_number { get; set; }
        public string credit_note_date { get; set; }
        public string reason_for_return { get; set; }
        public double total_sales { get; set; }
        public double taxable_sales_vat { get; set; }
        public double vat { get; set; }
        public double excisable_amount { get; set; }
        public double excise { get; set; }
        public double taxable_sales_hst { get; set; }
        public double hst { get; set; }
        public double amount_for_esf { get; set; }
        public double esf { get; set; }
        public double export_sales { get; set; }
        public double tax_exempted_sales { get; set; }
        public bool isrealtime { get; set; }
        public DateTime datetimeClient { get; set; }
        public int SalesMasterId { get; set; }
    }

    public class CbmsData
    {
        public int TotalSales { get; set; }
        public int SyncedSalesBill { get; set; }
        public int UnSyncedSalesBill { get; set; }
        public int SyncedReturnedSalesBill { get; set; }
        public int UnSyncedReturnedSalesBill { get; set; }
    }

    public class CbmsSyncedData
    {
        public string SyncedDate { get; set; }
        public int NoOfBills { get; set; }
        public decimal TotalSalesAmount { get; set; }
        public decimal TaxableSalesAmount { get; set; }
        public decimal VatAmount { get; set; }
    }
    #endregion

    #region Restro
    //this is new
    public class itemsales
    {
        public string BillDate { get; set; }
        public string CostCenterName { get; set; }
        public string ITName { get; set; }
        public float QTY { get; set; }
        public string Date { get; set; }
        public string Quantity { get; set; }
        public decimal rate { get; set; }
        public decimal NetAmount { get; set; }
        public bool IsCombo { get; set; }
        public string ITUnit { get; set; }
        public int ITId { get; set; }

        public string Details { get; set; }
    }


    public class PrintDetail
    {
        public int PrintId { get; set; }
        public string PrintBillNo { get; set; }
        public int PrintedNumber { get; set; }
        public string PrintedDate { get; set; }
        public string PrintedBy { get; set; }
    }
    public class RestrOrderInfo
    {
        public string TableId { get; set; }
        public static int comId { get; set; }
        public decimal amount { get; set; }
        public string Status { get; set; }
        public int RoomTypeID { get; set; }
        public int restroRoomId { get; set; }
        public string MergeID { get; set; }
        public string MergeTableName { get; set; }
    }

    public class MergeTableInfo
    {
        public int MergeID { get; set; }
        public int TableID { get; set; }
        public int MergeTableList { get; set; }
        public string TableName { get; set; }
    }
    public class MergeList
    {
        public List<MergeTableInfo> MergeTableInfo { get; set; }
    }
    public class CurrencyClass
    {
        public int CurrencyID { get; set; }
        public string CurrencyName { get; set; }
        public string SubCurrencyName { get; set; }
        public string CurrencyIcon { get; set; }

    }
    public class CategoriesClass
    {
        public int ItemId { get; set; }
        public string ItemName { get; set; }
        public int PItemId { get; set; }
        public string ImagePath { get; set; }
        public int CategoriesID { get; set; }
        public int MenuID { get; set; }
        public string CategoriesName { get; set; }
        public string PhotoPath { get; set; }
        public string MenuName { get; set; }
        public bool IsCategory { get; set; }
        public decimal SRate { get; set; }
        public List<ItemsClass> itemList { get; set; }
        public bool IsOutOfStock { get; set; }

        public void AddItem(ItemsClass item)
        {
            List<ItemsClass> itemquery = new List<ItemsClass>();
            itemquery.Add(item);
        }
        public string LanguageMenuText { get; set; }
    }
    public class ItemsClass
    {
        public decimal SRate { get; set; }
        public decimal PRate { get; set; }

        public int ROI_ItemId { get; set; }
        public int ItemID { get; set; }
        public string ItemName { get; set; }
        public string ImagePath { get; set; }

        public string ItemDescription { get; set; }
        public string PhotoPath { get; set; }
        public decimal Price { get; set; }
        public string PriceWithIcon { get; set; }
        public string ItemCode { get; set; }
        public int UnitID { get; set; }
        public int CostCenterId { get; set; }
        public string CostCenterName { get; set; }
        public string RowTotal { get; set; }
        public int CategoriesID { get; set; }
        public string CategoriesName { get; set; }
        public string UnitName { get; set; }
        public string Note { get; set; }
        public string ExtraCharge { get; set; }
        public float Quantity { get; set; }
        public int SeatNo { get; set; }
        public int GuestNo { get; set; }
        public bool IsSplit { get; set; }
        public string Remarks { get; set; }
        public int OrderDetailsID { get; set; }
        public bool IsCancelled { get; set; }
        public string Status { get; set; }
        public int RoomId { get; set; }
        public int OrderMasterId { get; set; }
        public int TableId { get; set; }
        public int OrderId { get; set; }
        public string restrotableTitle { get; set; }
        public int BillPaid { get; set; }
        public string room { get; set; }
        public bool IsCombo { get; set; }
        public List<UnitClass> unitList { get; set; }
        public void AddUnit(UnitClass unit)
        {
            unitList.Add(unit);
        }
        //public int CategoriesID { get; set; }

        public string ItemStatus { get; set; }
        public string Waiter { get; set; }
        public bool IsCategory { get; set; }
        public bool IsOutOfStock { get; set; }
        public string LanguageMenuText { get; set; }
        public int CustomerID { get; set; }
        public string CustomerName { get; set; }
        public string Address { get; set; }
        public string Phone { get; set; }
        public int TokenNo { get; set; }
    }
    public partial class MenuClass
    {
        public string ImagePath { get; set; }
        public int ROrderLevel { get; set; }
        public int ItemId { get; set; }
        public string ItemName { get; set; }
        public string LookupName { get; set; }
        public int MenuID { get; set; }
        public string MenuName { get; set; }
        public string PhotoPath { get; set; }

        public List<CategoriesClass> categoryList { get; set; }
        public void AddCategory(CategoriesClass item)
        {
            //categoryList = new List<ItemsClass>();
            categoryList.Add(item);

        }
        public string LanguageMenuText { get; set; }
    }

    public partial class ClassforMenuItem
    {
        public int ItemId { get; set; }
        public string ItemName { get; set; }
        public int PItemId { get; set; }
        public int ItemCode { get; set; }
        public int CostCenterID { get; set; }
        public int MUnitId { get; set; }
        public int DSUnitId { get; set; }
        public int DPUnitId { get; set; }
        public bool IsExpirable { get; set; }
        public bool IsProduMaterial { get; set; }
        public int Level { get; set; }
        public bool IsUnitWiseRate { get; set; }


    }

    public class SalesDetailClass
    {
        public int SalesDetailId { get; set; }
        public int StoreId { get; set; }
        public int ItemId { get; set; }
        public int SalesQty { get; set; }
        public int SalesUnit { get; set; }
        public int SalesAmt { get; set; }
    }



    public partial class OrderDetailClass
    {
        public int CompId { get; set; }
        public int CompMasterID { get; set; }
        public string Note { get; set; }
        public int salesMasterId { get; set; }
        public bool IsCombo { get; set; }
        public int OrderDetailsID { get; set; }
        public float Quantity { get; set; }
        public decimal Rate { get; set; }
        public decimal SRate { get; set; }
        // decimal ExciseRate { get; set; }
        //  public System.DateTime Date { get; set; }
        public decimal Amount { get; set; }
        public Decimal Bevrage { get; set; }
        public bool IsCancelled { get; set; }
        public int ItemId { get; set; }
        public bool IsTaxable { get; set; }
        public string ItemName { get; set; }
        public int OrderMasterId { get; set; }
        public int SeatNo { get; set; }
        public int GuestNo { get; set; }
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
        public string NepaliInvoiceDate { get; set; }
        public string ItemDescription { get; set; }
        public string ItemStatus { get; set; }

        public string AmountinWords { get; set; }
        public decimal totaldiscount { get; set; }
        public string billtime { get; set; }
        public decimal Price { get; set; }
        public int CostCenterId { get; set; }
        public int GroupId { get; set; }
        public string CostCenterName { get; set; }
        public int IsRunningOrder { get; set; }
        public int IsSplit { get; set; }
        public int HomePackQty { get; set; }
        public int PrintCount { get; set; }
        public int ROI_ItemId { get; set; }
        public string ROI_ItemName { get; set; }
        public string ITName { get; set; }
        public string ImagePath { get; set; }
        public int CusID { get; set; }
        public string CusName { get; set; }
        public string PAN { get; set; }
        public string Address { get; set; }
        public string PhoneNumber { get; set; }
        public string Cashier { get; set; }
        //public string restroRoom { get; set; }
        // public decimal NetAmount { get; set; }
        public string MergeTableName { get; set; }
        public string Waiter { get; set; }
        public decimal RoomRate { get; set; }
        public decimal BookedDays { get; set; }
        public decimal RoomCharge { get; set; }
        public decimal AdvancePayment { get; set; }
        public bool IsTable { get; set; }
        public decimal coDiscount { get; set; }
        public int OrderNo { get; set; }
        public int CCDiscount { get; set; }
        public int MembershipID { get; set; }
        public bool IsEveningDiscount { get; set; }
        public string MergedTables { get; set; }
        public Decimal Bakery { get; set; }
        public Decimal Pizza { get; set; }
        public List<OrderExtraItem> orderExtraItem { get; set; }

        public List<WaiterCallInfo> GetWaiterLog { get; set; }
        public bool IsPriceEditable { get; set; }
    }

    public partial class OrderMasterClass
    {

        public string CancelReason { get; set; }
        public string CancelBy { get; set; }
        public DateTime CancelDate { get; set; }
        private string RealBillNo = string.Empty;
        public int BillPaid { get; set; }
        public int OrderMasterID { get; set; }
        public int CompMasterID { get; set; }
        public string TableId { get; set; }
        public string BillNo { get; set; }
        public System.DateTime Date { get; set; }

        public decimal BasicAmount { get; set; }
        public decimal TermAmount { get; set; }
        public decimal NetAmount { get; set; }
        public string Remarks { get; set; }
        public bool IsCancelled { get; set; }
        public string UserName { get; set; }
        public bool IsSplit { get; set; }
        public int GuestNo { get; set; }
        public int RoomId { get; set; }
        public string Status { get; set; }
        public string restrotableTitle { get; set; }
        public int restroRoomId { get; set; }
        public string restroRoom { get; set; }
        public int OrderStatus { get; set; }
        public int OID { get; set; }
        public string ArchivedBy { get; set; }
        public List<OrderDetailClass> OrderDetailsList { get; set; }

        public string names { get; set; }
        public string phoneNo { get; set; }
        //public int NoOfGuests { get; set; }
        public int membershipId { get; set; }
        //public void GetDetails(OrderDetailClass orderDetails)
        //{
        //    OrderDetailsList.Add(orderDetails);
        //}

        public int RoomBookedDays { get; set; }
        public decimal RoomRate { get; set; }
        public decimal RoomTotal { get; set; }
        public decimal AdvancePaid { get; set; }
        public string Details { get; set; }
        public int TokenNo { get; set; }
        public int OrderNo { get; set; }
        public string Address { get; set; }
        public int OrderTypeID { get; set; }
        public List<OrderExtraItem> orderExtraItem { get; set; }
    }
    public class Unit
    {
        public int UnitID { get; set; }
        public string UnitName { get; set; }
    }
    public class UnitClass
    {

        public int UnitID { get; set; }
        public int UnitId { get; set; }
        public string UnitName { get; set; }
        public int Unit1Id { get; set; }

        public string UnitDescription { get; set; }
        public string Particulars { get; set; }
        public string Symbol { get; set; }
        public int FUnit { get; set; }
        public int SUnit { get; set; }



        public int Unit2ID { get; set; }

        public int FirstUnit { get; set; }
        public int Conversion { get; set; }
        public int SecondUnit { get; set; }
        public int ErrorBit { get; set; }
        public string Firstunitname { get; set; }

        public string Secondunitname { get; set; }
        public int ItemID { get; set; }



    }


    public class UnitConversion
    {
        public int UnitID { get; set; }
        public int FirstUnitID { get; set; }
        public int SecondUnitID { get; set; }
        public decimal Conversion { get; set; }
        public string FirstUnitCode { get; set; }
        public string SecondUnitCode { get; set; }
        public string FirstUnit { get; set; }
        public string SecondUnit { get; set; }
        public bool IsFirst { get; set; }
    }
    //stored procedure get json

    public class ROGETITEMResult
    {

        public Nullable<int> MenuID { get; set; }
        public Nullable<int> ItemID { get; set; }
        public string ItemName { get; set; }
        public string ItemDescription { get; set; }
        public string PhotoPath { get; set; }
        public Nullable<decimal> Price { get; set; }
        public string ItemCode { get; set; }
        public Nullable<int> UnitID { get; set; }

        public Nullable<int> CategoriesID { get; set; }
        public string CategoriesName { get; set; }

        public string MenuName { get; set; }

        public string UnitName { get; set; }
    }

    //test
    public class ROGETITEMResulttest
    {
        public List<MenuClass> MenuList { get; set; }

    }

    public partial class UserClass
    {
        public int UserID { get; set; }
        public string Username { get; set; }
        public string Status { get; set; }
        public string Password { get; set; }
        public string RoleNames { get; set; }
        public String toJson()
        {
            return JsonConvert.SerializeObject(this);
        }
        public string WaiterIP { get; set; }
        public string OrderMenuListType { get; set; }
        public string OrderMenuImageshow { get; set; }

    }
    public class restroTable
    {
        public int restrotableId { get; set; }
        public string restrotableTitle { get; set; }
        public int restroRoomId { get; set; }
        public string restroRoom { get; set; }
        public int Seatcap { get; set; }
        public int MergeTableList { get; set; }
        public int MergeID { get; set; }
        public string MergeTableName { get; set; }
        public int restrotablesStatusID { get; set; }
        public int BillPaid { get; set; }
        public int IsOccupied { get; set; }
        public string tableDate { get; set; }
        public string tabletime { get; set; }
        public int IsCancelled
        {
            get;
            set;
        }
        public bool IsTable { get; set; }
        public decimal Rate { get; set; }
        public int OrderMasterId { get; set; }
        public int CompMasterID { get; set; }
        public int GuestNo { get; set; }
        public int OrderNo { get; set; }
        public int TokenNo { get; set; }
        public int UserModuleID { get; set; }
        public decimal Amount { get; set; }
        public string Details { get; set; }
    }
    public class RestroRoom
    {
        public int restroRoomId { get; set; }
        public string restroRoom { get; set; }
        public List<restroTable> tableList { get; set; }
        public string Title { get; set; }
        public int RoomStatusId { get; set; }
        public int RoomTypeID { get; set; }

        public string RoomType { get; set; }
    }
    public class RoomType
    {
        public int RoomTypeID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string InsertedBy { get; set; }
        public string UpdateBy { get; set; }
        public string DeleteBy { get; set; }
        public List<RestroRoom> roomlist { get; set; }
    }

    public class companyInfo
    {
        public int companyId { get; set; }
        public string Name { get; set; }
        public string RegistrationNo { get; set; }
        public string Address { get; set; }
        public string Country { get; set; }
        public int CurrencyID { get; set; }
        public string Logo { get; set; }
        public string PhoneNo { get; set; }
        public string PAN { get; set; }
        public bool IsPan { get; set; }
        public string CBMSUserName { get; set; }
        public string CBMSPassword { get; set; }
        public string Code { get; set; }
        public decimal HHTRate { get; set; }

        public decimal VATRate { get; set; }
        public decimal AbbreviatedValue { get; set; }
        public bool IsAbbreviated { get; set; }
    }
    public class billingTerm
    {
        public int BilingID { get; set; }
        public string Name { get; set; }
        public bool IsAdd { get; set; }
        public string Rate { get; set; }
        public string Description { get; set; }
        public int SequenceOrder { get; set; }
        public bool IsAlwaysActive { get; set; }

    }
    public class billTermDetails
    {
        public int BillTermDetailsID { get; set; }
        public int BilingID { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string FromTime { get; set; }
        public string ToTime { get; set; }
        public bool Sunday { get; set; }
        public bool Monday { get; set; }
        public bool Tuesday { get; set; }
        public bool Wednesday { get; set; }
        public bool Thursday { get; set; }
        public bool Friday { get; set; }
        public bool Saturday { get; set; }
    }
    public class NetAmount
    {
        public decimal Net_Amount { get; set; }
        public decimal Amount { get; set; }
    }

    #endregion Restro Section
    #region Account Section
    public class EnumClass
    {
        public int EnumId { get; set; }
        public string CValue { get; set; }
        public string Type { get; set; }
        public int Order { get; set; }
    }

    public class modalAccountGroup
    {
        public int AccountGroupID { get; set; }
        public string AccountCode { get; set; }
        public string AccountName { get; set; }
        public short Type { get; set; }
        public int Schedule { get; set; }
        public int VoucherNumbering { get; set; }
        public DateTime CreateDate { get; set; }
        public string CreatedBy { get; set; }
        public string LastUpdateBy { get; set; }
        public DateTime LastUpdateDate { get; set; }

    }

    public class modalAccountSubGroup
    {
        public int AccountSubGroupId { get; set; }
        public string Code { get; set; }
        public string Name { get; set; }
        public int AccountGroupId { get; set; }
        public int VoucherNumbering { get; set; }
        public string CreatedBy { get; set; }
        public string LastUpdateBy { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime LastUpdateDate { get; set; }
        public string AccountName { get; set; }

    }
    public class modalAccountSubGroupSearch
    {
        public int Id { get; set; }
        public string Code { get; set; }
        public string Name { get; set; }
        public string AccountGroupName { get; set; }


    }
    #endregion Account Section


    #region Full Room Info Class Section

    public class FullRestroInfo
    {


        public int RoomId { get; set; }
        public string TableId { get; set; }

    }

    #endregion Full Room Info Class Section

    #region SMS

    public class SMSSend
    {
        public string auth_token { get; set; }
        public string from { get; set; }
        public string to { get; set; }
        public string text { get; set; }
    }

    public class SMSResponse
    {
        public string response { get; set; }
        public string response_code { get; set; }
    }

    #endregion
    public class roistore
    {
        public int StoreId { get; set; }
        public int PSTId { get; set; }
        public string StName { get; set; }
        public int STId { get; set; }
        public string text { get; set; }
        public string PName { get; set; }
        public bool IsDispatchStore { get; set; }
    }

    public class CostCenterGroup
    {
        public int GroupId { get; set; }
        public string GroupName { get; set; }
        public bool IsActive { get; set; }
        public decimal TotalAmt { get; set; }
        public decimal NonTaxableAmt { get; set; }
        public decimal TotalDis { get; set; }

        public decimal GroupDis { get; set; }
    }


    public class PrevProduction
    {
        public int ProductionMainId { get; set; }
        public int ItemId { get; set; }
        public string ItemName { get; set; }
        public string Quantity { get; set; }
        public int StoreId { get; set; }
        public int UnitId { get; set; }
        public string Symbol { get; set; }
        public DateTime AddedOn { get; set; }

    }


    public class FiscalYear
    {
        public int fyId { get; set; }
        public string fyName { get; set; }
        public Boolean isActive { get; set; }
        public int OrderMasterId { get; set; }

    }
    public class costCenter
    {
        public int CostCenterID { get; set; }
        public string CostCenterName { get; set; }
        public string DefaultPrinter { get; set; }
        public decimal coDiscount { get; set; }
        public int GroupId { get; set; }
        public List<OrderDetailClass> tableList { get; set; }
    }
    public class costCenterReport
    {
        public string ItemName { get; set; }
        public int Quantity { get; set; }
        public decimal Rate { get; set; }
        public decimal Total { get; set; }
        public string CostCenterName { get; set; }
        public string BillDate { get; set; }
    }
    public class CardProvider
    {
        public int ProviderID { get; set; }
        public string ProviderName { get; set; }
        public string Description { get; set; }

        public string Addresss { get; set; }
        public string Name { get; set; }
        public int MembershipID { get; set; }
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
        public decimal GoodReceivedQuantity { get; set; }
        public decimal Remaining { get; set; }
        public decimal UnitRate { get; set; }
        public decimal PurchaseQuantity { get; set; }
        public string ITName { get; set; }
        public decimal RemainingBalance { get; set; }
        public decimal OpeningBalance { get; set; }
    }




    public class customerBilling
    {
        //public double Discount { get; set; }
        //public double ServiceCharge { get; set; }
        //public double Tax { get; set; }
        //public double CustomerLoayaltyDiscountCard { get; set; }
        //public double NetAmount { get; set; }
        public bool IsAdd { get; set; }
        public int ID { get; set; }
        public string BillTerm { get; set; }
        public decimal Rate { get; set; }
        public decimal Amount { get; set; }
    }


    public class BillTermAmount
    {
        public int BTID { get; set; }
        public int SalesMasterID { get; set; }
        public int BillTermID { get; set; }
        public string BillTerm { get; set; }
        public decimal Amount { get; set; }
    }


    public class SalesMaster
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
        public string NepaliInvoiceDate { get; set; }
        public int RoomId { get; set; }
        public int TableId { get; set; }
        public decimal NonTaxable { get; set; }
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
        public string PhoneNumber { get; set; }
        public string Address { get; set; }
        public int CusID { get; set; }
        public string AddedBy { get; set; }
        public decimal RoomRate { get; set; }
        public decimal BookedDays { get; set; }
        public decimal RoomCharge { get; set; }
        public decimal AdvancePayment { get; set; }
        public decimal sumBakery { get; set; }
        public decimal sumPizza { get; set; }
        public decimal DeliveryCharge { get; set; }
        public string DeliveredBy { get; set; }
        public List<usedBillingTermInfo> usedBillingTerm { get; set; }
    }

    public class MaterializedReport
    {
        public string FiscalYear { get; set; }
        public string Bill_No { get; set; }
        public string Customer_Name { get; set; }
        public string Customer_PAN { get; set; }
        public string Bill_Date { get; set; }
        public decimal AMOUNT { get; set; }
        public decimal Discount { get; set; }
        public decimal ServiceCharge { get; set; }
        public string PaymentModes { get; set; }
        public decimal TaxableAmount { get; set; }
        public decimal Tax_Amount { get; set; }
        public bool Is_Printed { get; set; }
        public bool Is_Active { get; set; }
        public int PrintCount { get; set; }
        public string Printed_Time { get; set; }
        public string Entered_by { get; set; }
        public string Printed_by { get; set; }
        public string Reasons { get; set; }
        public bool isrealtime { get; set; }
        public bool SyncWithIRD { get; set; }
        public int salesMasterId { get; set; }
    }

    public class ClosingReport
    {
        public string ITName { get; set; }
        public string CostCenterName { get; set; }
        public int Conversion { get; set; }
        public int QTY { get; set; }
        public string Symbol { get; set; }
        public decimal Rate { get; set; }
        public decimal Amount { get; set; }
        public int ITId { get; set; }

    }
    public class StatementInfo
    {
        public string DATE { get; set; }
        public string BillNo { get; set; }
        public decimal TotalAll { get; set; }
        public decimal BEV { get; set; }
        public decimal KOT { get; set; }
        public decimal Bakery { get; set; }
        public decimal Pizza { get; set; }
        public decimal RoomCharge { get; set; }
        public decimal DISCOUNT { get; set; }
        public decimal Total { get; set; }
        public decimal ServiceCharge { get; set; }
        public decimal TaxCharge { get; set; }
        public decimal NetAmount { get; set; }
        public decimal SalesPerBill { get; set; }
        public decimal CashReceived { get; set; }
        public decimal eSewaReceived { get; set; }
        public decimal FonePayReceived { get; set; }
        public decimal ChequeReceived { get; set; }
        public decimal CardReceived { get; set; }
        public decimal CreditReceived { get; set; }
        public decimal SurplusDeficit { get; set; }
        public decimal KotDiscount { get; set; }
        public decimal BarDiscount { get; set; }
        public decimal BakeryDiscount { get; set; }
        public decimal PizzaDiscount { get; set; }
        public decimal RoomDiscount { get; set; }
        public decimal LoyalityDiscount { get; set; }
        public decimal DeliveryCharge { get; set; }
        public decimal Complementry { get; set; }

    }
    public class SalesDetails
    {
        public int salesMasterId { get; set; }
        public int ItemId { get; set; }
        public float qty { get; set; }
        public decimal rate { get; set; }
        //public decimal ExciseRate { get; set; }
        public decimal Amount { get; set; }
        public decimal NetAmount { get; set; }
        public int CostCenterId { get; set; }
        public int OrderDetailsID { get; set; }

        public string CusName { get; set; }
        public int CusID { get; set; }
        public bool IsCombo { get; set; }
        public List<SalesDetailExtra> extraSales { get; set; }
    }
    public class SalesDetailExtra
    {
        public int ExtraId { get; set; }
        public int SalesMasterId { get; set; }
        public int SalesDetailsId { get; set; }
        public int ItemId { get; set; }
        public int ExtraItemId { get; set; }
        public string ExtraItem { get; set; }
        public int Quantity { get; set; }
        public decimal Rate { get; set; }
        public decimal Amount { get; set; }
    }
    public class bestby
    {

        public string WaiterbyDays { get; set; }
        public string TablebyDays { get; set; }
        public string RoombyDays { get; set; }
        public string ItembyDays { get; set; }

        public string WaiterbyWeek { get; set; }
        public string TablebyWeek { get; set; }
        public string RoombyWeek { get; set; }
        public string ItembyWeek { get; set; }

        public string WaiterbyMonth { get; set; }
        public string TablebyMonth { get; set; }
        public string RoombyMonth { get; set; }
        public string ItembyMonth { get; set; }

        public string WaiterbyYear { get; set; }
        public string TablebyYear { get; set; }
        public string RoombyYear { get; set; }
        public string ItembyYear { get; set; }


    }

    public class flatorperdiscount
    {
        public int pfdId { get; set; }
        public int SalesMasterId { get; set; }
        public string kotdis { get; set; }
        public string bardis { get; set; }
        public string roomdis { get; set; }
        public bool isflatdis { get; set; }
        public decimal BasicAmount { get; set; }
        public decimal TermAmount { get; set; }
        public decimal NetAmount { get; set; }
        public bool isLoyalty { get; set; }
        public string loyaltydis { get; set; }
        public string bakerydis { get; set; }
        public string tradingDis { get; set; }
        public string pizzadis { get; set; }
        public string cakedis { get; set; }
        public List<CostCenterGroup> CCGroup { get; set; }

    }
    public class Cusinfo
    {
        public bool isTakeAwayhome { get; set; }
        public string CellNo { get; set; }
        public string FullAddress { get; set; }
        public int OrderID { get; set; }
        public string Name { get; set; }
        public string OrderDate { get; set; }
        public string OrderTime { get; set; }
        public string AppoinmentReceiveTime { get; set; }
        public string AppoinmentReceiveDate { get; set; }
        public string OrderModulID { get; set; }
        public int People { get; set; }
        public string Message { get; set; }

    }
    public class MvPurchaseDetails
    {
        public string PuNo { get; set; }
        public int StoreID { get; set; }
        public int PurchaseDetailsID { get; set; }
        public int PurchaseMainID { get; set; }
        public int ItemID { get; set; }
        //public int UsedUnitID { get; set; }
        public int UnitID { get; set; }
        public decimal Quentity { get; set; }
        public string QuentityText { get; set; }
        public decimal Rate { get; set; }
        public string ITName { get; set; }
        public int ITId { get; set; }
        //public int UnitId { get; set; }
        public string UnitName { get; set; }
        public decimal quantity { get; set; }
        public int vender { get; set; }
        public string Fname { get; set; }
        public string Lname { get; set; }
        public int SmallUnit { get; set; }
        public string UnitDescription { get; set; }
        public int LargeUnit { get; set; }
        public bool IsCategory { get; set; }
        public bool IsExpirable { get; set; }
        public string Symbol { get; set; }
        public decimal Total { get; set; }
        public int Conversion { get; set; }
        public int RecqDetailId { get; set; }
        public int VendorPurchaseId { get; set; }
        public bool IsVat { get; set; }
        public decimal Discount { get; set; }
    }

    public class purchaseMains
    {
        public int PurchaseDetailsID { get; set; }
        public string PuNo { get; set; }
        public DateTime PbDate { get; set; }
        public string IvNo { get; set; }
        public int Vid { get; set; }
        public string Remarks { get; set; }
        public int FyId { get; set; }
        public bool IsVat { get; set; }
        public string PostedOn { get; set; }
        public string PostedBy { get; set; }
        public int PurchaseMainID { get; set; }
        public int ItemID { get; set; }
        //public int UsedUnitID { get; set; }
        public int UnitID { get; set; }
        public decimal Quentity { get; set; }
        public string QuentityText { get; set; }
        public decimal Rate { get; set; }
        public string ITName { get; set; }
        public int ITId { get; set; }
        public int UnitId { get; set; }
        public string UnitName { get; set; }
        //public int Vid { get; set; }
        //public string Remarks { get; set; }
        public decimal quantity { get; set; }
        public int vender { get; set; }
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
        public string Total { get; set; }
        public string LotNo { get; set; }
        public string BatchNo { get; set; }
        public string ExpDate { get; set; }
        public int MembershipID { get; set; }
        public int GoodReceived { get; set; }
        public int Conversion { get; set; }
        public int RecqDetailId { get; set; }
        public int RecqId { get; set; }
        public decimal VAT { get; set; }
        public string Symbol { get; set; }

        public decimal Discount { get; set; }
    }

    public class MvPurchaseMain
    {

        public int PurchaseMainID { get; set; }
        public int PurchaseDetailsID { get; set; }
        public string PuNo { get; set; }
        public DateTime PbDate { get; set; }
        public string IvNo { get; set; }
        public int Vid { get; set; }
        public string Remarks { get; set; }
        public string FyId { get; set; }
        public string PostedOn { get; set; }
        public string PostedBy { get; set; }
        public int SPMID { get; set; }

        public decimal Discount { get; set; }
        public List<MvPurchaseDetails> PurchaseObjectDetails { get; set; }
        public List<purchaselot> PurchaseObjectDetailsLot { get; set; }
        public List<itemBal> PurchaseObjItemBal { get; set; }


        public List<RecquistionDetails> RecquistionObjectDetails { get; set; }
    }

    public class itemBal
    {
        public int GDId { get; set; }
        public int GMId { get; set; }
        public int PDId { get; set; }
        public decimal Qnty { get; set; }
        public decimal Rate { get; set; }
        public decimal Total { get; set; }

        public int check { get; set; }
        public int ITId { get; set; }
        public int PurchaseDetailsID { get; set; }
        public int STId { get; set; }
        public int OPBal { get; set; }
        public decimal CLBal { get; set; }
        public decimal Discount { get; set; }
        public bool IsVat { get; set; }
    }
    public class purchaselot
    {
        public int PurchaseDetailsID { get; set; }
        public string LotNo { get; set; }
        public string BatchNo { get; set; }
        public string ExpDate { get; set; }
    }
    public class salesSummary
    {
        public int Count { get; set; }
        public int OrderDetailsID { get; set; }
        public string BillNo { get; set; }
        public DateTime Date { get; set; }
        public int ROI_ItemId { get; set; }
        public string ITName { get; set; }
        public float Quantity { get; set; }
        public string ITUnit { get; set; }
    }

    public class salesSummaryByProviderMode
    {
        public int Count { get; set; }
        public decimal Amount { get; set; }
        public string BillDate { get; set; }
        public string ProviderName { get; set; }
    }
    public class unitclassforitem
    {
        public string UnitDescription { get; set; }
        public int Unit1Id { get; set; }
        public int UnitId { get; set; }
        public string Particulars { get; set; }
        public int ITId { get; set; }
        public string ITName { get; set; }
        public int ItemCostCentreID { get; set; }
        public string LanguageMenuText { get; set; }
    }

    public class extraItem
    {
        public int? ItemID { get; set; }
        public int? ExtraItemID { get; set; }
        public string ExtraItem { get; set; }
        public decimal? ExtraPrice { get; set; }
        public bool? IsActive { get; set; }
        public string AddedBy { get; set; }
        public bool? IsExtra { get; set; }
        public bool? IsDeleted { get; set; }
        public List<IngredientItems> Ingredientdata { get; set; }
    }

    public class ROInvItem
    {
        public float SRate { get; set; }
        public float LastPurchaseRate { get; set; }
        public int ItemDetailsID { get; set; }
        public int CostCenterID { get; set; }
        public string ImagePath { get; set; }
        public int ITId { get; set; }
        public string ITName { get; set; }
        public int PITId { get; set; }
        public string ITCode { get; set; }
        public int ItemId { get; set; }
        public int MUnitId { get; set; }
        public int DSUnitId { get; set; }
        public int DPUnitId { get; set; }
        public bool IsExpirable { get; set; }
        public bool IsProdMaterial { get; set; }
        public int ROrderLevel { get; set; }
        public bool IsUnitWiseRate { get; set; }
        public string MunitParticulars { get; set; }
        public string dsunitparticular { get; set; }
        public string dpunitparticular { get; set; }
        public int ItemRateID { get; set; }
        public int ItemCostCentreID { get; set; }

        public string Details { get; set; }

        public string CostCenterName { get; set; }
        public string ParentItem { get; set; }
        // public bool isMenu { get; set; }
        public bool IsMenu { get; set; }
        public bool IsCategory { get; set; }
        public bool IsActive { get; set; }
        public bool IsTaxable { get; set; }
        public bool IsCake { get; set; }
        public bool IsWholeSale { get; set; }
        public bool IsRetail { get; set; }
        public int SmallUnit { get; set; }
        public string AddedBy { get; set; }
        public bool IsExtra { get; set; }
        public int LargeUnit { get; set; }
        public int Conversion { get; set; }
        public bool IsDefaultPurchaseUnit { get; set; }
        public bool IsDefaultSalesUnit { get; set; }
        //public decimal SalesRate { get; set; }
        public string ValidFrom { get; set; }
        public bool IsCombo { get; set; }
        //public bool IsExtra { get; set; }
        //public int storeId { get; set; }
        //public int Unit { get; set; }
        //public string Value { get; set; }
        public int Ingredient { get; set; }
        public decimal Quantity { get; set; }
        public List<itemWithUnit> ItemWithUnit { get; set; }
        public List<extraItem> extradata { get; set; }
        public List<IngredientItems> Ingredientdata { get; set; }

        public List<StoreItemStock> storeitemstock { get; set; }
        public decimal COGS { get; set; }
        public string ItemName { get; set; }
        public bool IsPriceEditable { get; set; }

    }


    public class StockDetailItem
    {
        public int ItemId { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int StoreId { get; set; }

    }


    public class StockDetail
    {
        public int StockTranMasterId { get; set; }
        public DateTime TransactionDate { get; set; }
        public int ITId { get; set; }
        public string ITCode { get; set; }
        public int StoreId { get; set; }
        public string StoreName { get; set; }
        public string Symbol { get; set; }
        public decimal? OpeningQty { get; set; }
        public decimal? AdjustQty { get; set; }
        public decimal? PurchaseQty { get; set; }
        public decimal? ComplementQty { get; set; }
        public decimal? IssueQty { get; set; }
        public decimal? PurchaseRate { get; set; }
        public decimal? AvailableQty { get; set; }
        public decimal? PurchaseAmt { get; set; }
        public decimal? SalesQty { get; set; }
        public decimal? PurchaseReturnQty { get; set; }
        public decimal? SalesReturnQty { get; set; }
        public decimal? SalesAmt { get; set; }
        public decimal ItemBalance { get; set; }
        public decimal ItemValue { get; set; }
    }



    public class ROInvItemForApi
    {
        public int ItemId { get; set; }
        public string ItemName { get; set; }

        public string Details { get; set; }
        public int PItemId { get; set; }
        public string ItemCode { get; set; }
        public string ImagePath { get; set; }
        public int CostCenterID { get; set; }
        public int MUnitId { get; set; }
        public int DSUnitId { get; set; }
        public int DPUnitId { get; set; }
        public bool IsExpirable { get; set; }
        public bool IsProdMaterial { get; set; }
        public int Level { get; set; }
        public bool IsUnitWiseRate { get; set; }
        public decimal? SRate { get; set; }
        //public bool IsAppropriateItem { get; set; }
        public string Currency { get; set; }
        public List<extraItem> extradata { get; set; }
        public bool IsCombo { get; set; }
        public bool IsCategory { get; set; }
        public bool IsOutOfStock { get; set; }
        public string CostCenterName { get; set; }
    }

    public class fiscalyear
    {
        public int fyId { get; set; }
        public string fyName { get; set; }
        public bool isActive { get; set; }
    }
    public class issue
    {
        public int IMId { get; set; }

        public string ISNo { get; set; }
        public int IssuedToSTId { get; set; }
        public int IssuedFrSTId { get; set; }
        public DateTime IssuedOn { get; set; }
        public string IssuedBy { get; set; }
        public int IDId { get; set; }

        public int ITID { get; set; }
        public int UsedUnitId { get; set; }
        public int Qnty { get; set; }

        public string QntyInText { get; set; }
        public string ReceivedBy { get; set; }
        public DateTime ReceivedOn { get; set; }

    }
    public class issueMain
    {

        public string StName { get; set; }
        public string IssToStName { get; set; }
        public string ISNo { get; set; }
        public int IMId { get; set; }
        public int IssuedToSTId { get; set; }
        public int IssuedFrSTId { get; set; }
        public DateTime IssuedOn { get; set; }
        public string IssuedBy { get; set; }

        public string Symbol { get; set; }

        public string Qnty { get; set; }

        public string ITName { get; set; }

        public string ReceivedBy { get; set; }

        public bool IsVerified { get; set; }

        public List<IssueDetails> IssueObjectDetails { get; set; }
    }
    public class IssueDetails
    {
        public int IDId { get; set; }
        public int IMId { get; set; }
        public int ITID { get; set; }
        public int UsedUnitId { get; set; }
        public int Qnty { get; set; }
        public string QntyInText { get; set; }
        public string ReceivedBy { get; set; }
        public DateTime ReceivedOn { get; set; }
    }


    public class adjustmentMain
    {
        public int AMId { get; set; }
        public string AMNo { get; set; }
        public int STId { get; set; }
        public string Remarks { get; set; }
        public string FYId { get; set; }
        public DateTime PostedOn { get; set; }
        public string PostedBy { get; set; }
        public string StName { get; set; }
        public List<adjustmentDetail> AdjstmentObjectDetails { get; set; }
    }
    public class AdjustmentType
    {
        public int AdjustmentTypeID { get; set; }
        public string AdjustmentTypeName { get; set; }
        public Boolean IsActive { get; set; }
        public string AddedBy { get; set; }
        public DateTime AddedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
        public string DeletedBy { get; set; }
        public DateTime DeletedOn { get; set; }
        public int IsDeleted { get; set; }
    }
    public class adjustmentDetail
    {
        public int ADId { get; set; }
        public int AMId { get; set; }
        public int ITId { get; set; }
        public string ItName { get; set; }
        public string AdName { get; set; }
        public string unitName { get; set; }
        public int UsedUnitId { get; set; }

        public int Qnty { get; set; }
        public string QntyInText { get; set; }
        public int AdType { get; set; }

        public int PDId { get; set; }
        public bool IsAdd { get; set; }


    }
    public class goodsReceiveMain
    {
        public decimal Total { get; set; }
        public int ItemID { get; set; }
        public string ITName { get; set; }
        public int PurchaseDetailsID { get; set; }
        public string Quentity { get; set; }
        public string RemainingQnty { get; set; }
        public string StName { get; set; }
        public int GMId { get; set; }
        public string GMNo { get; set; }
        public int STId { get; set; }
        public string PostedBy { get; set; }
        public DateTime PostedOn { get; set; }
        public string PuNo { get; set; }
        public DateTime PbDate { get; set; }
        //public List<goodReceiveDetails> PurchaseObjectDetails { get; set; }
        public List<itemBal> PurchaseObjItemBal { get; set; }
        public string Symbol { get; set; }
        public int Conversion { get; set; }

        public int RecqId { get; set; }
        public int RecqDetailId { get; set; }
        public int vendorId { get; set; }
        public int paymentMode { get; set; }
        public bool IsVat { get; set; }

        public string InvoiceNo { get; set; }
        public DateTime InvoiceDate { get; set; }
        public DateTime BillDate { get; set; }

        public string Fname { get; set; }
        public string Address { get; set; }
        public string TelWork { get; set; }
        public decimal VAT { get; set; }
        public decimal Discount { get; set; }
        public decimal UnitRate { get; set; }
        public string PAN { get; set; }
        public decimal ExtraDiscount { get; set; }
        public float VatTotal { get; set; }
        public bool vat { get; set; }
        public string PayMode { get; set; }
        public string PurchaseDate { get; set; }
        public string PaymentModeName { get; set; }
        public decimal vatdiscount { get; set; }
        public List<RecquistionDetails> RecquistionObjectDetails { get; set; }
        //public List<PurchasePayment> PurchasePayment { get; set; }
    }
    public class goodReceiveDetails
    {
        public int GDId { get; set; }
        public int GMId { get; set; }
        public int PDId { get; set; }
        public decimal Qnty { get; set; }
        public decimal Rate { get; set; }
        public decimal Total { get; set; }
        public string Symbol { get; set; }
        public string ItemName { get; set; }
        public int ItemID { get; set; }
        public string Fname { get; set; }
        public string InvoiceNo { get; set; }
        public int vendorId { get; set; }
        public int Conversion { get; set; }
        public int STId { get; set; }
        public string StName { get; set; }
        public int UsedUnitID { get; set; }
        public string StoreName { get; set; }
        public string RemainingQnty { get; set; }
    }
    public class itemRate
    {
        public string Validfroms { get; set; }
        public int ItemRateID { get; set; }
        public int ItemID { get; set; }
        public int UnitID { get; set; }
        public decimal PRate { get; set; }
        public decimal SRate { get; set; }
        public DateTime ValidFrom { get; set; }
        public string PostedBy { get; set; }
        public DateTime PostedOn { get; set; }
        public string ITName { get; set; }

    }
    public class AdjustmnetMain
    {
        public string StName { get; set; }
        public int AMId { get; set; }
        public int AMNo { get; set; }
        public int STId { get; set; }
        public string Remarks { get; set; }
        public int FYId { get; set; }
        public DateTime PostedOn { get; set; }

        public string PostedBy { get; set; }
        public List<adjustmentDetail> addlist { get; set; }

        public List<AdjustmentDetails> AdjustmentDetails { get; set; }


    }
    public class AdjustmentDetails
    {

        public int ADId { get; set; }
        public int AMId { get; set; }
        public int ITId { get; set; }
        public int UsedUnitId { get; set; }
        public int Qnty { get; set; }
        public string QntyInText { get; set; }
        public int AdType { get; set; }
        public int PDId { get; set; }
        public bool IsAdd { get; set; }
        public string ItName { get; set; }
        public string AdName { get; set; }
        public string unitName { get; set; }

    }
    public class stockReport
    {
        public string ExpDate { get; set; }
        public string ITId { get; set; }
        public string ITName { get; set; }
        public int OPBal { get; set; }
        public decimal UnitRate { get; set; }
        public decimal CLBal { get; set; }
        public int MinStock { get; set; }
        public string PbDate { get; set; }
        public string ValidFrom { get; set; }
        public decimal PRate { get; set; }
        public decimal SRate { get; set; }
        public string StName { get; set; }
        public string ITUnit { get; set; }
        public string Symbol { get; set; }
        public decimal CLRate { get; set; }
        public decimal TotalValue { get; set; }
        public string PostedOn { get; set; }
        public string UnitRateSymbol { get; set; }
    }
    public class cumbomain
    {
        public int CostCenter { get; set; }
        public string StartDatee { get; set; }
        public string EndDatee { get; set; }
        public int ComboID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string ComboCode { get; set; }
        public string ImagePath { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public decimal SalesPrice { get; set; }
        public decimal ItemsSalesCost { get; set; }
        public bool IsActive { get; set; }
        public DateTime AddedOn { get; set; }
        public string AddedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime DeletedOn { get; set; }
        public string DeletedBy { get; set; }
        public List<cumbomainDetails> CumboPackDetails { get; set; }

    }
    public class cumbomainDetails
    {
        public decimal ItemsSalesCost { get; set; }
        public string ITName { get; set; }
        public string Name { get; set; }
        public string ComboCode { get; set; }
        public string ImagePath { get; set; }
        public string StartDatee { get; set; }
        public decimal SalesPrice { get; set; }
        public string EndDatee { get; set; }
        public int ComboID { get; set; }
        public int ComboDetailsID { get; set; }
        public int ItemID { get; set; }
        public decimal ItemRate { get; set; }

        public int Quantity { get; set; }
        public decimal TotalPrice { get; set; }
    }

    public class itemWithUnit
    {
        public int ItemWithUnitID { get; set; }
        public int ItemID { get; set; }
        public int LargeUnit { get; set; }
        public int Conversion { get; set; }
        public bool IsDefaultPurchaseUnit { get; set; }
        public bool IsDefaultSalesUnit { get; set; }
        public decimal SalesRate { get; set; }
        public string ValidFrom { get; set; }
        public string AddedBy { get; set; }
        public DateTime AddedOn { get; set; }
        public DateTime UpdatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public bool IsUpdated { get; set; }
        public bool IsArchived { get; set; }
        public string ArchivedBy { get; set; }
        public DateTime ArchivedOn { get; set; }
        public string CostCenterName { get; set; }
        //public decimal ExciseRate { get; set; }

    }
    public class itemDetailsData
    {
        public List<itemWithUnit> units { get; set; }
        public List<extraItem> extra { get; set; }

        public List<StoreItemStock> storeitemstock { get; set; }

    }
    public class ItemGroup
    {
        public int GroupID { get; set; }
        public string GroupName { get; set; }
        public string GroupCode { get; set; }
        public List<GroupWithItem> GroupWithItem { get; set; }
        public string userName { get; set; }

    }

    public class GroupWithItem
    {
        public int GroupItemID { get; set; }
        public int GroupID { get; set; }
        public int ItemID { get; set; }
        public string ITName { get; set; }
    }
    public class ActivityLog
    {
        public string Bill_No { get; set; }
        public string ordermasterid { get; set; }
        public string date { get; set; }
        public string UserName { get; set; }
        public string Event { get; set; }
        public string restrotableTitle { get; set; }
        public string RoomType { get; set; }
        public string Description { get; set; }
    }

    public class top6Item
    {
        public string ITName { get; set; }
        public int cntItem { get; set; }
    }
    public class top6Table
    {
        public string restroTableTitle { get; set; }
        public int cntTable { get; set; }
    }

    public class SalesChart
    {
        public int NoOfBill { get; set; }
        public string Bill_Date { get; set; }
        public decimal Amount { get; set; }
        public decimal Discount { get; set; }
        public decimal ServiceCharge { get; set; }
        public decimal TaxableAmount { get; set; }
        public decimal Tax_Amount { get; set; }
    }
    public class IngredientItems
    {
        public int? IngredientID { get; set; }
        public int? ItemId { get; set; }
        public int? Ingredient { get; set; }
        public decimal? Quantity { get; set; }
        public string ITName { get; set; }
        public decimal? Amount { get; set; }
    }
    public class OrderDetailCancel
    {
        public int ID { get; set; }
        public int CompId { get; set; }
        public int CompMasterID { get; set; }
        public string CanceledBy { get; set; }
        public string OrderBy { get; set; }
        public string Item { get; set; }
        public float Quantity { get; set; }
        public string Reason { get; set; }
        public string Date { get; set; }
        public string Responsible { get; set; }
        public int ItemID { get; set; }
        public int tableId { get; set; }
        public int orderMasterID { get; set; }
        public string restroRoom { get; set; }
        public string restrotableTitle { get; set; }
        public bool IsCombo { get; set; }
        public string OrderStatus { get; set; }
    }
    public class billingTermAndCostcenter
    {
        public List<billingTerm> billingTerm { get; set; }
        public List<costCenter> costCenter { get; set; }
    }
    public class CreditPayReport
    {
        public int MemberPayId { get; set; }
        public int MemberID { get; set; }
        public string CustName { get; set; }
        public decimal PayAmount { get; set; }
        public string PaymentMode { get; set; }
        public string AddedOn { get; set; }
        public string AddedBy { get; set; }
        public string CustType { get; set; }
        public string billNo { get; set; }
        public int salesMasterId { get; set; }
        public int iscustomer { get; set; }
        public decimal CreditAmount { get; set; }
        public int TrType { get; set; }
    }
    public class PinUser
    {
        public string Message { get; set; }
        public string UserID { get; set; }
        public string UserName { get; set; }
        public string Roles { get; set; }
        public bool DisablePin { get; set; }

        public string OrderMenuListType { get; set; }
        public string OrderMenuImageshow { get; set; }
    }
    public class TargetSales
    {
        public string TotalSales { get; set; }
        public string Dates { get; set; }
        public List<TargetSalesItem> SalesItems { get; set; }
    }
    public class TargetSalesItem
    {
        public string TopItem { get; set; }
        public string Quantity { get; set; }
        public string TotalPrice { get; set; }
        public string CostCenterName { get; set; }
    }
    public class SalesPayment
    {
        public int salesPaymentID { get; set; }
        public int salesMasterId { get; set; }
        public string BillNo { get; set; }
        public decimal BillAmount { get; set; }
        public decimal PayAmount { get; set; }
        public string SPMID { get; set; }
        public string ChequeNo { get; set; }
        public string TransactionNo { get; set; }
        public string ProviderID { get; set; }
        public string CusID { get; set; }
        public string Customer { get; set; }
        public string Address { get; set; }
        public string PAN { get; set; }
        public bool BillPaid { get; set; }
        public decimal TenderAmount { get; set; }
        public decimal ReturnAmount { get; set; }
        public string Remarks { get; set; }
    }
    public class UnpaidBills
    {
        public int salesMasterId { get; set; }
        public string BillNo { get; set; }
        public decimal BillAmount { get; set; }
        public int RoomId { get; set; }
        public string RoomName { get; set; }
        public int TableId { get; set; }
        public string TableName { get; set; }
        public string Customer { get; set; }
        public int CusID { get; set; }
        public string Address { get; set; }
        public string PAN { get; set; }
        public int OrderTypeID { get; set; }
        public string DeliveredBy { get; set; }
        public string BillDate { get; set; }

    }
    public class RoomBookingsInfo
    {
        public int RoomBookDetailsID { get; set; }
        public int OrderMasterId { get; set; }
        public int TableId { get; set; }
        public string BookedFrom { get; set; }
        public string BookedTo { get; set; }
        public bool IsCancelled { get; set; }
        public int BookedDays { get; set; }
        public decimal Rate { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal AdvancePayment { get; set; }
        public string CustomerName { get; set; }
        public string restrotableTitle { get; set; }
        public int CustomerId { get; set; }
        public string PhoneNo { get; set; }
        public string EmailAddress { get; set; }
        public string CtznNo { get; set; }
        public string BillNo { get; set; }
        public string Date { get; set; }
        public decimal BasicAmount { get; set; }
        public int RoomId { get; set; }
        public string RestroRoom { get; set; }
        public string Waiter { get; set; }
        public int LoyaltyDiscount { get; set; }
        public int GuestNo { get; set; }
        public int PaymentModeID { get; set; }
        public int ProviderID { get; set; }
        public string TransactionNo { get; set; }
        public decimal RemainingAmount { get; set; }
        public string Remarks { get; set; }
        public bool IsCheckedIn { get; set; }
        public string CheckedInOn { get; set; }
    }
    public class usedBillingTermInfo
    {
        public int UsedBillingTermID { get; set; }
        public int SalesMasterId { get; set; }
        public int BillingTermId { get; set; }
        public string BillingTerm { get; set; }
        public decimal Percent { get; set; }
        public decimal Amount { get; set; }
        public bool IsVAT { get; set; }
    }
    public class ConsumptionReport
    {
        public int IngredientId { get; set; }
        public string IngredientName { get; set; }
        public string Qnty { get; set; }
        public string Symbol { get; set; }
    }

    public class MvTempPurchaseDetail
    {
        public int ItemID { get; set; }
        public decimal Quantity { get; set; }
    }

    public class UserInfos
    {
        public string userName { get; set; }
        public string password { get; set; }
    }
    public class SalesBill
    {
        public List<OrderDetailClass> orderDetail { get; set; }
        public List<customerBilling> billingTerm { get; set; }
        public List<costCenter> cuscenter { get; set; }
        public RoomBookingsInfo RoomBooking { get; set; }
        public List<Token> Token { get; set; }
        public bool VATforBill { get; set; }

        public List<CostCenterGroup> costCenterGroups { get; set; }
    }
    public class ComplimentaryOrder
    {
        public int OrderMasterId { get; set; }
        public string restroRoom { get; set; }
        public string restrotableTitle { get; set; }
        public decimal Amount { get; set; }
        public string tableDate { get; set; }
        public int GuestNo { get; set; }
        public int itemId { get; set; }
        public string itemName { get; set; }
        public decimal Quantity { get; set; }
        public decimal Rate { get; set; }
        public int CostCenterId { get; set; }
        public string ExtraItem { get; set; }
        public decimal ExtraCharge { get; set; }
        public string Details { get; set; }

    }
    public class BillData
    {
        public List<companyInfo> companyInfo { get; set; }
        public List<OrderDetailClass> orderDetail { get; set; }
        public List<customerBilling> billingTerm { get; set; }
        public List<costCenter> cuscenter { get; set; }
        public string AmntInWord { get; set; }
        public bool splitCostCenter { get; set; }
        public flatorperdiscount discount { get; set; }
        public BillInfo billInfo { get; set; }
        public List<CostCenterGroup> costCenterGroup { get; set; }

        public bool VATforBill { get; set; }


        // public Cakeflatorperdiscount cakeDiscount { get; set; }
    }
    public class OrderExtraItem
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
    public partial class WaiterCallInfo
    {
        public string WaiterName { get; set; }
        public string ItemName { get; set; }
        public string RoomName { get; set; }
        public string TableName { get; set; }
        public string WaiterIP { get; set; }
        public string Department { get; set; }
        public int OrderDetailId { get; set; }
        public string image { get; set; }

        public int CompId { get; set; }
    }
    public class DailyClosingReport
    {
        public int FinancialID { get; set; }
        public string Period { get; set; }
        public decimal OpeningBalance { get; set; }
        public decimal TotalSales { get; set; }
        public decimal Cash { get; set; }
        public decimal Cheque { get; set; }
        public decimal Card { get; set; }
        public decimal Credit { get; set; }
        public decimal eSewa { get; set; }
        public decimal FonePay { get; set; }
        public decimal TotalCashReceived { get; set; }
        public decimal SurplusDeficit { get; set; }
        public decimal CreditCollectedInCash { get; set; }
        public decimal CreditCollectedIneSewa { get; set; }
        public decimal CreditCollectedInFonePay { get; set; }
        public decimal CreditCollectedInCard { get; set; }
        public decimal CreditCollectedInCheque { get; set; }
        public decimal CashInCounter { get; set; }
        public decimal CashSettlement { get; set; }
        public decimal ClosingBalance { get; set; }
        public bool IsClosed { get; set; }

        public decimal TotalExpenses { get; set; }

        public decimal AdvanceCollectedInCash { get; set; }
        public decimal AdvanceCollectedInCard { get; set; }
        public decimal AdvanceCollectedIneSewa { get; set; }
        public decimal AdvanceCollectedInFonePay { get; set; }
        public decimal AdvanceCollectedInCheque { get; set; }
    }
    public class CogsReport
    {
        public int ItemID { get; set; }
        public string ItemName { get; set; }
        public decimal MRP { get; set; }
        public int Ingredient { get; set; }
        public decimal Quantity { get; set; }
        public string IngredientName { get; set; }
        public decimal Amount { get; set; }
        public string Details { get; set; }
        public string ImagePath { get; set; }
        public decimal ItemCost { get; set; }
        public decimal TotalCost { get; set; }
        public decimal TotalSales { get; set; }
        public decimal Profit { get; set; }
    }
    public class PaymentModes
    {
        public int PaymentModeID { get; set; }
        public string PaymentMode { get; set; }
    }

    public class StoreItemStock
    {

        public int ItemId { get; set; }

        public int StoreItemId { get; set; }

        public string ItemName { get; set; }

        public int StoreId { get; set; }
        public int Unit { get; set; }
        public string Value { get; set; }
        public string StName { get; set; }
        public string UnitDescription { get; set; }

    }
    public class Recquistion
    {
        public int RecqId { get; set; }
        public string RecqNo { get; set; }
        public int StoreId { get; set; }
        public int ParentStore { get; set; }
        public string RequestedBy { get; set; }
        public string RequestedOn { get; set; }
        public int StatusId { get; set; }
        public List<RecquistionDetails> requestedItems { get; set; }
        public string StoreName { get; set; }
        public string ParentStoreName { get; set; }
        public string Status { get; set; }

        public string ReceivedBy { get; set; }

        public bool IsVerified { get; set; }

    }

    public class RecquistionDetails
    {
        public int RecqId { get; set; }
        public int RecqDetailId { get; set; }
        public int ItemId { get; set; }
        public float Quantity { get; set; }
        public int Unit { get; set; }
        public float IssueQuantity { get; set; }
        public int StatusId { get; set; }
        public string Symbol { get; set; }
        public string ItemName { get; set; }
        public string Status { get; set; }
        public int VendorId { get; set; }
        public string AddedBy { get; set; }

        public string vendorName { get; set; }
        public float QuantityInSmallUnit { get; set; }
    }

    public class ShiftItems
    {
        public string shiftType { get; set; }
        public int fromTable { get; set; }
        public string fromTableTitle { get; set; }
        public int fromSplitNo { get; set; }
        public int toTable { get; set; }
        public string toTableTitle { get; set; }
        public int toSplitNo { get; set; }
        public int OrderMasterID { get; set; }
        public int OrderNo { get; set; }
        public decimal? BasicAmount { get; set; }
        public string shiftedBy { get; set; }
        public List<ShiftItemList> itemList { get; set; }
    }
    public class ShiftItemList
    {
        public int ItemId { get; set; }
        public float Quantity { get; set; }
        public bool IsCombo { get; set; }
    }

    public class CustomerEvent
    {
        public int MembershipID { get; set; }
        public string dt { get; set; }
        public string CustomerName { get; set; }
        public string Event { get; set; }
        public string Date { get; set; }
        public int DaysRemaining { get; set; }
        public string TelMobile { get; set; }
    }

    public class SalesSummaryReport
    {
        public int InvoiceNo { get; set; }
        public string Table { get; set; }
        public string Room { get; set; }
        public string Cashier { get; set; }
        public string PaymentMode { get; set; }
        public string ProviderName { get; set; }

        public string Customer { get; set; }
        public string Waiter { get; set; }

        public string BillNo { get; set; }
        public DateTime BillDate { get; set; }

        public decimal Amount { get; set; }
    }

    public class ItemShiftReport
    {
        public string ITName { get; set; }
        public string FromTable { get; set; }
        public int FromSplitNo { get; set; }
        public string ToTable { get; set; }
        public int ToSplitNo { get; set; }
        public string ShiftedBy { get; set; }
        public decimal Quantity { get; set; }
        public bool IsCombo { get; set; }
        public DateTime ShiftedOn { get; set; }


    }

    public class ItemLedger
    {
        public string Item { get; set; }
        public decimal SalesQty { get; set; }
        public decimal PurchaseQty { get; set; }
        public float Balance { get; set; }
        public float Complimentry { get; set; }
        public float Adjustment { get; set; }
        public float PurchaseReturn { get; set; }
        public string Unit { get; set; }

        public DateTime Date { get; set; }


    }

    public class ProductionMain
    {
        public int ProductionMainId { get; set; }
        public int ItemId { get; set; }
        public int UnitId { get; set; }
        public int StoreId { get; set; }
        public float Quantity { get; set; }
        public DateTime AddedOn { get; set; }
        public string AddedBy { get; set; }
        public string ITName { get; set; }
        public string StName { get; set; }
        public int SmallUnit { get; set; }
        public string UnitDescription { get; set; }
        public string Symbol { get; set; }
        public List<ProductionDetails> ProductItems { get; set; }
    }

    public class ProductionDetails
    {
        public int ProductionMainID { get; set; }
        public int ItemId { get; set; }
        public int ItemUnitId { get; set; }
        public float Quantity { get; set; }
        public int StoreID { get; set; }
        public string ITName { get; set; }
        public int ITId { get; set; }
        public string StName { get; set; }
        public int SmallUnit { get; set; }
        public string UnitDescription { get; set; }
        public string Symbol { get; set; }


    }


    public class CashDenomination
    {
        public int DenominationId { get; set; }
        public DateTime Date { get; set; }
        public int thousand { get; set; }
        public int fivehundred { get; set; }
        public int hundred { get; set; }
        public int fifty { get; set; }
        public int twenty { get; set; }
        public int ten { get; set; }
        public int five { get; set; }
        public int two { get; set; }
        public int one { get; set; }


    }
    public class PurchaseData
    {
        public List<companyInfo> companyInfo { get; set; }
        public List<purchaseMains> purchaseMain { get; set; }
        public List<goodsReceiveMain> goodsMain { get; set; }
        public List<PurchaseReturnDetails> returnDetails { get; set; }
        public string AmntInWord { get; set; }
    }

    public class PurchaseReturnMain
    {
        public string PRNo { get; set; }
        public int PurchaseReturnId { get; set; }
        public int ItemID { get; set; }
        public string ITName { get; set; }
        public string Qnty { get; set; }
        public string RemainingQnty { get; set; }
        public string StName { get; set; }
        public int GMId { get; set; }
        public string GMNo { get; set; }
        public int STId { get; set; }
        public string PostedBy { get; set; }
        public DateTime PostedOn { get; set; }
        public string Symbol { get; set; }
        public int Conversion { get; set; }
        public int vendorId { get; set; }
        public string InvoiceNo { get; set; }
        public DateTime InvoiceDate { get; set; }
        public string Fname { get; set; }
        public string PuNo { get; set; }
        public List<itemBal> PurchaseObjItemBal { get; set; }
        public List<PurchaseReturnDetails> goodReceiveDetails { get; set; }
    }

    public class PurchaseReturnDetails
    {
        public int GDId { get; set; }
        public int GMId { get; set; }
        public int PDId { get; set; }
        public decimal Qnty { get; set; }
        public decimal Rate { get; set; }
        public decimal Total { get; set; }
        public string Symbol { get; set; }
        public string ItemName { get; set; }
        public int ItemID { get; set; }
        public string Fname { get; set; }
        public string InvoiceNo { get; set; }
        public int vendorId { get; set; }
        public int Conversion { get; set; }
        public int STId { get; set; }
        public string StName { get; set; }
        public int UsedUnitId { get; set; }
        public string Address { get; set; }
        public string TelWork { get; set; }

        public DateTime PostedOn { get; set; }
    }
    public class BillInfo
    {
        public string InvoiceNo { get; set; }
        public string InvoiceDate { get; set; }
        public bool IsCancelled { get; set; }
        public bool IsArchived { get; set; }
        public string CreditNoteNumber { get; set; }
        public string CreditNoteDate { get; set; }
        public string CreditNoteReason { get; set; }
        public decimal TotalAmount { get; set; }
        public int CustomerID { get; set; }
    }

    public class SalesReturnBillInfo
    {
        public int salesMasterId { get; set; }
        public string UserName { get; set; }
        public string Customer { get; set; }
        public string PAN { get; set; }
        public int CusId { get; set; }
        public string Remarks { get; set; }
    }


    public class TableReservation
    {
        public int ReservationID { get; set; }
        public string CustomerName { get; set; }
        public DateTime ReservedDateTime { get; set; }
        public int NoOfPeople { get; set; }
        public DateTime ReservedOn { get; set; }
        public string ReservedBy { get; set; }
        public bool IsConfirmed { get; set; }
        public string ConfirmedBy { get; set; }
        public string Note { get; set; }
        public bool IsCancelled { get; set; }
        public string CancelledBy { get; set; }
        public DateTime CancelledOn { get; set; }
        public string Phone { get; set; }
        public int NotifyBefore { get; set; }
        public string Tablename { get; set; }
        public string Time { get; set; }
        public List<ReservedTable> ReservedTable { get; set; }
    }

    public class ReservedTable
    {
        public int ReservedID { get; set; }
        public int ReservationID { get; set; }
        public int TableID { get; set; }
    }

    public class LanguageMenu
    {
        public int LanguageID { get; set; }
        public string CultureCode { get; set; }
        public string CultureName { get; set; }
        public string FallbackCulture { get; set; }
        public int ItemID { get; set; }
        public string Text { get; set; }
    }

    public class Token
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


    public class SaveLayoutTable
    {
        public int TableID { get; set; }
        public int RoomID { get; set; }
        public int UserModuleID { get; set; }
        public string restrotableTitle { get; set; }
        public string restroRoom { get; set; }

    }

    public class ordertype
    {
        public int OrderTypeID { get; set; }
        public string OrderType { get; set; }
    }

    public class CheckBill
    {
        public string ErrorMessage { get; set; }
        public int ErrorNumber { get; set; }
    }


    public class ShifTable
    {
        public int fromOrderMasterId { get; set; }
        public string shiftType { get; set; }
        public int fromTable { get; set; }
        public int fromSplitNo { get; set; }
        public int toTable { get; set; }
        public int toSplitNo { get; set; }
        public string shiftedBy { get; set; }
    }

    public class PurchasePayment
    {
        public int GMId { get; set; }
        public int paymentModeID { get; set; }
        public string ChequeNo { get; set; }
        public string TransactionNo { get; set; }
        public string ProviderID { get; set; }
        public string VendorID { get; set; }
        public string VendorName { get; set; }
        public decimal PayAmount { get; set; }
        public string Remarks { get; set; }
        public string PAN { get; set; }
    }

    public class License
    {
        public string CompanyCode { get; set; }
        public int ValidDays { get; set; }
    }
}

