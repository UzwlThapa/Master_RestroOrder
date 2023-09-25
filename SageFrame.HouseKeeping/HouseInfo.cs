namespace SageFrame.Housekeeping
{
    public class HouseInfo
    {
        //Housekeeping
        public int HkID { get; set; }
        public string Name { get; set; }
        public string ContactNo { get; set; }

        //Main House Keeping
        public int HK_ID { get; set; }
        public int RoomID { get; set; }
        public string Room { get; set; }
        public string RoomType { get; set; }
        public int RoomTypeID { get; set; }

        public string RoomStatus { get; set; }
        public string Availability { get; set; }
        public string HK_Date { get; set; }
        public string Time_Hour { get; set; }
        public string Time_Min { get; set; }


        public string Remarks_HK { get; set; }
        public string AssignTo { get; set; }

        //Unit
        public int UnitID { get; set; }
        public string Unit { get; set; }

        //HouseKeepingStatus

        public int HkStatusID { get; set; }
        public string HkStatus { get; set; }
        public string Color { get; set; }


        //Remarks
        public int RemarksID { get; set; }
        public string Remarks { get; set; }

        public string PostOnStatus { get; set; }

        public string SetRoomDirty { get; set; }

        public bool PostOn { get; set; }
        public string PostOnNoofNight { get; set; }

        public string CreatedBy { get; set; }
        public string ModifyBy { get; set; }
        public string Status { get; set; }

        //User
        public string Username { get; set; }

        //lost and found

        public int LF_ID { get; set; }
        public string Date { get; set; }
        public string Guest_Name { get; set; }

        public string Type { get; set; }
        public string Item_Name { get; set; }
        public string Roomvalue { get; set; }

        //Out Of Service

       // public int RoomID { get; set; }
        public int OutOfOrderID { get; set; }
        public string OO_Status { get; set; }
        public string FromDate { get; set; }
        public string ThroughDate { get; set; }
        public string ReturnAs { get; set; }
        public string Reason { get; set; }
        public string OO_Remarks { get; set; }
        public bool IsOutOfOrder { get; set; }
        public bool IsOutOfService { get; set; }
    }
    public class PackageMasterInfo
    {
        //Housekeeping
        public int PM_ID { get; set; }
        public string Package { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public decimal Price { get; set; }
        public string Description { get; set; }
        public string PM_Code { get; set; }


    }

    public class RateCategoryInfo
    {
        //Housekeeping
        public int RC_ID { get; set; }
        public string RateCategory { get; set; }
        public decimal Discount { get; set; }
        public string Description { get; set; }
        public int NoOfPacks { get; set; }
        public string RC_Code { get; set; }


    }
    public class DepositTypeInfo
    {
        //Housekeeping
        public int DT_ID { get; set; }
        public string DepositType { get; set; }

    }

    public class BookingConditionInfo
    {
        //Housekeeping
        public int Bcon_ID { get; set; }
        public int DepositTypeID { get; set; }
        public string DepositType { get; set; }
        public string BalanceDue { get; set; }

    }
}
