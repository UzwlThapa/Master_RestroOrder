namespace SageFrame.AccountReport
{
    public class AccountReportInfo
    {
        public int TransactionID { get; set; }

        public int FinancialAcID { get; set; }
        public string TransactionDate { get; set; }
        public string FinanceName { get; set; }
        public float Debit { get; set; }
        public float Credit { get; set; }
        public string Account { get; set; }
        public string CompanyName { get; set; }
        public string Date { get; set; }
        public string ParentAccount { get; set; }
        public string AccountHead { get; set; }
        public string Particulars { get; set; }
        public float Balance { get; set; }
 
    }


    public class TransactionReportInfo
    {
        public int GlID { get; set; }
        public string GLName { get; set; }
        public int level { get; set; }
        public bool IsGroup { get; set; }
        public float openingBalance { get; set; }
        public float DebitAmount { get; set; }
        public float CreditAmount { get; set; }
        public float ClosingAmount { get; set; }
    
    }

    public class TransactionReportDetailsInfo
    {
        public int TransactionID { get; set; }
        public int TransactionDetailID { get; set; }
        public string Date { get; set; }
        public string VoucherNo { get; set; }
        public string Descriptions { get; set; }
        public string Particulars { get; set; }
        public float Debit { get; set; }
        public float credit { get; set; }
        public float Balance { get; set; }
    
    }

}
