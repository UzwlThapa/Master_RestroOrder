using SageFrame.Web.Utilities;
using System;
using System.Collections.Generic;

namespace SageFrame.DailyChalan
{
    class DailyChalanProvider
    {
        internal List<DailyChalanInfo> GetDropDown()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<DailyChalanInfo>("getUserName");

        }

        internal void ChalanSaveTodatabase(DailyChalanInfo chalan)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
          Param.Add(new KeyValuePair<string, object>("@DailyChalanId", chalan.DailyChalanId));
            Param.Add(new KeyValuePair<string, object>("@TotalAmount", chalan.TotalAmount));
            //Param.Add(new KeyValuePair<string, object>("@RemainingAmount", chalan.RemainingAmount));
            Param.Add(new KeyValuePair<string, object>("@AssignedBy", chalan.AssignedBy));
            Param.Add(new KeyValuePair<string, object>("@IssuedBalance", chalan.IssuedBalance));
            Param.Add(new KeyValuePair<string, object>("@ReturnedBalance", chalan.ReturnedBalance));

            var obj = sqlhan.ExecuteAsScalar<object>("[USP_RO_SaveDailyChalan]", Param);

            chalan.DailyChalanId = Convert.ToInt32(obj);


            //for (int i = 0; i < chalan.issueDetails.Count; i++)
            foreach (var item in chalan.issueDetails)
            {
                if (item.IssuedAmount != 0)
                {
                    List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                    Param1.Add(new KeyValuePair<string, object>("@issueID", item.issueID));
                    Param1.Add(new KeyValuePair<string, object>("@DailyChalanId", chalan.DailyChalanId));
                    Param1.Add(new KeyValuePair<string, object>("@IssuedBy", item.IssuedBy));
                    Param1.Add(new KeyValuePair<string, object>("@For", item.For));
                    Param1.Add(new KeyValuePair<string, object>("@IssuedAmount", item.IssuedAmount));
                    sqlhan.ExecuteNonQuery("[USP_RO_SaveDailyChalanIssueDetails]", Param1);
                }
            }

            foreach (var item in chalan.returnedDetails)
            {
                if (item.ReturnedAmount != 0)
                {
                    List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                    Param2.Add(new KeyValuePair<string, object>("@returnedID", item.returnedID));
                    Param2.Add(new KeyValuePair<string, object>("@DailyChalanId", chalan.DailyChalanId));
                    Param2.Add(new KeyValuePair<string, object>("@ReturnedBy", item.ReturnedBy));
                    Param2.Add(new KeyValuePair<string, object>("@ReturnedAmount", item.ReturnedAmount));
                    Param2.Add(new KeyValuePair<string, object>("@Remarks", item.Remarks));
                    sqlhan.ExecuteNonQuery("[USP_RO_SaveDailyChalanReturnedDetail]", Param2);
                }
            }
        }
        internal List<DailyChalanInfo> GetDataFromDatabase()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<DailyChalanInfo>("USP_RO_GetDailyChalanMaster");
        }

        internal List<DailyChalanIssue> GetIssuedDetails(int DailyChalanId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@DailyChalanId", DailyChalanId));
            SQLHandler sqlhan = new SQLHandler();
            List<DailyChalanIssue> Iteminfo = sqlhan.ExecuteAsList<DailyChalanIssue>("[USP_RO_GetDailyChalanIssueDetails]", Param);
            return Iteminfo;
        }

       
        internal List<DailyChalanReturn> GetReturnedDetails(int DailyChalanId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@DailyChalanId", DailyChalanId));
            SQLHandler sqlhan = new SQLHandler();
            List<DailyChalanReturn> Iteminfo = sqlhan.ExecuteAsList<DailyChalanReturn>("[USP_RO_GetDailyChalanReturnedDetails]", Param);
            return Iteminfo;
        }

        internal void ChalanUpdateTodatabase(DailyChalanInfo chalan)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@DailyChalanId", chalan.DailyChalanId));
            Param.Add(new KeyValuePair<string, object>("@TotalAmount", chalan.TotalAmount));
            Param.Add(new KeyValuePair<string, object>("@AssignedBy", chalan.AssignedBy));
            Param.Add(new KeyValuePair<string, object>("@IssuedBalance", chalan.IssuedBalance));
            Param.Add(new KeyValuePair<string, object>("@ReturnedBalance", chalan.ReturnedBalance));
            var obj = sqlhan.ExecuteAsScalar<object>("[USP_RO_SaveDailyChalan]", Param);

            chalan.DailyChalanId = Convert.ToInt32(obj);


            //for (int i = 0; i < chalan.issueDetails.Count; i++)
            foreach (var item in chalan.issueDetails)
            {
                List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                Param1.Add(new KeyValuePair<string, object>("@issueID", item.issueID));
                Param1.Add(new KeyValuePair<string, object>("@DailyChalanId", chalan.DailyChalanId));
                Param1.Add(new KeyValuePair<string, object>("@IssuedBy", item.IssuedBy));
                Param1.Add(new KeyValuePair<string, object>("@For", item.For));
                Param1.Add(new KeyValuePair<string, object>("@IssuedAmount", item.IssuedAmount));
                sqlhan.ExecuteNonQuery("[USP_RO_SaveDailyChalanIssueDetails]", Param1);
            }

            foreach (var item in chalan.returnedDetails)
            {
                List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                Param2.Add(new KeyValuePair<string, object>("@returnedID", item.returnedID));
                Param2.Add(new KeyValuePair<string, object>("@DailyChalanId", chalan.DailyChalanId));
                Param2.Add(new KeyValuePair<string, object>("@ReturnedBy", item.ReturnedBy));
                Param2.Add(new KeyValuePair<string, object>("@ReturnedAmount", item.ReturnedAmount));
                Param2.Add(new KeyValuePair<string, object>("@Remarks", item.Remarks));
                sqlhan.ExecuteNonQuery("[USP_RO_SaveDailyChalanReturnedDetail]", Param2);

            }
        }
    }
}
