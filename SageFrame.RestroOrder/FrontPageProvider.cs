using SageFrame.Web.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using SageFrame.CostCenter;
using SageFrame.RestoLoyalty;
using SageFrame.FiscalYear;
using SageFrame.Security.Entities;
using System.Data;

namespace SageFrame.RestroOrder
{
   public  class FrontPageProvider
    {
        public List<FrontPage> getFrontpageStatus()
        {
            SQLHandler sqlhan = new SQLHandler();
            List<FrontPage> list = new List<FrontPage>();
            list = sqlhan.ExecuteAsList<FrontPage>("usp_ro_get_frontpageStatus");
            return list;
        }

        public List<FrontPageHeader> getFrontpageHeaderStatus()
        {
            SQLHandler sqlhan = new SQLHandler();
            List<FrontPageHeader> list = new List<FrontPageHeader>();
            list = sqlhan.ExecuteAsList<FrontPageHeader>("usp_ro_get_frontpageheaderStatus");
            return list;
        }




        public List<OccupiedTables> getOccupiedTableList()
        {
            SQLHandler sqlhan = new SQLHandler();
            List<OccupiedTables> table = new List<OccupiedTables>();
            table = sqlhan.ExecuteAsList<OccupiedTables>("[USP_RO_GetOccupiedTable]");
            return table;
        }



    }
}
