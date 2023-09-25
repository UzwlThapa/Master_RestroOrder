namespace SageFrame.FrontPage
{
    public class FrontPageInfo
    {
        public int id { get; set; }
        public string description { get; set; }
        public int PortalID { get; set; }
        public int UserModuleID { get; set; }
        public string Culture { get; set; }

    }

    public class CustomerEvent
    {
        public string dt { get; set; }
        public string CustomerName { get; set; }
        public string Event { get; set; }
        public string Date { get; set; }
        public int DaysRemaining { get; set; }
    }
}
