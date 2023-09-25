using System;
using System.Collections.Generic;
using SageFrame.Web.Utilities;
using System.Transactions;

namespace SageFrame.Sales
{
    public class SalesProvider
    {
        public List<customerBilling1> getActiveBILLTERM()
        {
            SQLHandler sqlhan = new SQLHandler();
            return sqlhan.ExecuteAsList<customerBilling1>("[USP_RO_ActiveBILLTERM]");
        }
        public void saveSalesBill(SalesMaster1 sm, List<SalesDetails1> sd, int splited, List<customerBilling1> bt)
        {
            //var username=GetUsername;
            using (TransactionScope ts = new TransactionScope())
            {

                SQLHandler sqlhan = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@billNo", sm.billNo));
                Param.Add(new KeyValuePair<string, object>("@BillDate", sm.BillDate));
                Param.Add(new KeyValuePair<string, object>("@RoomId", sm.RoomId));
                Param.Add(new KeyValuePair<string, object>("@TableId", sm.TableId));
                Param.Add(new KeyValuePair<string, object>("@BasicAmount", sm.BasicAmount));
                Param.Add(new KeyValuePair<string, object>("@TermAmount", sm.TermAmount));
                Param.Add(new KeyValuePair<string, object>("@NetAmount", sm.NetAmount));
                Param.Add(new KeyValuePair<string, object>("@OrderMasterId", sm.OrderMasterId));
                Param.Add(new KeyValuePair<string, object>("@WaiterId", sm.Waiter));
                Param.Add(new KeyValuePair<string, object>("@totaldiscount", sm.totaldiscount));
                Param.Add(new KeyValuePair<string, object>("@sumBev", sm.sumBev));
                Param.Add(new KeyValuePair<string, object>("@sumKot", sm.sumKot));
                Param.Add(new KeyValuePair<string, object>("@SPMID", sm.SPMID));
                Param.Add(new KeyValuePair<string, object>("@ProviderID", sm.ProviderID));
                Param.Add(new KeyValuePair<string, object>("@CusName", sm.CusName));
                Param.Add(new KeyValuePair<string, object>("@CusID", sm.CusID));
                Param.Add(new KeyValuePair<string, object>("@IsSplit", sm.IsSplit));
                Param.Add(new KeyValuePair<string, object>("@SeatNo", sm.SeatNo));
                Param.Add(new KeyValuePair<string, object>("@AddedBy", sm.AddedBy));
                Param.Add(new KeyValuePair<string, object>("@Address", sm.Address));
                Param.Add(new KeyValuePair<string, object>("@PAN", sm.PAN));
                Param.Add(new KeyValuePair<string, object>("@ChequNO", sm.ChequeNo));
                Param.Add(new KeyValuePair<string, object>("@TransactionNo", sm.TransactionNo));
                //Param.Add(new KeyValuePair<string, object>("@WaiterId", sm.Waiter));
                List<OrderDetailClass1> list = new List<OrderDetailClass1>();
                var a = sqlhan.ExecuteAsScalar<object>("usp_ro_savesalesMaster", Param);
                int salesMasterId = Convert.ToInt32(a);



                //save billing term 
                foreach (customerBilling1 term in bt)
                {

                    List<KeyValuePair<string, object>> ParamBill2 = new List<KeyValuePair<string, object>>();
                    ParamBill2.Add(new KeyValuePair<string, object>("@amount", term.Amount));
                    ParamBill2.Add(new KeyValuePair<string, object>("@SaleMasterID", salesMasterId));
                    ParamBill2.Add(new KeyValuePair<string, object>("@BillingID", term.ID));
                    ParamBill2.Add(new KeyValuePair<string, object>("@rate", term.Rate));
                    var billTermList = sqlhan.ExecuteAsList<customerBilling1>("USP_RO_SaveBILLTERM_WITHID", ParamBill2);
                }

                //List<BillTermAmount> billTermAmountList = new List<BillTermAmount>();

                //foreach (var obj in billTermList)
                //{
                //    //BillTermAmount bta = new BillTermAmount();
                //    //bta.BillTermID = obj.ID;
                //    //bta.SalesMasterID = salesMasterId;
                //    //bta.BillTerm = obj.BillTerm;
                //    //bta.Amount = obj.Amount;
                //    //billTermAmountList.Add(bta);

                //    List<KeyValuePair<string, object>> ParamBill4 = new List<KeyValuePair<string, object>>();
                //    ParamBill4.Add(new KeyValuePair<string, object>("@SalesMasterID", salesMasterId));
                //    ParamBill4.Add(new KeyValuePair<string, object>("@BillTermID", obj.ID));
                //    ParamBill4.Add(new KeyValuePair<string, object>("@Amount", obj.Amount));
                //    ParamBill4.Add(new KeyValuePair<string, object>("@IsVoid", false));

                //    sqlhan.ExecuteNonQuery("[USP_RO_BILLTERMAMOUNT_SAVE]", ParamBill4);

                //}
                //foreach(var obj in billTermAmountList)
                //{
                //    List<KeyValuePair<string, object>> ParamBill4 = new List<KeyValuePair<string, object>>();
                //    ParamBill4.Add(new KeyValuePair<string, object>("@SalesMasterID", obj.SalesMasterID));
                //    ParamBill4.Add(new KeyValuePair<string, object>("@BillTerm", obj.BillTermID));
                //    ParamBill4.Add(new KeyValuePair<string, object>("@Amount", obj.Amount));
                //    ParamBill4.Add(new KeyValuePair<string, object>("@IsVoid", false));

                //    sqlhan.ExecuteNonQuery("[USP_RO_BILLTERMAMOUNT_SAVE]", ParamBill4);
                //}

                List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                for (int i = 0; i < sd.Count; i++)
                {

                    Param1.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                    Param1.Add(new KeyValuePair<string, object>("@ItemId", sd[i].ItemId));
                    Param1.Add(new KeyValuePair<string, object>("@qty", sd[i].qty));
                    Param1.Add(new KeyValuePair<string, object>("@rate", sd[i].rate));
                    Param1.Add(new KeyValuePair<string, object>("@Amount", sd[i].Amount));
                    Param1.Add(new KeyValuePair<string, object>("@NetAmount", sd[i].NetAmount));
                    Param1.Add(new KeyValuePair<string, object>("@CostCenterId", sd[i].CostCenterId));
                    Param1.Add(new KeyValuePair<string, object>("@IsCombo", sd[i].IsCombo));
                    sqlhan.ExecuteAsScalar<object>("usp_ro_savesalesDetail", Param1);
                    Param1.Clear();
                }


                List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                Param2.Add(new KeyValuePair<string, object>("@OrderMasterId", sm.OrderMasterId));
                Param2.Add(new KeyValuePair<string, object>("@termAmount", sm.TermAmount));
                Param2.Add(new KeyValuePair<string, object>("@NetAmount", sd[0].NetAmount));
                Param2.Add(new KeyValuePair<string, object>("@splited", splited));
                sqlhan.ExecuteNonQuery("usp_ro_updateOrderMaster", Param2);

                List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                for (int i = 0; i < sd.Count; i++)
                {
                    Param3.Add(new KeyValuePair<string, object>("@orderDetailsId", sd[i].OrderDetailsID));
                    Param3.Add(new KeyValuePair<string, object>("@qty", sd[i].qty));
                    Param3.Add(new KeyValuePair<string, object>("@netAmount", sd[i].Amount));
                    sqlhan.ExecuteNonQuery("usp_ro_updateOrderDetails", Param3);
                    Param3.Clear();
                }
                ts.Complete();
            }
        }
    }
}
