using SageFrame.Web.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SageFrame.RestroOrder
{
    public class DailyReportProvider
    {
        private SQLHandler sqlHandler;

        public DailyReportProvider()
        {
            sqlHandler = new SQLHandler();
        }
        internal List<SalesReport> GenerateDailySalesReport(string period)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@date", period));
            Param.Add(new KeyValuePair<string, object>("@viewOnly", true));
            List<SalesReport> orderMasterinfo = sqlHandler.ExecuteAsList<SalesReport>("[usp_ro_generateDailySalesReport]", Param);
            return orderMasterinfo;
        }

        internal List<SalesReport> GetDayPartWiseSalesReport(string period)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Date", period));
            List<SalesReport> orderMasterinfo = sqlHandler.ExecuteAsList<SalesReport>("[USP_GetDayPartWise_Sales_Report]", Param);
            return orderMasterinfo;
        }

        internal bool CheckIfCBMSAlreadySent(int salesMasterId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
            return sqlHandler.ExecuteAsScalar<bool>("[usp_cbms_CheckIfCBMSAlreadySent]", Param);
        }

        internal List<StockReport> GenerateDailyStockReport(string period)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@date", period));
            Param.Add(new KeyValuePair<string, object>("@viewOnly", true));
            List<StockReport> orderMasterinfo = sqlHandler.ExecuteAsList<StockReport>("[usp_ro_generateDailyStockReport]", Param);
            return orderMasterinfo;
        }
        internal List<SummaryReport> GenerateDailySummaryReport(string period)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@date", period));
            Param.Add(new KeyValuePair<string, object>("@viewOnly", true));
            List<SummaryReport> orderMasterinfo = sqlHandler.ExecuteAsList<SummaryReport>("[usp_ro_generateDailyFinancialReport]", Param);
            return orderMasterinfo;
        }
        internal List<CreditorBalanceReport> GenerateDailyCreditorsReport()
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@IsCustomer", true));
            List<CreditorBalanceReport> orderMasterinfo = sqlHandler.ExecuteAsList<CreditorBalanceReport>("[usp_GetCustomerBalanceByID]", Param);
            return orderMasterinfo;
        }
        internal List<CreditorBalanceReport> GenerateDailyVendorsReport()
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@IsCustomer", false));
            List<CreditorBalanceReport> orderMasterinfo = sqlHandler.ExecuteAsList<CreditorBalanceReport>("[usp_GetCustomerBalanceByID]", Param);
            return orderMasterinfo;
        }

        internal List<CreditPayReport> getCreditPayReportByDates(DateTime sdate, DateTime edate, bool? IsCustomer = null)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@sdate", sdate));
                Param.Add(new KeyValuePair<string, object>("@edate", edate));
                Param.Add(new KeyValuePair<string, object>("@IsCustomer", IsCustomer));
                return sqlHandler.ExecuteAsList<CreditPayReport>("USP_RO_getCreditPayReportByDates", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal List<dailyreport> getdailyReportByReportNumber(DateTime startdate, DateTime enddate, int ReportNum)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Todaydate", startdate));
            Param.Add(new KeyValuePair<string, object>("@enddate", enddate));
            Param.Add(new KeyValuePair<string, object>("@ReportNum", ReportNum));
            List<dailyreport> dailyReportList = sqlHandler.ExecuteAsList<dailyreport>("[USP_SALSEREPORTBtodayByReportNum]", Param);
            return dailyReportList;
        }

        internal List<providersReport> getAllProvidersReport(DateTime startDate, DateTime endDate, int paymentMode, int provider)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@paymentMode", paymentMode));
            Param.Add(new KeyValuePair<string, object>("@provider", provider));
            List<providersReport> dailyReportList = sqlHandler.ExecuteAsList<providersReport>("[usp_GetAllSalesProvidersReport]", Param);
            return dailyReportList;
        }

        internal CashDenomination GetCashDenomination()
        {
            List<CashDenomination> CashDenominationList = sqlHandler.ExecuteAsList<CashDenomination>("[USP_GETLatestCashDenomination]");
            return CashDenominationList[0];
        }

        internal List<ItemSalesReport> GetDailyItemSalesForMail(string period)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@date", period));
            return sqlHandler.ExecuteAsList<ItemSalesReport>("[usp_ro_dailyItemSalesForMail]", Param);
        }

        internal string Mailkey(string MailKey)
        {
            List<KeyValuePair<string, object>> Parameter = new List<KeyValuePair<string, object>>();
             Parameter.Add(new KeyValuePair<string, object>("@MailKey", MailKey));
            SQLHandler sqlH = new SQLHandler();
            return sqlH.ExecuteAsScalar<string>("usp_GetMailKey", Parameter);
        }

        internal string MailValue(string MailValue)
        {
            List<KeyValuePair<string, object>> Parameter = new List<KeyValuePair<string, object>>();
            Parameter.Add(new KeyValuePair<string, object>("@MailValue", MailValue));
            SQLHandler sqlH = new SQLHandler();
            return sqlH.ExecuteAsScalar<string>("usp_GetMailValue", Parameter);
        }
    }
}