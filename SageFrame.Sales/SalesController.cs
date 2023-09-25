using System.Collections.Generic;

namespace SageFrame.Sales
{
    public class SalesController
    {
        public List<customerBilling1> getActiveBILLTERM()
        {
            SalesProvider robobj = new SalesProvider();
            return robobj.getActiveBILLTERM();
        }
        public void saveSalesBill(SalesMaster1 sm, List<SalesDetails1> sd, int splited, List<customerBilling1> bt)
        {
            SalesProvider prov = new SalesProvider();
            prov.saveSalesBill(sm, sd, splited, bt);
        }
    }
}
