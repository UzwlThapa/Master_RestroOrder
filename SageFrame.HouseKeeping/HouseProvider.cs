using SageFrame.Web.Utilities;
using System;
using System.Collections.Generic;


namespace SageFrame.Housekeeping
{
    public class HouseProvider
    {

        internal void SaveMainHouseKeeping(HouseInfo obj)
        {
            try
            {
                new SQLHandler().ExecuteNonQuery("[dbo].[usp_H_SaveMainHouseKeeping]", new List<KeyValuePair<string, object>>()
        {
          new KeyValuePair<string, object>("@HK_ID", (object) obj.HK_ID),
          new KeyValuePair<string, object>("@RoomID", (object) obj.RoomID),
          new KeyValuePair<string, object>("@RoomType", (object) obj.RoomType),
          new KeyValuePair<string, object>("@Room", (object) obj.Room),
          new KeyValuePair<string, object>("@RoomStatus", (object) obj.RoomStatus ),
          new KeyValuePair<string, object>("@Availability", (object) obj.Availability),
          new KeyValuePair<string, object>("@HK_Date", (object) obj.HK_Date + " " + obj.Time_Hour + " : " + obj.Time_Min),
         // new KeyValuePair<string, object>("@Time_Hour", (object) obj.Time_Hour),
          //new KeyValuePair<string, object>("@Time_Min", (object) obj.Time_Min),
          new KeyValuePair<string, object>("@Remarks_HK", (object) obj.Remarks_HK),
          new KeyValuePair<string, object>("@AssignTo", (object) obj.AssignTo)
        // new KeyValuePair<string, object>("@AddedOn", (object) obj.AddedOn)
        });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal List<HouseInfo> GetMainHouseKeepingInfo(string Status, string AssignTo)
        {

            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@RoomStatus", Status));
            Param.Add(new KeyValuePair<string, object>("@AssignTo", AssignTo));
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<HouseInfo>("usp_H_GetMainHouseKeepingInfo", Param);
        }

        internal void DeleteMainHouseKeepingDetails(int HK_ID)
        {
            try
            {
                new SQLHandler().ExecuteNonQuery("[dbo].[usp_H_DeleteMainHouseKeepingDetails]", new List<KeyValuePair<string, object>>()
        {
          new KeyValuePair<string, object>("@HK_ID", (object) HK_ID),
          //new KeyValuePair<string, object>("@PortalID", (object) obj.PortalID),
          //new KeyValuePair<string, object>("@UserModuleID", (object) obj.UserModuleID)
        });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<HouseInfo> GetStatus()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<HouseInfo>("usp_H_GetStatus");
        }

        internal List<HouseInfo> GetUsers()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<HouseInfo>("getUserbyHouseKeepingRole");
        }

        internal List<HouseInfo> GetRooms()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<HouseInfo>("usp_H_GetRooms");
        }
        internal List<HouseInfo> GetRoomsByRoomID(int restroRoomID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@restroRoomID", restroRoomID));
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<HouseInfo>("usp_H_GetRoomsByRoomID", Param);
        }
        internal List<HouseInfo> GetRoomName()
        {
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<HouseInfo>("usp_H_GetRoomName");
        }
        internal List<HouseInfo> GetRoomNameByID(int Roomvalue)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Roomvalue", Roomvalue));
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<HouseInfo>("usp_H_GetRoomNameByID", Param);
        }
        internal void SaveLostAndFound(HouseInfo obj)
        {
            try
            {
                new SQLHandler().ExecuteNonQuery("[dbo].[usp_H_SaveLostAndFound]", new List<KeyValuePair<string, object>>()
        {
          new KeyValuePair<string, object>("@LF_ID", (object) obj.LF_ID),
          new KeyValuePair<string, object>("@RoomType", (object) obj.RoomType),
          new KeyValuePair<string, object>("@Room", (object) obj.Room),
          new KeyValuePair<string, object>("@Date", (object) obj.Date),
          new KeyValuePair<string, object>("@Guest_Name", (object) obj.Guest_Name),
          new KeyValuePair<string, object>("@Type", (object) obj.Type),
          new KeyValuePair<string, object>("@Item_Name", (object) obj.Item_Name)
        });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal List<HouseInfo> GetLostAndFound()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<HouseInfo>("USP_H_GetLostAndFound");
        }
        internal void DeleteLostAndFound(int LF_ID)
        {
            try
            {
                new SQLHandler().ExecuteNonQuery("[dbo].[usp_H_DeleteLostAndFound]", new List<KeyValuePair<string, object>>()
        {
          new KeyValuePair<string, object>("@LF_ID", (object) LF_ID),
        });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal List<HouseInfo> getLostNFoundreport(string StartDate, string EndDate)
        {
            SQLHandler sqh = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@StartDate", StartDate));
            Param.Add(new KeyValuePair<string, object>("@EndDate", EndDate));
            return sqh.ExecuteAsList<HouseInfo>("USP_H_LostNFoundReport", Param);
        }

        internal void SaveOutOfOrder(HouseInfo obj)
        {
            try
            {
                new SQLHandler().ExecuteNonQuery("[dbo].[usp_H_SaveOutOfOrder]", new List<KeyValuePair<string, object>>()
        {
          new KeyValuePair<string, object>("@OutOfOrderID", (object) obj.OutOfOrderID),
          new KeyValuePair<string, object>("@RoomID", (object) obj.RoomID),
          new KeyValuePair<string, object>("@OO_Status", (object) obj.OO_Status),
          new KeyValuePair<string, object>("@FromDate", (object) obj.FromDate),
          new KeyValuePair<string, object>("@ThroughDate", (object) obj.ThroughDate),
          new KeyValuePair<string, object>("@ReturnAs", (object) obj.ReturnAs),
          new KeyValuePair<string, object>("@Reason", (object) obj.Reason),
          new KeyValuePair<string, object>("@OO_Remarks", (object) obj.OO_Remarks),
          new KeyValuePair<string, object>("@IsOutOfOrder", (object) obj.IsOutOfOrder),
          new KeyValuePair<string, object>("@IsOutOfService", (object) obj.IsOutOfService)

        });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<HouseInfo> GetOutOfOrder()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<HouseInfo>("USP_H_GetOutOfOrder");
        }

        internal List<HouseInfo> GetRoomClass()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<HouseInfo>("usp_H_GetRoomClass");
        }

        //internal List<HouseInfo> GetMainHouseKeepingInfo(string Status, string AssignTo)
        //{

        //    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
        //    Param.Add(new KeyValuePair<string, object>("@RoomStatus", Status));
        //    Param.Add(new KeyValuePair<string, object>("@AssignTo", AssignTo));
        //    SQLHandler sqh = new SQLHandler();
        //    return sqh.ExecuteAsList<HouseInfo>("usp_H_GetRoomClass", Param);
        //}

        internal List<HouseInfo> getOOReport(int RoomID, int RoomTypeID, string RoomClass, string StartDate, int IsOutOfOrder, int IsOutOfService)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@RoomID", RoomID));
            Param.Add(new KeyValuePair<string, object>("@RoomTypeID", RoomTypeID));
            Param.Add(new KeyValuePair<string, object>("@RoomClass", RoomClass));
            Param.Add(new KeyValuePair<string, object>("@StartDate", StartDate));
            Param.Add(new KeyValuePair<string, object>("@IsOutOfOrder", IsOutOfOrder));
            Param.Add(new KeyValuePair<string, object>("@IsOutOfService", IsOutOfService));

            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<HouseInfo>("usp_H_getOOReport", Param);
        }

        internal List<HouseInfo> GetOrderItemByID(int OutOfOrderID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@OutOfOrderID", OutOfOrderID));

            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<HouseInfo>("usp_H_roomListByID", Param);
        }

        internal void DeleteOutOfOrder(int Oid)
        {
            try
            {
                new SQLHandler().ExecuteNonQuery("[dbo].[usp_H_DeleteOutOfOrder]", new List<KeyValuePair<string, object>>()
        {
          new KeyValuePair<string, object>("@OutOfOrderID", (object) Oid),
        });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<PackageMasterInfo> getPackageMasterList()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<PackageMasterInfo>("usp_HS_getPackageMasterList");
        }

        internal void savePackageMaster(PackageMasterInfo PmObj)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@PM_ID", PmObj.PM_ID));
                Param.Add(new KeyValuePair<string, object>("@Package", PmObj.Package));
                Param.Add(new KeyValuePair<string, object>("@StartDate", PmObj.StartDate));
                Param.Add(new KeyValuePair<string, object>("@EndDate", PmObj.EndDate));
                Param.Add(new KeyValuePair<string, object>("@Price", PmObj.Price));
                Param.Add(new KeyValuePair<string, object>("@Description", PmObj.Description));
                Param.Add(new KeyValuePair<string, object>("@PM_Code", PmObj.PM_Code));
                //Param.Add(new KeyValuePair<string, object>("@CardNumber", PmObj.CardNumber));

                sqlhan.ExecuteNonQuery("[USP_HS_savePackageMaster]", Param);

            }
            catch (Exception)
            {
                throw;
            }
        }

        internal void deletePackageMasterByID(int PM_ID)
        {
            try
            {
                new SQLHandler().ExecuteNonQuery("[dbo].[usp_HS_deletePackageMasterByID]", new List<KeyValuePair<string, object>>()
        {
          new KeyValuePair<string, object>("@PM_ID", (object) PM_ID),
        });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<RateCategoryInfo> getRateCategoryList()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<RateCategoryInfo>("usp_HS_getRateCategoryList");
        }

        internal void saveRateCategory(RateCategoryInfo rcObj)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RC_ID", rcObj.RC_ID));
                Param.Add(new KeyValuePair<string, object>("@RateCategory", rcObj.RateCategory));
                Param.Add(new KeyValuePair<string, object>("@Discount", rcObj.Discount));
                Param.Add(new KeyValuePair<string, object>("@Description", rcObj.Description));
                Param.Add(new KeyValuePair<string, object>("@NoOfPacks", rcObj.NoOfPacks));
                Param.Add(new KeyValuePair<string, object>("@RC_Code", rcObj.RC_Code));


                sqlhan.ExecuteNonQuery("[USP_HS_saveRateCategory]", Param);

            }
            catch (Exception)
            {

                throw;
            }
        }

