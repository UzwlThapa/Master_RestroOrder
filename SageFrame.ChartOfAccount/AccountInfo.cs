using System;
using System.Collections.Generic;

namespace SageFrame.ChartOfAccount
{
    public class BalanceSheet
    {
        public List<AccountInfo> balanceSheet { get; set; }
        public decimal profitLoss { get; set; }
    }
    public class AccountInfo
    {
        public int FinancialSysID { get; set; }
        public string FinancialSysName { get; set; }
        public bool IsGroup { get; set; }
        public bool FinancialSysIsActive { get; set; }
        public string Note { get; set; }
        public int FinancialAcID { get; set; }
        public string FinancialAcName { get; set; }
        public int? PFinancialAcID { get; set; }
        public string AddedBy { get; set; }
        public string AddedOn { get; set; }
        public string PFinancialAcName { get; set; }
        public string items { get; set; }
        public bool isGroup { get; set; }
        public List<bankInfo> bankInfo { get; set; }
        public int level { get; set; }
        public decimal Credit { get; set; }
        public decimal Debit { get; set; }
        public decimal? OpeningBalance { get; set; }
        public int AccountEntryType { get; set; }
        public bool IsDebit { get; set; }
        public decimal PLBalance { get; set; }
        public bool SystemGenerated { get; set; }
    }

    public class MergerAccDetails
    {
        public int ParentAccId { get; set; }
        public string NewAccName { get; set; }
        public int MergeFirstAccId { get; set; }
        public int MergeSecondAccId { get; set; }
        public string  MergeBy { get; set; }
    }

    public class ACOpeningInfo
    {
        public int AccId { get; set; }
        public DateTime OpeningDate { get; set; }
        public decimal OpeningBalance { get; set; }
        public bool IsDebit { get; set; }
        public string AddedBy { get; set; }
    }

    public class OpeningBalDetails
    {
        public int AcOpeningId { get; set; }
        public bool IsLoyality { get; set; }
        public int MemberShipId { get; set; }
        public int TranId { get; set; }
        public DateTime TranDate { get; set; }
        public decimal OpeningAmt { get; set; }
        public bool IsDebit { get; set; }
        public DateTime AddedOn { get; set; }
        public string AddedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
        public bool IsArchived { get; set; }
        public string AcName { get; set; }
    }

    public class Voucher {
        public int VoucherTypeID { get; set; }
        public string VoucherName { get; set; }
        public string Prefix { get; set; }
        public int FiscalID { get; set; }
        public int VoucherCount { get; set; }
        public bool IsAutomatic { get; set; }
        public string AddedBy { get; set; }
        public DateTime AddedOn { get; set; }
        public bool IsUpdated { get; set; }
        public DateTime UpdatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public bool IsArchived { get; set; }
        public DateTime ArchivedOn { get; set; }
        public string ArchivedBy { get; set; }
    }

    public class Transaction
    {
        public int TransactionID { get; set; }
        public string TransactionDate { get; set; }
        public string VerificationDate { get; set; }
        public int VoucherTypeID { get; set; }
        public string VoucherNo { get; set; }
        public string Descriptions { get; set; }
        public string PostedBy { get; set; }
        public DateTime PostedOn { get; set; }
        public DateTime UpdatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public bool IsUpdated { get; set; }
        public bool IsDeleted { get; set; }
        public string DeletedBy { get; set; }
        public DateTime DeletedOn { get; set; }
        public DateTime VerifiedOn { get; set; }
        public string VerifiedBy { get; set; }
        public List<TransactionDetails> TransactionDetails { get; set; }
        public decimal totalDebit { get; set; }
        public decimal totalCredit { get; set; }
        public string VoucherName { get; set; }
    }

    public class TransactionDetails {
        public int TransactionDetailID { get; set; }
        public int TransactionID { get; set; }
        public int FinancialAcID { get; set; }
        public int MemberShipID { get; set; }
        public string ChequeNo { get; set; }
        public string ChequeDate { get; set; }
        public string Particulars { get; set; }
        public decimal Debit { get; set; }
        public decimal Credit { get; set; }
        public string financialAcName { get; set; }
        public string PostedBy { get; set; }
        public string PostedOn { get; set; }
        public int VoucherTypeID { get; set; }
        public string VoucherName { get; set; }
    }

    public class VoucherType {
        public int VoucherTypeID { get; set; }
        public string VoucherName { get; set; }
        public string Prefix { get; set; }
        public string AddedBy { get; set; }
    }

    public class bankInfo
    {
        public int BankAccountID { get; set; }
        public int FinancialAcID { get; set; }
        public string PhoneNo { get; set; }
        public string Branch { get; set; }
        public string ContactPerson { get; set; }
        public bool IsFixed{ get; set; }
        public decimal InterestRate { get; set; }
        public string OpenDate { get; set; }
        public string MatureDate { get; set; }
        public decimal MinimumBalance { get; set; }
    }

    public class PaymentModes
    {
        public int PaymentModeID { get; set; }
        public string PaymentMode { get; set; } 
    }


    public class PaymentReceiveVoucher
    {
        public string VoucherDescription { get; set; }
        public DateTime VoucherDate { get; set; }
        public int VoucherTypeId { get; set; }
        public int FinancialAcID { get; set; }
        public string Particulars { get; set; }
        public decimal Amount { get; set; }
        public int BankAccId { get; set; }
        public int PaymodeId { get; set; }
        public string ChequeNo { get; set; }
        public DateTime ChequeDate { get; set; }
        public string UserName { get; set; }

    }
}
