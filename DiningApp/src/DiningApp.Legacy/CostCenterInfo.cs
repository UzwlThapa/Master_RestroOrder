using System;

namespace SageFrame.CostCenter
{
    public class CostCenterInfo
    {
        public int CostCenterId { get; set; }
        public string CostCenterName { get; set; }
        public DateTime CostCenterAddedDate { get; set; }
        public string CostCenterAddedBy { get; set; }
        public string Username { get; set; }
        public string DefaultPrinter { get; set; }
        public decimal coDiscount { get; set; }
        public int NumberOfCounter { get; set; }
        public int store { get; set; }
        public string StName { get; set; }
        public string GroupName { get; set; }
        public int GroupId { get; set; } 

    }
}
