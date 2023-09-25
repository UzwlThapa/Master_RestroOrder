using SageFrame.Web.Utilities;
using System;
using System.Collections.Generic;

namespace SageFrame.Laundry
{
    public class LaundryProvider
    {
        SQLHandler sqLH = new SQLHandler();

        internal List<L_MaterialTypeInfo> LoadMaterialTypeList()
        {
            try
            {
                return sqLH.ExecuteAsList<L_MaterialTypeInfo>("usp_L_MaterialType_LoadMaterialType");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal void DeleteMaterialType(int materialTypeId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", materialTypeId));

                sqLH.ExecuteNonQuery("usp_L_MaterialType_DeleteMaterialTypeByID", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal L_MaterialTypeInfo GetMaterialTypeByID(int materialTypeId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", materialTypeId));
                return sqLH.ExecuteAsObject<L_MaterialTypeInfo>("usp_L_MaterialType_GetMaterialTypeByID", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void UpdateMaterialType(L_MaterialTypeInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", obj.ID));
                Param.Add(new KeyValuePair<string, object>("@type", obj.Type));

                sqLH.ExecuteNonQuery("usp_L_MaterialType_UpdateMaterialType", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void SaveMaterialType(L_MaterialTypeInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@type", obj.Type));

                sqLH.ExecuteNonQuery("usp_L_MaterialType_SaveMaterialType", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal List<L_LaundryTypeInfo> LoadLaundryTypeList(int cloth)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@clothid", cloth));

                return sqLH.ExecuteAsList<L_LaundryTypeInfo>("usp_L_LaundryType_LoadLaundryType",Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal void DeleteLaundryType(int laundryTypeId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", laundryTypeId));

                sqLH.ExecuteNonQuery("usp_L_LaundryType_DeleteLaundryTypeByID", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal L_LaundryTypeInfo GetLaundryTypeByID(int laundryTypeId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", laundryTypeId));
                return sqLH.ExecuteAsObject<L_LaundryTypeInfo>("usp_L_LaundryType_GetLaundryTypeByID", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void UpdateLaundryType(L_LaundryTypeInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", obj.ID));
                Param.Add(new KeyValuePair<string, object>("@type", obj.Type));

                sqLH.ExecuteNonQuery("usp_L_LaundryType_UpdateLaundryType", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void deleteLaundry(int laundryMasterID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", laundryMasterID));

                sqLH.ExecuteNonQuery("usp_L_LaundryMaster_DeleteLaundry", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void SaveLaundryType(L_LaundryTypeInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@type", obj.Type));

                sqLH.ExecuteNonQuery("usp_L_LaundryType_SaveLaundryType", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<RoomGroupInfo> getRoomGroupList()
        {
            return sqLH.ExecuteAsList<RoomGroupInfo>("usp_R_RoomGroup_getRoomGroupList");
        }

        internal void deleteRoomGroup(int roomGroupID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", roomGroupID));

                sqLH.ExecuteNonQuery("usp_R_RoomGroup_deleteRoomGroup", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal void saveRoomGroup(RoomGroupInfo roomgroup)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", roomgroup.ID));
                Param.Add(new KeyValuePair<string, object>("@roomgroup", roomgroup.RoomGroup));

                sqLH.ExecuteNonQuery("usp_R_RoomGroup_saveRoomGroup", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal void updateldisdelivered(int laundryDetailsID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", laundryDetailsID));

                sqLH.ExecuteNonQuery("usp_L_LaundryDetails_LDUpdateDelivered", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal void updateisdelivered(int laundryMasterID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", laundryMasterID));

                sqLH.ExecuteNonQuery("usp_L_LaundryMaster_updateDelivered", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<RoomClassInfo> getRoomClassList()
        {
            return sqLH.ExecuteAsList<RoomClassInfo>("usp_R_RoomClass_getRoomClassList");
        }

        internal void deleteRoomClass(int roomClassID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", roomClassID));

                sqLH.ExecuteNonQuery("usp_R_RoomClass_deleteRoomClass", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal void saveRoomClass(RoomClassInfo roomclass)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", roomclass.ID));
                Param.Add(new KeyValuePair<string, object>("@roomclass", roomclass.Class));

                sqLH.ExecuteNonQuery("usp_R_RoomClass_saveRoomClass", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal List<BuildingBlockInfo> getBuildingBlockList()
        {
            return sqLH.ExecuteAsList<BuildingBlockInfo>("usp_R_BuildingBlock_getBuildingBlockList");
        }

        internal void deleteBuildingBlock(int BuildingBlockID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", BuildingBlockID));

                sqLH.ExecuteNonQuery("usp_R_BuildingBlock_deleteBuildingBlock", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal void saveBuildingBlock(BuildingBlockInfo BuildingBlock)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", BuildingBlock.ID));
                Param.Add(new KeyValuePair<string, object>("@blockname", BuildingBlock.BlockName));
                Param.Add(new KeyValuePair<string, object>("@nooffloor", BuildingBlock.No_of_floor));
                Param.Add(new KeyValuePair<string, object>("@noofrooms", BuildingBlock.No_of_rooms));

                sqLH.ExecuteNonQuery("usp_R_BuildingBlock_saveBuildingBlock", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal void deleteAmnities(int amnitiesID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", amnitiesID));

                sqLH.ExecuteNonQuery("usp_R_Amnities_deleteAmnities", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal void saveAmnities(AmnitiesInfo amnities)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", amnities.ID));
                Param.Add(new KeyValuePair<string, object>("@amnities", amnities.Amnities));

                sqLH.ExecuteNonQuery("usp_R_Amneties_saveAmnities", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<AmnitiesInfo> getAmnitiesList()
        {
            return sqLH.ExecuteAsList<AmnitiesInfo>("usp_R_Amnities_getAmnitiesList");
        }


        internal List<L_LaundryRateInfo> LoadLaundryType()
        {
            return sqLH.ExecuteAsList<L_LaundryRateInfo>("usp_L_LaundryRate_LoadLaundryTypeList");
        }

        internal List<L_LaundryRateInfo> LoadClothList()
        {
            return sqLH.ExecuteAsList<L_LaundryRateInfo>("usp_L_LaundryRate_LoadClothList");
        }

        internal List<L_LaundryRateInfo> LoadLaundryRateList()
        {
            return sqLH.ExecuteAsList<L_LaundryRateInfo>("usp_L_LaundryRate_LoadLaundryRateList");
        }

        internal L_LaundryRateInfo GetLaundryRateByID(int laundryRateId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", laundryRateId));
                return sqLH.ExecuteAsObject<L_LaundryRateInfo>("usp_L_LaundryRate_GetLaundryRateByID", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void DeleteLaundryRate(int laundryRateId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", laundryRateId));
                sqLH.ExecuteAsObject<L_LaundryRateInfo>("usp_L_LaundryRate_DeleteLaundryRate", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void UpdateLaundryRate(L_LaundryRateInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", obj.ID));
                Param.Add(new KeyValuePair<string, object>("@clothid", obj.ClothTypeID));
                Param.Add(new KeyValuePair<string, object>("@laundryTypeId", obj.LaundryTypeID));
                Param.Add(new KeyValuePair<string, object>("@rate", obj.Rate));
                sqLH.ExecuteNonQuery("usp_L_LaundryRate_UpdateLaundryRateByID", Param);

            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void SaveLaundryRate(L_LaundryRateInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@clothid", obj.ClothTypeID));
                Param.Add(new KeyValuePair<string, object>("@laundryTypeId", obj.LaundryTypeID));
                Param.Add(new KeyValuePair<string, object>("@rate", obj.Rate));
                sqLH.ExecuteNonQuery("usp_L_LaundryRate_SaveLaundryRate", Param);

            }
            catch (Exception e)
            {
                throw e;
            }

        }
        internal List<L_ClothInfo> LoadCloth()
        {
            try
            {
                return sqLH.ExecuteAsList<L_ClothInfo>("usp_L_Cloth_LoadCloth");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal void DeleteCloth(int ClothId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", ClothId));

                sqLH.ExecuteNonQuery("usp_L_Cloth_DeleteClothByID", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal L_ClothInfo GetClothByID(int ClothId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", ClothId));
                return sqLH.ExecuteAsObject<L_ClothInfo>("usp_L_Cloth_GetClothByID", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void UpdateCloth(L_ClothInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", obj.ID));
                Param.Add(new KeyValuePair<string, object>("@cloth", obj.Cloth));
                Param.Add(new KeyValuePair<string, object>("@gender", obj.Gender));

                sqLH.ExecuteNonQuery("usp_L_Cloth_UpdateCloth", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void SaveCloth(L_ClothInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@cloth", obj.Cloth));
                Param.Add(new KeyValuePair<string, object>("@gender", obj.Gender));

                sqLH.ExecuteNonQuery("usp_L_Cloth_SaveCloth", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal List<L_ConditionInfo> LoadConditionList()
        {
            try
            {
                return sqLH.ExecuteAsList<L_ConditionInfo>("usp_L_Condition_LoadCondition");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal void DeleteCondition(int ConditionId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", ConditionId));

                sqLH.ExecuteNonQuery("usp_L_Condition_DeleteConditionByID", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal L_ConditionInfo GetConditionByID(int ConditionId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", ConditionId));
                return sqLH.ExecuteAsObject<L_ConditionInfo>("usp_L_Condition_GetConditionByID", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void UpdateCondition(L_ConditionInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", obj.ID));
                Param.Add(new KeyValuePair<string, object>("@condition", obj.Condition));

                sqLH.ExecuteNonQuery("usp_L_Condition_UpdateCondition", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void SaveCondition(L_ConditionInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@condition", obj.Condition));

                sqLH.ExecuteNonQuery("usp_L_Condition_SaveCondition", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal L_LaundryMasterInfo ViewAddedLaundry(L_LaundryMasterInfo obj)
        {
            try
            {
                return sqLH.ExecuteAsObject<L_LaundryMasterInfo>("usp_L_LaundryMaster_ViewAddedLaundry");

            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal void AddLaundry(L_LaundryMasterInfo obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@roomid", obj.RoomID));
                Param.Add(new KeyValuePair<string, object>("@customerid", obj.CustomerID));
                Param.Add(new KeyValuePair<string, object>("@date", obj.Date));
                Param.Add(new KeyValuePair<string, object>("@deliverydate", obj.DeliveryDate));
                Param.Add(new KeyValuePair<string, object>("@challanno", obj.ChallanNo));
                Param.Add(new KeyValuePair<string, object>("@housekeeperid", obj.HouseKeeperID));
                sqLH.ExecuteAsObject<L_LaundryMasterInfo>("usp_L_LaundryMaster_SaveLaundry", Param);

            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal object GetRoom()
        {
            return sqLH.ExecuteAsDataSet("usp_getRestroRoom");
        }

        internal List<L_LaundryDetailsInfo> getLaundryByID(int laundryMasterID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@lmasterID", laundryMasterID));

            return sqLH.ExecuteAsList<L_LaundryDetailsInfo>("usp_L_LaundryMaster_getLaundryByID", Param);
        }

        internal List<L_LaundryMasterInfo> LoadLaundry()
        {
            return sqLH.ExecuteAsList<L_LaundryMasterInfo>("usp_L_LaundryMaster_LoadLaundry");
        }

        internal int SaveLaundry(L_LaundryMasterInfo laundry)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@id", laundry.ID));
            Param.Add(new KeyValuePair<string, object>("@RoomTypeID", laundry.RoomTypeID));
            Param.Add(new KeyValuePair<string, object>("@roomid", laundry.RoomID));
            Param.Add(new KeyValuePair<string, object>("@customerid", laundry.CustomerID));
            Param.Add(new KeyValuePair<string, object>("@date", laundry.Date));
            Param.Add(new KeyValuePair<string, object>("@deliverydate", laundry.DeliveryDate));
            Param.Add(new KeyValuePair<string, object>("@challanno", laundry.ChallanNo));
            Param.Add(new KeyValuePair<string, object>("@housekeeperid", laundry.HouseKeeperID));
            Param.Add(new KeyValuePair<string, object>("@isdelivered", laundry.IsDelivered));
            Param.Add(new KeyValuePair<string, object>("@amount", laundry.Amount));
            Param.Add(new KeyValuePair<string, object>("@disctype", laundry.DiscountType));
            Param.Add(new KeyValuePair<string, object>("@discount", laundry.Discount));
            Param.Add(new KeyValuePair<string, object>("@total", laundry.Total));
            int ids = sqLH.ExecuteAsScalar<int>("usp_L_LaundryMaster_SaveLaundry", Param);

            List<KeyValuePair<string, object>> param3 = new List<KeyValuePair<string, object>>();
            param3.Add(new KeyValuePair<string, object>("@lmasterid", ids));
            sqLH.ExecuteNonQuery("usp_ac_deleteLaundryDetailByID", param3);

            foreach (L_LaundryDetailsInfo details in laundry.laundryDetails)
            {
                List<KeyValuePair<string, object>> param2 = new List<KeyValuePair<string, object>>();
                //param2.Add(new KeyValuePair<string, object>("@BankAccountID", bankInfo.BankAccountID));
                param2.Add(new KeyValuePair<string, object>("@LaundryMasterID", ids));
                param2.Add(new KeyValuePair<string, object>("@ClothID", details.ClothID));
                param2.Add(new KeyValuePair<string, object>("@MaterialID", details.MaterialID));
                param2.Add(new KeyValuePair<string, object>("@Color", details.Color));
                param2.Add(new KeyValuePair<string, object>("@Description", details.Description));
                param2.Add(new KeyValuePair<string, object>("@LaundryTypeID", details.LaundryTypeID));
                param2.Add(new KeyValuePair<string, object>("@Quantity", details.Quantity));
                param2.Add(new KeyValuePair<string, object>("@Rate", details.Rate));
                param2.Add(new KeyValuePair<string, object>("@isdelivered", details.IsDelivered));
                sqLH.ExecuteNonQuery("usp_L_SaveLaundryDetails", param2);
            }
            return ids;
        }

        internal decimal getRatebyId(int cloth, int Ltype)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@cloth", cloth));
            Param.Add(new KeyValuePair<string, object>("@Ltype", Ltype));
            return sqLH.ExecuteAsScalar<decimal>("usp_L_getRatebyId", Param);
        }

        internal List<L_LaundryMasterInfo> getRoomNoByRoomType(int RoomTypeID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@RoomTypeID", RoomTypeID));
            return sqLH.ExecuteAsList<L_LaundryMasterInfo>("usp_getRoomNoByRoomType", Param);
        }
        internal void saveAgent(AgentInfo agent)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", agent.ID));
                Param.Add(new KeyValuePair<string, object>("@agent", agent.Agent));

                sqLH.ExecuteNonQuery("usp_H_Agent_saveAgent", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<AgentInfo> getAgentList()
        {
            return sqLH.ExecuteAsList<AgentInfo>("usp_H_Agent_getAgentList");
        }
        
        internal void deleteAgent(int agentID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", agentID));

                sqLH.ExecuteNonQuery("usp_H_Agent_deleteAgent", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal void saveReservationStatus(ReservationStatusInfo reservationStatus)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", reservationStatus.ID));
                Param.Add(new KeyValuePair<string, object>("@status", reservationStatus.Status));

                sqLH.ExecuteNonQuery("usp_H_ReservationStatus_saveReservationStatus", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<ReservationStatusInfo> getReservationStatusList()
        {
            return sqLH.ExecuteAsList<ReservationStatusInfo>("usp_H_ReservationStatus_getReservationStatusList");
        }


        internal void deleteReservationStatus(int reservationStatusID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", reservationStatusID));

                sqLH.ExecuteNonQuery("usp_H_ReservationStatus_deleteReservationStatus", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
