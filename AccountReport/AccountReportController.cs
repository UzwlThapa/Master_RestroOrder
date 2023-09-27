using System;
using System.Collections.Generic;
using System.Data;

namespace SageFrame.AccountReport
{
    public class AccountReportController
    {
        public List<AccountReportInfo> GeneralLedgerReport(DateTime StartDate, DateTime EndDate, string FaIds)
        {
            AccountReportProvider prov = new AccountReportProvider();
            return prov.GeneralLedgerReport(StartDate, EndDate, FaIds);
        }

        public DataSet GetLedgerDetail(int transactionID)
        {
            AccountReportProvider prov = new AccountReportProvider();
            DataSet res = prov.GetLedgerDetail(transactionID);
            res.Tables[0].TableName = "TransactionInfo";
            res.Tables[1].TableName = "TransactionDetail";

            return res;
        }

        public List<AccountReportInfo> TrialBalanceReport(DateTime Date)
        {
            AccountReportProvider prov = new AccountReportProvider();
            return prov.TrialBalanceReport(Date);
        }

        public List<TransactionReportInfo> GetTransactionReport(DateTime From, DateTime To)
        {
            AccountReportProvider prov = new AccountReportProvider();
            return prov.GetTransactionReport(From, To);
        }

        public List<TransactionReportDetailsInfo> GetTransactionDetailReport(DateTime From, DateTime To, int GL_ID)
        {
            AccountReportProvider prov = new AccountReportProvider();
            return prov.GetTransactionDetailReport(From, To, GL_ID);
        }

        public List<TransactionReportInfo> GetGL_Name()
        {
            AccountReportProvider prov = new AccountReportProvider();
            return prov.GetGL_Name();
        }
    }
}
