using SageFrame.Web.Utilities;
using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace SageFrame.ChartOfAccount
{
    public class AccountProvider
    {

        internal List<AccountInfo> getParentFinancialAcName()
        {
            SQLHandler sql = new SQLHandler();
            return sql.ExecuteAsList<AccountInfo>("usp_Ac_getParentFinancialAcName");
        }

        internal List<AccountInfo> getFinancialSysName()
        {
            SQLHandler sql = new SQLHandler();
            return sql.ExecuteAsList<AccountInfo>("usp_Ac_FinancialSysName");
        }

        internal int saveFinancialAc(AccountInfo info)
        {
            SQLHandler sql = new SQLHandler();
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@FinancialAcID", info.FinancialAcID));
            param.Add(new KeyValuePair<string, object>("@FinancialAcName", info.FinancialAcName));
            param.Add(new KeyValuePair<string, object>("@PFinancialAcID", info.PFinancialAcID));
            param.Add(new KeyValuePair<string, object>("@FinancialSysID", info.FinancialSysID));
            param.Add(new KeyValuePair<string, object>("@AddedBy", info.AddedBy));
            param.Add(new KeyValuePair<string, object>("@OpeningBalance", info.OpeningBalance));
            param.Add(new KeyValuePair<string, object>("@AccEntryType", info.AccountEntryType));
            param.Add(new KeyValuePair<string, object>("@IsDebit", info.IsDebit));
            var FinancialAcID = sql.ExecuteAsScalar<int>("usp_Ac_saveFinancialAc", param);


            if (info.FinancialSysID == 4)
            {
                foreach (bankInfo bankInfo in info.bankInfo)
                {
                    List<KeyValuePair<string, object>> param2 = new List<KeyValuePair<string, object>>();
                    //param2.Add(new KeyValuePair<string, object>("@BankAccountID", bankInfo.BankAccountID));
                    param2.Add(new KeyValuePair<string, object>("@FinancialAcID", FinancialAcID));
                    param2.Add(new KeyValuePair<string, object>("@PhoneNo", bankInfo.PhoneNo));
                    param2.Add(new KeyValuePair<string, object>("@Branch", bankInfo.Branch));
                    param2.Add(new KeyValuePair<string, object>("@ContactPerson", bankInfo.ContactPerson));
                    param2.Add(new KeyValuePair<string, object>("@IsFixed", bankInfo.IsFixed));
                    param2.Add(new KeyValuePair<string, object>("@InterestRate", bankInfo.InterestRate));
                    param2.Add(new KeyValuePair<string, object>("@OpenDate", bankInfo.OpenDate));
                    param2.Add(new KeyValuePair<string, object>("@MatureDate", bankInfo.MatureDate));
                    param2.Add(new KeyValuePair<string, object>("@MinimumBalance", bankInfo.MinimumBalance));
                    sql.ExecuteNonQuery("usp_Ac_saveBankInfo", param2);
                }
            }
            return FinancialAcID;
        }

        internal List<AccountInfo> getAllFinancialAcForGrid()
        {
            SQLHandler sql = new SQLHandler();
            return sql.ExecuteAsList<AccountInfo>("usp_ac_getAllFinancialAcForGrid");
        }

        internal string deleteFinancialAcByID(int id, string username)
        {
            try
            {
                SQLHandler sql = new SQLHandler();
                List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
                param.Add(new KeyValuePair<string, object>("@id", id));
                param.Add(new KeyValuePair<string, object>("@username", username));
                return sql.ExecuteAsScalar<string>("usp_ac_deleteFinancialAcByID", param);
            }
            catch (Exception)
            {

                throw;
            }


        }

        internal List<Voucher> getVoucharType()
        {
            SQLHandler sql = new SQLHandler();
            return sql.ExecuteAsList<Voucher>("usp_ac_getVoucharTypeForDropDown");
        }

        internal bool CheckForDisplayChequeNo(int FinancialAcID)
        {
            SQLHandler sql = new SQLHandler();
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@FinancialAcID", FinancialAcID));
            return sql.ExecuteAsScalar<bool>("usp_ac_CheckForDisplayChequeNo", param);
        }

        internal int SaveTransaction(Transaction Transaction)
        {
            SQLHandler sql = new SQLHandler();
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@TransactionID", Transaction.TransactionID));
            param.Add(new KeyValuePair<string, object>("@VoucherTypeID", Transaction.VoucherTypeID));
            //param.Add(new KeyValuePair<string, object>("@VoucherNo", Transaction.VoucherNo));
            param.Add(new KeyValuePair<string, object>("@Descriptions", Transaction.Descriptions));
            param.Add(new KeyValuePair<string, object>("@TransactionDate", Transaction.TransactionDate));
            param.Add(new KeyValuePair<string, object>("@PostedBy", Transaction.PostedBy));
            var transactionID = sql.ExecuteAsScalar<int>("usp_ac_SaveTransaction", param);

            List<KeyValuePair<string, object>> param3 = new List<KeyValuePair<string, object>>();
            param3.Add(new KeyValuePair<string, object>("@transactionID", transactionID));
            sql.ExecuteNonQuery("usp_ac_deleteTransactionDetailByID", param3);

            foreach (TransactionDetails detail in Transaction.TransactionDetails)
            {
                List<KeyValuePair<string, object>> param2 = new List<KeyValuePair<string, object>>();
                param2.Add(new KeyValuePair<string, object>("@TransactionID", transactionID));
                param2.Add(new KeyValuePair<string, object>("@FinancialAcID", detail.FinancialAcID));
                param2.Add(new KeyValuePair<string, object>("@ChequeNo", detail.ChequeNo));
                param2.Add(new KeyValuePair<string, object>("@ChequeDate", detail.ChequeDate));
                param2.Add(new KeyValuePair<string, object>("@Particulars", detail.Particulars));
                param2.Add(new KeyValuePair<string, object>("@Debit", detail.Debit));
                param2.Add(new KeyValuePair<string, object>("@Credit", detail.Credit));
                sql.ExecuteNonQuery("usp_ac_SaveTransactionDetails", param2);
            }
            return transactionID;
        }

        internal List<AccountInfo> getFinancialAcDetails(int financialAcId, string date)
        {
            SQLHandler sql = new SQLHandler();
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@FinancialAcID", financialAcId));
            param.Add(new KeyValuePair<string, object>("@date", date));
            return sql.ExecuteAsList<AccountInfo>("USP_ac_getFinancialAcDetails", param);
        }

        internal string getAutoVoucherNo()
        {
            SQLHandler sql = new SQLHandler();
            return sql.ExecuteAsScalar<string>("USP_ROI_VoucherAUTONUMBER");
        }

        internal List<Transaction> getTempTransactionList(string startDate, string endDate)
        {
            SQLHandler sql = new SQLHandler();
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@StartDate", startDate));
            param.Add(new KeyValuePair<string, object>("@EndDate", endDate));
            return sql.ExecuteAsList<Transaction>("USP_AC_getTempTransactionList", param);
        }

        internal List<TransactionDetails> getTransactionByID(int transactionID)
        {
            List<KeyValuePair<string, object>> param1 = new List<KeyValuePair<string, object>>();
            param1.Add(new KeyValuePair<string, object>("@TransactionID", transactionID));
            SQLHandler sql = new SQLHandler();
            return sql.ExecuteAsList<TransactionDetails>("usp_ac_getTransactionByID", param1);
        }



        internal int SaveVerifiedTransaction(Transaction Transaction)
        {
            SQLHandler sql = new SQLHandler();
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@TransactionID", Transaction.TransactionID));
            param.Add(new KeyValuePair<string, object>("@VoucherTypeID", Transaction.VoucherTypeID));
            // param.Add(new KeyValuePair<string, object>("@VoucherNo", Transaction.VoucherNo));
            param.Add(new KeyValuePair<string, object>("@Descriptions", Transaction.Descriptions));
            param.Add(new KeyValuePair<string, object>("@TransactionDate", Transaction.TransactionDate));
            param.Add(new KeyValuePair<string, object>("@PostedBy", Transaction.PostedBy));
            param.Add(new KeyValuePair<string, object>("@PostedOn", Transaction.PostedOn));
            param.Add(new KeyValuePair<string, object>("@VerifiedBy", Transaction.VerifiedBy));
            var transactionID = sql.ExecuteAsScalar<int>("usp_ac_SaveVerifiedTransaction", param);
            foreach (TransactionDetails detail in Transaction.TransactionDetails)
            {
                List<KeyValuePair<string, object>> param2 = new List<KeyValuePair<string, object>>();
                param2.Add(new KeyValuePair<string, object>("@TransactionID", transactionID));
                param2.Add(new KeyValuePair<string, object>("@FinancialAcID", detail.FinancialAcID));
                param2.Add(new KeyValuePair<string, object>("@ChequeNo", detail.ChequeNo));
                param2.Add(new KeyValuePair<string, object>("@ChequeDate", detail.ChequeDate));
                param2.Add(new KeyValuePair<string, object>("@Particulars", detail.Particulars));
                param2.Add(new KeyValuePair<string, object>("@Debit", detail.Debit));
                param2.Add(new KeyValuePair<string, object>("@Credit", detail.Credit));
                sql.ExecuteNonQuery("usp_ac_SaveVerifiedTransactionDetails", param2);
            }
            return transactionID;
        }

        internal List<Transaction> getVerifiedTransactionList(string startDate, string endDate)
        {
            SQLHandler sql = new SQLHandler();
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@StartDate", startDate));
            param.Add(new KeyValuePair<string, object>("@EndDate", endDate));
            return sql.ExecuteAsList<Transaction>("USP_AC_getVerifiedTransactionList", param);
        }

        internal void DeleteTempTransactionByID(int transactionID, string username)
        {
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@transactionID", transactionID));
            param.Add(new KeyValuePair<string, object>("@username", username));
            SQLHandler sql = new SQLHandler();
            sql.ExecuteNonQuery("USP_AC_DeleteTempTransactionByID", param);
        }

        internal List<VoucherType> getVoucherTypeList()
        {
            SQLHandler sql = new SQLHandler();
            return sql.ExecuteAsList<VoucherType>("USP_AC_getVoucherTypeList");
        }

        internal void saveVoucherType(VoucherType voucher)
        {
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@VoucherTypeID", voucher.VoucherTypeID));
            param.Add(new KeyValuePair<string, object>("@VoucherName", voucher.VoucherName));
            param.Add(new KeyValuePair<string, object>("@Prefix", voucher.Prefix));
            param.Add(new KeyValuePair<string, object>("@AddedBy", voucher.AddedBy));
            SQLHandler sql = new SQLHandler();
            sql.ExecuteNonQuery("USP_AC_saveVoucherType", param);
        }

        internal void deleteVoucherTypeByID(int VoucherTypeID, string username)
        {
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@VoucherTypeID", VoucherTypeID));
            param.Add(new KeyValuePair<string, object>("@ArchivedBy", username));
            SQLHandler sql = new SQLHandler();
            sql.ExecuteNonQuery("USP_AC_deleteVoucherTypeByID", param);
        }

        internal List<AccountInfo> getFinancialAc()
        {
            SQLHandler sql = new SQLHandler();
            return sql.ExecuteAsList<AccountInfo>("USP_AC_getFinancialAc");
        }


        internal void MergeFinancialAcc(MergerAccDetails obj)
        {
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@ParentAccId", obj.ParentAccId));
            param.Add(new KeyValuePair<string, object>("@NewAccName", obj.NewAccName));
            param.Add(new KeyValuePair<string, object>("@MergeFirstAccId", obj.MergeFirstAccId));
            param.Add(new KeyValuePair<string, object>("@MergeSecondAccId", obj.MergeSecondAccId));
            param.Add(new KeyValuePair<string, object>("@MergeBy", obj.MergeBy));
            SQLHandler sql = new SQLHandler();
            sql.ExecuteNonQuery("USP_Ac_MergeAcc", param);
        }

        internal void AddOpeningBalance(ACOpeningInfo obj)
        {
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@AcId", obj.AccId));
            param.Add(new KeyValuePair<string, object>("@OpeningDate", obj.OpeningDate));
            param.Add(new KeyValuePair<string, object>("@OpeningAmt", obj.OpeningBalance));
            param.Add(new KeyValuePair<string, object>("@AddedBy", obj.AddedBy));
            param.Add(new KeyValuePair<string, object>("@IsDebit", obj.IsDebit));
            SQLHandler sql = new SQLHandler();
            sql.ExecuteNonQuery("USP_Ac_AddACOpeningBalance", param);
        }

        internal void UpdateOpeningBalance(OpeningBalDetails obj)
        {
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@OpeningId", obj.AcOpeningId));
            param.Add(new KeyValuePair<string, object>("@TranDate", obj.TranDate));
            param.Add(new KeyValuePair<string, object>("@OpeningAmt", obj.OpeningAmt));
            param.Add(new KeyValuePair<string, object>("@AddedBy", obj.AddedBy));
            param.Add(new KeyValuePair<string, object>("@IsDebit", obj.IsDebit));
            SQLHandler sql = new SQLHandler();
            sql.ExecuteNonQuery("USP_Ac_UpdateACOpeningBalance", param);
        }

        internal OpeningBalDetails getOpeningBalanceDetailsById(int Id)
        {
            SQLHandler sql = new SQLHandler();
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@Id", Id));
            return sql.ExecuteAsObject<OpeningBalDetails>("USP_Ac_GetAcOpeningBalanceById", param);
        }

        internal List<OpeningBalDetails> getOpeningBalanceDetails()
        {
            SQLHandler sql = new SQLHandler(); ;
            return sql.ExecuteAsList<OpeningBalDetails>("USP_Ac_GetAcOpeningBalance");
        }





        internal List<AccountInfo> getBalanceSheet(string startdate, string enddate)
        {
            SQLHandler sql = new SQLHandler();
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@StartDate", startdate));
            param.Add(new KeyValuePair<string, object>("@EndDate", enddate));
            return sql.ExecuteAsList<AccountInfo>("usp_ac_getBalanceSheets", param);
        }

        internal List<AccountInfo> getTrailBalance(DateTime Dates)
        {
            SQLHandler sql = new SQLHandler();
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@Date", Dates));
            return sql.ExecuteAsList<AccountInfo>("usp_ac_getTrailBalance", param);
        }

        internal List<AccountInfo> ProfitLoss(string startdate, string enddate)
        {
            SQLHandler sql = new SQLHandler();
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@StartDate", startdate));
            param.Add(new KeyValuePair<string, object>("@EndDate", enddate));
            return sql.ExecuteAsList<AccountInfo>("usp_ac_getProfitLoss", param);
        }
        internal List<ChartOfAccount.bankInfo> getBankInfoByFinancialAcID(int FinancialAcID)
        {
            SQLHandler sqh = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FinancialAcID", FinancialAcID));
            return sqh.ExecuteAsList<ChartOfAccount.bankInfo>("usp_roi_getBankInfoByFinancialAcID", Param);
        }


        internal List<TransactionDetails> getVerifiedTransactionByID(int transactionID, int financialAccountId = 0)
        {
            List<KeyValuePair<string, object>> param1 = new List<KeyValuePair<string, object>>
            {
                new KeyValuePair<string, object>("@TransactionID", transactionID),
                new KeyValuePair<string, object>("@FinancialAccountId", financialAccountId)
            };
            SQLHandler sql = new SQLHandler();
            return sql.ExecuteAsList<TransactionDetails>("usp_ac_getVerifiedTransactionByID", param1);
        }

        internal void SaveVerifiedTransactionByID(List<Transaction> Transaction)
        {
            SQLHandler sqlhan = new SQLHandler();
            foreach (Transaction Trans in Transaction)
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@TransactionID", Trans.TransactionID));
                sqlhan.ExecuteNonQuery("Usp_saveTransctionByID", Param);
            }
        }
        internal string TempPurchaseDetailExists()
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            return sqlhan.ExecuteAsScalar<string>("SpTempPurchaseDetailExists", Param);
        }

        internal List<PaymentModes> getPaymentMethods()
        {
            SQLHandler sql = new SQLHandler();
            return sql.ExecuteAsList<PaymentModes>("usp_ro_GetPaymentModes");
        }

        internal void SavePaymentReceiveVoucher(PaymentReceiveVoucher obj)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@VoucherTypeId", obj.VoucherTypeId));
            Param.Add(new KeyValuePair<string, object>("@FinancialAcId", obj.FinancialAcID));
            Param.Add(new KeyValuePair<string, object>("@Particulars", obj.Particulars));
            Param.Add(new KeyValuePair<string, object>("@Amount", obj.Amount));
            Param.Add(new KeyValuePair<string, object>("@PaymentModeId", obj.PaymodeId));
            Param.Add(new KeyValuePair<string, object>("@BankAccId", obj.BankAccId));
            Param.Add(new KeyValuePair<string, object>("@ChequeNo", obj.ChequeNo));
            Param.Add(new KeyValuePair<string, object>("@ChequeDate", obj.ChequeDate));
            Param.Add(new KeyValuePair<string, object>("@Description", obj.VoucherDescription));
            Param.Add(new KeyValuePair<string, object>("@VoucherDate", obj.VoucherDate));
            Param.Add(new KeyValuePair<string, object>("@CreatedBy", obj.UserName));
            sqlhan.ExecuteNonQuery("USP_Save_PaymentReceiveVoucher", Param);
        }
    }
}
