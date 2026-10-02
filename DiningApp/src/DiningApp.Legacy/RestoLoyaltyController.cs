using System;
using System.Collections.Generic;

namespace SageFrame.RestoLoyalty
{
    public class RestoLoyaltyController
    {

        public void SaveMembership(MemberInfo MemberInfo)
        {
            RestoLoyaltyProvider prov = new RestoLoyaltyProvider();
            prov.SaveMembership(MemberInfo);
        }
        
        public void SaveAgent(AgentInfo AgentInfo)
        {
            RestoLoyaltyProvider prov = new RestoLoyaltyProvider();
            prov.SaveAgent(AgentInfo);
        }

        public List<PickInfo> GetPickOrderFromDataBase()
        {
            RestoLoyaltyProvider prov = new RestoLoyaltyProvider();
            return prov.GetPickOrderFromDataBase();
        }

        public List<MemberInfo> getmemInfo()
        {
            RestoLoyaltyProvider prov = new RestoLoyaltyProvider();
            return prov.getmemInfo();
        }

        public List<ItemInfo> GetItemFromDataBase()
        {
            RestoLoyaltyProvider pro = new RestoLoyaltyProvider();
            return pro.GetItemFromDatbase();
        }

        public List<ItemInfo> GetUnitFromDataBaseOnChange(int ITId)
        {
            RestoLoyaltyProvider pro = new RestoLoyaltyProvider();
            return pro.GetItemFromDatbase(ITId);
        }

        public List<ItemInfo> GetItemDropDown()
        {
            RestoLoyaltyProvider pro = new RestoLoyaltyProvider();
            return pro.GetItemDropDown();
        }

        public List<ItemInfo> GetUnitDropDown()
        {
            RestoLoyaltyProvider pro = new RestoLoyaltyProvider();
            return pro.GetUnitDropDown();
        }

        public void SaveRestoItem(ItemInfo ItemInfoobj)
        {
            try
            {
                RestoLoyaltyProvider dpobj = new RestoLoyaltyProvider();
                dpobj.SaveRestoItem(ItemInfoobj);
            }
            catch (Exception)
            {

                throw;
            }
        }

        public List<ItemInfo> GetRollerItemFromDataBase()
        {
            RestoLoyaltyProvider pro = new RestoLoyaltyProvider();
            return pro.GetRollerItemFromDataBase();
        }

        public void DeleteItem(int RId)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            robobj.DeleteItem(RId);
        }

        public List<MemberInfo> getmembershiplist(int customer)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.getmembershiplist(customer);
        }

        public List<AgentInfo> getAgentList(int agent)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.getAgentList(agent);
        }

        public int deletemember(int RId, string deletedby)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.deletemember(RId, deletedby);
        }

        public int deleteAgent(int RId, string deletedby)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.deleteAgent(RId, deletedby);
        }

        public void SaveBalance(BalanceInfo BalanceInfo)
        {
            RestoLoyaltyProvider prov = new RestoLoyaltyProvider();
            prov.SaveBalance(BalanceInfo);
        }

        public List<BalanceInfo> GetItemBalance()
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.GetItemBalance();
        }

       

        //public List<roistore> GetStoreDropDown()
        //{
        //    RestoLoyaltyProvider pro = new RestoLoyaltyProvider();
        //    return pro.GetStoreDropDown();
        //}

        public void Deletebalance(int ItemBalID)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            robobj.Deletebalance(ItemBalID);
        }

        public void SaveCustomerAmount(MemberInfo MemberInfo)
        {
            try
            {
                RestoLoyaltyProvider dpobj = new RestoLoyaltyProvider();
                dpobj.SaveCustomerAmount(MemberInfo);
            }
            catch (Exception)
            {

                throw;
            }
        }

        public List<MemberInfo> getmembershipCreditlist()
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.getmembershipCreditlist();
        }

        public List<MemberInfo> GetCusOnChange(int MembershipID)
        {
            RestoLoyaltyProvider prov = new RestoLoyaltyProvider();
            return prov.GetCusOnChange(MembershipID);
        }

        public void SaveTotalCashPaid(MemberInfo MemberInfo)
        {
            try
            {
                RestoLoyaltyProvider dpobj = new RestoLoyaltyProvider();
                dpobj.SaveTotalCashPaid(MemberInfo);
            }
            catch (Exception)
            {

                throw;
            }
        }

        public void SaveVendor(MemberInfo MemberInfo)
        {
            RestoLoyaltyProvider prov = new RestoLoyaltyProvider();
            prov.SaveVendor(MemberInfo);
        }



        public int SaveExtraBilling(ExtraBilling PurchaseObjectItem)
        {
            RestoLoyaltyProvider prov = new RestoLoyaltyProvider();
            return prov.SaveExtraBilling(PurchaseObjectItem);
        }

        public List<ExtraBilling> GetExtraBillingList(string eid)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.GetExtraBillingList(eid);
        }

        //public List<itemsalesReport> getiemsalesreport(DateTime Start, DateTime EndDate)
        //{
        //    RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
        //    return robobj.getiemsalesreport(Start, EndDate);
        //}



        public List<BalanceTransaction> getCustomerTransactionbyID(int MembershipID)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.getCustomerTransactionbyID(MembershipID);
        }

        public string UPDATE_MembershipBalance(MemberInfo MemberInfo, CreditPayment payment)
        {
            RestoLoyaltyProvider dpobj = new RestoLoyaltyProvider();
            return dpobj.UPDATE_MembershipBalance(MemberInfo, payment);
        }

        public List<MemberInfo> getmembershiplistbyId(int memberid)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.getmembershiplistbyId(memberid);
        }

        public List<MemberInfo> getMemberDetailsbyinfo(string info)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.getMemberDetailsbyinfo(info);
        }

        public List<CreditPayment> getcustomerbalanceReceipt(int memberpayid)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.getcustomerbalanceReceipt(memberpayid);
        }

        public void SaveLoyalityCard(CardInfo CardInfo)
        {
            RestoLoyaltyProvider prov = new RestoLoyaltyProvider();
            prov.SaveLoyalityCard(CardInfo);
        }


        public void DeleteLoyalityCardType(int CardTypeID)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            robobj.DeleteLoyalityCardType(CardTypeID);
        }

        public List<CardInfo> getLoyalityCardType()
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.getLoyalityCardType();
        }

        public List<CardInfo> GetLoyalityDiscountByCard(int CardTypeID)
        {
            RestoLoyaltyProvider robobj = new RestoLoyaltyProvider();
            return robobj.GetLoyalityDiscountByCard(CardTypeID);
        }

    }
}
