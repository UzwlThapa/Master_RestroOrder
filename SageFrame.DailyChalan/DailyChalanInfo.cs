using System.Collections.Generic;

namespace SageFrame.DailyChalan
{
    public class DailyChalanInfo
    {
        public string UserName { get; set; }
        public int DailyChalanId { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal RemainingAmount { get; set; }
        public string AssignedBy { get; set; }
        public decimal IssuedBalance { get; set; }
        public decimal ReturnedBalance { get; set; }
        public List<DailyChalanIssue> issueDetails { get; set; }
        public List<DailyChalanReturn> returnedDetails { get; set; }

    }
    public class DailyChalanIssue
    {
        public int issueID { get; set; }
        public string IssuedBy { get; set; }
        public decimal IssuedAmount { get; set; }
        public string For { get; set; }
    }

    public class DailyChalanReturn
    {
        public int returnedID { get; set; }
        public string ReturnedBy { get; set; }
        public decimal ReturnedAmount { get; set; }
        public string Remarks { get; set; }
    }
}
