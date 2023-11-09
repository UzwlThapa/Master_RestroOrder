using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;

namespace SageFrame.ChartOfAccount
{
    public class AccountController
    {
        public List<AccountInfo> getParentFinancialAcName()
        {
            AccountProvider prov = new AccountProvider();
            return prov.getParentFinancialAcName();
        }

        public List<AccountInfo> getFinancialSysName()
        {
            AccountProvider prov = new AccountProvider();
            return prov.getFinancialSysName();
        }

        public int saveFinancialAc(AccountInfo info)
        {
            AccountProvider prov = new AccountProvider();
            return prov.saveFinancialAc(info);
        }

        public List<AccountInfo> getAllFinancialAcForGrid()
        {
            AccountProvider prov = new AccountProvider();
            return prov.getAllFinancialAcForGrid();
        }

        public string deleteFinancialAcByID(int id, string username)
        {
            AccountProvider prov = new AccountProvider();
            return prov.deleteFinancialAcByID(id, username);
        }

        public List<Voucher> getVoucharType()
        {
            AccountProvider prov = new AccountProvider();
            return prov.getVoucharType();
        }

        public bool CheckForDisplayChequeNo(int FinancialAcID)
        {
            AccountProvider prov = new AccountProvider();
            return prov.CheckForDisplayChequeNo(FinancialAcID);
        }

        public int SaveTransaction(Transaction Transaction)
        {
            AccountProvider prov = new AccountProvider();
            return prov.SaveTransaction(Transaction);
        }

        public string getAutoVoucherNo()
        {
            AccountProvider prov = new AccountProvider();
            return prov.getAutoVoucherNo();
        }

        public List<Transaction> getTempTransactionList(string startDate, string endDate)
        {
            AccountProvider prov = new AccountProvider();
            return prov.getTempTransactionList(startDate, endDate);
        }

        public List<TransactionDetails> getTransactionByID(int transactionID)
        {
            AccountProvider prov = new AccountProvider();
            return prov.getTransactionByID(transactionID);
        }

        public int SaveVerifiedTransaction(Transaction Transaction)
        {
            AccountProvider prov = new AccountProvider();
            return prov.SaveVerifiedTransaction(Transaction);
        }

        public List<Transaction> getVerifiedTransactionList(string startDate, string endDate)
        {
            AccountProvider prov = new AccountProvider();
            return prov.getVerifiedTransactionList(startDate, endDate);
        }

        public void DeleteTempTransactionByID(int transactionID, string username)
        {
            AccountProvider prov = new AccountProvider();
            prov.DeleteTempTransactionByID(transactionID, username);
        }

        public List<VoucherType> getVoucherTypeList()
        {
            AccountProvider prov = new AccountProvider();
            return prov.getVoucherTypeList();
        }

        public void saveVoucherType(VoucherType voucher)
        {
            AccountProvider prov = new AccountProvider();
            prov.saveVoucherType(voucher);
        }

        public void deleteVoucherTypeByID(int VoucherTypeID, string username)
        {
            AccountProvider prov = new AccountProvider();
            prov.deleteVoucherTypeByID(VoucherTypeID, username);
        }

        public List<AccountInfo> getFinancialAc()
        {
            AccountProvider prov = new AccountProvider();
            return prov.getFinancialAc();
        }
        
        public void MergeFinancialAcc(MergerAccDetails obj)
        {
            AccountProvider prov = new AccountProvider();
            prov.MergeFinancialAcc(obj);
        }

        public void AddOpeningBalance(ACOpeningInfo obj)
        {
            AccountProvider prov = new AccountProvider();
            prov.AddOpeningBalance(obj);
        }

        public void UpdateOpeningBalance(OpeningBalDetails obj)
        {
            AccountProvider prov = new AccountProvider();
            prov.UpdateOpeningBalance(obj);
        }

        

        public List<OpeningBalDetails> getOpeningBalanceDetails()
        {
            AccountProvider prov = new AccountProvider();
            return prov.getOpeningBalanceDetails();
        }

        public OpeningBalDetails getOpeningBalanceDetailsById(int id)
        {
            AccountProvider prov = new AccountProvider();
            return prov.getOpeningBalanceDetailsById(id);
        }




        public string getBalanceSheet(string startdate, string enddate)
        {
            AccountProvider prov = new AccountProvider();
            JavaScriptSerializer serialize = new JavaScriptSerializer();
            BalanceSheet balanceSheet = new BalanceSheet();
            balanceSheet.balanceSheet = prov.getBalanceSheet(startdate,enddate);
            balanceSheet.profitLoss = balanceSheet.balanceSheet.Sum(p => p.Debit) - balanceSheet.balanceSheet.Sum(p => p.Credit);

            return serialize.Serialize(balanceSheet);
        }

        public List<AccountInfo> getTrailBalance(DateTime Dates)
        {
            AccountProvider prov = new AccountProvider();
            return prov.getTrailBalance(Dates);
        }

        public List<AccountInfo> getProfitLoss(string startdate, string enddate)
        {
            AccountProvider prov = new AccountProvider();
            return prov.ProfitLoss(startdate, enddate);
        }
        public List<AccountInfo> getFinancialAcDetails(int financialAcId, string date)
        {
            AccountProvider prov = new AccountProvider();
            return prov.getFinancialAcDetails(financialAcId, date);
        }

        public List<ChartOfAccount.bankInfo> getBankInfoByFinancialAcID(int FinancialAcID)
        {
            AccountProvider rep = new AccountProvider();
            return rep.getBankInfoByFinancialAcID(FinancialAcID);
        }

        public List<TransactionDetails> getVerifiedTransactionByID(int transactionID, int financialAccountId = 0)
        {
            AccountProvider prov = new AccountProvider();
            return prov.getVerifiedTransactionByID(transactionID,financialAccountId);
        }


        public void SaveVerifiedTransactionByID(List<Transaction> Transaction)
        {
            AccountProvider prov = new AccountProvider();
            prov.SaveVerifiedTransactionByID(Transaction);
        }

        public List<PaymentModes> getPaymentMethods()
        {
            AccountProvider prov = new AccountProvider();
            return prov.getPaymentMethods();
        }

        public void SavePaymentReceiveVoucher(PaymentReceiveVoucher obj)
        {
            AccountProvider prov = new AccountProvider();
            prov.SavePaymentReceiveVoucher(obj);
        }
        


    }
}