        internal void deleteRateCategoryByID(int RC_ID)
        {
            try
            {
                new SQLHandler().ExecuteNonQuery("[dbo].[usp_H_deleteRateCategoryByID]", new List<KeyValuePair<string, object>>()
        {
          new KeyValuePair<string, object>("@RC_ID", (object) RC_ID),
        });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<DepositTypeInfo> getDepositTypeList()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<DepositTypeInfo>("usp_HS_getDepositTypeList");
        }

        internal void saveDepositType(DepositTypeInfo DtObj)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@DT_ID", DtObj.DT_ID));
                Param.Add(new KeyValuePair<string, object>("@DepositType", DtObj.DepositType));

                sqlhan.ExecuteNonQuery("[USP_HS_saveDepositType]", Param);

            }
            catch (Exception)
            {
                throw;
            }
        }

        internal void deleteDepositTypeByID(int DT_ID)
        {
            try
            {
                new SQLHandler().ExecuteNonQuery("[dbo].[usp_H_deleteDepositTypeByID]", new List<KeyValuePair<string, object>>()
        {
          new KeyValuePair<string, object>("@DT_ID", (object) DT_ID),
        });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<BookingConditionInfo> getBookingConditionList()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<BookingConditionInfo>("usp_HS_getBookingConditionList");
        }

        internal void saveBookingCondition(BookingConditionInfo BconObj)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@Bcon_ID", BconObj.Bcon_ID));
                Param.Add(new KeyValuePair<string, object>("@DepositTypeID", BconObj.DepositTypeID));
                Param.Add(new KeyValuePair<string, object>("@BalanceDue", BconObj.BalanceDue));

                sqlhan.ExecuteNonQuery("[USP_HS_saveBookingCondition]", Param);

            }
            catch (Exception)
            {

                throw;
            }
        }

        internal void deleteBookingConditionByID(int Bcon_ID)
        {
            try
            {
                new SQLHandler().ExecuteNonQuery("[dbo].[usp_H_deleteBookingConditionByID]", new List<KeyValuePair<string, object>>()
        {
          new KeyValuePair<string, object>("@Bcon_ID", (object) Bcon_ID),
        });
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<BookingConditionInfo> getDepositType()
        {
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<BookingConditionInfo>("usp_HS_getDepositTypeForDD");
        }

      
    }
}
