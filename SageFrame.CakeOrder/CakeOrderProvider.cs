using SageFrame.Web.Utilities;
using System;
using SageFrame.RestoLoyalty;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace SageFrame.CakeOrder
{
    class CakeOrderProvider
    {
        private SQLHandler sqlHandler;
        public CakeOrderProvider()
        {
            sqlHandler = new SQLHandler();
        }

        internal int CakeOrderMasterSaveToDatabase(CakeOrderMaster cakeOrderMaster,List<CakeOrderList> cakeOrderDetailList)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    //DeleteOrderDetailsByMaster(orderMasterInfo.OrderMasterID, orderMasterInfo.UserName);
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@CakeOrderMasterID", cakeOrderMaster.OrderMasterID));
                    Param.Add(new KeyValuePair<string, object>("@BillNo", cakeOrderMaster.BillNo));
                    //Param.Add(new KeyValuePair<string, object>("@Date", cakeOrderMaster.Date));
                    Param.Add(new KeyValuePair<string, object>("@CustomerId",cakeOrderMaster.CustomerId ));
                    Param.Add(new KeyValuePair<string, object>("@UpdatedBy", cakeOrderMaster.UpdatedBy));
                    Param.Add(new KeyValuePair<string, object>("@PAN", cakeOrderMaster.PAN));
                    Param.Add(new KeyValuePair<string, object>("@CancelReason", cakeOrderMaster.CancelReason));
                    Param.Add(new KeyValuePair<string, object>("@Remarks", cakeOrderMaster.Remarks));
                    Param.Add(new KeyValuePair<string, object>("@AddedBy", cakeOrderMaster.AddedBy));
                    Param.Add(new KeyValuePair<string, object>("@Address", cakeOrderMaster.Address));
                    Param.Add(new KeyValuePair<string, object>("@AdvanceAmount", cakeOrderMaster.AdvanceAmount));
                    Param.Add(new KeyValuePair<string, object>("@CustomerName", cakeOrderMaster.CustomerName));
                    Param.Add(new KeyValuePair<string, object>("@DeliveryService", cakeOrderMaster.DeliveryService));
                    Param.Add(new KeyValuePair<string, object>("@DeliveryTime", cakeOrderMaster.DeliveryTime)); 
                    Param.Add(new KeyValuePair<string, object>("@Phone", cakeOrderMaster.Phone));
                    Param.Add(new KeyValuePair<string, object>("@SalesType", cakeOrderMaster.SalesType));
                    Param.Add(new KeyValuePair<string, object>("@OrderTypeID", cakeOrderMaster.OrderTypeID));
                    //Param.Add(new KeyValuePair<string, object>("@StatusId", 1));
                    var obj = sqlHandler.ExecuteAsScalar<object>("[USP_RO_CAKEORDERMASTER]", Param);
                    int m = (cakeOrderMaster.OrderMasterID == 0) ? Convert.ToInt32(obj) : cakeOrderMaster.OrderMasterID;

                    if (cakeOrderMaster.CustomerName != null || cakeOrderMaster.CustomerId != 0 || cakeOrderMaster.Phone != "" || cakeOrderMaster.TokenNo != 0)
                    {
                        List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                        Param2.Add(new KeyValuePair<string, object>("@OrderMasterID", m));
                        Param2.Add(new KeyValuePair<string, object>("@CustomerID", cakeOrderMaster.CustomerId));
                        Param2.Add(new KeyValuePair<string, object>("@CustomerName", cakeOrderMaster.CustomerName == null ? "" : cakeOrderMaster.CustomerName));
                        Param2.Add(new KeyValuePair<string, object>("@Phone", cakeOrderMaster.Phone == null ? "" : cakeOrderMaster.Phone));
                        Param2.Add(new KeyValuePair<string, object>("@TokenNo", cakeOrderMaster.TokenNo));
                        Param2.Add(new KeyValuePair<string, object>("@Address", cakeOrderMaster.Address == null ? "" : cakeOrderMaster.Address));
                        sqlHandler.ExecuteNonQuery("USP_SaveCakeOrderToken", Param2);
                    }

                    int count = 0;

                    foreach (CakeOrderList cakeOrderDetail in cakeOrderDetailList)
                    {
                        //int runningOrder = 0;
                        cakeOrderDetail.OrderMasterId = m;
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@LoopCount", count));
                        Param1.Add(new KeyValuePair<string, object>("@OrderMasterID", m));
                        Param1.Add(new KeyValuePair<string, object>("@ItemId", cakeOrderDetail.ItemId));
                        Param1.Add(new KeyValuePair<string, object>("@ItemName", cakeOrderDetail.ItemName));
                        Param1.Add(new KeyValuePair<string, object>("@Quantity", cakeOrderDetail.Quantity));
                        Param1.Add(new KeyValuePair<string, object>("@Rate", cakeOrderDetail.Rate));
                        Param1.Add(new KeyValuePair<string, object>("@Amount", cakeOrderDetail.Amount));
                        Param1.Add(new KeyValuePair<string, object>("@AddedBy", cakeOrderDetail.AddedBy));
                        Param1.Add(new KeyValuePair<string, object>("@IsUpdated", cakeOrderDetail.IsUpdated));
                        Param1.Add(new KeyValuePair<string, object>("@UpdatedBy", cakeOrderDetail.UpdatedBy));
                        Param1.Add(new KeyValuePair<string, object>("@IsArchived", cakeOrderDetail.IsArchived));
                        Param1.Add(new KeyValuePair<string, object>("@ArchivedBy", cakeOrderDetail.ArchivedBy));
                        Param1.Add(new KeyValuePair<string, object>("@ArchivedOn", DateTime.Now));
                        Param1.Add(new KeyValuePair<string, object>("@SalesType", cakeOrderDetail.SalesType));

                        var obj1 = sqlHandler.ExecuteAsScalar<object>("[USP_RO_SAVECAKEORDERDETAIL]", Param1);
                        int ordid = Convert.ToInt32(obj1);

                        count++;
                        //if (OrderDetailInf.orderExtraItem != null)
                        //{
                        //    foreach (OrderExtraItem ext in OrderDetailInf.orderExtraItem)
                        //    {
                        //        List<KeyValuePair<string, object>> ExtParam = new List<KeyValuePair<string, object>>();
                        //        ExtParam.Add(new KeyValuePair<string, object>("@OrderMasterId", m));
                        //        ExtParam.Add(new KeyValuePair<string, object>("@OrderDetailsID", ordid));
                        //        ExtParam.Add(new KeyValuePair<string, object>("@ItemID", ext.ItemID));
                        //        ExtParam.Add(new KeyValuePair<string, object>("@ExtraItemID", ext.ExtraItemID));
                        //        ExtParam.Add(new KeyValuePair<string, object>("@ExtraItem", ext.ExtraItem));
                        //        ExtParam.Add(new KeyValuePair<string, object>("@Quantity", ext.Quantity));
                        //        ExtParam.Add(new KeyValuePair<string, object>("@ExtraPrice", ext.ExtraPrice));
                        //        sqlHandler.ExecuteNonQuery("[USP_RO_SaveExtraOrderedItems]", ExtParam);
                        //    }
                        //}
                    }
                   
                    ts.Complete();
                    return m ;
                }
                catch (Exception)
                {
                    throw;
                }
            }
        }

        public List<CakeOrderMaster> GetCakeOrders(string lookupName)
        {
            try
            {
                List<CakeOrderMaster> list = new List<CakeOrderMaster>();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@lookupName", lookupName));
                list = sqlHandler.ExecuteAsList<CakeOrderMaster>("[dbo].[USP_GetCakeOrders]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<WholeSaleOrderMaster> GetWholesaleOrders(string lookupName)
        {
            try
            {
                List<WholeSaleOrderMaster> list = new List<WholeSaleOrderMaster>();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@lookupName", lookupName));
                list = sqlHandler.ExecuteAsList<WholeSaleOrderMaster>("[dbo].[USP_GetTradingOrders]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal List<CakeOrderList> getOrderDetailByOrderMasterId(int orderMasterId,string SalesType)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@orderMasterId", orderMasterId));
                Param.Add(new KeyValuePair<string, object>("@SalesType", SalesType));

                List<CakeOrderList> list = new List<CakeOrderList>();
                list = sqlHandler.ExecuteAsList<CakeOrderList>("[USP_RO_getCakeOrderDetailByOrderMaster]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<CustomerBilling> getActiveBILLTERM()
        {
            return sqlHandler.ExecuteAsList<CustomerBilling>("[USP_RO_ActiveBILLTERM]");
        }

        internal List<CakeOrderItems> GetPreviousCakeOrderById(int Id)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@orderMasterId", Id));
                List<CakeOrderItems> list = new List<CakeOrderItems>();
                list = sqlHandler.ExecuteAsList<CakeOrderItems>("[dbo].[GetPreviousCakeOrderById]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal int saveCakeSalesBill(CakeSalesMaster sm, List<CakeSalesDetails> sds, List<CustomerBilling> bt, SalesPayMode spm, Cakeflatorperdiscount flatorperdiscount)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    //save save sales Master 
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@BillNo", sm.BillNo));
                    Param.Add(new KeyValuePair<string, object>("@BillDate", sm.BillDate));
                    Param.Add(new KeyValuePair<string, object>("@OrderMasterId", sm.OrderMasterId));
                    Param.Add(new KeyValuePair<string, object>("@CustomerId", sm.CustomerId));
                    Param.Add(new KeyValuePair<string, object>("@CustomerName", sm.CustomerName));
                    Param.Add(new KeyValuePair<string, object>("@ContactNumber", sm.ContactNumber));
                    Param.Add(new KeyValuePair<string, object>("@PAN", sm.PAN));
                    Param.Add(new KeyValuePair<string, object>("@Address", sm.Address));
                    Param.Add(new KeyValuePair<string, object>("@BasicAmount", sm.BasicAmount));
                    Param.Add(new KeyValuePair<string, object>("@TermAmount", sm.TermAmount));
                    Param.Add(new KeyValuePair<string, object>("@NetAmount", sm.NetAmount));
                    Param.Add(new KeyValuePair<string, object>("@AdvancePayment", sm.AdvancePayment));
                    Param.Add(new KeyValuePair<string, object>("@Reasons", sm.Reasons));
                    Param.Add(new KeyValuePair<string, object>("@NepaliInvoiceDate", sm.NepaliInvoiceDate));
                    Param.Add(new KeyValuePair<string, object>("@AddedBy", sm.AddedBy));
                    Param.Add(new KeyValuePair<string, object>("@SalesType", sm.SalesType));
                    Param.Add(new KeyValuePair<string, object>("@TenderAmount", spm.TenderAmount));
                    Param.Add(new KeyValuePair<string, object>("@ReturnAmount", spm.ReturnAmount));

                    //List<OrderDetailClass> list = new List<OrderDetailClass>();
                    var a = sqlHandler.ExecuteAsScalar<object>("[USP_RO_CAKE_SAVESALESMASTER]", Param);
                    int salesMasterId = Convert.ToInt32(a);

                    //save save sales details 
                    foreach (CakeSalesDetails sd in sds)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                        Param1.Add(new KeyValuePair<string, object>("@ItemId", sd.ItemId));
                        Param1.Add(new KeyValuePair<string, object>("@ItemName", sd.ItemName));
                        Param1.Add(new KeyValuePair<string, object>("@Quantity", sd.Quantity));
                        Param1.Add(new KeyValuePair<string, object>("@Rate", sd.Rate));
                        Param1.Add(new KeyValuePair<string, object>("@Amount", sd.Amount));
                        Param1.Add(new KeyValuePair<string, object>("@NetAmount", sd.NetAmount));
                        Param1.Add(new KeyValuePair<string, object>("@CostCenterId", sd.CostCenterId));
                        Param1.Add(new KeyValuePair<string, object>("@SalesType", sm.SalesType));
                        var si = sqlHandler.ExecuteAsScalar<object>("[USP_RO_CAKE_SAVESALESDETAIL]", Param1);
                        int salesdetailId = Convert.ToInt32(si);
                    }

                    //save billing term 
                    foreach (CustomerBilling term in bt)
                    {
                        List<KeyValuePair<string, object>> ParamBill2 = new List<KeyValuePair<string, object>>();
                        ParamBill2.Add(new KeyValuePair<string, object>("@SaleMasterID", salesMasterId));
                        ParamBill2.Add(new KeyValuePair<string, object>("@amount", term.Amount));
                        ParamBill2.Add(new KeyValuePair<string, object>("@BillingID", term.ID));
                        ParamBill2.Add(new KeyValuePair<string, object>("@IsVoid", term.IsAdd));
                        ParamBill2.Add(new KeyValuePair<string, object>("@rate", term.Rate));
                        ParamBill2.Add(new KeyValuePair<string, object>("@SalesType", sm.SalesType));
                        var billTermList = sqlHandler.ExecuteAsList<CustomerBilling>("[USP_RO_CAKE_SaveBILLTERM]", ParamBill2);
                    }

                    ////save salespaymode 
                    List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                    Param3.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                    Param3.Add(new KeyValuePair<string, object>("@SPMID", spm.SPMID));
                    Param3.Add(new KeyValuePair<string, object>("@ChequeNo", spm.ChequeNo));
                    Param3.Add(new KeyValuePair<string, object>("@TransactionNo", spm.TransactionNo));
                    Param3.Add(new KeyValuePair<string, object>("@ProviderID", spm.ProviderID));
                    Param3.Add(new KeyValuePair<string, object>("@CusID", spm.CusID));
                    Param3.Add(new KeyValuePair<string, object>("@Customer", spm.Customer));
                    Param3.Add(new KeyValuePair<string, object>("@Address", spm.Address));
                    Param3.Add(new KeyValuePair<string, object>("@PAN", spm.PAN));
                    Param3.Add(new KeyValuePair<string, object>("@PayAmount", spm.PayAmount));
                    Param3.Add(new KeyValuePair<string, object>("@TenderAmount", spm.TenderAmount));
                    Param3.Add(new KeyValuePair<string, object>("@ReturnAmount", spm.ReturnAmount));
                    Param3.Add(new KeyValuePair<string, object>("@Remarks", spm.Remarks));
                    Param3.Add(new KeyValuePair<string, object>("@ReturnPayment", spm.ReturnPayment));
                    Param3.Add(new KeyValuePair<string, object>("@SalesType", sm.SalesType));
                    if (Convert.ToInt32(spm.SPMID) == 4)
                    {
                        RestoLoyaltyController dpobj = new RestoLoyaltyController();
                        MemberInfo meminfo = new MemberInfo();
                        meminfo.MembershipID = Convert.ToInt32(spm.CusID);
                        meminfo.RemainingBalance = spm.PayAmount;
                        meminfo.PayAmount = 0;
                        meminfo.AddedBy = "";
                        meminfo.GoodReceivedMainId = 0;
                        dpobj.SaveCustomerAmount(meminfo);
                    }

                    //List<OrderDetailClass> list = new List<OrderDetailClass>();
                    a = sqlHandler.ExecuteAsScalar<object>("[usp_ro_Cake_UpdateSalesPayMode]", Param3);
                    //salesMasterId = Convert.ToInt32(a);

                    //save save sales Discount details 

                    List<KeyValuePair<string, object>> Param4 = new List<KeyValuePair<string, object>>();
                    Param4.Add(new KeyValuePair<string, object>("@SalesMasterId", salesMasterId));
                    Param4.Add(new KeyValuePair<string, object>("@DiscountValue", flatorperdiscount.DiscountValue));
                    Param4.Add(new KeyValuePair<string, object>("@IsFlatDis", flatorperdiscount.IsFlatDis));
                    Param4.Add(new KeyValuePair<string, object>("@TotalDiscount", flatorperdiscount.TotalDiscount));
                    Param4.Add(new KeyValuePair<string, object>("@BasicAmount", flatorperdiscount.BasicAmount));
                    Param4.Add(new KeyValuePair<string, object>("@SalesType", sm.SalesType));

                    sqlHandler.ExecuteNonQuery("[usp_ro_Cake_DiscountDetails]", Param4);
                    ts.Complete();
                    return salesMasterId;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        internal void UpdateSalesPayMode(SalesPayMode spm)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@salesMasterId", spm.salesMasterId));
                Param.Add(new KeyValuePair<string, object>("@SPMID", Convert.ToInt32(spm.SPMID)));
                Param.Add(new KeyValuePair<string, object>("@ChequeNo", spm.ChequeNo));
                Param.Add(new KeyValuePair<string, object>("@TransactionNo", spm.TransactionNo));
                Param.Add(new KeyValuePair<string, object>("@ProviderID", (spm.ProviderID == "" ? 0 : Convert.ToInt32(spm.ProviderID))));
                Param.Add(new KeyValuePair<string, object>("@CusID", (spm.CusID == "" ? 0 : Convert.ToInt32(spm.CusID))));
                Param.Add(new KeyValuePair<string, object>("@Customer", spm.Customer));
                Param.Add(new KeyValuePair<string, object>("@Address", spm.Address));
                Param.Add(new KeyValuePair<string, object>("@PAN", spm.PAN));
                Param.Add(new KeyValuePair<string, object>("@PayAmount", Convert.ToInt32(spm.SPMID) == 1 ? spm.TenderAmount - spm.ReturnAmount : spm.PayAmount));
                Param.Add(new KeyValuePair<string, object>("@TenderAmount", spm.TenderAmount));
                Param.Add(new KeyValuePair<string, object>("@ReturnAmount", spm.ReturnAmount));
                Param.Add(new KeyValuePair<string, object>("@Remarks", spm.Remarks));
                Param.Add(new KeyValuePair<string, object>("@ReturnPayment", spm.ReturnPayment));
                Param.Add(new KeyValuePair<string, object>("@SalesType", spm.SalesType));

                sqlHandler.ExecuteNonQuery("[usp_ro_Cake_UpdateSalesPayMode]", Param);

                List<KeyValuePair<string, object>> param2 = new List<KeyValuePair<string, object>>();
                param2.Add(new KeyValuePair<string, object>("@SalesMasterID", spm.salesMasterId));
                param2.Add(new KeyValuePair<string, object>("@SalesType", spm.SalesType));
                sqlHandler.ExecuteNonQuery("Usp_ro_UpdateCustomerBalance", param2);

                List<KeyValuePair<string, object>> param5 = new List<KeyValuePair<string, object>>();
                param5.Add(new KeyValuePair<string, object>("@SalesMasterID", spm.salesMasterId));
                sqlHandler.ExecuteNonQuery("usp_SaveTransactionForSales", param5);
                ts.Complete();
            }
        }

        internal void CancelOrder(CakeOrderMaster orderMaster)
        {
            //List<OrderMasterClass> orderMasterList = GetAllOrder();
            ////OrderMasterClass orderMasterInfo = new OrderMasterClass();
            //foreach(OrderMasterClass orderMasterInf in orderMasterList)
            //{
            //    if(orderMasterInf.OrderMasterID == orderMaster.OrderMasterID)
            //    {
            //        orderMaster = orderMasterInf;
            //        break;
            //    }
            //}
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@OrderMasterID", orderMaster.OrderMasterID));
           // Param.Add(new KeyValuePair<string, object>("@IsCancelled", orderMaster.IsCancelled));
           // Param.Add(new KeyValuePair<string, object>("@TableId", orderMaster.TableId));
            Param.Add(new KeyValuePair<string, object>("@CancelReason", orderMaster.CancelReason));
           // Param.Add(new KeyValuePair<string, object>("@CancelBy", orderMaster.CancelBy));
           // Param.Add(new KeyValuePair<string, object>("@SeatNo", orderMaster.GuestNo));
            sqlHandler.ExecuteNonQuery("[USP_CAKEORDERCANCEL]", Param);
        }
        internal List<CakeOrderList> GetOrderDetailsByMaster(int orderMasterId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@OrderMasterId", orderMasterId));
            List<CakeOrderList> OrderDetailList = sqlHandler.ExecuteAsList<CakeOrderList>("[USP_RO_GETORDERDETAIL]", Param);
            return OrderDetailList;
        }
        internal List<OrderExtraItems> GetOrderedExtraItemByOrderMaster(int orderMasterID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OrderMasterId", orderMasterID));
                return sqlHandler.ExecuteAsList<OrderExtraItems>("[usp_ro_GetOrderedExtraItemByOrderMaster]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void SaveExtraOrderedItem(List<OrderExtraItems> addedExtra, List<OrderExtraItems> removedExtra)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    if (removedExtra.Count > 0)
                    {
                        foreach (OrderExtraItems ext in removedExtra)
                        {
                            List<KeyValuePair<string, object>> RemParam = new List<KeyValuePair<string, object>>();
                            RemParam.Add(new KeyValuePair<string, object>("@OrderMasterId", ext.OrderMasterId));
                            RemParam.Add(new KeyValuePair<string, object>("@ItemID", ext.ItemID));
                            RemParam.Add(new KeyValuePair<string, object>("@ExtraItemID", ext.ExtraItemID));
                            RemParam.Add(new KeyValuePair<string, object>("@ExtraItem", ext.ExtraItem));
                            RemParam.Add(new KeyValuePair<string, object>("@Quantity", ext.Quantity));
                            RemParam.Add(new KeyValuePair<string, object>("@ExtraPrice", ext.ExtraPrice));
                            RemParam.Add(new KeyValuePair<string, object>("@SeatNo", ext.SeatNo));
                            sqlHandler.ExecuteNonQuery("[USP_RO_RemoveExtraOrderedItems]", RemParam);
                        }
                    }
                    if (addedExtra.Count > 0)
                    {
                        foreach (OrderExtraItems ext in addedExtra)
                        {
                            List<KeyValuePair<string, object>> AddParam = new List<KeyValuePair<string, object>>();
                            AddParam.Add(new KeyValuePair<string, object>("@OrderMasterId", ext.OrderMasterId));
                            AddParam.Add(new KeyValuePair<string, object>("@ItemID", ext.ItemID));
                            AddParam.Add(new KeyValuePair<string, object>("@ExtraItemID", ext.ExtraItemID));
                            AddParam.Add(new KeyValuePair<string, object>("@ExtraItem", ext.ExtraItem));
                            AddParam.Add(new KeyValuePair<string, object>("@Quantity", ext.Quantity));
                            AddParam.Add(new KeyValuePair<string, object>("@ExtraPrice", ext.ExtraPrice));
                            AddParam.Add(new KeyValuePair<string, object>("@SeatNo", ext.SeatNo));
                            sqlHandler.ExecuteNonQuery("[USP_RO_SaveExtraOrderedItems]", AddParam);
                        }
                    }
                }
                catch (Exception)
                {
                    throw;
                }
                ts.Complete();
            }
        }
        public Tokens getOrderNobyOrderMasterId(int orderMasterId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@orderMasterId", orderMasterId));
                return sqlHandler.ExecuteAsObject<Tokens>("[USP_getcakeordernobyOrdermasterId]", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
