using System.Collections.Generic;

namespace SageFrame.Laundry
{
    public class LaundryController
    {
        LaundryProvider provider = new LaundryProvider();
        public List<L_MaterialTypeInfo> LoadMaterialTypeList()
        {
            return provider.LoadMaterialTypeList();
        }

        public L_MaterialTypeInfo GetMaterialTypeByID(int materialTypeId)
        {
            return provider.GetMaterialTypeByID(materialTypeId);
        }

        public void DeleteMaterialType(int materialTypeId)
        {
            provider.DeleteMaterialType(materialTypeId);
        }

        public void UpdateMaterialType(L_MaterialTypeInfo obj)
        {
            provider.UpdateMaterialType(obj);
        }

        public void SaveMaterialType(L_MaterialTypeInfo obj)
        {
            provider.SaveMaterialType(obj);
        }
        public List<L_LaundryTypeInfo> LoadLaundryTypeList(int cloth)
        {
            return provider.LoadLaundryTypeList(cloth);
        }

        public L_LaundryTypeInfo GetLaundryTypeByID(int laundryTypeId)
        {
            return provider.GetLaundryTypeByID(laundryTypeId);
        }

        public void DeleteLaundryType(int laundryTypeId)
        {
            provider.DeleteLaundryType(laundryTypeId);
        }

        public void UpdateLaundryType(L_LaundryTypeInfo obj)
        {
            provider.UpdateLaundryType(obj);
        }

        public void SaveLaundryType(L_LaundryTypeInfo obj)
        {
            provider.SaveLaundryType(obj);
        }
        public List<L_LaundryRateInfo> LoadLaundryType()
        {
            return provider.LoadLaundryType();
        }
        public List<L_LaundryRateInfo> LoadClothList()
        {
            return provider.LoadClothList();
        }
        public List<L_LaundryRateInfo> LoadLaundryRateList()
        {
            return provider.LoadLaundryRateList();
        }

        public L_LaundryRateInfo GetLaundryRateByID(int laundryRateId)
        {
            return provider.GetLaundryRateByID(laundryRateId);
        }

        public void DeleteLaundryRate(int laundryRateId)
        {
            provider.DeleteLaundryRate(laundryRateId);
        }

        public void UpdateLaundryRate(L_LaundryRateInfo obj)
        {
            provider.UpdateLaundryRate(obj);
        }

        public void SaveLaundryRate(L_LaundryRateInfo obj)
        {
            provider.SaveLaundryRate(obj);
        }
        public List<L_ClothInfo> LoadCloth()
        {
            return provider.LoadCloth();
        }

        public L_ClothInfo GetClothByID(int clothId)
        {
            return provider.GetClothByID(clothId);
        }

        public void DeleteCloth(int clothId)
        {
            provider.DeleteCloth(clothId);
        }

        public void UpdateCloth(L_ClothInfo obj)
        {
            provider.UpdateCloth(obj);
        }

        public void SaveCloth(L_ClothInfo obj)
        {
            provider.SaveCloth(obj);
        }
        public List<L_ConditionInfo> LoadConditionList()
        {
            return provider.LoadConditionList();
        }

        public L_ConditionInfo GetConditionByID(int conditionId)
        {
            return provider.GetConditionByID(conditionId);
        }

        public void DeleteCondition(int conditionId)
        {
            provider.DeleteCondition(conditionId);
        }

        public void UpdateCondition(L_ConditionInfo obj)
        {
            provider.UpdateCondition(obj);
        }

        public void SaveCondition(L_ConditionInfo obj)
        {
            provider.SaveCondition(obj);
        }
        public void AddLaundry(L_LaundryMasterInfo obj)
        {
            provider.AddLaundry(obj);
        }
        public L_LaundryMasterInfo ViewAddedLaundry(L_LaundryMasterInfo obj)
        {
            return provider.ViewAddedLaundry(obj);
        }

        public List<L_LaundryMasterInfo> LoadLaundry()
        {
            return provider.LoadLaundry();
        }

        public object GetRoom()
        {
            return provider.GetRoom();
        }

        public int SaveLaundry(L_LaundryMasterInfo laundry)
        {
            return provider.SaveLaundry(laundry);
        }
        public void deleteLaundry(int laundryMasterID)
        {
            provider.deleteLaundry(laundryMasterID);
        }
        public decimal getRatebyId(int cloth, int Ltype)
        {
            return provider.getRatebyId(cloth, Ltype);
        }
        public List<L_LaundryDetailsInfo> getLaundryByID(int laundryMasterID)
        {
            return provider.getLaundryByID(laundryMasterID);
        }

        public List<L_LaundryMasterInfo> getRoomNoByRoomType(int RoomTypeID)
        {
            return provider.getRoomNoByRoomType(RoomTypeID);
        }

        public List<RoomGroupInfo> getRoomGroupList()
        {
            return provider.getRoomGroupList();
        }
        public void saveRoomGroup(RoomGroupInfo roomclass)
        {
            provider.saveRoomGroup(roomclass);
        }
        public void deleteRoomGroup(int roomGroupID)
        {
            provider.deleteRoomGroup(roomGroupID);
        }
        public List<AmnitiesInfo> getAmnitiesList()
        {
            return provider.getAmnitiesList();
        }
        public void saveAmnities(AmnitiesInfo amnities)
        {
            provider.saveAmnities(amnities);
        }
        public void deleteAmnities(int amnitiesID)
        {
            provider.deleteAmnities(amnitiesID);
        }
        public List<RoomClassInfo> getRoomClassList()
        {
            return provider.getRoomClassList();
        }
        public void saveRoomClass(RoomClassInfo roomclass)
        {
            provider.saveRoomClass(roomclass);
        }
        public void deleteRoomClass(int roomClassID)
        {
            provider.deleteRoomClass(roomClassID);
        }
        public List<BuildingBlockInfo> getBuildingBlockList()
        {
            return provider.getBuildingBlockList();
        }
        public void saveBuildingBlock(BuildingBlockInfo BuildingBlock)
        {
            provider.saveBuildingBlock(BuildingBlock);
        }
        public void deleteBuildingBlock(int BuildingBlockID)
        {
            provider.deleteBuildingBlock(BuildingBlockID);
        }
        public void updateisdelivered(int laundryMasterID)
        {
            provider.updateisdelivered(laundryMasterID);
        }
        public void updateldisdelivered(int laundryDetailsID)
        {
            provider.updateldisdelivered(laundryDetailsID);
        }
        public List<ReservationStatusInfo> getReservationStatusList()
        {
            return provider.getReservationStatusList();
        }
        public void saveReservationStatus(ReservationStatusInfo reservationStatus)
        {
            provider.saveReservationStatus(reservationStatus);
        }
        public void deleteReservationStatus(int reservationStatusID)
        {
            provider.deleteReservationStatus(reservationStatusID);
        }
        public List<AgentInfo> getAgentList()
        {
            return provider.getAgentList();
        }
        public void saveAgent(AgentInfo agent)
        {
            provider.saveAgent(agent);
        }
        public void deleteAgent(int agentID)
        {
            provider.deleteAgent(agentID);
        }
    }
}
