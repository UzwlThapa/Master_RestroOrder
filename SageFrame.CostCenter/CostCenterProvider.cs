using SageFrame.Web.Utilities;
using System.Collections.Generic;
using System.Data;

namespace SageFrame.CostCenter
{
    public class CostCenterProvider
    {
        internal void SaveCostCenter(CostCenterInfo dataObj)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CostCenterId", dataObj.CostCenterId));
            Param.Add(new KeyValuePair<string, object>("@CostCenterName", dataObj.CostCenterName));
            Param.Add(new KeyValuePair<string, object>("@Username", dataObj.Username));
            Param.Add(new KeyValuePair<string, object>("@DefaultPrinter", dataObj.DefaultPrinter));
            Param.Add(new KeyValuePair<string, object>("@coDiscount", dataObj.coDiscount));
            Param.Add(new KeyValuePair<string, object>("@NumberOfCounter", dataObj.NumberOfCounter));
            Param.Add(new KeyValuePair<string, object>("@store", dataObj.store));
            Param.Add(new KeyValuePair<string, object>("@GroupId", dataObj.GroupId));
            sqlhan.ExecuteNonQuery("[dbo].[usp_CostCenterSaveData]", Param);
        }



        internal List<CostCenterInfo> GetCostCenter()
        {
            SQLHandler sqlhan = new SQLHandler();
            List<CostCenterInfo> list = new List<CostCenterInfo>();
            list = sqlhan.ExecuteAsList<CostCenterInfo>("[dbo].[usp_CostCenterGetData]");
            return list;
        }

        internal DataTable GetCostCenterDatatable()
        {
            SQLHandler sqlhan = new SQLHandler();
            DataSet setlist = new DataSet();
            setlist = sqlhan.ExecuteAsDataSet("[dbo].[usp_CostCenterGetData]");
            return setlist.Tables[0];
        }

        internal void deleteCostCenter(int id)
        {
            SQLHandler sqh = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@cid", id));
            sqh.ExecuteAsList<CostCenterInfo>("USP_RO_DELETECOSTCENTER", Param);
        }

        internal int CheckCostCenter(int id)
        {
            SQLHandler sqh = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@cid", id));
            var pass = sqh.ExecuteAsScalar<int>("USP_CheckCostCenterValid", Param);
            return pass;
        }

        

        internal CostCenterInfo GetCostCenterById(int Id)
        {
            SQLHandler sqlhan = new SQLHandler();
            CostCenterInfo costCenter = new CostCenterInfo();

            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CostCenterId", Id));
            costCenter = sqlhan.ExecuteAsObject<CostCenterInfo>("[dbo].[USP_RO_GETCOSTCENTERBYID]", Param);
            return costCenter;
        }
        
        
        internal void SaveAssignedCostCenter(string UserName, string CostCenterName)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@UserName", UserName));
            Param.Add(new KeyValuePair<string, object>("@CostCenterName", CostCenterName));
            sqlhan.ExecuteNonQuery("[dbo].[USP_RO_SaveAssignedCostCenter]", Param);
        }

        internal DataTable GetgridDatatable()
        {
            SQLHandler sqlhan = new SQLHandler();
            DataSet setlist = new DataSet();
            setlist = sqlhan.ExecuteAsDataSet("[dbo].[usp_GetgridDatatable]");
            return setlist.Tables[0];
        }
    }
}
