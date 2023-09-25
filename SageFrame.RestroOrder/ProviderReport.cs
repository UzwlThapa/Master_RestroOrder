using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SageFrame.RestroOrder
{
    public class providersReport
    {
        public string billDate { get; set; }
        public string billNo { get; set; }
        public string restrotableTitle { get; set; }
        public string restroRoom { get; set; }
        public decimal total { get; set; }
        public decimal discount { get; set; }
        public decimal serviceCharge { get; set; }
        public decimal vat { get; set; }
        public decimal netAmount { get; set; }
        public decimal payAmount { get; set; }
        public int paymentID { get; set; }
        public string ProviderName { get; set; }
        public string ChequeNo { get; set; }
        public string TransactionNo { get; set; }
    }
}
