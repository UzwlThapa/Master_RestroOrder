using System.Collections.Generic;

namespace SageFrame.DailyChalan
{
    public class 
        DailyChalanController
    {
        private int DailyChalanId;
        public List<DailyChalanInfo> GetDropDown()
        {
            DailyChalanProvider prov = new DailyChalanProvider();
            return prov.GetDropDown();
        }

        public void ChalanSaveTodatabase(DailyChalanInfo chalan)
        {
            DailyChalanProvider prov = new DailyChalanProvider();
            prov.ChalanSaveTodatabase(chalan);

        }
        public List<DailyChalanInfo> GetDataFromDatabase()
        {
            DailyChalanProvider prov = new DailyChalanProvider();
            return prov.GetDataFromDatabase();
        }

        public List<DailyChalanIssue> GetIssuedDetails(int DailyChalanId)
        {
            DailyChalanProvider prov = new DailyChalanProvider();
            return prov.GetIssuedDetails(DailyChalanId);
        }
        //DailyChalanReturn
        public List<DailyChalanReturn> GetReturnedDetails(int DailyChalanId)
        {
            DailyChalanProvider prov = new DailyChalanProvider();
            return prov.GetReturnedDetails(DailyChalanId);
        }

        public void ChalanUpdateTodatabase(DailyChalanInfo chalan)
        {
            DailyChalanProvider prov = new DailyChalanProvider();
            prov.ChalanUpdateTodatabase(chalan);
        }
    }
}
