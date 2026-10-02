using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using SageFrame.Security.Entities;

namespace SageFrame.RestroOrder
{
    public class FrontPageController
    {
        public List<FrontPage> getFrontpageStatus()
        {
            FrontPageProvider robobj = new FrontPageProvider();
            return robobj.getFrontpageStatus();
        }

        public List<FrontPageHeader> getFrontpageHeaderStatus()
        {
            FrontPageProvider robobj = new FrontPageProvider();
            return robobj.getFrontpageHeaderStatus();
        }
        

        public List<OccupiedTables> getOccupiedTableList()
        {
            FrontPageProvider robobj = new FrontPageProvider();
            return robobj.getOccupiedTableList();
        }

    }
}
