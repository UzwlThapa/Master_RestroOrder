using SageFrame.Web.Utilities;
using System;
using System.Collections.Generic;
using System.Data;

namespace SageFrame.AccountReport
{
    public class AccountReportProvider
    {
        internal List<AccountReportInfo> GeneralLedgerReport(DateTime StartDate, DateTime EndDate, string VoucherNo)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Start", StartDate));
            Param.Add(new KeyValuePair<string, object>("@End", EndDate));
            Param.Add(new KeyValuePair<string, object>("@ACID", int.Parse(VoucherNo)));
            return sqlhan.ExecuteAsList<AccountReportInfo>("[usp_AC_GeneralLedgerReport_New]", Param);
        }


        internal List<AccountReportInfo> TrialBalanceReport(DateTime Date)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Date", Date));
            return sqlhan.ExecuteAsList<AccountReportInfo>("[usp_AC_TrialBalanceReport]", Param);
        }

        internal List<TransactionReportInfo> GetTransactionReport(DateTime From, DateTime To)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@From", From));
            Param.Add(new KeyValuePair<string, object>("@To", To));
            //Param.Add(new KeyValuePair<string, object>("@End", EndDate));
            //Param.Add(new KeyValuePair<string, object>("@VoucherNo", int.Parse(VoucherNo)));
            return sqlhan.ExecuteAsList<TransactionReportInfo>("[USP_AC_GetTransactionReport]", Param);
        }

        internal List<TransactionReportDetailsInfo> GetTransactionDetailReport(DateTime From, DateTime To, int GL_ID)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@From", From));
            Param.Add(new KeyValuePair<string, object>("@to", To));
            Param.Add(new KeyValuePair<string, object>("@GLID", GL_ID));
            //Param.Add(new KeyValuePair<string, object>("@VoucherNo", int.Parse(VoucherNo)));
            return sqlhan.ExecuteAsList<TransactionReportDetailsInfo>("[USP_AC_GetTransactionDetailReport]", Param);
        }

        internal List<TransactionReportInfo> GetGL_Name()
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            //  Param.Add(new KeyValuePair<string, object>("@Date", Dates));
            //Param.Add(new KeyValuePair<string, object>("@End", EndDate));
            //Param.Add(new KeyValuePair<string, object>("@VoucherNo", int.Parse(VoucherNo)));
            return sqlhan.ExecuteAsList<TransactionReportInfo>("[USP_AC_GetGL_Name]", Param);
        }

        internal DataSet GetLedgerDetail(int transactionID)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@TransactionID", transactionID));
            return sqlhan.ExecuteAsDataSet("[dbo].[usp_GetLedgerDetail]", Param);
        }
    }
}
