using SageFrame.Web.Utilities;
using System.Collections.Generic;

namespace SageFrame.FrontPage
{
    public class FrontPageDataProvider
    {
        SQLHandler sagesql = new SQLHandler();
        public List<FrontPageInfo> GetallData(FrontPageInfo objFrontPage)
        {
            try
            {
                List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
                param.Add(new KeyValuePair<string, object>("@PortalID", objFrontPage.PortalID));
                param.Add(new KeyValuePair<string, object>("@UserModuleID", objFrontPage.UserModuleID));
                param.Add(new KeyValuePair<string, object>("@Culture", objFrontPage.Culture));
                return sagesql.ExecuteAsList<FrontPageInfo>("[dbo].[usp_FrontPage_GetallData]", param);
            }
            catch
            {
                throw;
            }
        }
        public FrontPageInfo GetByID(int id)
        {
            try
            {
                List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
                param.Add(new KeyValuePair<string, object>("@id", id));
                return sagesql.ExecuteAsObject<FrontPageInfo>("[dbo].[usp_FrontPage_GetByID]", param);
            }
            catch
            {
                throw;
            }
        }
        public void DeleteByID(int id)
        {
            try
            {
                List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
                param.Add(new KeyValuePair<string, object>("@id", id));
                sagesql.ExecuteNonQuery("[dbo].[usp_FrontPage_DeleteByID]", param);
            }
            catch
            {
                throw;
            }
        }
        public void Insert(FrontPageInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
                param.Add(new KeyValuePair<string, object>("@id", obj.id));
                param.Add(new KeyValuePair<string, object>("@description", obj.description));
                param.Add(new KeyValuePair<string, object>("@PortalID", obj.PortalID));
                param.Add(new KeyValuePair<string, object>("@UserModuleID", obj.UserModuleID));
                param.Add(new KeyValuePair<string, object>("@Culture", obj.Culture));
                sagesql.ExecuteNonQuery("[dbo].[usp_FrontPage_Insert]", param);
            }
            catch
            {
                throw;
            }
        }
        public void Update(FrontPageInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
                param.Add(new KeyValuePair<string, object>("@id", obj.id));
                param.Add(new KeyValuePair<string, object>("@description", obj.description));
                sagesql.ExecuteNonQuery("[dbo].[usp_FrontPage_Update]", param);
            }
            catch
            {
                throw;
            }
        }

        public List<CustomerEvent> getCustomerEvents()
        {
            List<CustomerEvent> customer = new List<CustomerEvent>();
            customer = sagesql.ExecuteAsList<CustomerEvent>("[dbo].[usp_GetCustomerEvents]");
            return customer;
        }
    }
}
