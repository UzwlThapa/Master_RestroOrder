using System;
using System.Collections.Generic;

namespace SageFrame.Housekeeping
{
    public class HouseController
    {
        public void SaveMainHouseKeeping(HouseInfo obj)
        {
            try
            {
                new HouseProvider().SaveMainHouseKeeping(obj);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<HouseInfo> GetMainHouseKeepingInfo(string Status, string AssignTo)
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.GetMainHouseKeepingInfo(Status, AssignTo);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteMainHouseKeepingDetails(int HK_ID)
        {
            try
            {
                new HouseProvider().DeleteMainHouseKeepingDetails(HK_ID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<HouseInfo> GetStatus()
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.GetStatus();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<HouseInfo> GetUsers()
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.GetUsers();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<HouseInfo> GetRooms()
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.GetRooms();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<HouseInfo> GetRoomsByRoomID(int restroRoomID)
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.GetRoomsByRoomID(restroRoomID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<HouseInfo> GetRoomName()
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.GetRoomName();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<HouseInfo> GetRoomNameByID(int Roomvalue)
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.GetRoomNameByID(Roomvalue);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void SaveLostAndFound(HouseInfo obj)
        {
            try
            {
                new HouseProvider().SaveLostAndFound(obj);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<HouseInfo> GetLostAndFound()
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.GetLostAndFound();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteLostAndFound(int LF_ID)
        {
            try
            {
                new HouseProvider().DeleteLostAndFound(LF_ID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<HouseInfo> getLostNFoundreport(string StartDate, string EndDate)
        {
            HouseProvider prov = new HouseProvider();
            return prov.getLostNFoundreport(StartDate, EndDate);
        }

        public void SaveOutOfOrder(HouseInfo obj)
        {
            try
            {
                new HouseProvider().SaveOutOfOrder(obj);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<HouseInfo> GetOutOfOrder()
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.GetOutOfOrder();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<HouseInfo> getOOReport(int RoomID, int RoomTypeID, string RoomClass, string StartDate, int IsOutOfOrder, int IsOutOfService)
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.getOOReport(RoomID, RoomTypeID, RoomClass, StartDate, IsOutOfOrder, IsOutOfService);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<HouseInfo> GetOrderItemByID(int OutOfOrderID)
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.GetOrderItemByID(OutOfOrderID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteOutOfOrder(int Oid)
        {

            try
            {
                new HouseProvider().DeleteOutOfOrder(Oid);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<PackageMasterInfo> getPackageMasterList()
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.getPackageMasterList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void savePackageMaster(PackageMasterInfo PmObj)
        {
            try
            {
                new HouseProvider().savePackageMaster(PmObj);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void deletePackageMasterByID(int PM_ID)
        {
            try
            {
                new HouseProvider().deletePackageMasterByID(PM_ID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<RateCategoryInfo> getRateCategoryList()
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.getRateCategoryList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void saveRateCategory(RateCategoryInfo rcObj)
        {
            try
            {
                new HouseProvider().saveRateCategory(rcObj);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void deleteRateCategoryByID(int RC_ID)
        {
            try
            {
                new HouseProvider().deleteRateCategoryByID(RC_ID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<DepositTypeInfo> getDepositTypeList()
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.getDepositTypeList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void saveDepositType(DepositTypeInfo DtObj)
        {
            try
            {
                new HouseProvider().saveDepositType(DtObj);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void deleteDepositTypeByID(int DT_ID)
        {
            try
            {
                new HouseProvider().deleteDepositTypeByID(DT_ID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<BookingConditionInfo> getBookingConditionList()
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.getBookingConditionList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void saveBookingCondition(BookingConditionInfo BconObj)
        {
            try
            {
                new HouseProvider().saveBookingCondition(BconObj);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void deleteBookingConditionByID(int Bcon_ID)
        {
            try
            {
                new HouseProvider().deleteBookingConditionByID(Bcon_ID);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        public List<BookingConditionInfo> getDepositType()
        {
            try
            {
                HouseProvider clt = new HouseProvider();
                return clt.getDepositType();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

       
    }
}
