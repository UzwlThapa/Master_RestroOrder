using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;

namespace SageFrame.RestroOrder
{
    public class FrontPage
    {
        public decimal TotalSales { get; set; }

        public int TotalTables { get; set; }

        public int OccupiedTables { get; set; }
    }
    public class FrontPageHeader
    {
        public decimal TotalSales { get; set; }
        public decimal OutstandingSales { get; set; }
        public int BillIssued { get; set; }

        public int TotalOrders { get; set; }
        public int TotalCancelled { get; set; }
    }


    public class OccupiedTables
    {
        public int restrotableId { get; set; }
        public string restrotableTitle { get; set; }
        public int restroRoomId { get; set; }
        public string restroRoom { get; set; }
        public int Seatcap { get; set; }
        public int restrotablesStatusID { get; set; }
        public int BillPaid { get; set; }
        public string tableDate { get; set; }
        public string tabletime { get; set; }
        public int IsCancelled { get; set; }
        public bool IsTable { get; set; }
        public decimal Rate { get; set; }
        public int OrderMasterId { get; set; }

    }


}
