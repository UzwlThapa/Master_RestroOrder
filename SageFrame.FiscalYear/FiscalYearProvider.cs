using SageFrame.Web.Utilities;
using System;
using System.Collections.Generic;

namespace SageFrame.FiscalYear
{
    internal class FiscalYearProvider
    {
        internal List<FiscalYearInfo> GetAllFiscalYear()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                SQLHandler sqlhan = new SQLHandler();
                List<FiscalYearInfo> fiscalList = sqlhan.ExecuteAsList<FiscalYearInfo>("[usp_ro_GetFiscalYear]");
                return fiscalList;
            }
            catch (Exception)
            {

                throw;
            }
        }

        internal void SaveFiscalYear(FiscalYearInfo info)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@fyId", info.fyId));
                Param.Add(new KeyValuePair<string, object>("@fyName", info.fyName));
                Param.Add(new KeyValuePair<string, object>("@StartDate", info.StartDate));
                Param.Add(new KeyValuePair<string, object>("@EndDate", info.EndDate));
                Param.Add(new KeyValuePair<string, object>("@isActive", info.isActive));
                Param.Add(new KeyValuePair<string, object>("@AddedBy", info.AddedBy));

                sqlhan.ExecuteNonQuery("[USP_RO_SaveFiscalYear]", Param);

            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}
