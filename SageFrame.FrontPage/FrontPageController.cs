using System.Collections.Generic;

namespace SageFrame.FrontPage
{
    public class FrontPageController
    {
        public void Insert(FrontPageInfo obj)
        {
            try
            {
                FrontPageDataProvider objDataProvider = new FrontPageDataProvider();
                objDataProvider.Insert(obj);
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
                FrontPageDataProvider objDataProvider = new FrontPageDataProvider();
                objDataProvider.Update(obj);
            }
            catch
            {
                throw;
            }
        }
        public List<FrontPageInfo> GetallData(FrontPageInfo objFrontPage)
        {
            try
            {
                FrontPageDataProvider objDataProvider = new FrontPageDataProvider();
                return objDataProvider.GetallData(objFrontPage);
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
                FrontPageDataProvider objDataProvider = new FrontPageDataProvider();
                return objDataProvider.GetByID(id);
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
                FrontPageDataProvider objDataProvider = new FrontPageDataProvider();
                objDataProvider.DeleteByID(id);
            }
            catch
            {
                throw;
            }
        }

        public List<CustomerEvent> getCustomerEvents()
        {
            try
            {
                FrontPageDataProvider objDataProvider = new FrontPageDataProvider();
                return objDataProvider.getCustomerEvents();
            }
            catch
            {
                throw;
            }
        }
    }
}
