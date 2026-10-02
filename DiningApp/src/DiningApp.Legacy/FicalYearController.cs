using System.Collections.Generic;

namespace SageFrame.FiscalYear
{
    public class FicalYearController
    {
        public List<FiscalYearInfo> GetAllFiscalYear()
        {
            FiscalYearProvider prov = new FiscalYearProvider();
            return prov.GetAllFiscalYear();
        }
        public void SaveFiscalYear(FiscalYearInfo info)
        {
            FiscalYearProvider prov = new FiscalYearProvider();
            prov.SaveFiscalYear(info);
        }
    }
}
