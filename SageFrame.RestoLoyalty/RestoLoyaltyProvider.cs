using SageFrame.Web.Utilities;
using System;
using System.Collections.Generic;
using System.Transactions;



namespace SageFrame.RestoLoyalty
{
    public class RestoLoyaltyProvider
    {
        public void SaveMembership(MemberInfo MemberInfo)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@MembershipID", MemberInfo.MembershipID));
                Param.Add(new KeyValuePair<string, object>("@Fname  ", MemberInfo.Fname));
                Param.Add(new KeyValuePair<string, object>("@Lname", MemberInfo.Lname));
                Param.Add(new KeyValuePair<string, object>("@Address", MemberInfo.Address));
                Param.Add(new KeyValuePair<string, object>("@City", MemberInfo.City));
                Param.Add(new KeyValuePair<string, object>("@Country", MemberInfo.Country));
                Param.Add(new KeyValuePair<string, object>("@TelHome", MemberInfo.TelHome));
                Param.Add(new KeyValuePair<string, object>("@TelWork", MemberInfo.TelWork));
                Param.Add(new KeyValuePair<string, object>("@TelMobile", MemberInfo.TelMobile));
                Param.Add(new KeyValuePair<string, object>("@Email", MemberInfo.Email));
                Param.Add(new KeyValuePair<string, object>("@Occupation", MemberInfo.Occupation));
                Param.Add(new KeyValuePair<string, object>("@Company", MemberInfo.Company));
                Param.Add(new KeyValuePair<string, object>("@Birthday", MemberInfo.Birthday));
                Param.Add(new KeyValuePair<string, object>("@Anniversary", MemberInfo.Anniversary));
                Param.Add(new KeyValuePair<string, object>("@CardNumber", MemberInfo.CardNumber));
                Param.Add(new KeyValuePair<string, object>("@OpeningBalance", MemberInfo.OpeningBalance));
                if (MemberInfo.DateOfIssue == "")
                {

                    Param.Add(new KeyValuePair<string, object>("@DateOfIssue", MemberInfo.DateOfIssue));
                }
                if (MemberInfo.DateOfExpire == "")
                {
                    Param.Add(new KeyValuePair<string, object>("@DateOfExpire", MemberInfo.DateOfExpire));
                }
                Param.Add(new KeyValuePair<string, object>("@discount", MemberInfo.discount));
                Param.Add(new KeyValuePair<string, object>("@PAN", MemberInfo.PAN));
                Param.Add(new KeyValuePair<string, object>("@IsCustomer", MemberInfo.IsCustomer));
                Param.Add(new KeyValuePair<string, object>("@IsVat", MemberInfo.IsVat));
                Param.Add(new KeyValuePair<string, object>("@Addedby", MemberInfo.AddedBy));
                sqlhan.ExecuteNonQuery("[USP_RO_SAVEMEMBERSHIP]", Param);

            }
            catch (Exception)
            {

                throw;
            }
        }


        public void SaveAgent(AgentInfo MemberInfo)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@MembershipID", MemberInfo.MembershipID));
                Param.Add(new KeyValuePair<string, object>("@Fname  ", MemberInfo.Fname));
                Param.Add(new KeyValuePair<string, object>("@Lname", MemberInfo.Lname));
                Param.Add(new KeyValuePair<string, object>("@Address", MemberInfo.Address));
                Param.Add(new KeyValuePair<string, object>("@City", MemberInfo.City));
                Param.Add(new KeyValuePair<string, object>("@Country", MemberInfo.Country));
                Param.Add(new KeyValuePair<string, object>("@TelWork", MemberInfo.TelWork));
                Param.Add(new KeyValuePair<string, object>("@TelMobile", MemberInfo.TelMobile));
                Param.Add(new KeyValuePair<string, object>("@Email", MemberInfo.Email));
                Param.Add(new KeyValuePair<string, object>("@Company", MemberInfo.Company));        
                Param.Add(new KeyValuePair<string, object>("@DateOfIssue", MemberInfo.DateOfIssue));
                Param.Add(new KeyValuePair<string, object>("@DateOfExpire", MemberInfo.DateOfExpire));
                Param.Add(new KeyValuePair<string, object>("@Commission", MemberInfo.Commission));
                Param.Add(new KeyValuePair<string, object>("@PAN", MemberInfo.PAN));
                Param.Add(new KeyValuePair<string, object>("@IsAgent", MemberInfo.IsAgent));
                Param.Add(new KeyValuePair<string, object>("@IsVat", MemberInfo.IsVat));
                Param.Add(new KeyValuePair<string, object>("@Addedby", MemberInfo.AddedBy));
                sqlhan.ExecuteNonQuery("[USP_RO_SAVEAGENT]", Param);

            }
            catch (Exception)
            {

                throw;
            }
        }


        internal List<PickInfo> GetPickOrderFromDataBase()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                SQLHandler sqlhan = new SQLHandler();
                List<PickInfo> RPickInfo = sqlhan.ExecuteAsList<PickInfo>("[usp_ro_listpickorder]");
                return RPickInfo;
            }
            catch (Exception)
            {

                throw;
            }
        }

        public List<MemberInfo> getmemInfo()
        {
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<MemberInfo>("[usp_ro_getmembershipInfo]");

        }

        public List<ItemInfo> GetItemFromDatbase()
        {
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<ItemInfo>("[USP_GET_ROITEMS]");
        }

        internal List<ItemInfo> GetItemFromDatbase(int ITId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ITId", ITId));
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<ItemInfo>("[USP_GET_ROUNIT]", Param);
        }

        internal List<ItemInfo> GetItemDropDown()
        {
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<ItemInfo>("[RO_GET_ITEM]");
            //USP_RO_GETITEM
        }

        internal List<ItemInfo> GetUnitDropDown()
        {
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<ItemInfo>("[RO_GET_UNIT]");
        }

        public void SaveRestoItem(ItemInfo ItemInfoobj)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RId", ItemInfoobj.RId));
                Param.Add(new KeyValuePair<string, object>("@ITId", ItemInfoobj.ITId));
                Param.Add(new KeyValuePair<string, object>("@UnitId", ItemInfoobj.UnitId));
                Param.Add(new KeyValuePair<string, object>("@PRate", ItemInfoobj.PRate));
                Param.Add(new KeyValuePair<string, object>("@SRate", ItemInfoobj.SRate));
                Param.Add(new KeyValuePair<string, object>("@ValidFrom", ItemInfoobj.ValidFrom));
                Param.Add(new KeyValuePair<string, object>("@PostedBy", ItemInfoobj.PostedBy));



                sqlhan.ExecuteNonQuery("[ROI_INSERT_ITEM]", Param);


            }
            catch (Exception)
            {

                throw;
            }
        }

        internal List<ItemInfo> GetRollerItemFromDataBase()
        {
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<ItemInfo>("[ROI_GET_ITEM_RATE]");
        }

        internal void DeleteItem(int RId)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RId", RId));
                sqlhan.ExecuteNonQuery("[USP_DELETE_ITEMRATE]", Param);
            }
            catch (Exception)
            {

                throw;
            }
        }

        public List<MemberInfo> getmembershiplist(int customer)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@customer", customer));
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<MemberInfo>("[USP_GETMEMBERSHIPFORM]", Param);
        }

        public List<AgentInfo> getAgentList(int agent)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@IsAgent", agent));
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<AgentInfo>("[USP_GETAGENTLIST]", Param);
        }

        public int deletemember(int RId, string deletedby)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@MembershipID", RId));
                Param.Add(new KeyValuePair<string, object>("@ArchivedBy", deletedby));
                var a = sqlhan.ExecuteAsScalar<object>("[USP_PO_DELETEMEMBERSHIP]", Param);
                return Convert.ToInt32(a);

            }
            catch (Exception)
            {

                throw;
            }
        }

        public int deleteAgent(int RId, string deletedby)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@MembershipID", RId));
                Param.Add(new KeyValuePair<string, object>("@ArchivedBy", deletedby));
                var a = sqlhan.ExecuteAsScalar<object>("[USP_PO_DELETEAGENT]", Param);
                return Convert.ToInt32(a);

            }
            catch (Exception)
            {

                throw;
            }
        }

        //internal List<roistore> GetStoreDropDown()
        //{
        //    SQLHandler sqlhan = new SQLHandler();
        //    return sqlhan.ExecuteAsList<roistore>("[USP_ROI_Store]");
        //}

        internal void SaveBalance(BalanceInfo BalanceInfo)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ITId", BalanceInfo.ITId));
                Param.Add(new KeyValuePair<string, object>("@STId", BalanceInfo.STId));
                Param.Add(new KeyValuePair<string, object>("@OPBal", BalanceInfo.OPBal));
                Param.Add(new KeyValuePair<string, object>("@OPRate", BalanceInfo.OPRate));




                sqlhan.ExecuteNonQuery("[USP_ROI_SAVEBALANCE]", Param);


            }
            catch (Exception)
            {

                throw;
            }
        }

        internal List<BalanceInfo> GetItemBalance()
        {
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<BalanceInfo>("[USP_GET_BALANCE]");
        }

        internal void Deletebalance(int ItemBalID)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ItemBalID", ItemBalID));

                sqlhan.ExecuteNonQuery("[USP_DELETE_ITEMBALANCE]", Param);
            }
            catch (Exception)
            {

                throw;
            }
        }

        internal void SaveCustomerAmount(MemberInfo MemberInfo)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@MembershipID", MemberInfo.MembershipID));
                Param.Add(new KeyValuePair<string, object>("@RemainingBalance", MemberInfo.RemainingBalance));
                Param.Add(new KeyValuePair<string, object>("@PayAmount", MemberInfo.PayAmount));
                Param.Add(new KeyValuePair<string, object>("@AddedBy", MemberInfo.AddedBy));
                Param.Add(new KeyValuePair<string, object>("@GoodReceivedMainId", MemberInfo.GoodReceivedMainId));
                sqlhan.ExecuteNonQuery("[USP_UPDATE_MEMBERSHIP]", Param);
            }
            catch (Exception)
            {

                throw;
            }
        }

        internal List<MemberInfo> getmembershipCreditlist()
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<MemberInfo>("[USP_GET_MEMBER_CREDIT]", Param);
        }

        internal List<MemberInfo> GetCusOnChange(int MembershipID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@MembershipID", MembershipID));
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<MemberInfo>("[USP_GET_MEMBER_CREDIT_BYID]", Param);
        }

        internal void SaveTotalCashPaid(MemberInfo MemberInfo)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@MembershipID", MemberInfo.MembershipID));
                Param.Add(new KeyValuePair<string, object>("@UptoNowPaid", MemberInfo.UptoNowPaid));
                sqlhan.ExecuteNonQuery("[USP_UPDATE_MEMBERSHIP_PAIDAMOUNT]", Param);


            }
            catch (Exception)
            {

                throw;
            }
        }

        internal void SaveVendor(MemberInfo MemberInfo)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@MembershipID", MemberInfo.MembershipID));
            Param.Add(new KeyValuePair<string, object>("@Name  ", MemberInfo.Name));
            Param.Add(new KeyValuePair<string, object>("@Address", MemberInfo.Address));
            Param.Add(new KeyValuePair<string, object>("@City", MemberInfo.City));
            Param.Add(new KeyValuePair<string, object>("@Country", MemberInfo.Country));
            Param.Add(new KeyValuePair<string, object>("@TelHome", MemberInfo.TelHome));
            Param.Add(new KeyValuePair<string, object>("@TelWork", MemberInfo.TelWork));
            Param.Add(new KeyValuePair<string, object>("@TelMobile", MemberInfo.TelMobile));
            Param.Add(new KeyValuePair<string, object>("@Email", MemberInfo.Email));
            Param.Add(new KeyValuePair<string, object>("@PAN", MemberInfo.PAN));


            sqlhan.ExecuteNonQuery("[USP_RO_SAVEVENDOR]", Param);

        }

        public int SaveExtraBilling(ExtraBilling PurchaseObjectItem)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    SQLHandler sqh = new SQLHandler();
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@CustomerName", PurchaseObjectItem.CustomerName));
                    Param.Add(new KeyValuePair<string, object>("@IssueDate", PurchaseObjectItem.IssueDate));
                    Param.Add(new KeyValuePair<string, object>("@Pan", PurchaseObjectItem.Pan));
                    Param.Add(new KeyValuePair<string, object>("@NetTotal", PurchaseObjectItem.NetTotal));
                    Param.Add(new KeyValuePair<string, object>("@Discount", PurchaseObjectItem.Discount));
                    Param.Add(new KeyValuePair<string, object>("@Vat", PurchaseObjectItem.Vat));
                    Param.Add(new KeyValuePair<string, object>("@GrandTotal", PurchaseObjectItem.GrandTotal));


                    var a = sqh.ExecuteAsScalar<object>("[USP_ROI_ExtraBillMainSave]", Param);
                    PurchaseObjectItem.ExtraBillingID = Convert.ToInt32(a);

                    for (int i = 0; i < PurchaseObjectItem.ExtrabillingObjectDetails.Count; i++)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@BillingID", PurchaseObjectItem.ExtraBillingID));
                        Param1.Add(new KeyValuePair<string, object>("@Item", PurchaseObjectItem.ExtrabillingObjectDetails[i].Item));
                        Param1.Add(new KeyValuePair<string, object>("@Rate", PurchaseObjectItem.ExtrabillingObjectDetails[i].Rate));
                        Param1.Add(new KeyValuePair<string, object>("@Quantity", PurchaseObjectItem.ExtrabillingObjectDetails[i].Quantity));
                        Param1.Add(new KeyValuePair<string, object>("@Total", PurchaseObjectItem.ExtrabillingObjectDetails[i].Total));

                        sqh.ExecuteNonQuery("[USP_ROI_ExtraBillingDetailsSave]", Param1);
                    }
                    ts.Complete();
                    return Convert.ToInt32(a);
                }

                catch (Exception)
                {

                    throw;
                }
            }

        }

        //internal object GetExtraBillingList()
        internal List<ExtraBilling> GetExtraBillingList(string eid)
        {

            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@eid", eid));
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<ExtraBilling>("[USP_GET_MEMBER_EXTRABILLING]", Param);

        }



        internal List<BalanceTransaction> getCustomerTransactionbyID(int MembershipID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@MembershipID", MembershipID));
            SQLHandler sqh = new SQLHandler();
            return sqh.ExecuteAsList<BalanceTransaction>("[getCustomerBalanceTransactionRecordByID]", Param);
        }

        internal string UPDATE_MembershipBalance(MemberInfo MemberInfo, CreditPayment payment)
        {
            SQLHandler sqlhan = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@MembershipID", MemberInfo.MembershipID));
            Param.Add(new KeyValuePair<string, object>("@RemainingBalance", MemberInfo.RemainingBalance));
            Param.Add(new KeyValuePair<string, object>("@PayAmount", MemberInfo.PayAmount));
            Param.Add(new KeyValuePair<string, object>("@SettlementAmount", MemberInfo.SettlementAmount));
            Param.Add(new KeyValuePair<string, object>("@AddedBy", MemberInfo.AddedBy));
            var payId = sqlhan.ExecuteAsScalar<object>("[USP_UPDATE_MembershipBalance]", Param);

            List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
            Param3.Add(new KeyValuePair<string, object>("@MembershipID", MemberInfo.MembershipID));
            string prevVoucherNo = sqlhan.ExecuteAsScalar<string>("[usp_ac_getPrevousVoucherNo]", Param3);
            string newVoucherNo = (Convert.ToInt32((prevVoucherNo!=null ?prevVoucherNo.Split('-')[1]:"0")) + 1).ToString();

            List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
            Param2.Add(new KeyValuePair<string, object>("@MembershipID", MemberInfo.MembershipID));
            Param2.Add(new KeyValuePair<string, object>("@PayAmount", MemberInfo.PayAmount));
            Param2.Add(new KeyValuePair<string, object>("@SettlementAmount", MemberInfo.SettlementAmount));
            Param2.Add(new KeyValuePair<string, object>("@NewVoucherNo", newVoucherNo));
            Param2.Add(new KeyValuePair<string, object>("@PaymentModeID", payment.PaymentModeID));
            Param2.Add(new KeyValuePair<string, object>("@TransactionNo", payment.TransactionNo));
            Param2.Add(new KeyValuePair<string, object>("@ProviderID", payment.ProviderID));
            var transactionId = sqlhan.ExecuteAsScalar<object>("[USP_SaveCreditPaymentTransaction]", Param2);

            List<KeyValuePair<string, object>> Param4 = new List<KeyValuePair<string, object>>();
            Param4.Add(new KeyValuePair<string, object>("@MemberPayId", Convert.ToInt32(payId)));
            Param4.Add(new KeyValuePair<string, object>("@MemberID", payment.MemberID));
            Param4.Add(new KeyValuePair<string, object>("@PaymentModeID", payment.PaymentModeID));
            Param4.Add(new KeyValuePair<string, object>("@ProviderID", payment.ProviderID));
            Param4.Add(new KeyValuePair<string, object>("@TransactionNo", payment.TransactionNo));
            Param4.Add(new KeyValuePair<string, object>("@PayAmount", MemberInfo.PayAmount));
            Param4.Add(new KeyValuePair<string, object>("@SettlementAmount", MemberInfo.SettlementAmount));
            Param4.Add(new KeyValuePair<string, object>("@VoucherNo", newVoucherNo));
            Param4.Add(new KeyValuePair<string, object>("@TransactionId", transactionId));
            sqlhan.ExecuteNonQuery("[USP_SaveCreditPaymentMode]", Param4);

            return newVoucherNo;

        }


        public List<MemberInfo> getmembershiplistbyId(int memberid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@MembershipID", memberid));
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<MemberInfo>("USP_GetMemberByID", Param);
        }


        public List<MemberInfo> getMemberDetailsbyinfo(string info)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@info", info));
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<MemberInfo>("USP_GetMemberDetailsbyinfo", Param);
        }

        public List<CreditPayment> getcustomerbalanceReceipt(int memberpayid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@MemberPayID", memberpayid));
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<CreditPayment>("USP_GETCREDITPAYBILL", Param);
        }


        public void SaveLoyalityCard(CardInfo CardInfo)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@CardTypeID", CardInfo.CardTypeID));
                Param.Add(new KeyValuePair<string, object>("@CardName", CardInfo.CardName));
                Param.Add(new KeyValuePair<string, object>("@Description", CardInfo.Description));
                Param.Add(new KeyValuePair<string, object>("@discount", CardInfo.discount));            
                sqlhan.ExecuteNonQuery("USP_SaveLoyalityCardType", Param);
            }
            catch (Exception)
            {

                throw;
            }
        }


        internal void DeleteLoyalityCardType(int CardTypeID)
        {
            try
            {
                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@CardTypeID", CardTypeID));

                sqlhan.ExecuteNonQuery("USP_DeleteLoyalityCardType", Param);
            }
            catch (Exception)
            {

                throw;
            }
        }

        internal List<CardInfo> getLoyalityCardType()
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<CardInfo>("USP_GetLoyalityCardType", Param);
        }

        public List<CardInfo> GetLoyalityDiscountByCard(int CardTypeID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CardTypeID", CardTypeID));
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<CardInfo>("USP_GetLoyalityDiscountByCard", Param);
        }
    }
}
