using System.Collections.Generic;

namespace SageFrame.Laundry
{
    class LaundryInfo
    {
    }
    public class L_MaterialTypeInfo
    {
        public int ID { get; set; }
        public string Type { get; set; }
    }
    public class L_LaundryTypeInfo
    {
        public int ID { get; set; }
        public string Type { get; set; }
    }
    public class L_LaundryRateInfo
    {
        public int ID { get; set; }
        public int ClothTypeID { get; set; }
        public int LaundryTypeID { get; set; }
        public decimal Rate { get; set; }
        public string LaundryType { get; set; }
        public string ClothType { get; set; }
    }
    public class L_ClothInfo
    {
        public int ID { get; set; }
        public string Cloth { get; set; }
        public string Gender { get; set; }
    }
    public class L_ConditionInfo
    {
        public int ID { get; set; }
        public string Condition { get; set; }
    }
    public class L_LaundryMasterInfo
    {
        public int ID { get; set; }
        public int RoomTypeID { get; set; }
        public int RoomID { get; set; }
        public int CustomerID { get; set; }
        public string Date { get; set; }
        public string DeliveryDate { get; set; }
        public int ChallanNo { get; set; }
        public string HouseKeeperID { get; set; }
        public string RoomName { get; set; }
        public string RoomTypeName { get; set; }
        public string CustomerName { get; set; }
        public string HouseKeeperName { get; set; }
        public bool IsDelivered { get; set; }
        public decimal Amount { get; set; }
        public string DiscountType { get; set; }
        public decimal Discount { get; set; }
        public decimal Total { get; set; }
        public int restrotableId { get; set; }
        public string restrotableTitle { get; set; }

        public List<L_LaundryDetailsInfo> laundryDetails { get; set; }

    }
    public class L_LaundryDetailsInfo
    {
        public int ClothID { get; set; }
        public string Color { get; set; }
        public string Description { get; set; }
        public int ID { get; set; }
        public int LaundryMasterID { get; set; }
        public int LaundryTypeID { get; set; }
        public int MaterialID { get; set; }
        public int Quantity { get; set; }
        public int Rate { get; set; }
        public bool IsDelivered { get; set; }

        public string Cloth { get; set; }
        public string Material { get; set; }
        public string LaundryType { get; set; }
    }

    public class AmnitiesInfo
    {
        public int ID { get; set; }
        public string Amnities { get; set; }
    }

    public class RoomGroupInfo
    {
        public int ID { get; set; }
        public string RoomGroup { get; set; }
    }
    public class BuildingBlockInfo
    {
        public int ID { get; set; }
        public string BlockName{ get; set; }
        public int No_of_floor { get; set; }
        public int No_of_rooms { get; set; }
    }

    public class RoomClassInfo
    {
        public int ID { get; set; }
        public string Class { get; set; }
    }

    public class ReservationStatusInfo
    {
        public int ID { get; set; }
        public string Status { get; set; }
    }
    public class AgentInfo
    {
        public int ID { get; set; }
        public string Agent { get; set; }
    }
}
