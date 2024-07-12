using SageFrame.Web.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using SageFrame.CostCenter;
using SageFrame.RestoLoyalty;
using SageFrame.FiscalYear;
using SageFrame.Security.Entities;
using System.Data;

namespace SageFrame.RestroOrder
{
    public class RestrOrderProvider
    {
        private SQLHandler sqlHandler;
        public RestrOrderProvider()
        {
            sqlHandler = new SQLHandler();
        }
        #region cbms
        internal int savePostedBill(BillViewModel bill, string statusCode, string status, DateTime postedDate, int salesMasterId, string englishInvDate)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@seller_pan", bill.seller_pan));
                Param.Add(new KeyValuePair<string, object>("@buyer_pan", bill.buyer_pan));
                Param.Add(new KeyValuePair<string, object>("@buyer_name", bill.buyer_name));
                Param.Add(new KeyValuePair<string, object>("@fiscal_year", bill.fiscal_year));
                Param.Add(new KeyValuePair<string, object>("@invoice_number", bill.invoice_number));
                Param.Add(new KeyValuePair<string, object>("@invoice_date", bill.invoice_date));
                Param.Add(new KeyValuePair<string, object>("@total_sales", bill.total_sales));
                Param.Add(new KeyValuePair<string, object>("@taxable_sales_vat", bill.taxable_sales_vat));
                Param.Add(new KeyValuePair<string, object>("@vat", bill.vat));
                Param.Add(new KeyValuePair<string, object>("@excisable_amount", bill.excisable_amount));
                Param.Add(new KeyValuePair<string, object>("@excise", bill.excise));
                Param.Add(new KeyValuePair<string, object>("@taxable_sales_hst", bill.taxable_sales_hst));
                Param.Add(new KeyValuePair<string, object>("@hst", bill.hst));
                Param.Add(new KeyValuePair<string, object>("@amount_for_esf", bill.amount_for_esf));
                Param.Add(new KeyValuePair<string, object>("@esf", bill.esf));
                Param.Add(new KeyValuePair<string, object>("@export_sales", bill.export_sales));
                Param.Add(new KeyValuePair<string, object>("@tax_exempted_sales", bill.tax_exempted_sales));
                Param.Add(new KeyValuePair<string, object>("@isrealtime", bill.isrealtime));
                Param.Add(new KeyValuePair<string, object>("@datetimeClient", bill.datetimeClient));
                Param.Add(new KeyValuePair<string, object>("@statusCode", statusCode));
                Param.Add(new KeyValuePair<string, object>("@status", status));
                Param.Add(new KeyValuePair<string, object>("@postedDate", postedDate));
                Param.Add(new KeyValuePair<string, object>("@salesMasterID ", salesMasterId));
                Param.Add(new KeyValuePair<string, object>("@EnglishInvDate ", englishInvDate));
                var logId = sqlHandler.ExecuteAsScalar<object>("[USP_cbms_SaveBillPostLog]", Param);
                return Convert.ToInt32(logId);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<BillPostLog> getErrorBillPostLog()
        {
            try
            {
                return sqlHandler.ExecuteAsList<BillPostLog>("USP_cbms_getErrorBillPostLog");
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void updatePostedBill(int logId, string statusCode, string status, DateTime postedDate, int salesMasterId, bool isRealTime)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@logId", logId));
                Param.Add(new KeyValuePair<string, object>("@statusCode", statusCode));
                Param.Add(new KeyValuePair<string, object>("@status", status));
                Param.Add(new KeyValuePair<string, object>("@postedDate", postedDate));
                Param.Add(new KeyValuePair<string, object>("@salesMasterID ", salesMasterId));
                Param.Add(new KeyValuePair<string, object>("@isRealTime ", isRealTime));
                sqlHandler.ExecuteNonQuery("[USP_cbms_updatePostedBillLog]", Param);
            }
            catch (Exception Ex)
            {
                throw;
            }
        }
        internal CbmsData getCbmsData()
        {
            return sqlHandler.ExecuteAsObject<CbmsData>("[USP_cbms_getCbmsData]");
        }
        internal List<CbmsSyncedData> getCbmsSyncedData(int days)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@days ", days));
            return sqlHandler.ExecuteAsList<CbmsSyncedData>("[USP_cbms_getCbmsSyncedData]", Param);
        }
        internal List<BillPostLog> GetSalesBook(string fromDate, string toDate)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@FromDate", fromDate));
                Param.Add(new KeyValuePair<string, object>("@ToDate", toDate));
                return sqlHandler.ExecuteAsList<BillPostLog>("usp_ro_GetSalesBook", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ReturnBillPostLog> GetReturnedSalesBook(string fromDate, string toDate)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@FromDate", fromDate));
                Param.Add(new KeyValuePair<string, object>("@ToDate", toDate));
                return sqlHandler.ExecuteAsList<ReturnBillPostLog>("usp_ro_GetReturnedSalesBook", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal BillPostLog GetPostedBillBySalesMasterId(int salesMasterId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                return sqlHandler.ExecuteAsObject<BillPostLog>("usp_cbms_GetPostedBillBySalesMasterId", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal void CancelSalesBook(int salesMasterId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                sqlHandler.ExecuteNonQuery("usp_cbms_CancelSalesBook", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal ReturnBillPostLog saveReturnedBill(BillReturnViewModel billreturn, string statusCode, string status, DateTime postedDate, int salesMasterId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@seller_pan", billreturn.seller_pan));
                Param.Add(new KeyValuePair<string, object>("@buyer_pan", billreturn.buyer_pan));
                Param.Add(new KeyValuePair<string, object>("@buyer_name", billreturn.buyer_name));
                Param.Add(new KeyValuePair<string, object>("@fiscal_year", billreturn.fiscal_year));
                Param.Add(new KeyValuePair<string, object>("@ref_invoice_number", billreturn.ref_invoice_number));
                Param.Add(new KeyValuePair<string, object>("@credit_note_date", billreturn.credit_note_date));
                Param.Add(new KeyValuePair<string, object>("@reason_for_return", billreturn.reason_for_return));
                Param.Add(new KeyValuePair<string, object>("@total_sales", billreturn.total_sales));
                Param.Add(new KeyValuePair<string, object>("@taxable_sales_vat", billreturn.taxable_sales_vat));
                Param.Add(new KeyValuePair<string, object>("@vat", billreturn.vat));
                Param.Add(new KeyValuePair<string, object>("@excisable_amount", billreturn.excisable_amount));
                Param.Add(new KeyValuePair<string, object>("@excise", billreturn.excise));
                Param.Add(new KeyValuePair<string, object>("@taxable_sales_hst", billreturn.taxable_sales_hst));
                Param.Add(new KeyValuePair<string, object>("@hst", billreturn.hst));
                Param.Add(new KeyValuePair<string, object>("@amount_for_esf", billreturn.amount_for_esf));
                Param.Add(new KeyValuePair<string, object>("@esf", billreturn.esf));
                Param.Add(new KeyValuePair<string, object>("@export_sales", billreturn.export_sales));
                Param.Add(new KeyValuePair<string, object>("@tax_exempted_sales", billreturn.tax_exempted_sales));
                Param.Add(new KeyValuePair<string, object>("@isrealtime", billreturn.isrealtime));
                Param.Add(new KeyValuePair<string, object>("@datetimeClient", billreturn.datetimeClient));
                Param.Add(new KeyValuePair<string, object>("@statusCode", statusCode));
                Param.Add(new KeyValuePair<string, object>("@status", status));
                Param.Add(new KeyValuePair<string, object>("@postedDate", postedDate));
                Param.Add(new KeyValuePair<string, object>("@salesMasterID ", salesMasterId));
                return sqlHandler.ExecuteAsObject<ReturnBillPostLog>("[USP_cbms_SaveReturnBillPostLog]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ReturnBillPostLog> getErrorReturnBillPostLog()
        {
            try
            {
                return sqlHandler.ExecuteAsList<ReturnBillPostLog>("USP_cbms_getReturnErrorBillPostLog");
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void updateReturnedBill(int logId, string statusCode, string status, DateTime postedDate, int salesMasterId, bool isRealTime)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@returnLogId", logId));
                Param.Add(new KeyValuePair<string, object>("@statusCode", statusCode));
                Param.Add(new KeyValuePair<string, object>("@status", status));
                Param.Add(new KeyValuePair<string, object>("@postedDate", postedDate));
                Param.Add(new KeyValuePair<string, object>("@salesMasterID ", salesMasterId));
                Param.Add(new KeyValuePair<string, object>("@isRealTime ", isRealTime));
                sqlHandler.ExecuteNonQuery("[USP_cbms_updateReturnedBill]", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
        #region GetJsonClass
        internal List<ROGETITEMResulttest> GetItemJsonFromDatabase()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                //bring menu group
                RestrOrderProvider rop = new RestrOrderProvider();
                CostCenterController ccp = new CostCenterController();
                List<MenuClass> menuList = RestrOrderProvider.GetMenuFromDatabase();
                List<ROGETITEMResulttest> itemListUpdated = new List<ROGETITEMResulttest>();
                ROGETITEMResulttest getJson = new ROGETITEMResulttest();
                foreach (MenuClass menu in menuList)
                {
                    List<CategoriesClass> catList = RestrOrderProvider.GetCategoriesFromDatabase(menu.MenuID);
                    List<CategoriesClass> catquery = new List<CategoriesClass>();
                    menu.categoryList = catList;
                    foreach (CategoriesClass cat in catList)
                    {
                        List<ItemsClass> itemList = RestrOrderProvider.GetItemFromDatabase(cat.CategoriesID);
                        cat.itemList = itemList;
                        foreach (ItemsClass item in itemList)
                        {
                            List<UnitClass> unitList = RestrOrderProvider.GetUnitFromDatabase(item.UnitID);
                            item.unitList = unitList;
                            List<companyInfo> comp = rop.getCompanyInfo();
                            CurrencyClass currency = rop.getCurrencyByID(comp[0].CurrencyID);
                            item.PriceWithIcon = currency.CurrencyIcon + " " + item.Price;
                            CostCenterInfo costCenter = ccp.GetCostCenterById(item.CostCenterId);
                            item.CostCenterName = costCenter.CostCenterName;
                        }
                    }
                    getJson.MenuList = menuList;
                }
                itemListUpdated.Add(getJson);
                return itemListUpdated;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal ROInvItem GetItemDetail(int itemID, bool isCombo)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@itemID", itemID));
                Param.Add(new KeyValuePair<string, object>("@isCombo", isCombo));
                ROInvItem Iteminfo = sqlHandler.ExecuteAsObject<ROInvItem>("[USP_RO_GETITEMDetail]", Param);
                return Iteminfo;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal static List<OrderMasterClass> GetAllOrder(int billPayed, bool isCancel, string tableID)
        {
            SQLHandler sqlHandler = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@BillPayed", billPayed));
            Param.Add(new KeyValuePair<string, object>("@IsCancel", isCancel));
            Param.Add(new KeyValuePair<string, object>("@TableID", tableID));
            List<OrderMasterClass> orderMasterinfo = sqlHandler.ExecuteAsList<OrderMasterClass>("[USP_RO_GETTableORDER]", Param);
            return orderMasterinfo;
        }
        private static List<UnitClass> GetUnitFromDatabase(int unitID)
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@unitID", unitID));
                List<UnitClass> Unitinfo = sqlHandler.ExecuteAsList<UnitClass>("[USP_RO_GETUNITBYITEM]", Param);
                return Unitinfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        private static List<ItemsClass> GetItemFromDatabase(int catID)
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@catID", catID));
                List<ItemsClass> Iteminfo = sqlHandler.ExecuteAsList<ItemsClass>("[USP_RO_GETITEMBYCATEGORY]", Param);
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        private static List<CategoriesClass> GetCategoriesFromDatabase(int MenuID)
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@MenuID", MenuID));
                List<CategoriesClass> Categoriesinfo = sqlHandler.ExecuteAsList<CategoriesClass>("[USP_RO_GETCATEGORIESBYMENU]", Param);
                return Categoriesinfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        #endregion
        #region Restro Room and Table
        internal List<RestroRoom> GetRoomWithTable()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                //bring menu group
                RestrOrderProvider rop = new RestrOrderProvider();
                List<RestroRoom> roomList = rop.getrestroRoom();
                List<RestroRoom> roomListUpdated = new List<RestroRoom>();
                RestroRoom getJson = new RestroRoom();
                foreach (RestroRoom room in roomList)
                {
                    //adding table in room list
                    List<restroTable> tableList = RestrOrderProvider.GetTableByRoomId(room.restroRoomId);
                    List<restroTable> tablequery = new List<restroTable>();
                    room.tableList = tableList;
                    getJson.tableList = tableList;
                }
                roomListUpdated.Add(getJson);
                return roomListUpdated;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void SaveDBLog(string operation, string destinationPath, string UserName)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@Operation", operation));
                Param.Add(new KeyValuePair<string, object>("@FilePath", destinationPath));
                Param.Add(new KeyValuePair<string, object>("@UserName", UserName));
                sqlHandler.ExecuteNonQuery("[usp_SaveDBLog]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public static List<restroTable> GetTableByRoomId(int RoomID)
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RoomID", RoomID));
                List<restroTable> tableInfo = sqlHandler.ExecuteAsList<restroTable>("[USP_RO_GETTABLEBYROOM]", Param);
                return tableInfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        public void SaveMergeTableList(List<MergeTableInfo> mergeTableList, string[] occupiedTableIds)
        {
            foreach (MergeTableInfo mergeTable in mergeTableList)
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@TableID", mergeTable.TableID));
                Param.Add(new KeyValuePair<string, object>("@MergeTableList", mergeTable.MergeTableList));
                sqlHandler.ExecuteNonQuery("[USP_RO_SAVEMERGE]", Param);
            }
            if (occupiedTableIds.Length > 1)
            {
                string tableIds = string.Join(",", occupiedTableIds);
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OccupiedTableIds", tableIds));
                Param.Add(new KeyValuePair<string, object>("@MergeTableList", mergeTableList[0].MergeTableList));
                sqlHandler.ExecuteNonQuery("[USP_RO_Merge_Occupied_Orders]", Param);
            }
        }
        #endregion
        #region Unit
        internal void UnitSaveTodatabase(UnitClass UnitInf)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@UnitID", UnitInf.UnitID));
                Param.Add(new KeyValuePair<string, object>("@UnitName", UnitInf.UnitName));
                sqlHandler.ExecuteNonQuery("[USP_RO_UNITSAVE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal static List<Unit> GetUnitFromDatabase()
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<Unit> Unitinfo = sqlHandler.ExecuteAsList<Unit>("[USP_RO_GETUNIT]");
                return Unitinfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void UnitDelete(int UnitID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@UnitID", UnitID));
                sqlHandler.ExecuteNonQuery("[USP_RO_UNITDELETE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        #endregion
        #region Menu
        internal void MenuSaveTodatabase(MenuClass MenuInf)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@MenuID", MenuInf.MenuID));
                Param.Add(new KeyValuePair<string, object>("@MenuName", MenuInf.MenuName));
                Param.Add(new KeyValuePair<string, object>("@PhotoPath", MenuInf.PhotoPath));
                sqlHandler.ExecuteNonQuery("[USP_RO_MENUSAVE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        //internal static List<MenuClass> GetMenuFromDatabase()
        //{
        //    try
        //    {
        //        List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
        //        
        //        List<MenuClass> Menuinfo = sqlHandler.ExecuteAsList<MenuClass>("[USP_RO_GETMENU]");
        //        return Menuinfo;
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
        internal void MenuDelete(int MenuID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@MenuID", MenuID));
                sqlHandler.ExecuteNonQuery("[USP_RO_MENUDELETE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        #endregion
        #region ItemsClass
        internal void ItemSaveTodatabase(ItemsClass ItemInf)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ItemID", ItemInf.ItemID));
                Param.Add(new KeyValuePair<string, object>("@ItemName", ItemInf.ItemName));
                Param.Add(new KeyValuePair<string, object>("@ItemDescription", ItemInf.ItemDescription));
                Param.Add(new KeyValuePair<string, object>("@PhotoPath", ItemInf.PhotoPath));
                Param.Add(new KeyValuePair<string, object>("@Price", ItemInf.Price));
                Param.Add(new KeyValuePair<string, object>("@ItemCode", ItemInf.ItemCode));
                Param.Add(new KeyValuePair<string, object>("@UnitID", ItemInf.UnitID));
                Param.Add(new KeyValuePair<string, object>("@CategoriesID", ItemInf.CategoriesID));
                Param.Add(new KeyValuePair<string, object>("@CostCenterID", ItemInf.CostCenterId));
                sqlHandler.ExecuteNonQuery("[USP_RO_ITEMSAVE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal static List<ItemsClass> GetItemFromDatabase()
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<ItemsClass> Iteminfo = sqlHandler.ExecuteAsList<ItemsClass>("[USP_RO_GETITEM]");
                // List<ItemsClass> Iteminfo = sqlHandler.ExecuteAsList<ItemsClass>("USP_RO_GETITEM_NEW");

                return Iteminfo;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #region ItemInvent
        internal static List<ROInvItem> GetInvItemFromDatabase()
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<ROInvItem> Iteminfo = sqlHandler.ExecuteAsList<ROInvItem>("[USP_RO_GETINVITEM]");
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        #endregion
        internal void ItemDelete(int ItemID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ItemID", ItemID));
                sqlHandler.ExecuteNonQuery("[USP_RO_ITEMDELETE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ActivityLog> GetActivityLog(DateTime startDate, DateTime endDate, string user)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@StartDate", startDate));
                Param.Add(new KeyValuePair<string, object>("@EndDate", endDate));
                Param.Add(new KeyValuePair<string, object>("@UserName", user));
                List<ActivityLog> Iteminfo = sqlHandler.ExecuteAsList<ActivityLog>("[usp_GetAuditLog]", Param);
                return Iteminfo;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal List<StockDetail> getStockDetailByItem(StockDetailItem obj)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@StartDate", obj.StartDate));
                Param.Add(new KeyValuePair<string, object>("@EndDate", obj.EndDate));
                Param.Add(new KeyValuePair<string, object>("@ItemId", obj.ItemId));
                Param.Add(new KeyValuePair<string, object>("@StoreId", obj.StoreId));
                List<StockDetail> Iteminfo = sqlHandler.ExecuteAsList<StockDetail>("[USP_GetStockTransactionDetail]", Param);
                return Iteminfo;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



        internal void shiftTable(int fromordermasterid, int totableID, int fromSeatNo, int toSeatNo, string shiftedby)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@FromOrderMasterId", fromordermasterid));
                Param.Add(new KeyValuePair<string, object>("@ToTableID", totableID));
                Param.Add(new KeyValuePair<string, object>("@fromSeatNo", fromSeatNo));
                Param.Add(new KeyValuePair<string, object>("@toSeatNo", toSeatNo));
                Param.Add(new KeyValuePair<string, object>("@shiftedBy", shiftedby));
                sqlHandler.ExecuteNonQuery("[USP_RO_ShiftTable]", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal List<restroTable> Gettabledataforshift()
        {
            try
            {
                return sqlHandler.ExecuteAsList<restroTable>("USP_RO_Gettabledataforshift");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion
        #region Currency
        internal void CurrencySaveTodatabase(CurrencyClass CurrencyInf)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CurrencyID", CurrencyInf.CurrencyID));
            Param.Add(new KeyValuePair<string, object>("@CurrencyName", CurrencyInf.CurrencyName));
            Param.Add(new KeyValuePair<string, object>("@SubCurrencyName", CurrencyInf.SubCurrencyName));
            Param.Add(new KeyValuePair<string, object>("@CurrencyIcon", CurrencyInf.CurrencyIcon));
            sqlHandler.ExecuteNonQuery("[USP_RO_CURRENCYSAVE]", Param);
        }
        internal static List<CurrencyClass> GetCurrencyFromDatabase()
        {
            SQLHandler sqlHandler = new SQLHandler();
            return sqlHandler.ExecuteAsList<CurrencyClass>("USP_RO_GETCURRENCY");
        }
        internal void CurrencyDelete(int ID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CurrencyID", ID));
            sqlHandler.ExecuteAsList<CurrencyClass>("[USP_RO_CURRENCYDELETE]", Param);
        }
        public CurrencyClass getCurrencyByID(int CurrencyID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CurrencyID", CurrencyID));
            return sqlHandler.ExecuteAsObject<CurrencyClass>("[USP_RO_GETCURRENCYBYID]", Param);
        }
        #endregion
        #region CategoriessClass
        internal void CategoriesSaveTodatabase(CategoriesClass CategoriesInf)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@CategoriesID", CategoriesInf.CategoriesID));
                Param.Add(new KeyValuePair<string, object>("@CategoriesName", CategoriesInf.CategoriesName));
                Param.Add(new KeyValuePair<string, object>("@MenuID", CategoriesInf.MenuID));
                Param.Add(new KeyValuePair<string, object>("@PhotoPath", CategoriesInf.PhotoPath));
                sqlHandler.ExecuteNonQuery("[USP_RO_CATEGORIESSAVE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal static List<CategoriesClass> GetCategoriesFromDatabase()
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<CategoriesClass> Categoriesinfo = sqlHandler.ExecuteAsList<CategoriesClass>("[USP_RO_GETCATEGORIES]");
                return Categoriesinfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void CategoriesDelete(int CategoriesID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@CategoriesID", CategoriesID));
                sqlHandler.ExecuteNonQuery("[USP_RO_CATEGORIESDELETE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        #endregion
        #region Account Section
        #region Enum
        internal void EnumSaveTodatabase(EnumClass EnumInf)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@EnumID", EnumInf.EnumId));
            Param.Add(new KeyValuePair<string, object>("@CValue", EnumInf.CValue));
            Param.Add(new KeyValuePair<string, object>("@Type", EnumInf.Type));
            Param.Add(new KeyValuePair<string, object>("@Order", EnumInf.Order));
            sqlHandler.ExecuteNonQuery("[USP_RO_ENUMSAVE]", Param);
        }
        internal static List<EnumClass> GetEnumFromDatabase()
        {
            SQLHandler sqlHandler = new SQLHandler();
            return sqlHandler.ExecuteAsList<EnumClass>("USP_RO_GETENUM");
        }
        internal void EnumDelete(int ID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@EnumID", ID));
            sqlHandler.ExecuteAsList<EnumClass>("[USP_RO_ENUMDELETE]", Param);
        }
        public EnumClass getEnumByID(int EnumID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@EnumID", EnumID));
            return sqlHandler.ExecuteAsObject<EnumClass>("[USP_RO_GETENUMBYID]", Param);
        }
        #endregion
        #region AccountGroup
        internal void AccountGroupSaveTodatabase(modalAccountGroup AccountGroupInf)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@AccountId", AccountGroupInf.AccountGroupID));
                Param.Add(new KeyValuePair<string, object>("@AccountCode", AccountGroupInf.AccountCode));
                Param.Add(new KeyValuePair<string, object>("@AccountName", AccountGroupInf.AccountName));
                Param.Add(new KeyValuePair<string, object>("@Schedule", AccountGroupInf.Schedule));
                Param.Add(new KeyValuePair<string, object>("@Type", AccountGroupInf.Type));
                Param.Add(new KeyValuePair<string, object>("@LastUpdateDate", DateTime.Now));
                Param.Add(new KeyValuePair<string, object>("@CreateDate", DateTime.Now));
                sqlHandler.ExecuteNonQuery("[USP_RO_ACCOUNTGROUPSAVE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal static List<modalAccountGroup> GetAccountGroupfromDatabase()
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<modalAccountGroup> AccountGroupinfo = sqlHandler.ExecuteAsList<modalAccountGroup>("[USP_RO_GETACCOUNTGROUP]");
                return AccountGroupinfo;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal void AccountGroupDelete(int AccountGroupId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@AccountGroupId", AccountGroupId));
                sqlHandler.ExecuteNonQuery("[USP_RO_ACCOUNTGROUPDELETE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        #endregion AccountGroup
        #region Account SubGroup
        internal void AccountSubGroupSaveTodatabase(modalAccountSubGroup AccountSubGroupInf)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@AccountSubGroupId", AccountSubGroupInf.AccountSubGroupId));
                Param.Add(new KeyValuePair<string, object>("@Code", AccountSubGroupInf.Code));
                Param.Add(new KeyValuePair<string, object>("@Name", AccountSubGroupInf.Name));
                Param.Add(new KeyValuePair<string, object>("@AccountGroupId", AccountSubGroupInf.AccountGroupId));
                Param.Add(new KeyValuePair<string, object>("@CreateDate", DateTime.Now));
                Param.Add(new KeyValuePair<string, object>("@LastUpdateDate", DateTime.Now));
                sqlHandler.ExecuteNonQuery("[USP_RO_ACCOUNTSUBGROUPSAVE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal static List<modalAccountSubGroup> GetAccountSubGroupfromDatabase()
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<modalAccountSubGroup> AccountSubGroupinfo = sqlHandler.ExecuteAsList<modalAccountSubGroup>("[USP_RO_GETACCOUNTSUBGROUP]");
                return AccountSubGroupinfo;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal static modalAccountSubGroup GetAccountSubGroupfromDatabaseById(int Id)
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@AccountSubGroupId", Id));
                modalAccountSubGroup AccountSubGroupinfo = sqlHandler.ExecuteAsObject<modalAccountSubGroup>("[USP_RO_GETACCOUNTSUBGROUPBYID]", Param);
                return AccountSubGroupinfo;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal void AccountSubGroupDelete(int AccountSubGroupId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@AccountSubGroupId", AccountSubGroupId));
                sqlHandler.ExecuteNonQuery("[USP_RO_ACCOUNTSUBGROUPDELETE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        #endregion
        #endregion
        #region Other
        public static List<CategoriesClass> getCategory()
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<CategoriesClass> Menuinfo = sqlHandler.ExecuteAsList<CategoriesClass>("[USP_RO_GETCATEGORIES]");
                return Menuinfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal static List<MenuClass> GetMenuFromDatabase()
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<MenuClass> Menuinfo = sqlHandler.ExecuteAsList<MenuClass>("[USP_RO_GETMENU]");
                return Menuinfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal static List<ClassforMenuItem> GetMenuFromDatabase1(int pitId, int level)
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@pitId", pitId));
                Param.Add(new KeyValuePair<string, object>("@level", level));
                List<ClassforMenuItem> Menuinfo = sqlHandler.ExecuteAsList<ClassforMenuItem>("[dbo].[USP_RO_getItemForApi2]", Param);
                return Menuinfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        //
        internal void OrderMasterSaveTodatabase(OrderMasterClass OrderMasterInf)
        {
            try
            {
                DeleteOrderDetailsByMaster(OrderMasterInf.OrderMasterID, OrderMasterInf.UserName);
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OrderMasterID", OrderMasterInf.OrderMasterID));
                Param.Add(new KeyValuePair<string, object>("@TableId", OrderMasterInf.TableId));
                Param.Add(new KeyValuePair<string, object>("@BasicAmount", OrderMasterInf.BasicAmount));
                Param.Add(new KeyValuePair<string, object>("@BillNo", OrderMasterInf.BillNo));
                Param.Add(new KeyValuePair<string, object>("@Date", DateTime.Now));
                Param.Add(new KeyValuePair<string, object>("@IsCancelled", OrderMasterInf.IsCancelled));
                Param.Add(new KeyValuePair<string, object>("@TermAmount", OrderMasterInf.TermAmount));
                Param.Add(new KeyValuePair<string, object>("@NetAmount", OrderMasterInf.NetAmount));
                Param.Add(new KeyValuePair<string, object>("@UserName", OrderMasterInf.UserName));
                Param.Add(new KeyValuePair<string, object>("@Remarks", OrderMasterInf.Remarks));
                Param.Add(new KeyValuePair<string, object>("@IsSplit", OrderMasterInf.IsSplit));
                Param.Add(new KeyValuePair<string, object>("@GuestNo", OrderMasterInf.GuestNo));
                Param.Add(new KeyValuePair<string, object>("@BillPaid", OrderMasterInf.BillPaid));
                Param.Add(new KeyValuePair<string, object>("@RoomId", OrderMasterInf.RoomId));
                Param.Add(new KeyValuePair<string, object>("@OID", OrderMasterInf.OID));
                Param.Add(new KeyValuePair<string, object>("@OrderTypeID", OrderMasterInf.OrderTypeID.ToString() == null ? 0 : OrderMasterInf.OrderTypeID));
                var obj = sqlHandler.ExecuteAsScalar<object>("[USP_PO_SAVEPURCHASEMASTER]", Param);
                int m = (OrderMasterInf.OrderMasterID == 0) ? Convert.ToInt32(obj) : OrderMasterInf.OrderMasterID;
                Dictionary<string, int> dictionary = new Dictionary<string, int>();
                dictionary.Add("noone", 0);
                if (OrderMasterInf.OrderDetailsList != null)
                {
                    foreach (OrderDetailClass OrderDetailInf in OrderMasterInf.OrderDetailsList)
                    {
                        if (!dictionary.ContainsValue(OrderDetailInf.ItemId) && OrderDetailInf.Quantity != 0)
                        {
                            dictionary.Add(OrderDetailInf.ItemId.ToString(), OrderDetailInf.ItemId);
                            List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                            Param1.Add(new KeyValuePair<string, object>("@OrderDetailID", OrderDetailInf.OrderDetailsID));
                            Param1.Add(new KeyValuePair<string, object>("@OrderMasterID", m));
                            Param1.Add(new KeyValuePair<string, object>("@Quantity", OrderDetailInf.Quantity));
                            Param1.Add(new KeyValuePair<string, object>("@ItemId", OrderDetailInf.ItemId));
                            Param1.Add(new KeyValuePair<string, object>("@Rate", OrderDetailInf.SRate));
                            Param1.Add(new KeyValuePair<string, object>("@IsCancelled", OrderDetailInf.IsCancelled));
                            Param1.Add(new KeyValuePair<string, object>("@Amount", OrderDetailInf.Amount));
                            Param1.Add(new KeyValuePair<string, object>("@Note", OrderDetailInf.Note));
                            Param1.Add(new KeyValuePair<string, object>("@ExtraItem", OrderDetailInf.ExtraItem));
                            Param1.Add(new KeyValuePair<string, object>("@ExtraCharge", OrderDetailInf.ExtraCharge));
                            Param1.Add(new KeyValuePair<string, object>("@SeatNo", OrderDetailInf.SeatNo));
                            Param1.Add(new KeyValuePair<string, object>("@Status", OrderDetailInf.Status));
                            Param1.Add(new KeyValuePair<string, object>("@HomeDeliveyNumber", OrderDetailInf.HomeDeliveyNumber));
                            sqlHandler.ExecuteNonQuery("[USP_RO_ORDERDETAILSAVE]", Param1);
                        }
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal static List<OrderMasterClass> GetAllOrder()
        {
            SQLHandler sqlHandler = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            List<OrderMasterClass> orderMasterinfo = sqlHandler.ExecuteAsList<OrderMasterClass>("[USP_RO_GETAllORDER]");
            return orderMasterinfo;
        }
        internal static List<OrderMasterClass> GetAllPickOrder()
        {
            SQLHandler sqlHandler = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            List<OrderMasterClass> orderMasterinfo = sqlHandler.ExecuteAsList<OrderMasterClass>("[USP_RO_GETAllPICKORDER]");
            return orderMasterinfo;
        }
        internal static OrderMasterClass GetOrderDetailsFromDatabase(string tableId)
        {
            SQLHandler sqlHandler = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@TableId", tableId));
            OrderMasterClass orderMasterinfo = sqlHandler.ExecuteAsObject<OrderMasterClass>("[USP_RO_GETORDERMASTER]", Param);
            return orderMasterinfo;
        }
        internal void OrderCancel(OrderMasterClass orderMaster)
        {
            List<OrderDetailClass> orderDetail = orderMaster.OrderDetailsList;
            OrderMasterClass orderMasterInfo = RestrOrderProvider.GetOrderDetailsFromDatabase(orderMaster.TableId);
            List<OrderDetailClass> orderDetailInfo = orderMasterInfo.OrderDetailsList;
            if (orderMaster.IsCancelled == true)
            {
                orderMasterInfo.IsCancelled = true;
            }
            else
            {
                foreach (OrderDetailClass detailClass in orderDetail)
                {
                    if (detailClass.IsCancelled == true)
                    {
                        foreach (OrderDetailClass orderInfo in orderDetailInfo)
                        {
                            if (detailClass.OrderDetailsID == orderInfo.OrderDetailsID)
                            {
                                orderInfo.IsCancelled = true;
                                break;
                            }
                        }
                    }
                }
            }
            OrderMasterSaveTodatabase(orderMasterInfo);
        }
        internal void CancelOrder(OrderMasterClass orderMaster)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@OrderMasterID", orderMaster.OrderMasterID));
            Param.Add(new KeyValuePair<string, object>("@IsCancelled", orderMaster.IsCancelled));
            Param.Add(new KeyValuePair<string, object>("@TableId", orderMaster.TableId));
            Param.Add(new KeyValuePair<string, object>("@CancelReason", orderMaster.CancelReason));
            Param.Add(new KeyValuePair<string, object>("@CancelBy", orderMaster.CancelBy));
            Param.Add(new KeyValuePair<string, object>("@SeatNo", orderMaster.GuestNo));
            sqlHandler.ExecuteNonQuery("[USP_RO_ORDERCANCEL]", Param);
        }
        internal List<OrderDetailClass> GetOrderDetailsByMaster(int orderMasterId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@OrderMasterId", orderMasterId));
            List<OrderDetailClass> OrderDetailList = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_GETORDERDETAIL]", Param);
            return OrderDetailList;
        }
        internal void DeleteOrderDetailsByMaster(int orderMasterId, string UserName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@OrderMasterId", orderMasterId));
            Param.Add(new KeyValuePair<string, object>("@UserName", UserName));
            sqlHandler.ExecuteNonQuery("[USP_RO_DELTEORDERDETAIL]", Param);
        }
        #region Table
        internal static List<RestrOrderInfo> GetTableName()
        {
            SQLHandler sqlHandler = new SQLHandler();
            List<RestrOrderInfo> tableNameList = sqlHandler.ExecuteAsList<RestrOrderInfo>("[USP_RO_GETTABLENAME]");
            return tableNameList;
        }
        public void saveRestrotable(restroTable rt)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@restrotableId", rt.restrotableId));
            Param.Add(new KeyValuePair<string, object>("@restrotableTitle", rt.restrotableTitle));
            Param.Add(new KeyValuePair<string, object>("@restroRoomId", rt.restroRoomId));
            Param.Add(new KeyValuePair<string, object>("@SeatNo", rt.Seatcap));
            Param.Add(new KeyValuePair<string, object>("@IsTable", rt.IsTable));
            Param.Add(new KeyValuePair<string, object>("@Rate", rt.Rate));
            sqlHandler.ExecuteNonQuery("[RO_saveTable]", Param);
        }
        public restroTable getRestroTableByID(int restrotableId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@restrotableId", restrotableId));
                return sqlHandler.ExecuteAsObject<restroTable>("USP_RO_GETRESTROTABLEBYID", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void deleteTable(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@restrotableId", id));
            sqlHandler.ExecuteAsList<restroTable>("USP_RO_DELETETABLE", Param);
        }
        public List<restroTable> getrestroTable()
        {
            return sqlHandler.ExecuteAsList<restroTable>("usp_getrestrotable");
        }
        #endregion
        #region ROOM
        public void saveRestroRoom(RestroRoom rt)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@restroRoomId", rt.restroRoomId));
            Param.Add(new KeyValuePair<string, object>("@restroRoom", rt.restroRoom));
            Param.Add(new KeyValuePair<string, object>("@RoomTypeID", rt.RoomTypeID));
            sqlHandler.ExecuteNonQuery("[USP_RO_SAVEROOM]", Param);
        }
        public RestroRoom getRestroRoomByID(int restroRoomId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@restroRoomId", restroRoomId));
            return sqlHandler.ExecuteAsObject<RestroRoom>("USP_RO_GETRESTROROOMBYID", Param);
        }
        public void deleteRoom(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@restroRoomId", id));
            sqlHandler.ExecuteAsList<restroTable>("USP_RO_DELETEROOM", Param);
        }
        public List<RestroRoom> getrestroRoom()
        {
            return sqlHandler.ExecuteAsList<RestroRoom>("USP_RO_GETRESTROROOM");
        }
        #endregion
        #region COmpanyinfo
        public void savecompanyInfo(companyInfo ci)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@companyId", RestrOrderInfo.comId));
            Param.Add(new KeyValuePair<string, object>("@Name", ci.Name));
            Param.Add(new KeyValuePair<string, object>("@RegistrationNo", ci.RegistrationNo));
            Param.Add(new KeyValuePair<string, object>("@Address", ci.Address));
            Param.Add(new KeyValuePair<string, object>("@Country", ci.Country));
            Param.Add(new KeyValuePair<string, object>("@Logo", ci.Logo));
            Param.Add(new KeyValuePair<string, object>("@PhoneNo", ci.PhoneNo));
            Param.Add(new KeyValuePair<string, object>("@PAN", ci.PAN));
            Param.Add(new KeyValuePair<string, object>("@CurrencyID", ci.CurrencyID));
            Param.Add(new KeyValuePair<string, object>("@IsPan", ci.IsPan));
            Param.Add(new KeyValuePair<string, object>("@CBMSUserName", ci.CBMSUserName));
            Param.Add(new KeyValuePair<string, object>("@CBMSPassword", ci.CBMSPassword));
            Param.Add(new KeyValuePair<string, object>("@Code", ci.Code));
            Param.Add(new KeyValuePair<string, object>("@IsAbbreviated", ci.IsAbbreviated));

            sqlHandler.ExecuteNonQuery("usp_saveCompanyInfo", Param);
        }
        public List<companyInfo> getCompanyInfo()
        {
            return sqlHandler.ExecuteAsList<companyInfo>("usp_getcompanyInfo");
        }
        public void deleteCompany(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@cId", id));
            sqlHandler.ExecuteAsList<companyInfo>("usp_deleteCompanyInfo", Param);
        }
        internal companyInfo getcompany()
        {
            return sqlHandler.ExecuteAsObject<companyInfo>("usp_getcompanyInfo");
        }
        #endregion
        #region Billing term
        public int saveBillingTerm(billingTerm bt)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@billtermId", bt.BilingID));
            Param.Add(new KeyValuePair<string, object>("@Name", bt.Name));
            Param.Add(new KeyValuePair<string, object>("@IsAdd", bt.IsAdd));
            Param.Add(new KeyValuePair<string, object>("@Rate", bt.Rate));
            Param.Add(new KeyValuePair<string, object>("@Description", bt.Description));
            Param.Add(new KeyValuePair<string, object>("@SequenceOrder", bt.SequenceOrder));
            return sqlHandler.ExecuteAsScalar<int>("USP_RO_SAVEBILLINGTERM", Param);
        }
        public void deleteBillTerm(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@billtermId", id));
            sqlHandler.ExecuteAsList<restroTable>("USP_RO_DELETEBILLTERM", Param);
        }
        public List<billingTerm> getbillInfo()
        {
            return sqlHandler.ExecuteAsList<billingTerm>("usp_getBillterm");
        }
        public billingTerm getbillInfoById(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@billtermId", id));
            billingTerm bt = sqlHandler.ExecuteAsObject<billingTerm>("USP_RO_GETBILLTERMBYID", Param);
            return bt;
        }
        #endregion
        #region SMS
        internal int savePostedSMS(string mobileNumber, string message)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@contactNumber ", mobileNumber));
                Param.Add(new KeyValuePair<string, object>("@message ", message));
                var smsId = sqlHandler.ExecuteAsScalar<object>("[usp_RO_saveSentNumberMessage]", Param);
                return Convert.ToInt32(smsId);
            }
            catch (Exception)
            {
                throw;
            }
        }
        #endregion
        //Get In Word
        internal string GetInWord(decimal amount, string currencyName, string subCurrencyName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Amount", amount));
            Param.Add(new KeyValuePair<string, object>("@BigCurrency", currencyName));
            Param.Add(new KeyValuePair<string, object>("@SmallCurrency", subCurrencyName));
            var WordAmount = sqlHandler.ExecuteAsScalar<string>("[USP_RO_GETWORD]", Param);
            string inWord = WordAmount.ToString();
            return inWord;
        }
        public Decimal GetNetAmount(decimal Amount)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@amount", Amount));
            var bt = sqlHandler.ExecuteAsObject<RestrOrderInfo>("USP_RO_BILLTERM_NETAMOUNT", Param);
            decimal d = Convert.ToDecimal(bt.amount);
            return d;
        }
        public static List<ItemsClass> GetItemFromDatabaseByPagination(int offset, int limit)
        {
            SQLHandler sqlHandler = new SQLHandler();
            List<KeyValuePair<string, object>> ParaMeterCollection = new List<KeyValuePair<string, object>>();
            ParaMeterCollection.Add(new KeyValuePair<string, object>("@offset", (object)offset));
            ParaMeterCollection.Add(new KeyValuePair<string, object>("@limit", (object)limit));
            List<ItemsClass> list = new List<ItemsClass>();
            return sqlHandler.ExecuteAsList<ItemsClass>("USP_RO_GETITEMforPagination", ParaMeterCollection);
        }
        #endregion
        internal void saveRoomType(RoomType srt)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@RoomTypeID", srt.RoomTypeID));
            Param.Add(new KeyValuePair<string, object>("@Title", srt.Title));
            Param.Add(new KeyValuePair<string, object>("@Description", srt.Description));
            Param.Add(new KeyValuePair<string, object>("@InsertedBy", srt.InsertedBy));
            Param.Add(new KeyValuePair<string, object>("@UpdateBy", srt.UpdateBy));
            sqlHandler.ExecuteNonQuery("[USP_RO_ROOMTYPESAVE]", Param);
        }

        internal List<RoomType> getRoomType()
        {
            return sqlHandler.ExecuteAsList<RoomType>("USP_RO_GETROOMTYPE");
        }
        public List<OrderDetailClass> GetOrderDetailWithStatus(int OrderMasterID)
        {
            List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
            Param1.Add(new KeyValuePair<string, object>("@OrderMasterId", OrderMasterID));
            List<OrderDetailClass> OrderDetailList = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_GETORDERDETAIL]", Param1);
            return OrderDetailList;
        }
        internal List<RoomType> GetrestroFullDetail()
        {
            try
            {
                RestrOrderProvider rop = new RestrOrderProvider();
                List<RoomType> roomtypelst = new List<RoomType>();
                roomtypelst = rop.getRoomType();
                foreach (RoomType roomtype in roomtypelst)
                {
                    List<RestroRoom> roomList = RestrOrderProvider.getRestroRoomByRoomtypeID(roomtype.RoomTypeID);
                    foreach (RestroRoom room in roomList)
                    {
                        List<restroTable> tableList = RestrOrderProvider.GetTableByRoomId(room.restroRoomId);
                        room.tableList = tableList;
                    }
                    roomtype.roomlist = roomList;
                }
                return roomtypelst;
            }
            catch (Exception)
            {
                throw;
            }
        }
        private static List<RestroRoom> getRestroRoomByRoomtypeID(int roomtyprId)
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RoomTypeID", roomtyprId));
                List<RestroRoom> list = new List<RestroRoom>();
                list = sqlHandler.ExecuteAsList<RestroRoom>("[USP_RO_GetRoomListByRoomTypeId]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal RoomType getRoomTypeByID(int ID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ID", ID));
            return sqlHandler.ExecuteAsObject<RoomType>("USP_RO_GETROOMTYPEByID", Param);
        }
        public void deleteRoomType(string ID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ID", ID));
                sqlHandler.ExecuteNonQuery("[USP_RO_DELETEROOMTYPE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<restroTable> GetOccupiedTables(bool isTable)
        {
            try
            {
                List<restroTable> list = new List<restroTable>();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@isTable", isTable));
                list = sqlHandler.ExecuteAsList<restroTable>("[dbo].[USP_RO_GetOccupiedTables]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<restroTable> GetComplimentaryOccupiedTables(bool isTable)
        {
            try
            {
                List<restroTable> list = new List<restroTable>();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@isTable", isTable));
                list = sqlHandler.ExecuteAsList<restroTable>("[dbo].[USP_RO_GetComplimentaryOccupiedTables]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<RestroRoom> GetRoomByRoomTypeId(int RoomTypeID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RoomTypeID", RoomTypeID));
                List<RestroRoom> list = new List<RestroRoom>();
                list = sqlHandler.ExecuteAsList<RestroRoom>("[USP_RO_GetRoomListByRoomTypeId]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<restroTable> GetTableByRoomTypeId(int RoomId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RoomTypeId", RoomId));
                List<restroTable> list = new List<restroTable>();
                list = sqlHandler.ExecuteAsList<restroTable>("[USP_RO_GetTableByRoomTypeId]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<restroTable> GetTableByRoomTypeIdWeb(int RoomId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RoomTypeId", RoomId));
                List<restroTable> list = new List<restroTable>();
                list = sqlHandler.ExecuteAsList<restroTable>("[USP_RO_GetTableByRoomTypeIdWeb]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<OrderDetailClass> GettabledataById(int TableId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@TableId", TableId));
                List<OrderDetailClass> list = new List<OrderDetailClass>();
                list = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_GettabledataById]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<OrderDetailClass> GetPickData(int TableId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@TableId", TableId));
                List<OrderDetailClass> list = new List<OrderDetailClass>();
                list = sqlHandler.ExecuteAsList<OrderDetailClass>("[usp_ro_getpickdata]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<costCenter> getcostcenter()
        {
            List<costCenter> list = new List<costCenter>();
            list = sqlHandler.ExecuteAsList<costCenter>("[dbo].[USP_GetCostCenter]");
            return list;
        }
        public List<costCenterReport> getAllCostCenterReport(DateTime startDate, DateTime endDate, int costCenter)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@costCenter", costCenter));
            List<costCenterReport> list = new List<costCenterReport>();
            List<costCenterReport> dailyReportList = sqlHandler.ExecuteAsList<costCenterReport>("[usp_CostCenterwiseAllReport]", Param);
            return dailyReportList;
        }
        public List<costCenterReport> getDailyCostCenterReport(DateTime startDate, DateTime endDate, int costCenter)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@costCenter", costCenter));
            List<costCenterReport> list = new List<costCenterReport>();
            List<costCenterReport> dailyReportList = sqlHandler.ExecuteAsList<costCenterReport>("[usp_CostCenterwiseDailyReport]", Param);
            return dailyReportList;
        }
        public List<costCenterReport> getSummaryCostCenterReport(DateTime startDate, DateTime endDate, int costCenter)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@costCenter", costCenter));
            List<costCenterReport> list = new List<costCenterReport>();
            List<costCenterReport> dailyReportList = sqlHandler.ExecuteAsList<costCenterReport>("[usp_CostCenterwiseSummaryReport]", Param);
            return dailyReportList;
        }
        public List<OrderDetailClass> getitemprocessing(int costcenterID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CostCenterId", costcenterID));
            List<OrderDetailClass> list = new List<OrderDetailClass>();
            list = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_GetDataFromCostCenterID]", Param);
            return list;
        }
        internal List<OrderDetailClass> inprocess(int ItemID, int StatusID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemID", ItemID));
            Param.Add(new KeyValuePair<string, object>("@StatusID", StatusID));
            List<OrderDetailClass> list = new List<OrderDetailClass>();
            list = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_UpdateStatusOfOrderByCostCenter]", Param);
            return list;
        }
        public List<customerBilling> getbillingTerm(decimal val)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@amount", val));
            return sqlHandler.ExecuteAsList<customerBilling>("[USP_RO_BILLTERM]", Param);
        }

        internal List<OrderDetailClass> GettabledataByIdforMenu(int TableId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@TableId", TableId));
                List<OrderDetailClass> list = new List<OrderDetailClass>();
                list = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_GettabledataByIdforMenu]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<RoomBookingsInfo> GetroomdataByIdforMenu(int tableId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@TableId", tableId));
                return sqlHandler.ExecuteAsList<RoomBookingsInfo>("[USP_RO_GetRoomBookingsByRoomId]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public void saveSalesBill(SalesMaster sm, List<SalesDetails> sd, int splited, List<customerBilling> bt)
        {
            //var username=GetUsername;
            using (TransactionScope ts = new TransactionScope())
            {
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
                Param.Add(new KeyValuePair<string, object>("@RoomRate", sm.RoomRate));
                Param.Add(new KeyValuePair<string, object>("@BookedDays", sm.BookedDays));
                Param.Add(new KeyValuePair<string, object>("@RoomCharge", sm.RoomCharge));
                Param.Add(new KeyValuePair<string, object>("@AdvancePayment", sm.AdvancePayment));
                Param.Add(new KeyValuePair<string, object>("@DeliveryCharge", Convert.ToString(sm.DeliveryCharge) == null ? 0 : sm.DeliveryCharge));
                Param.Add(new KeyValuePair<string, object>("@DeliveredBy", sm.DeliveredBy == null ? "" : sm.DeliveredBy));
                //Param.Add(new KeyValuePair<string, object>("@WaiterId", sm.Waiter));
                List<OrderDetailClass> list = new List<OrderDetailClass>();
                var a = sqlHandler.ExecuteAsScalar<object>("usp_ro_savesalesMaster", Param);
                int salesMasterId = Convert.ToInt32(a);
                //save billing term 
                foreach (customerBilling term in bt)
                {
                    List<KeyValuePair<string, object>> ParamBill2 = new List<KeyValuePair<string, object>>();
                    ParamBill2.Add(new KeyValuePair<string, object>("@amount", term.Amount));
                    ParamBill2.Add(new KeyValuePair<string, object>("@SaleMasterID", salesMasterId));
                    ParamBill2.Add(new KeyValuePair<string, object>("@BillingID", term.ID));
                    ParamBill2.Add(new KeyValuePair<string, object>("@rate", term.Rate));
                    var billTermList = sqlHandler.ExecuteAsList<customerBilling>("USP_RO_SaveBILLTERM_WITHID", ParamBill2);
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
                //    sqlHandler.ExecuteNonQuery("[USP_RO_BILLTERMAMOUNT_SAVE]", ParamBill4);
                //}
                //foreach(var obj in billTermAmountList)
                //{
                //    List<KeyValuePair<string, object>> ParamBill4 = new List<KeyValuePair<string, object>>();
                //    ParamBill4.Add(new KeyValuePair<string, object>("@SalesMasterID", obj.SalesMasterID));
                //    ParamBill4.Add(new KeyValuePair<string, object>("@BillTerm", obj.BillTermID));
                //    ParamBill4.Add(new KeyValuePair<string, object>("@Amount", obj.Amount));
                //    ParamBill4.Add(new KeyValuePair<string, object>("@IsVoid", false));
                //    sqlHandler.ExecuteNonQuery("[USP_RO_BILLTERMAMOUNT_SAVE]", ParamBill4);
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
                    Param1.Add(new KeyValuePair<string, object>("@HsCode", sd[i].HsCode));
                    sqlHandler.ExecuteAsScalar<object>("usp_ro_savesalesDetail", Param1);
                    Param1.Clear();
                }
                List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                Param2.Add(new KeyValuePair<string, object>("@OrderMasterId", sm.OrderMasterId));
                Param2.Add(new KeyValuePair<string, object>("@termAmount", sm.TermAmount));
                Param2.Add(new KeyValuePair<string, object>("@NetAmount", sd[0].NetAmount));
                Param2.Add(new KeyValuePair<string, object>("@splited", splited));
                sqlHandler.ExecuteNonQuery("usp_ro_updateOrderMaster", Param2);
                List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                for (int i = 0; i < sd.Count; i++)
                {
                    Param3.Add(new KeyValuePair<string, object>("@orderDetailsId", sd[i].OrderDetailsID));
                    Param3.Add(new KeyValuePair<string, object>("@qty", sd[i].qty));
                    Param3.Add(new KeyValuePair<string, object>("@netAmount", sd[i].Amount));
                    sqlHandler.ExecuteNonQuery("usp_ro_updateOrderDetails", Param3);
                    Param3.Clear();
                }
                ts.Complete();
            }
        }
        internal List<CategoriesClass> GetCategoriesBymenuID(int MenuId, int languageid)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@MenuId", MenuId));
                Param.Add(new KeyValuePair<string, object>("@LanguageID", languageid));
                List<CategoriesClass> list = new List<CategoriesClass>();
                list = sqlHandler.ExecuteAsList<CategoriesClass>("[USP_RO_GetCategoriesBymenuID]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ItemsClass> GetItemByCategoryID(int CategoriesID, int LanguageID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@CategoriesID", CategoriesID));
                Param.Add(new KeyValuePair<string, object>("@LanguageID", LanguageID));
                List<ItemsClass> list = new List<ItemsClass>();
                list = sqlHandler.ExecuteAsList<ItemsClass>("[USP_RO_GetItemByCategoryID]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ItemsClass> GetPreviousItemByID(int Id)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@Id", Id));
                List<ItemsClass> list = new List<ItemsClass>();
                list = sqlHandler.ExecuteAsList<ItemsClass>("[USP_RO_GetPreviousItemByID]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ItemsClass> GetPreviousItemByRoomID(int Id)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@Id", Id));
                List<ItemsClass> list = new List<ItemsClass>();
                list = sqlHandler.ExecuteAsList<ItemsClass>("[USP_RO_GETPREVIOUSITEMBYROOMID]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal List<dailyreports> getAccSalesReport(DateTime startDate, DateTime endDate, string PaymentMode, int Status, int OrdertypeID, string custName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@PaymentMode", PaymentMode));
            Param.Add(new KeyValuePair<string, object>("@Status", Status));
            Param.Add(new KeyValuePair<string, object>("@OrdertypeID", OrdertypeID));
            Param.Add(new KeyValuePair<string, object>("@CustName", custName));
            List<dailyreports> dailyReportList = sqlHandler.ExecuteAsList<dailyreports>("[USP_ALL_REPORT]", Param);
            return dailyReportList;
        }

        internal List<dailyreports> getSalesReport(DateTime startDate, DateTime endDate, string PaymentMode, int Status, int OrdertypeID, string custName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@PaymentMode", PaymentMode));
            Param.Add(new KeyValuePair<string, object>("@Status", Status));
            Param.Add(new KeyValuePair<string, object>("@OrdertypeID", OrdertypeID));
            Param.Add(new KeyValuePair<string, object>("@CustName", custName));
            List<dailyreports> dailyReportList = sqlHandler.ExecuteAsList<dailyreports>("[USP_SALES_REPORT]", Param);
            return dailyReportList;
        }
        internal List<dailyreports> getSalesReportForSalesReturn(DateTime startDate, DateTime endDate, string billNo)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@BillNo", billNo));
            List<dailyreports> dailyReportList = sqlHandler.ExecuteAsList<dailyreports>("[USP_SALES_REPORT_For_SalesReturn]", Param);
            return dailyReportList;
        }
        internal List<dailyreport> getdailyReport(DateTime dateTime)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Todaydate", dateTime));
            List<dailyreport> dailyReportList = sqlHandler.ExecuteAsList<dailyreport>("[USP_SALSEREPORTBtoday]", Param);
            return dailyReportList;
        }
        internal List<dailyreport> getdailyReportForCancelledBill(DateTime startdate, DateTime enddate, string cancelledby)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startdate", startdate));
            Param.Add(new KeyValuePair<string, object>("@enddate", enddate));
            Param.Add(new KeyValuePair<string, object>("@cancelledby", cancelledby));
            List<dailyreport> dailyReportList = sqlHandler.ExecuteAsList<dailyreport>("[USP_CancelledBillREPORTBtoday]", Param);
            return dailyReportList;
        }
        internal List<dailyreport> getdailyReportBySum(DateTime dateTime)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Todaydate", dateTime));
            return sqlHandler.ExecuteAsList<dailyreport>("[usp_ro_getbasicsumamount]", Param);
        }
        internal List<dailyreport> getweeklysumbyDate(DateTime dateTime)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", dateTime));
            return sqlHandler.ExecuteAsList<dailyreport>("[usp_ro_sumweekly]", Param);
        }
        internal List<dailyreport> getdailyReportByWeekly(DateTime dateTime)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", dateTime));
            return sqlHandler.ExecuteAsList<dailyreport>("[USP_SALSEREPORTBYWEEKLY]", Param);
        }
        internal List<dailyreport> getdailyReportByMonthly(string year, string month)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            Param.Add(new KeyValuePair<string, object>("@month", month));
            return sqlHandler.ExecuteAsList<dailyreport>("[USP_GETDATABYMONTHLY]", Param);
        }
        internal List<dailyreport> getdailyReportByYearly(string year)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            return sqlHandler.ExecuteAsList<dailyreport>("[USP_GETDATABYYEARLY]", Param);
        }
        internal List<itemsales> getDailyItemSalesReport(DateTime startDate, DateTime endDate, int costCenterID, int pitid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@costCenterID", costCenterID));
            Param.Add(new KeyValuePair<string, object>("@PITId", pitid));
            return sqlHandler.ExecuteAsList<itemsales>("[USP_RO_DailyItemSalesReport]", Param);
        }
        internal List<itemsales> getSummaryItemSalesReport(DateTime startDate, DateTime endDate, int costCenterID, int pitid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@costCenterID", costCenterID));
            Param.Add(new KeyValuePair<string, object>("@PITId", pitid));
            return sqlHandler.ExecuteAsList<itemsales>("[USP_RO_SummaryItemSalesReport]", Param);
        }

        public List<bestby> getdatabyBest()
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            return sqlHandler.ExecuteAsList<bestby>("[usp_getdatabyBest]");
        }
        internal RestroRoom GetRoomByTable(int p)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@TableId", p));
            return sqlHandler.ExecuteAsObject<RestroRoom>("[USP_RO_GETROOMBYTABLE]", Param);
        }
        public List<OrderDetailClass> GetDataforPrint(int TableId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@TableId", TableId));
                List<OrderDetailClass> list = new List<OrderDetailClass>();
                list = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_GetdataforPrint]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        public void updateIsprinted(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@OrderMasterId", id));
            sqlHandler.ExecuteNonQuery("[ro_updateIsPrinted]", Param);
        }
        public int SaveCus(Cusinfo Cusinfo)
        {
            try
            {
                int OrderId = 0;
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OrderID", Cusinfo.OrderID));
                Param.Add(new KeyValuePair<string, object>("@Name", Cusinfo.Name));
                Param.Add(new KeyValuePair<string, object>("@OrderDate", Cusinfo.OrderDate));
                Param.Add(new KeyValuePair<string, object>("@OrderTime", Cusinfo.OrderTime));
                Param.Add(new KeyValuePair<string, object>("@AppoinmentReceiveTime", Cusinfo.AppoinmentReceiveTime));
                Param.Add(new KeyValuePair<string, object>("@AppoinmentReceiveDate", Cusinfo.AppoinmentReceiveDate));
                Param.Add(new KeyValuePair<string, object>("@People", Cusinfo.People));
                Param.Add(new KeyValuePair<string, object>("@Message", Cusinfo.Message));
                if (Cusinfo.OrderID == 0)
                {
                    var a = sqlHandler.ExecuteAsScalar<object>("[USP_INSERT_CUSORDER]", Param);
                    OrderId = Convert.ToInt32(a);
                }
                else
                {
                    sqlHandler.ExecuteNonQuery("[USP_INSERT_CUSORDER]", Param);
                }
                return OrderId;
            }
            catch (Exception)
            {
                throw;
            }
        }
        public string DoesTableNameExist(string tableName)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@TableName", tableName));
                var a = sqlHandler.ExecuteAsScalar<object>("[USP_RO_CheckDuplicteTableName]", Param);
                if (a == null)
                {
                    return "";
                }
                return "Table Name already exist";
            }
            catch
            {
                return "Error";
                throw;
            }
        }
        public string DoesRoomNameExist(string roomName)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RoomName", roomName));
                var a = sqlHandler.ExecuteAsScalar<object>("[USP_RO_CheckDuplicteRoomName]", Param);
                if (a == null)
                {
                    return "";
                }
                return "Room Name already exist";
            }
            catch
            {
                return "Error";
                throw;
            }
        }
        public string DoesRoomTypeExist(string roomType)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RoomType", roomType));
                var a = sqlHandler.ExecuteAsScalar<object>("[USP_RO_CheckDuplicteRoomType]", Param);
                if (a == null)
                {
                    return "";
                }
                return "Room Type already exist";
            }
            catch
            {
                return "Error";
                throw;
            }
        }
        public List<OrderDetailClass> Getdataforsplitbill(int TableId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@tableId", TableId));
                // Param.Add(new KeyValuePair<string, object>("@OrdermasterId", mId));
                List<OrderDetailClass> list = new List<OrderDetailClass>();
                list = sqlHandler.ExecuteAsList<OrderDetailClass>("[ro_getdataforSplitBill]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<MemberInfo> CheckLoyaltyForDiscount(string MembershipID, string TelMobile)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@MembershipID", MembershipID));
                Param.Add(new KeyValuePair<string, object>("@TelMobile", TelMobile));
                List<MemberInfo> lst = sqlHandler.ExecuteAsList<MemberInfo>("[USP_RO_CheckLoyaltyForDiscount]", Param);
                return lst;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal BillInfo getbillInfo(int salesMasterId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                BillInfo lst = sqlHandler.ExecuteAsObject<BillInfo>("[USP_RO_GetBillInfo]", Param);
                return lst;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal List<OrderDetailClass> OrderMasterSaveTodatabase(OrderMasterClass orderMasterInfo, List<OrderDetailClass> repeateditem)
        {
            try
            {
                DeleteOrderDetailsByMaster(orderMasterInfo.OrderMasterID, orderMasterInfo.UserName);
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OrderMasterID", orderMasterInfo.OrderMasterID));
                Param.Add(new KeyValuePair<string, object>("@TableId", orderMasterInfo.TableId));
                Param.Add(new KeyValuePair<string, object>("@BasicAmount", orderMasterInfo.BasicAmount));
                Param.Add(new KeyValuePair<string, object>("@BillNo", orderMasterInfo.BillNo));
                Param.Add(new KeyValuePair<string, object>("@Date", DateTime.Now));
                Param.Add(new KeyValuePair<string, object>("@IsCancelled", orderMasterInfo.IsCancelled));
                Param.Add(new KeyValuePair<string, object>("@TermAmount", orderMasterInfo.TermAmount));
                Param.Add(new KeyValuePair<string, object>("@NetAmount", orderMasterInfo.NetAmount));
                Param.Add(new KeyValuePair<string, object>("@UserName", orderMasterInfo.UserName));
                Param.Add(new KeyValuePair<string, object>("@Remarks", orderMasterInfo.Remarks));
                Param.Add(new KeyValuePair<string, object>("@IsSplit", orderMasterInfo.IsSplit));
                Param.Add(new KeyValuePair<string, object>("@GuestNo", orderMasterInfo.GuestNo));
                Param.Add(new KeyValuePair<string, object>("@BillPaid", orderMasterInfo.BillPaid));
                Param.Add(new KeyValuePair<string, object>("@RoomId", orderMasterInfo.RoomId));
                Param.Add(new KeyValuePair<string, object>("@OID", orderMasterInfo.OID));
                Param.Add(new KeyValuePair<string, object>("@OrderStatus", orderMasterInfo.OrderStatus));
                Param.Add(new KeyValuePair<string, object>("@OrderTypeID", orderMasterInfo.OrderTypeID.ToString() == null ? 0 : orderMasterInfo.OrderTypeID));
                var obj = sqlHandler.ExecuteAsScalar<object>("[USP_PO_SAVEPURCHASEMASTER]", Param);
                int m = (orderMasterInfo.OrderMasterID == 0) ? Convert.ToInt32(obj) : orderMasterInfo.OrderMasterID;

                List<OrderDetailClass> orderDetailRunning = new List<OrderDetailClass>();
                List<OrderDetailClass> leftOrderRecord = new List<OrderDetailClass>();
                Dictionary<string, int> dictionary = new Dictionary<string, int>();
                dictionary.Add("noone", 0);
                int co = 0;
                if (orderMasterInfo.OrderDetailsList != null)
                {
                    foreach (OrderDetailClass OrderDetailInf in orderMasterInfo.OrderDetailsList)
                    {
                        OrderDetailInf.OrderMasterId = m;
                        if (checkContainingValue(dictionary, OrderDetailInf.ItemId, OrderDetailInf.SeatNo, OrderDetailInf.IsCombo) == 0 && OrderDetailInf.Quantity != 0)
                        {
                            dictionary.Add((OrderDetailInf.ItemId.ToString() + '_' + co + '_' + OrderDetailInf.IsCombo), OrderDetailInf.SeatNo);
                            co++;
                            List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                            Param1.Add(new KeyValuePair<string, object>("@OrderDetailID", OrderDetailInf.OrderDetailsID));
                            Param1.Add(new KeyValuePair<string, object>("@OrderMasterID", m));
                            Param1.Add(new KeyValuePair<string, object>("@Quantity", OrderDetailInf.Quantity));
                            Param1.Add(new KeyValuePair<string, object>("@RO_ItemID", OrderDetailInf.ItemId));
                            Param1.Add(new KeyValuePair<string, object>("@IsCombo", OrderDetailInf.IsCombo));
                            Param1.Add(new KeyValuePair<string, object>("@Rate", OrderDetailInf.SRate));
                            Param1.Add(new KeyValuePair<string, object>("@IsCancelled", OrderDetailInf.IsCancelled));
                            Param1.Add(new KeyValuePair<string, object>("@Amount", OrderDetailInf.Amount));
                            Param1.Add(new KeyValuePair<string, object>("@Note", OrderDetailInf.Note));
                            Param1.Add(new KeyValuePair<string, object>("@ExtraCharge", OrderDetailInf.ExtraCharge));
                            Param1.Add(new KeyValuePair<string, object>("@SeatNo", OrderDetailInf.SeatNo));
                            Param1.Add(new KeyValuePair<string, object>("@Status", OrderDetailInf.Status));
                            Param1.Add(new KeyValuePair<string, object>("@IsHomeDelivery", OrderDetailInf.IsHomeDelivery));
                            Param1.Add(new KeyValuePair<string, object>("@HomeDeliveyNumber", OrderDetailInf.HomeDeliveyNumber));
                            int runningOrder = 0;
                            if (repeateditem.Count > 0)
                            {
                                int testRunning = 0;
                                foreach (OrderDetailClass v in repeateditem)
                                {
                                    //OrderDetailInf.Quantity = OrderDetailInf.Quantity - v.Quantity;
                                    if ((v.ItemId == OrderDetailInf.ItemId) && (v.IsCombo == OrderDetailInf.IsCombo)) //10
                                    {
                                        leftOrderRecord.Add(OrderDetailInf);
                                        testRunning = 1;
                                        if (v.Quantity == OrderDetailInf.Quantity)
                                        {
                                            //Param1.Add(new KeyValuePair<string, object>("@IsRunningOrder", v.IsRunningOrder));
                                            runningOrder = v.IsRunningOrder;
                                        }
                                        else
                                        {
                                            //Param1.Add(new KeyValuePair<string, object>("@IsRunningOrder", 1));
                                            runningOrder = 1;
                                            OrderDetailInf.Quantity = OrderDetailInf.Quantity - v.Quantity;
                                            orderDetailRunning.Add(OrderDetailInf);
                                            //break;
                                        }
                                        break;
                                    }
                                }
                                if (testRunning == 0)
                                {
                                    orderDetailRunning.Add(OrderDetailInf);
                                }
                            }
                            else
                            {
                                runningOrder = 0;
                                orderDetailRunning.Add(OrderDetailInf);
                            }
                            Param1.Add(new KeyValuePair<string, object>("@IsRunningOrder", runningOrder));
                            sqlHandler.ExecuteNonQuery("[USP_RO_ORDERDETAILSAVE]", Param1);
                        }
                    }
                    List<OrderDetailClass> addedOrderList = repeateditem.Where(x => !leftOrderRecord.Any(y => y.ItemId == x.ItemId && y.IsCombo == x.IsCombo)).ToList();
                    foreach (OrderDetailClass order in addedOrderList)
                    {
                        order.Quantity = -order.Quantity;
                        order.IsCancelled = true;
                        orderDetailRunning.Add(order);
                    }
                }
                return orderDetailRunning;
                //        ts.Complete();
            }
            catch (Exception)
            {
                throw;
            }
        }
        private int checkContainingValue(Dictionary<string, int> dictionary, int ItemId, int SeatNo, bool IsCombo)
        {
            int retval = 0;
            foreach (var item in dictionary)
            {
                var split = item.Key.Split('_');
                if (split[0] == ItemId.ToString() && item.Value == SeatNo && split[2] == IsCombo.ToString())
                {
                    retval = 1;
                    break;
                }
            }
            return retval;
        }
        public List<costCenter> getdiscountfromcostcenter()
        {
            List<costCenter> lst = sqlHandler.ExecuteAsList<costCenter>("usp_ro_getdiscountfromcostcenter");
            return lst;
        }
        public List<OrderDetailClass> GetPickDataforPrint(int p)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@TableId", p));
            return sqlHandler.ExecuteAsList<OrderDetailClass>("[usp_ro_getpickdataforprint]", Param);
        }
        internal void saveflatorperdis(flatorperdiscount fl)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@SalesMasterId", fl.SalesMasterId));
            Param.Add(new KeyValuePair<string, object>("@kotdis", fl.kotdis));
            Param.Add(new KeyValuePair<string, object>("@bardis", fl.bardis));
            Param.Add(new KeyValuePair<string, object>("@roomdis", fl.roomdis));
            Param.Add(new KeyValuePair<string, object>("@isflatdis", fl.isflatdis));
            Param.Add(new KeyValuePair<string, object>("@isloyalty", fl.isLoyalty));
            Param.Add(new KeyValuePair<string, object>("@loyaltydis", fl.loyaltydis));
            //Param.Add(new KeyValuePair<string, object>("@BasicAmount", fl.BasicAmount));
            //Param.Add(new KeyValuePair<string, object>("@TermAmount", fl.TermAmount));
            //Param.Add(new KeyValuePair<string, object>("@NetAmount", fl.NetAmount));
            sqlHandler.ExecuteNonQuery("[usp_ro_saveflatandPerdiscount]", Param);
        }
        public List<flatorperdiscount> getflarorperdiscount(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@SalesMasterId", id));
            return sqlHandler.ExecuteAsList<flatorperdiscount>("[usp_getflatandperdiscount]", Param);
        }

        public List<flatorperdiscount> getcakediscount(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@SalesMasterId", id));
            return sqlHandler.ExecuteAsList<flatorperdiscount>("[usp_getcakediscount]", Param);
        }

        public List<salesSummary> GetSalesSummary(DateTime dailyDate, DateTime weeklyDate, int value, int month, int year, DateTime fromDate, DateTime toDate)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@Todaydate", dailyDate));
                Param.Add(new KeyValuePair<string, object>("@Weeklydate", weeklyDate));
                Param.Add(new KeyValuePair<string, object>("@value", value));
                Param.Add(new KeyValuePair<string, object>("@month", month));
                Param.Add(new KeyValuePair<string, object>("@year", year));
                Param.Add(new KeyValuePair<string, object>("@FromDate", fromDate));
                Param.Add(new KeyValuePair<string, object>("@ToDate", toDate));
                List<salesSummary> salesSummary = sqlHandler.ExecuteAsList<salesSummary>("[USP_RO_GetSalesSummary]", Param);
                return salesSummary;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #region Restro Order Inventory
        internal void Unit1Save1Todatabase(UnitClass UnitInf)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@UnitId", UnitInf.Unit1Id));
                Param.Add(new KeyValuePair<string, object>("@UnitDesc", UnitInf.UnitDescription));
                Param.Add(new KeyValuePair<string, object>("@Symbol", UnitInf.Symbol));
                sqlHandler.ExecuteNonQuery("[ROI_PUpdateUnit1]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal static List<UnitClass> GetUnit1fromDatabase()
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<UnitClass> Unitinfo = sqlHandler.ExecuteAsList<UnitClass>("[ROI_GetUnit1]");
                return Unitinfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void UnitDelete1(int UnitID1)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@Unit1Id", UnitID1));
                sqlHandler.ExecuteNonQuery("[ROI_UNIT1DELETE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal string Unit1Save2Todatabase(UnitClass UnitInf)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@UnitId", UnitInf.Unit2ID));
                Param.Add(new KeyValuePair<string, object>("@FUnitId", UnitInf.FirstUnit));
                Param.Add(new KeyValuePair<string, object>("@SUnitId", UnitInf.SecondUnit));
                Param.Add(new KeyValuePair<string, object>("@Conversion", UnitInf.Conversion));
                sqlHandler.ExecuteNonQuery("[ROI_PUpdateUnit2]", Param);
                return "Saved Successfully";
            }
            catch (Exception ex)
            {
                string[] data = ex.Message.Split('.');
                return data[0];
            }
        }
        internal List<UnitConversion> GetUnit2fromDatabase()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<UnitConversion> Unitinfo = sqlHandler.ExecuteAsList<UnitConversion>("[ROI_GetUnit2]");
                return Unitinfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void UnitDelete2(int UnitID2)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@UnitID2", UnitID2));
                sqlHandler.ExecuteNonQuery("[ROI_UNIT2DELETE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal int RestroPurchaseOrder(MvPurchaseMain PurchaseObject)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@PurchaseMainID", PurchaseObject.PurchaseMainID));
                    Param.Add(new KeyValuePair<string, object>("@PuNo", PurchaseObject.PuNo));
                    Param.Add(new KeyValuePair<string, object>("@IvNo", PurchaseObject.IvNo));
                    Param.Add(new KeyValuePair<string, object>("@PbDate", PurchaseObject.PbDate));
                    Param.Add(new KeyValuePair<string, object>("@Vid", PurchaseObject.Vid));
                    Param.Add(new KeyValuePair<string, object>("@Remarks", PurchaseObject.Remarks));
                    Param.Add(new KeyValuePair<string, object>("@FyId", PurchaseObject.FyId));
                    Param.Add(new KeyValuePair<string, object>("@PostedOn", DateTime.Now));
                    Param.Add(new KeyValuePair<string, object>("@PostedBy", PurchaseObject.PostedBy));
                    Param.Add(new KeyValuePair<string, object>("@SPMID", PurchaseObject.SPMID));
                    int ids = sqlHandler.ExecuteAsScalar<int>("[ROI_SAVEPURCHASEMAIN]", Param);

                    List<KeyValuePair<string, object>> param6 = new List<KeyValuePair<string, object>>();
                    param6.Add(new KeyValuePair<string, object>("@PurchaseMainID", ids));
                    sqlHandler.ExecuteNonQuery("USP_DELETEPurchaseMainID", param6);
                    for (int i = 0; i < PurchaseObject.PurchaseObjectDetails.Count; i++)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@PurchaseMainID", ids));
                        Param1.Add(new KeyValuePair<string, object>("@PurchaseDetailsID", PurchaseObject.PurchaseDetailsID));
                        Param1.Add(new KeyValuePair<string, object>("@ItemID", PurchaseObject.PurchaseObjectDetails[i].ItemID));
                        Param1.Add(new KeyValuePair<string, object>("@UsedUnitID", PurchaseObject.PurchaseObjectDetails[i].UnitID));
                        Param1.Add(new KeyValuePair<string, object>("@Quentity", PurchaseObject.PurchaseObjectDetails[i].Quentity));
                        Param1.Add(new KeyValuePair<string, object>("@QuentityText", PurchaseObject.PurchaseObjectDetails[i].QuentityText));
                        Param1.Add(new KeyValuePair<string, object>("@UnitRate", PurchaseObject.PurchaseObjectDetails[i].Rate));
                        Param1.Add(new KeyValuePair<string, object>("@Total", PurchaseObject.PurchaseObjectDetails[i].Total));
                        Param1.Add(new KeyValuePair<string, object>("@Conversion", PurchaseObject.PurchaseObjectDetails[i].Conversion));
                        Param1.Add(new KeyValuePair<string, object>("@RecqDetailId", PurchaseObject.PurchaseObjectDetails[i].RecqDetailId));
                        Param1.Add(new KeyValuePair<string, object>("@VendorPurchaseId", PurchaseObject.PurchaseObjectDetails[i].VendorPurchaseId));
                        Param1.Add(new KeyValuePair<string, object>("@IsVat", PurchaseObject.PurchaseObjectDetails[i].IsVat));
                        Param1.Add(new KeyValuePair<string, object>("@Discount", PurchaseObject.PurchaseObjectDetails[i].Discount));
                        var b = sqlHandler.ExecuteAsScalar<object>("[ROI_SAVEPURCHASEDETAILS]", Param1);
                    }
                    //for (int i = 0; i < PurchaseObject.RecquistionObjectDetails.Count; i++)
                    //{
                    //    List<KeyValuePair<string, object>> Param7 = new List<KeyValuePair<string, object>>();
                    //    Param7.Add(new KeyValuePair<string, object>("@RecqDetailId", PurchaseObject.RecquistionObjectDetails[i].RecqDetailId));
                    //    Param7.Add(new KeyValuePair<string, object>("@RecqId", PurchaseObject.RecquistionObjectDetails[i].RecqId));
                    //    sqlHandler.ExecuteNonQuery("USP_UpdateReq_RecquistionDetails", Param7);
                    //}
                    //for (int i = 0; i < PurchaseObject.PurchaseObjectDetailsLot.Count; i++)
                    //{
                    //    List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                    //    Param2.Add(new KeyValuePair<string, object>("@PurchaseDetailsID", PurchaseObject.PurchaseDetailsID));
                    //    Param2.Add(new KeyValuePair<string, object>("@LotNo", PurchaseObject.PurchaseObjectDetailsLot[i].LotNo));
                    //    Param2.Add(new KeyValuePair<string, object>("@BatchNo", PurchaseObject.PurchaseObjectDetailsLot[i].BatchNo));
                    //    Param2.Add(new KeyValuePair<string, object>("@ExpDate", PurchaseObject.PurchaseObjectDetailsLot[i].ExpDate.ToString()));
                    //    sqlHandler.ExecuteNonQuery("[ROI_SAVEPURCHASELOT]", Param2);
                    //}
                    ts.Complete();
                    return ids;
                }
                catch (Exception)
                {
                    throw;
                }
            }
        }
        #endregion Restro Order Inventory
        internal void TransfterTableForOrder(int OldTable, int NewTable)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@OldTable", OldTable));
            Param.Add(new KeyValuePair<string, object>("@NewTable", NewTable));
            sqlHandler.ExecuteNonQuery("[USP_RO_TABLETRANSFER]", Param);
        }
        #region salesReportNew
        public List<SalesMaster> getdailysalesReport(DateTime dt)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@date", dt));
            return sqlHandler.ExecuteAsList<SalesMaster>("[usp_ro_reportDaily]", Param);
        }
        public List<SalesMaster> getweeklysalesReport(DateTime dt)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@date", dt));
            return sqlHandler.ExecuteAsList<SalesMaster>("[usp_ro_reportweekly]", Param);
        }
        public List<SalesMaster> getmonthlysalesReport(string year, string month)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            Param.Add(new KeyValuePair<string, object>("@month", month));
            return sqlHandler.ExecuteAsList<SalesMaster>("[usp_ro_reportmonthly]", Param);
        }
        public List<SalesMaster> getyearlysalesReport(string year)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            return sqlHandler.ExecuteAsList<SalesMaster>("[usp_ro_reportyearly]", Param);
        }
        #endregion
        public void UnMergeTable(int tableId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@TableId", tableId));
            sqlHandler.ExecuteNonQuery("[USP_RO_ClearMergeTableList]", Param);
        }
        #region CardProvider
        internal void SaveCardProvider(CardProvider cd)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ProviderID", cd.ProviderID));
            Param.Add(new KeyValuePair<string, object>("@ProviderName", cd.ProviderName));
            Param.Add(new KeyValuePair<string, object>("@Description", cd.Description));
            sqlHandler.ExecuteNonQuery("[USP_RO_SAVECARDPROVIDER]", Param);
        }
        internal List<CardProvider> getCardProvider()
        {
            return sqlHandler.ExecuteAsList<CardProvider>("[USP_RO_GETCARDPROVIDER]");
        }
        internal List<providersReport> getAllProvidersReport(DateTime startDate, DateTime endDate, int paymentMode, int provider)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@paymentMode", paymentMode));
            Param.Add(new KeyValuePair<string, object>("@provider", provider));
            List<providersReport> dailyReportList = sqlHandler.ExecuteAsList<providersReport>("[usp_GetAllSalesProvidersReport]", Param);
            return dailyReportList;
        }
        internal List<providersReport> getDayProvidersReport(DateTime startDate, DateTime endDate, int paymentMode, int provider)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@paymentMode", paymentMode));
            Param.Add(new KeyValuePair<string, object>("@provider", provider));
            List<providersReport> dailyReportList = sqlHandler.ExecuteAsList<providersReport>("[usp_GetDaySalesProvidersReport]", Param);
            return dailyReportList;
        }
        internal List<providersReport> getSummaryProvidersReport(DateTime startDate, DateTime endDate, int paymentMode, int provider)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@paymentMode", paymentMode));
            Param.Add(new KeyValuePair<string, object>("@provider", provider));
            List<providersReport> dailyReportList = sqlHandler.ExecuteAsList<providersReport>("[usp_GetSummarySalesProvidersReport]", Param);
            return dailyReportList;
        }
        internal CardProvider getCardProviderById(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ProviderID", id));
            return sqlHandler.ExecuteAsObject<CardProvider>("[USP_RO_GETCARDPROVIDERBYID]", Param);
        }
        internal void deleteCardProvider(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ProviderID", id));
            sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_DELETECARDPROVIDER]", Param);
        }
        #endregion
        #region Report By Provider List
        public List<SalesMaster> GetReportByPaymentMode(DateTime dt, int SPMID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@date", dt));
            Param.Add(new KeyValuePair<string, object>("@SPMID", SPMID));
            return sqlHandler.ExecuteAsList<SalesMaster>("[USP_RO_REPORT_BYPAYMENTMODE]", Param);
        }
        #endregion
        internal List<salesSummaryByProviderMode> GetSalesSummaryByProviderMode(int mode, int id, DateTime dailyDate, DateTime weeklyDate, int month, int year)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@mode", mode));
                Param.Add(new KeyValuePair<string, object>("@id", id));
                Param.Add(new KeyValuePair<string, object>("@TodayDate", dailyDate));
                Param.Add(new KeyValuePair<string, object>("@WeeklyDate", weeklyDate));
                Param.Add(new KeyValuePair<string, object>("@Month", month));
                Param.Add(new KeyValuePair<string, object>("@Year", year));
                List<salesSummaryByProviderMode> salesSummary = sqlHandler.ExecuteAsList<salesSummaryByProviderMode>("[USP_SaleReportByPayementMode]", Param);
                return salesSummary;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal List<salesSummaryByProviderMode> GetSalesSummaryByProviderList(int id, int providerId, DateTime dailyDate, DateTime weeklyDate, int month, int year)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", id));
                Param.Add(new KeyValuePair<string, object>("@ProviderId", providerId));
                Param.Add(new KeyValuePair<string, object>("@TodayDate", dailyDate));
                Param.Add(new KeyValuePair<string, object>("@WeeklyDate", weeklyDate));
                Param.Add(new KeyValuePair<string, object>("@Month", month));
                Param.Add(new KeyValuePair<string, object>("@Year", year));
                List<salesSummaryByProviderMode> salesSummary = sqlHandler.ExecuteAsList<salesSummaryByProviderMode>("[USP_SaleReportByProviderList]", Param);
                return salesSummary;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public List<fiscalyear> getfiscalYear()
        {
            return sqlHandler.ExecuteAsList<fiscalyear>("usp_getfiscalYear");
        }
        //internal List<ItemsClass> getitemfromdatabase()
        //internal List<ItemsClass> getitemfromdatabase()
        //{
        //    try
        //    {
        //        List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
        //        
        //        List<ItemsClass> Iteminfo = sqlHandler.ExecuteAsList<ItemsClass>("[USP_RO_GETITEM]");
        //        return Iteminfo;
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
        internal List<ROInvItem> getitemfromdatabase()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<ROInvItem> Iteminfo = sqlHandler.ExecuteAsList<ROInvItem>("[USP_RO_GETIITEM]");
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        //MyApiData
        internal List<ROInvItemForApi> getItemListForApi()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<ROInvItemForApi> Iteminfo = sqlHandler.ExecuteAsList<ROInvItemForApi>("[USP_RO_getItemForApi]");
                //getcumbolist();
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<unitclassforitem> GetAllUnitforItem()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<unitclassforitem> Iteminfo = sqlHandler.ExecuteAsList<unitclassforitem>("[USP_ROI_FGETUNITB]");
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void SaveRoiItem(ROInvItem info, itemRate inforate)
        {
            if (info.ITId == 0)
            {
                using (TransactionScope ts = new TransactionScope())
                {
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@ITId", info.ITId));
                    Param.Add(new KeyValuePair<string, object>("@ITName", info.ITName));
                    Param.Add(new KeyValuePair<string, object>("@PITId", info.PITId));
                    Param.Add(new KeyValuePair<string, object>("@isMenu", info.IsMenu));
                    Param.Add(new KeyValuePair<string, object>("@IsActive", info.IsActive));
                    Param.Add(new KeyValuePair<string, object>("@IsCake", info.IsCake));
                    Param.Add(new KeyValuePair<string, object>("@IsWholeSale", info.IsWholeSale));
                    Param.Add(new KeyValuePair<string, object>("@IsRetail", info.IsRetail));
                    Param.Add(new KeyValuePair<string, object>("@AddedBy", info.AddedBy));
                    var obj = sqlHandler.ExecuteAsScalar<object>("[usp_RoiItemMainSave]", Param);
                    List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                    Param1.Add(new KeyValuePair<string, object>("@ItemDetailsID", info.ItemDetailsID));
                    Param1.Add(new KeyValuePair<string, object>("@ITId", Convert.ToInt32(obj)));
                    Param1.Add(new KeyValuePair<string, object>("@ITCode", info.ITCode));
                    Param1.Add(new KeyValuePair<string, object>("@CostCenterID", info.CostCenterID));
                    Param1.Add(new KeyValuePair<string, object>("@ImagePath", info.ImagePath));
                    Param1.Add(new KeyValuePair<string, object>("@MUnitId", info.MUnitId));
                    Param1.Add(new KeyValuePair<string, object>("@DSUnitId", info.DSUnitId));
                    Param1.Add(new KeyValuePair<string, object>("@DPUnitId", info.DPUnitId));
                    Param1.Add(new KeyValuePair<string, object>("@IsExpirable", info.IsExpirable));
                    Param1.Add(new KeyValuePair<string, object>("@IsProdMaterial", info.IsProdMaterial));
                    Param1.Add(new KeyValuePair<string, object>("@IsUnitWiseRate", info.IsUnitWiseRate));
                    Param1.Add(new KeyValuePair<string, object>("@ROrderLevel", info.ROrderLevel));
                    Param1.Add(new KeyValuePair<string, object>("@ItemCostCentreID", info.ItemCostCentreID));
                    Param1.Add(new KeyValuePair<string, object>("@Details", info.Details));
                    sqlHandler.ExecuteNonQuery("[usp_RoiItemDetailsSave]", Param1);

                    for (int i = 0; i < info.extradata.Count; i++)
                    {
                        List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                        Param3.Add(new KeyValuePair<string, object>("@ItemID", Convert.ToInt32(obj)));
                        Param3.Add(new KeyValuePair<string, object>("@ExtraItem", info.extradata[i].ExtraItem));
                        Param3.Add(new KeyValuePair<string, object>("@ExtraPrice", info.extradata[i].ExtraPrice));
                        sqlHandler.ExecuteNonQuery("usp_ro_extraitemsave", Param3);
                    }

                    List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                    Param2.Add(new KeyValuePair<string, object>("@ItemRateID", 0));
                    Param2.Add(new KeyValuePair<string, object>("@ItemID", Convert.ToInt32(obj)));
                    Param2.Add(new KeyValuePair<string, object>("@UnitID", inforate.UnitID));
                    Param2.Add(new KeyValuePair<string, object>("@PRate", inforate.PRate == 0 ? 0 : inforate.PRate));
                    Param2.Add(new KeyValuePair<string, object>("@SRate", inforate.SRate == 0 ? 0 : inforate.SRate));
                    Param2.Add(new KeyValuePair<string, object>("@PostedBy", inforate.PostedBy));
                    sqlHandler.ExecuteNonQuery("[USP_ROI_ITEMRATESAVE]", Param2);
                    ts.Complete();
                }
            }
            else
            {
                using (TransactionScope ts = new TransactionScope())
                {
                    List<KeyValuePair<string, object>> param2 = new List<KeyValuePair<string, object>>();
                    param2.Add(new KeyValuePair<string, object>("@ITId", info.ITId));
                    param2.Add(new KeyValuePair<string, object>("@ITName", info.ITName));
                    param2.Add(new KeyValuePair<string, object>("@PITId", info.PITId));
                    //param2.Add(new KeyValuePair<string, object>("@ItemDetailsID", info.ItemDetailsID));
                    param2.Add(new KeyValuePair<string, object>("@ITCode", info.ITCode));
                    param2.Add(new KeyValuePair<string, object>("@CostCenterID", info.ItemCostCentreID));
                    param2.Add(new KeyValuePair<string, object>("@ImagePath", info.ImagePath));
                    param2.Add(new KeyValuePair<string, object>("@MUnitId", info.MUnitId));
                    param2.Add(new KeyValuePair<string, object>("@DSUnitId", info.DSUnitId));
                    param2.Add(new KeyValuePair<string, object>("@DPUnitId", info.DPUnitId));
                    param2.Add(new KeyValuePair<string, object>("@IsExpirable", info.IsExpirable));
                    param2.Add(new KeyValuePair<string, object>("@IsProdMaterial", info.IsProdMaterial));
                    param2.Add(new KeyValuePair<string, object>("@IsUnitWiseRate", info.IsUnitWiseRate));
                    param2.Add(new KeyValuePair<string, object>("@ROrderLevel", info.ROrderLevel));
                    param2.Add(new KeyValuePair<string, object>("@PRate", inforate.PRate == 0 ? 0 : inforate.PRate));
                    param2.Add(new KeyValuePair<string, object>("@SRate", inforate.SRate == 0 ? 0 : inforate.SRate));
                    //Param2.Add(new KeyValuePair<string, object>("@ItemID", Convert.ToInt32(obj)));
                    param2.Add(new KeyValuePair<string, object>("@UnitID", inforate.UnitID));
                    //param2.Add(new KeyValuePair<string, object>("@ValidFrom", inforate.ValidFrom));
                    param2.Add(new KeyValuePair<string, object>("@PostedBy", inforate.PostedBy));
                    param2.Add(new KeyValuePair<string, object>("@isMenu", info.IsMenu));
                    param2.Add(new KeyValuePair<string, object>("@IsActive", info.IsActive));
                    sqlHandler.ExecuteNonQuery("[usp_ROIITEMUPDATE]", param2);
                    ts.Complete();
                }
            }
        }
        internal List<unitclassforitem> GetPareintItem(bool IsMenu = true)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@IsMenu", IsMenu));
                List<unitclassforitem> Iteminfo = sqlHandler.ExecuteAsList<unitclassforitem>("[usp_GetROIItemParint]", Param);
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ROInvItem> GetRoiItemfromDatabase()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<ROInvItem> Iteminfo = sqlHandler.ExecuteAsList<ROInvItem>("[USP_GetAllItemfromDatabases]");
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void DeleteROIiTEM(int Itemid, string userName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Itemid", Itemid));
            Param.Add(new KeyValuePair<string, object>("@ArchivedBy", userName));
            sqlHandler.ExecuteNonQuery("[USP_DeleteROI_Item]", Param);
        }
        public List<adjustmentMain> getAdjustmentDetails()
        {
            return sqlHandler.ExecuteAsList<adjustmentMain>("usp_getadjustmentDetails");
        }
        internal List<roistore> getIssueToDDlHirerchy()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<roistore> Iteminfo = sqlHandler.ExecuteAsList<roistore>("[USP_ROI_StoreByHirerchy]");
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<roistore> getIssueToDDl()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<roistore> Iteminfo = sqlHandler.ExecuteAsList<roistore>("[USP_ROI_Store]");
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal List<CostCenterGroup> GetCostCenterGroup()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<CostCenterGroup> Iteminfo = sqlHandler.ExecuteAsList<CostCenterGroup>("[USP_GetCostCenterGroup]");
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<CostCenterGroup> GetPOSCostCenterGroup()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<CostCenterGroup> Iteminfo = sqlHandler.ExecuteAsList<CostCenterGroup>("[USP_GetPOSCostCenterGroup]");
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }


        internal string IssueSave(issueMain IssueObject)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    string IsuueNo = "0";
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@IssuedToSTId", IssueObject.IssuedToSTId));
                    Param.Add(new KeyValuePair<string, object>("@IssuedFrSTId", IssueObject.IssuedFrSTId));
                    Param.Add(new KeyValuePair<string, object>("@IssuedOn", DateTime.Now));
                    Param.Add(new KeyValuePair<string, object>("@IssuedBy", IssueObject.IssuedBy));
                    Param.Add(new KeyValuePair<string, object>("@ReceivedBy", IssueObject.ReceivedBy));
                    issueMain a = sqlHandler.ExecuteAsObject<issueMain>("[USP_PO_SAVEISSUEMAIN]", Param);
                    IssueObject.IMId = a.IMId;
                    for (int i = 0; i < IssueObject.IssueObjectDetails.Count; i++)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@IssuedToSTId", IssueObject.IssuedToSTId));
                        Param1.Add(new KeyValuePair<string, object>("@IssuedFrSTId", IssueObject.IssuedFrSTId));
                        Param1.Add(new KeyValuePair<string, object>("@IMId", IssueObject.IMId));
                        Param1.Add(new KeyValuePair<string, object>("@ITID", IssueObject.IssueObjectDetails[i].ITID));
                        Param1.Add(new KeyValuePair<string, object>("@UsedUnitId", IssueObject.IssueObjectDetails[i].UsedUnitId));
                        Param1.Add(new KeyValuePair<string, object>("@Qnty", IssueObject.IssueObjectDetails[i].Qnty));
                        Param1.Add(new KeyValuePair<string, object>("@QntyInText", IssueObject.IssueObjectDetails[i].QntyInText));
                        Param1.Add(new KeyValuePair<string, object>("@ReceivedBy", IssueObject.IssueObjectDetails[i].ReceivedBy));
                        Param1.Add(new KeyValuePair<string, object>("@ReceivedOn", DateTime.Now));
                        sqlHandler.ExecuteNonQuery("[USP_PO_SAVIssueDETAILS]", Param1);
                    }
                    ts.Complete();
                    return a.ISNo;
                }
                catch (Exception)
                {
                    throw;
                }
            }
        }
        internal static List<UnitClass> getunitbyItem(string itemID)
        {
            try
            {
                SQLHandler sqlHandler = new SQLHandler();
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ItemNames", itemID));
                List<UnitClass> Unitinfo = sqlHandler.ExecuteAsList<UnitClass>("[USP_GetUnitByItem]", Param);
                return Unitinfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<MvPurchaseMain> getAutoNumber()
        {
            List<MvPurchaseMain> Unitinfo = sqlHandler.ExecuteAsList<MvPurchaseMain>("[USP_ROI_PURCHASEAUTONUMBER]");
            return Unitinfo;
        }
        internal List<MvPurchaseDetails> getPurchaseDetails()
        {
            //A
            List<MvPurchaseDetails> Unitinfo = sqlHandler.ExecuteAsList<MvPurchaseDetails>("[USP_ROI_GETPRUCHASEDETAILS]");
            return Unitinfo;
        }
        internal int GoodsReceivedss(goodsReceiveMain GoodReived, MemberInfo memberInfo, List<PurchasePayment> purchasePayment = null)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@GMNo", GoodReived.GMNo));
                    Param.Add(new KeyValuePair<string, object>("@STId", GoodReived.STId));
                    Param.Add(new KeyValuePair<string, object>("@PostedBy", GoodReived.PostedBy));
                    Param.Add(new KeyValuePair<string, object>("@PostedOn", DateTime.Now));
                    Param.Add(new KeyValuePair<string, object>("@InvoiceNo", GoodReived.InvoiceNo));
                    Param.Add(new KeyValuePair<string, object>("@InvoiceDate", GoodReived.InvoiceDate));
                    Param.Add(new KeyValuePair<string, object>("@vendorId", GoodReived.vendorId));
                    Param.Add(new KeyValuePair<string, object>("@paymentMode", GoodReived.paymentMode));
                    Param.Add(new KeyValuePair<string, object>("@ExtraDiscount", GoodReived.ExtraDiscount));
                    var a = sqlHandler.ExecuteAsScalar<object>("[USP_ROI_GoodReceivedmainSave]", Param);
                    GoodReived.GMId = Convert.ToInt32(a);
                    for (int i = 0; i < GoodReived.PurchaseObjItemBal.Count; i++)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@PDId", GoodReived.PurchaseObjItemBal[i].PDId));
                        Param1.Add(new KeyValuePair<string, object>("@ItemID", GoodReived.PurchaseObjItemBal[i].ITId));
                        Param1.Add(new KeyValuePair<string, object>("@STId", GoodReived.PurchaseObjItemBal[i].STId));
                        Param1.Add(new KeyValuePair<string, object>("@OPBal", GoodReived.PurchaseObjItemBal[i].OPBal));
                        Param1.Add(new KeyValuePair<string, object>("@CLBal", GoodReived.PurchaseObjItemBal[i].CLBal));
                        Param1.Add(new KeyValuePair<string, object>("@BillDate", GoodReived.BillDate));
                        var b = sqlHandler.ExecuteAsScalar<object>("[ROI_SAVEPURCHASEitembal]", Param1);
                        //ItemBal
                    }

                    for (int i = 0; i < GoodReived.PurchaseObjItemBal.Count; i++)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@GMId", GoodReived.GMId));
                        Param1.Add(new KeyValuePair<string, object>("@PDId", GoodReived.PurchaseObjItemBal[i].PDId));
                        Param1.Add(new KeyValuePair<string, object>("@Qnty", GoodReived.PurchaseObjItemBal[i].Qnty));
                        Param1.Add(new KeyValuePair<string, object>("@STId", GoodReived.PurchaseObjItemBal[i].STId));
                        Param1.Add(new KeyValuePair<string, object>("@Rate", GoodReived.PurchaseObjItemBal[i].Rate));
                        Param1.Add(new KeyValuePair<string, object>("@Total", GoodReived.PurchaseObjItemBal[i].Total));
                        Param1.Add(new KeyValuePair<string, object>("@Discount", GoodReived.PurchaseObjItemBal[i].Discount));
                        Param1.Add(new KeyValuePair<string, object>("@IsVat", GoodReived.PurchaseObjItemBal[i].IsVat));
                        sqlHandler.ExecuteNonQuery("[USP_ROI_GoodReceivedDetailsSave]", Param1);
                        //GoodsReceive
                    }

                    for (int i = 0; i < GoodReived.RecquistionObjectDetails.Count; i++)
                    {
                        List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                        Param2.Add(new KeyValuePair<string, object>("@RecqDetailId", GoodReived.RecquistionObjectDetails[i].RecqDetailId));
                        Param2.Add(new KeyValuePair<string, object>("@RecqId", GoodReived.RecquistionObjectDetails[i].RecqId));
                        Param2.Add(new KeyValuePair<string, object>("@IssueQuantity", GoodReived.RecquistionObjectDetails[i].IssueQuantity));
                        sqlHandler.ExecuteNonQuery("USP_UpdateReq_RecquistionDetails", Param2);
                    }

                    foreach (PurchasePayment pp in purchasePayment)
                    {
                        List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                        Param3.Add(new KeyValuePair<string, object>("@GMId", GoodReived.GMId));
                        Param3.Add(new KeyValuePair<string, object>("@paymentModeID", Convert.ToInt32(pp.paymentModeID)));
                        Param3.Add(new KeyValuePair<string, object>("@ChequeNo", pp.ChequeNo));
                        Param3.Add(new KeyValuePair<string, object>("@TransactionNo", pp.TransactionNo));
                        Param3.Add(new KeyValuePair<string, object>("@ProviderID", (pp.ProviderID == "" ? 0 : Convert.ToInt32(pp.ProviderID))));
                        Param3.Add(new KeyValuePair<string, object>("@VendorID", ((pp.VendorID == "" || pp.VendorID == null) ? 0 : Convert.ToInt32(pp.VendorID))));
                        Param3.Add(new KeyValuePair<string, object>("@VendorName", pp.VendorName));
                        Param3.Add(new KeyValuePair<string, object>("@PayAmount", pp.PayAmount));
                        Param3.Add(new KeyValuePair<string, object>("@Remarks", pp.Remarks));
                        Param3.Add(new KeyValuePair<string, object>("@PAN", pp.PAN));
                        sqlHandler.ExecuteNonQuery("USP_SavePurchasePaymentMode", Param3);

                        if (Convert.ToInt32(pp.paymentModeID) == 4)
                        {
                            RestoLoyaltyController dpobj = new RestoLoyaltyController();
                            MemberInfo meminfo = new MemberInfo();
                            meminfo.MembershipID = Convert.ToInt32(pp.VendorID);
                            meminfo.RemainingBalance = pp.PayAmount;
                            memberInfo.GoodReceivedMainId = GoodReived.GMId;
                            meminfo.PayAmount = pp.PayAmount;
                            meminfo.AddedBy = "";
                            dpobj.SaveCustomerAmount(meminfo);
                        }
                    }

                    List<KeyValuePair<string, object>> param5 = new List<KeyValuePair<string, object>>();
                    param5.Add(new KeyValuePair<string, object>("@GoodsReceivedMainID", GoodReived.GMId));
                    sqlHandler.ExecuteNonQuery("usp_SaveTransactionForPurchase", param5);
                    ts.Complete();
                    return GoodReived.GMId;
                }
                catch (Exception)
                {
                    throw;
                }
            }
        }
        internal List<goodsReceiveMain> GoodReceiveAutoNumber()
        {
            List<goodsReceiveMain> Unitinfo = sqlHandler.ExecuteAsList<goodsReceiveMain>("[USP_ROI_GoodsReceiveAUTONUMBER]");
            return Unitinfo;
        }
        internal void savestore(roistore rc, string UserName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@STId", rc.STId));
            Param.Add(new KeyValuePair<string, object>("@StName", rc.StName));
            Param.Add(new KeyValuePair<string, object>("@PSTId", rc.PSTId));
            Param.Add(new KeyValuePair<string, object>("@UserName", UserName));
            sqlHandler.ExecuteNonQuery("[USP_SAVESTORE]", Param);
        }
        internal string deleteStore(int empid, string UserName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@STId", empid));
            Param.Add(new KeyValuePair<string, object>("@UserName", UserName));
            //Param.Add(new KeyValuePair<string, object>("@text",""));
            var message = sqlHandler.ExecuteAsScalar<string>("[USP_DELETESTORE]", Param);
            string messages = message.ToString();
            return messages;
        }
        internal List<itemRate> GetItemRateList()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<itemRate> categoryList = sqlHandler.ExecuteAsList<itemRate>("[USP_ROI_GETITEMRATE]");
                return categoryList;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void DeleteItemRate(int ir)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ItemRateID", ir));
                sqlHandler.ExecuteNonQuery("[USP_ROI_DELETEITEMRATE]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void SaveItemRate(itemRate itemrate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemRateID", itemrate.ItemRateID));
            Param.Add(new KeyValuePair<string, object>("@ItemID", itemrate.ItemID));
            Param.Add(new KeyValuePair<string, object>("@UnitID", itemrate.UnitID));
            Param.Add(new KeyValuePair<string, object>("@PRate", itemrate.PRate));
            Param.Add(new KeyValuePair<string, object>("@SRate", itemrate.SRate));
            Param.Add(new KeyValuePair<string, object>("@ValidFrom", itemrate.ValidFrom));
            Param.Add(new KeyValuePair<string, object>("@PostedBy", itemrate.PostedBy));
            Param.Add(new KeyValuePair<string, object>("@PostedOn", DateTime.Now));
            sqlHandler.ExecuteNonQuery("[USP_ROI_ITEMRATESAVE]", Param);
        }
        internal List<roistore> getStoreList()
        {
            try
            {
                List<roistore> storeList = sqlHandler.ExecuteAsList<roistore>("[USP_ROI_Store]");
                return storeList;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void SaveStoreDataTodatabase(roistore storeInfo)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@storeId", storeInfo.StoreId));
            Param.Add(new KeyValuePair<string, object>("@storeName", storeInfo.StName));
            Param.Add(new KeyValuePair<string, object>("@ParentStoreId", storeInfo.PSTId));
            sqlHandler.ExecuteNonQuery("[USP_ROI_SAVESTORE]", Param);
        }
        internal List<ROInvItem> GetInvItemForOrderLevelFromDatabase(int p)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ParentId", p));
            List<ROInvItem> salesSummary = sqlHandler.ExecuteAsList<ROInvItem>("[USP_RO_GETINVITEM_OrderLevel]", Param);
            return salesSummary;
        }
        internal List<issueMain> issueautonumber()
        {
            List<issueMain> storeList = sqlHandler.ExecuteAsList<issueMain>("[USP_ROI_IssueAUTONUMBER]");
            return storeList;
        }
        internal List<MvPurchaseDetails> getitemidbyname(string itemname)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ITName", itemname));
            List<MvPurchaseDetails> storeList = sqlHandler.ExecuteAsList<MvPurchaseDetails>("[USP_ROI_Getpurchaseitemidbyname]", Param);
            return storeList;
        }
        internal List<goodsReceiveMain> getGoodsReceive(string PoNO)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@PoNO", PoNO));
            List<goodsReceiveMain> storeList = sqlHandler.ExecuteAsList<goodsReceiveMain>("[usp_roi_goodsreceive]", Param);
            return storeList;
        }
        internal void GoodsDelete(int GMId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@GMId", GMId));
            sqlHandler.ExecuteNonQuery("[usp_roi_goodsreceiveDelete]", Param);
        }
        internal List<MemberInfo> getVender()
        {
            List<MemberInfo> vander = sqlHandler.ExecuteAsList<MemberInfo>("[dbo].[usp_venderForDropDown]");
            return vander;
        }
        internal List<MvPurchaseDetails> GETITEMIDPOIDBYNAME(string ItemName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemName", ItemName));
            List<MvPurchaseDetails> storeList = sqlHandler.ExecuteAsList<MvPurchaseDetails>("[USP_ROI_GETITEMIDPOIDBYNAME]", Param);
            return storeList;
        }
        internal void SaveAdjsment(adjustmentMain AdjustMain)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@AMNo", AdjustMain.AMNo));
                    Param.Add(new KeyValuePair<string, object>("@STId", AdjustMain.STId));
                    Param.Add(new KeyValuePair<string, object>("@FYId", AdjustMain.FYId));
                    Param.Add(new KeyValuePair<string, object>("@Remarks", AdjustMain.Remarks));
                    Param.Add(new KeyValuePair<string, object>("@PostedBy", AdjustMain.PostedBy));
                    Param.Add(new KeyValuePair<string, object>("@PostedOn", DateTime.Now));
                    var a = sqlHandler.ExecuteAsScalar<object>("[USP_ROI_AdjustmentmainSave]", Param);
                    AdjustMain.AMId = Convert.ToInt32(a);
                    for (int i = 0; i < AdjustMain.AdjstmentObjectDetails.Count; i++)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@STID", AdjustMain.STId));
                        Param1.Add(new KeyValuePair<string, object>("@AMId", AdjustMain.AMId));
                        Param1.Add(new KeyValuePair<string, object>("@ITId", AdjustMain.AdjstmentObjectDetails[i].ITId));
                        Param1.Add(new KeyValuePair<string, object>("@UsedUnitId", AdjustMain.AdjstmentObjectDetails[i].UsedUnitId));
                        Param1.Add(new KeyValuePair<string, object>("@Qnty", AdjustMain.AdjstmentObjectDetails[i].Qnty));
                        Param1.Add(new KeyValuePair<string, object>("@QntyInText", AdjustMain.AdjstmentObjectDetails[i].QntyInText));
                        Param1.Add(new KeyValuePair<string, object>("@AdType", AdjustMain.AdjstmentObjectDetails[i].AdType));
                        Param1.Add(new KeyValuePair<string, object>("@IsAdd", AdjustMain.AdjstmentObjectDetails[i].IsAdd));
                        //Param1.Add(new KeyValuePair<string, object>("@PDId", AdjustMain.AdjstmentObjectDetails[i].PDId));
                        sqlHandler.ExecuteNonQuery("[USP_ROI_AdjustmentDetailsSave]", Param1);
                    }
                    ts.Complete();
                }
                catch (Exception)
                {
                    throw;
                }
            }
        }
        public List<purchaseMains> getPurchaseList(string startDate, string endDate)
        {
            List<KeyValuePair<string, object>> param = new List<KeyValuePair<string, object>>();
            param.Add(new KeyValuePair<string, object>("@StartDate", startDate));
            param.Add(new KeyValuePair<string, object>("@EndDate", endDate));
            List<purchaseMains> lst = sqlHandler.ExecuteAsList<purchaseMains>("usp_ROI_Purchase_Listing", param);
            return lst;
        }
        internal List<adjustmentMain> getadjustment()
        {
            List<adjustmentMain> vander = sqlHandler.ExecuteAsList<adjustmentMain>("[dbo].[USP_GETADJSMENT]");
            return vander;
        }
        internal List<adjustmentMain> getAdjustmentAutoNumber()
        {
            List<adjustmentMain> vander = sqlHandler.ExecuteAsList<adjustmentMain>("[dbo].[USP_ROI_Adjustment]");
            return vander;
        }
        public void ajustdelete(int AMId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@AMId", AMId));
            sqlHandler.ExecuteAsList<restroTable>("USP_ROI_DELETEAJDUSTMENT", Param);
        }
        public List<issueMain> getissuemain()
        {
            List<issueMain> vander = sqlHandler.ExecuteAsList<issueMain>("[dbo].[USP_ROI_GETISSUES]");
            return vander;
        }
        internal void DELETEissue(int IMId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@IMId", IMId));
            sqlHandler.ExecuteAsList<restroTable>("usp_roideleteissue", Param);
        }
        internal void deletePurchase(int mainId, int detailsId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@PurchaseMainID", mainId));
            Param.Add(new KeyValuePair<string, object>("@PurchaseDetailsID", detailsId));
            sqlHandler.ExecuteNonQuery("[dbo].[usp_purchase_delete]", Param);
        }
        internal List<stockReport> stockreportdaily(DateTime TodayDate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@TodayDate", TodayDate));
            return sqlHandler.ExecuteAsList<stockReport>("USP_STOCKREPORT", Param);
        }
        internal List<stockReport> stockreportWeekly(DateTime TodayDate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", TodayDate));
            return sqlHandler.ExecuteAsList<stockReport>("USP_STOCKREPORTWEEKLY", Param);
        }
        internal List<stockReport> stockreportMonthly(string year, string month)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            Param.Add(new KeyValuePair<string, object>("@month", month));
            return sqlHandler.ExecuteAsList<stockReport>("USP_STOCKREPORTMONTHLY", Param);
        }
        internal List<stockReport> stockreportYear(string year)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            return sqlHandler.ExecuteAsList<stockReport>("USP_STOCKREPORTYEAR", Param);
        }
        internal List<stockReport> stockreportRange(DateTime StartDate, DateTime EndDate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@StardDate", StartDate));
            Param.Add(new KeyValuePair<string, object>("@EndDate", EndDate));
            return sqlHandler.ExecuteAsList<stockReport>("USP_STOCKREPORTRANGE", Param);
        }
        internal List<MvPurchaseDetails> getgoodreceiveforissue()
        {
            //A
            List<MvPurchaseDetails> Unitinfo = sqlHandler.ExecuteAsList<MvPurchaseDetails>("[USP_ROI_GETITEMFORGOODS]");
            return Unitinfo;
        }
        internal int GetItemRateIdByItemId(int empid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemID", empid));
            var Unitinfo = sqlHandler.ExecuteAsScalar<object>("[USP_ROI_GetItemRateIdByItemId]", Param);
            return Convert.ToInt32(Unitinfo);
        }
        internal List<CategoriesClass> txtSearchForItem(string ItemName, int languageid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemName", ItemName));
            Param.Add(new KeyValuePair<string, object>("@LanguageID", languageid));
            List<CategoriesClass> storeList = sqlHandler.ExecuteAsList<CategoriesClass>("[USP_ROI_txtSearchForItem]", Param);
            return storeList;
        }
        internal List<MvPurchaseDetails> GetItemForSearch()
        {
            return sqlHandler.ExecuteAsList<MvPurchaseDetails>("[USP_ROI_GetItemForSearch]");
        }
        internal List<MvPurchaseDetails> GetItemForWholeSaleSearch(string LookUpName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@LookUpName", LookUpName));
            List<MvPurchaseDetails> list = sqlHandler.ExecuteAsList<MvPurchaseDetails>("[USP_ROI_GetItemForWholeSaleSearch]", Param);
            return list;
        }
        internal List<extraItem> GetItemExtraListByItemID(int ItemId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemId", ItemId));
            List<extraItem> storeList = sqlHandler.ExecuteAsList<extraItem>("[USP_ROI_GetItemExtraListByItemID]", Param);
            return storeList;
        }
        internal List<OrderDetailClass> GetdataforViewBill(int TableId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OrderMasterID", TableId));
                List<OrderDetailClass> list = new List<OrderDetailClass>();
                list = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_GetdataforViewBill]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<OrderDetailClass> GetdataforViewCakeBill(int TableId, string SalesType)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@SalesMasterId", TableId));
                Param.Add(new KeyValuePair<string, object>("@SalesType", SalesType));
                List<OrderDetailClass> list = new List<OrderDetailClass>();
                list = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_CAKE_GetdataforViewBill]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<CardProvider> getCusName(int IsCustomer)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@IsCustomer", IsCustomer));
            return sqlHandler.ExecuteAsList<CardProvider>("[usp_GetCustomerBalanceByID]", Param);
        }
        internal List<dailyreport> getdailyReportByReportNumber(DateTime startdate, DateTime enddate, int ReportNum)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Todaydate", startdate));
            Param.Add(new KeyValuePair<string, object>("@enddate", enddate));
            Param.Add(new KeyValuePair<string, object>("@ReportNum", ReportNum));
            List<dailyreport> dailyReportList = sqlHandler.ExecuteAsList<dailyreport>("[USP_SALSEREPORTBtodayByReportNum]", Param);
            return dailyReportList;
        }
        internal List<dailyreport> getdailyCusReportByMonthly(string year, string month)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            Param.Add(new KeyValuePair<string, object>("@month", month));
            return sqlHandler.ExecuteAsList<dailyreport>("[USP_GETDATABYMONTHLY_CUS]", Param);
        }
        internal List<dailyreport> getdailyReportByWeeklyByReportNumber(DateTime dateTime, int ReportNum)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", dateTime));
            Param.Add(new KeyValuePair<string, object>("@ReportNum", ReportNum));
            return sqlHandler.ExecuteAsList<dailyreport>("[getdailyReportByWeeklyByReportNumber]", Param);
        }
        internal List<dailyreport> getdailyCusReportByYearly(string year)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            return sqlHandler.ExecuteAsList<dailyreport>("[USP_GETDATABYYEARLY_CUS]", Param);
        }
        internal List<dailyreport> GetMemberReport(int MembershipID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@MembershipID", MembershipID));
            return sqlHandler.ExecuteAsList<dailyreport>("[USP_GET_MEMBER_CREDIT_REPORT]", Param);
        }
        internal List<dailyreport> getdailyReportByMonthlyByReportNumber(string year, string month, int ReportNum)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            Param.Add(new KeyValuePair<string, object>("@month", month));
            Param.Add(new KeyValuePair<string, object>("@ReportNum", ReportNum));
            return sqlHandler.ExecuteAsList<dailyreport>("[USP_GETDATABYMONTHLYByReportNumber]", Param);
        }
        internal List<dailyreport> getdailyReportByYearlyByReportNumber(string year, int ReportNum)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            Param.Add(new KeyValuePair<string, object>("@ReportNum", ReportNum));
            return sqlHandler.ExecuteAsList<dailyreport>("[USP_GETDATABYYEARLYByReportNumber]", Param);
        }
        internal List<dailyreport> getdailyReportBySumByReportNumber(DateTime dateTime, int ReportNum)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Todaydate", dateTime));
            Param.Add(new KeyValuePair<string, object>("@ReportNum", ReportNum));
            return sqlHandler.ExecuteAsList<dailyreport>("[usp_ro_getbasicsumamountByReportNumber]", Param);
        }
        internal List<dailyreport> getweeklysumbyDateByReportNumber(DateTime dateTime, int ReportNum)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", dateTime));
            Param.Add(new KeyValuePair<string, object>("@ReportNum", ReportNum));
            return sqlHandler.ExecuteAsList<dailyreport>("[usp_ro_sumweeklyByReportNumber]", Param);
        }
        public List<costCenter> KitchenOrderApi()
        {
            try
            {
                RestrOrderProvider rop = new RestrOrderProvider();
                List<costCenter> list = new List<costCenter>();
                list = rop.getcostcenter();
                foreach (costCenter roomtype in list)
                {
                    List<OrderDetailClass> lists = RestrOrderProvider.getitemprocessings(roomtype.CostCenterID);
                    roomtype.tableList = lists;
                }
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal string SavePrintCountDetail(int Printcount, string BillNo, string PrintedBy, string SalesType = "")
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Printcount", Printcount));
            Param.Add(new KeyValuePair<string, object>("@BillNo", BillNo));
            Param.Add(new KeyValuePair<string, object>("@PrintedBy", PrintedBy));
            Param.Add(new KeyValuePair<string, object>("@SalesType", SalesType));
            return sqlHandler.ExecuteAsScalar<string>("[usp_ro_SavePrintCountDetail]", Param);
        }
        internal List<PrintDetail> getPrintedDetailByBillNo(string billNo)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@billNo", billNo));
            return sqlHandler.ExecuteAsList<PrintDetail>("[usp_ro_getPrintedDetailByBillNo]", Param);
        }
        public static List<OrderDetailClass> getitemprocessings(int costcenterID)
        {
            SQLHandler sqlHandler = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CostCenterId", costcenterID));
            List<OrderDetailClass> list = new List<OrderDetailClass>();
            list = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_GetDataFromCostCenterID]", Param);
            return list;
        }
        internal FiscalYear GetRONumberByFiscalYear()
        {
            FiscalYear list = sqlHandler.ExecuteAsObject<FiscalYear>("[usp_ro_getRONumberByFiscalYear]");
            return list;
        }
        internal List<ROInvItem> getitemwithRate(int ItemID)//
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemID", ItemID));
            List<ROInvItem> list = new List<ROInvItem>();
            list = sqlHandler.ExecuteAsList<ROInvItem>("[USP_RO_getitemlistwithrate]", Param);
            return list;
        }
        internal List<ROInvItem> getitemwithRateForCombo(int ItemID)//getitemwithRateForCombo
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemID", ItemID));
            List<ROInvItem> list = new List<ROInvItem>();
            list = sqlHandler.ExecuteAsList<ROInvItem>("[USP_RO_getCombolistwithrate]", Param);
            return list;
        }
        internal List<FiscalYearInfo> GetCurrentActiveFiscalYear()
        {
            List<FiscalYearInfo> list = sqlHandler.ExecuteAsList<FiscalYearInfo>("[usp_ro_GetCurrentActiveFiscalYear]");
            return list;
        }
        internal void CancelBillWithReason(int id, string userName, string reason, bool restoreOrder, bool? isWholesale = false)
        {
            try
            {

                if (isWholesale != false)
                {

                }
                else
                {
                    if (restoreOrder)
                    {
                        List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                        Param2.Add(new KeyValuePair<string, object>("@salesMasterId", id));
                        Param2.Add(new KeyValuePair<string, object>("@userName", userName));
                        sqlHandler.ExecuteNonQuery("[USP_RO_restoreOrder]", Param2);
                    }

                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@salesMasterId", id));
                    Param.Add(new KeyValuePair<string, object>("@Reasons", reason));
                    Param.Add(new KeyValuePair<string, object>("@userName", userName));
                    sqlHandler.ExecuteNonQuery("[USP_RO_CancelReason]", Param);
                    // removed sales return

                    //List<SalesDetailClass> salesDetail = new List<SalesDetailClass>();

                    //List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                    //Param3.Add(new KeyValuePair<string, object>("@salesMasterId", id));
                    //salesDetail = sqlHandler.ExecuteAsList<SalesDetailClass>("[USP_GetSalesDetailClass]", Param3);

                    //foreach (var item in salesDetail)
                    //{
                    //    List<KeyValuePair<string, object>> Param4 = new List<KeyValuePair<string, object>>();
                    //    Param4.Add(new KeyValuePair<string, object>("@ItemID", item.ItemId));
                    //    Param4.Add(new KeyValuePair<string, object>("@SalesDetailId", item.SalesDetailId));
                    //    Param4.Add(new KeyValuePair<string, object>("@STId", item.StoreId));
                    //    Param4.Add(new KeyValuePair<string, object>("@SalesReturnQty", item.SalesQty));
                    //    Param4.Add(new KeyValuePair<string, object>("@SalesReturnUnit", item.SalesUnit));
                    //    Param4.Add(new KeyValuePair<string, object>("@SalesReturnAmt", item.SalesAmt));
                    //    sqlHandler.ExecuteNonQuery("[dbo].[ROI_SAVESalesReturnItemBal]", Param4);
                    //}
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal void CancelBill(int id, string userName, string reason, bool restoreOrder)
        {
            if (restoreOrder)
            {
                List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                Param2.Add(new KeyValuePair<string, object>("@salesMasterId", id));
                Param2.Add(new KeyValuePair<string, object>("@userName", userName));
                sqlHandler.ExecuteNonQuery("[USP_RO_restoreOrder]", Param2);
            }

            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@salesMasterId", id));
            Param.Add(new KeyValuePair<string, object>("@Reasons", reason));
            Param.Add(new KeyValuePair<string, object>("@userName", userName));
            //List<OrderDetailClass> list = new List<OrderDetailClass>();
            sqlHandler.ExecuteNonQuery("[USP_RO_BillCancelReason]", Param);

            List<SalesDetailClass> salesDetail = new List<SalesDetailClass>();

            List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
            Param3.Add(new KeyValuePair<string, object>("@salesMasterId", id));
            salesDetail = sqlHandler.ExecuteAsList<SalesDetailClass>("[USP_GetSalesDetailClass]", Param3);

            foreach (var item in salesDetail)
            {
                List<KeyValuePair<string, object>> Param4 = new List<KeyValuePair<string, object>>();
                Param4.Add(new KeyValuePair<string, object>("@ItemID", item.ItemId));
                Param4.Add(new KeyValuePair<string, object>("@SalesDetailId", item.SalesDetailId));
                Param4.Add(new KeyValuePair<string, object>("@STId", item.StoreId));
                Param4.Add(new KeyValuePair<string, object>("@SalesReturnQty", item.SalesQty));
                Param4.Add(new KeyValuePair<string, object>("@SalesReturnUnit", item.SalesUnit));
                Param4.Add(new KeyValuePair<string, object>("@SalesReturnAmt", item.SalesAmt));
                sqlHandler.ExecuteNonQuery("[dbo].[ROI_SAVESalesReturnItemBal]", Param4);
            }

        }

        internal void ChangePaymentMode(List<SalesPayment> salesPayment)
        {

            using (TransactionScope ts = new TransactionScope())
            {
                int smId = salesPayment.FirstOrDefault().salesMasterId;

                if (salesPayment.Count > 0)
                {
                    List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                    Param1.Add(new KeyValuePair<string, object>("@SalesMasterId", smId));
                    sqlHandler.ExecuteNonQuery("[dbo].[usp_SaveTransactionForSalesReturn]", Param1);

                    //List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                    //Param2.Add(new KeyValuePair<string, object>("@SalesMasterId", smId));
                    //sqlHandler.ExecuteNonQuery("[dbo].[usp_RO_ArchivePaymentMethod]", Param2);

                    foreach (SalesPayment sp in salesPayment)
                    {
                        List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                        Param.Add(new KeyValuePair<string, object>("@salesMasterId", sp.salesMasterId));
                        Param.Add(new KeyValuePair<string, object>("@SPMID", Convert.ToInt32(sp.SPMID)));
                        Param.Add(new KeyValuePair<string, object>("@ChequeNo", sp.ChequeNo));
                        Param.Add(new KeyValuePair<string, object>("@TransactionNo", sp.TransactionNo));
                        Param.Add(new KeyValuePair<string, object>("@ProviderID", (sp.ProviderID == "" ? 0 : Convert.ToInt32(sp.ProviderID))));
                        Param.Add(new KeyValuePair<string, object>("@CusID", ((sp.CusID == "" || sp.CusID == null) ? 0 : Convert.ToInt32(sp.CusID))));
                        Param.Add(new KeyValuePair<string, object>("@Customer", sp.Customer));
                        Param.Add(new KeyValuePair<string, object>("@Address", sp.Address));
                        Param.Add(new KeyValuePair<string, object>("@PAN", sp.PAN));
                        Param.Add(new KeyValuePair<string, object>("@PayAmount", sp.PayAmount));
                        Param.Add(new KeyValuePair<string, object>("@TenderAmount", sp.TenderAmount));
                        Param.Add(new KeyValuePair<string, object>("@ReturnAmount", sp.ReturnAmount));
                        Param.Add(new KeyValuePair<string, object>("@Remarks", sp.Remarks));
                        sqlHandler.ExecuteNonQuery("[usp_RO_UpdatePaymentMethod]", Param);
                    }
                    List<KeyValuePair<string, object>> param5 = new List<KeyValuePair<string, object>>();
                    param5.Add(new KeyValuePair<string, object>("@SalesMasterID", salesPayment[0].salesMasterId));
                    sqlHandler.ExecuteNonQuery("usp_SaveTransactionForSales", param5);
                }
                //else
                //{
                //    List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                //    Param3.Add(new KeyValuePair<string, object>("@SalesMasterId", smId));
                //    Param3.Add(new KeyValuePair<string, object>("@CustomerName", billInfo.Customer));
                //    Param3.Add(new KeyValuePair<string, object>("@CusId", billInfo.CusId));
                //    Param3.Add(new KeyValuePair<string, object>("@PAN", billInfo.PAN));
                //    Param3.Add(new KeyValuePair<string, object>("@Remarks", billInfo.Remarks));
                //    sqlHandler.ExecuteNonQuery("[dbo].[USP_ChangeBillInfo]", Param3);

                //}

                ts.Complete();



            }
        }

        // }
        internal List<UserInfo> GetUsersDetail(Guid guid, string Username)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@UserId", guid));
            Param.Add(new KeyValuePair<string, object>("@Username", Username));
            List<UserInfo> list = sqlHandler.ExecuteAsList<UserInfo>("[USP_RO_GetUsersDetail]", Param);
            return list;
        }
        internal List<dailyreport> getdailyReportByWeeklyForCancelledBill(DateTime dateTime)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", dateTime));
            return sqlHandler.ExecuteAsList<dailyreport>("[USP_SALSEREPORTBYWEEKLY]", Param);
        }
        internal List<dailyreport> getdailyReportByMonthlyForCancelledBill(string year, string month)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", year));
            Param.Add(new KeyValuePair<string, object>("@FromDate", month));
            return sqlHandler.ExecuteAsList<dailyreport>("[USP_CancelledBillBYMONTHLY]", Param);
        }
        internal List<dailyreport> getdailyReportByYearlyForCancelledBill(string year)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", year));
            return sqlHandler.ExecuteAsList<dailyreport>("[USP_CancelledBillBYYEARLY]", Param);
        }
        internal List<MaterializedReport> MaterializedReportView(DateTime StartDate, DateTime EndDate, int Valid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@StartDate", StartDate));
            Param.Add(new KeyValuePair<string, object>("@EndDate", EndDate));
            Param.Add(new KeyValuePair<string, object>("@Valid", Valid));
            return sqlHandler.ExecuteAsList<MaterializedReport>("[usp_MaterializedReportView]", Param);
        }
        internal DataTable GetAllTableDataByTableName(string TableName)
        {
            DataSet ds = new DataSet();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@TableName", TableName));
            ds = sqlHandler.ExecuteAsDataSet("USP_RO_GetAllTableDataByTableName", Param);
            return ds.Tables[0];
        }
        internal DataSet GetAllTableName()
        {
            DataSet ds = new DataSet();
            ds = sqlHandler.ExecuteAsDataSet("USP_RO_GetAllTableName");
            return ds;
        }
        internal void PayseatnoBill(List<OrderDetailClass> lst)
        {
            foreach (var item in lst)
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OrderMasterId", item.OrderMasterId));
                Param.Add(new KeyValuePair<string, object>("@OrderDetailsID", item.OrderDetailsID));
                Param.Add(new KeyValuePair<string, object>("@SeatNo", item.SeatNo));
                sqlHandler.ExecuteNonQuery("[usp_ro_PayseatnoBill]", Param);
            }
        }
        internal List<OrderDetailClass> GetDataforPrintBySeatNo(int TableId, string Seatno)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@TableId", TableId));
                Param.Add(new KeyValuePair<string, object>("@Seatno", Convert.ToInt32(Seatno)));
                List<OrderDetailClass> list = new List<OrderDetailClass>();
                list = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_GetDataforPrintBySeatNo]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<unitclassforitem> getchangeunit(int unitid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@unitid", unitid));
            return sqlHandler.ExecuteAsList<unitclassforitem>("[USP_ROI_GETCHANGEUNIT]", Param);
        }
        internal void SaveSplittedData(List<OrderDetailClass> ItemsArray)
        {
            foreach (OrderDetailClass item in ItemsArray)
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OrderDetailsID", item.OrderDetailsID));
                Param.Add(new KeyValuePair<string, object>("@SeatNo", item.SeatNo));
                Param.Add(new KeyValuePair<string, object>("@restrotableId", item.restrotableId));
                sqlHandler.ExecuteNonQuery("[USP_ROI_SaveSplittedData]", Param);
            }
        }
        public void SaveAdjustmentType(AdjustmentType type)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@AdjustmentTypeName", type.AdjustmentTypeName));
            Param.Add(new KeyValuePair<string, object>("@IsActive", type.IsActive));
            Param.Add(new KeyValuePair<string, object>("@AddedBy", type.AddedBy));
            sqlHandler.ExecuteNonQuery("[USP_ROI_SaveAdjustmentType]", Param);
        }
        public List<AdjustmentType> getadjustmentType()
        {
            List<AdjustmentType> lst = sqlHandler.ExecuteAsList<AdjustmentType>("[USP_ROI_getadjustmentType]");
            return lst;
        }
        public AdjustmentType GettypedatabyId(int TypeId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@TypeId", TypeId));
            return sqlHandler.ExecuteAsObject<AdjustmentType>("[USP_ROI_GettypedatabyId]", Param);
        }
        public void EditAdjustmentType(int TypeId, string Name, bool IsActive, string Username)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@TypeId", TypeId));
            Param.Add(new KeyValuePair<string, object>("@AdjustmentTypeName", Name));
            Param.Add(new KeyValuePair<string, object>("@IsActive", IsActive == true ? 1 : 0));
            Param.Add(new KeyValuePair<string, object>("@Username", Username));
            sqlHandler.ExecuteAsObject<AdjustmentType>("[USP_ROI_EditAdjustmentType]", Param);
        }
        internal void DeleteAdjustmentType(int id, string Username)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@id", id));
            Param.Add(new KeyValuePair<string, object>("@Username", Username));
            sqlHandler.ExecuteNonQuery("[USP_ROI_DeleteAdjustmentType]", Param);
        }
        internal List<ItemsClass> getItemRateByItem(string ItemName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemName", ItemName));
            return sqlHandler.ExecuteAsList<ItemsClass>("[USP_RO_GETITEMRATEBYITEMNAME]", Param);
        }
        internal List<ItemsClass> getitemforcumbo()
        {
            List<ItemsClass> list = sqlHandler.ExecuteAsList<ItemsClass>("[USP_GETITEMFORCUMBO]");
            return list;
        }
        internal int restroCombo(cumbomain comboorder)
        {
            //   using (TransactionScope ts = new TransactionScope())
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ComboID", comboorder.ComboID));
                Param.Add(new KeyValuePair<string, object>("@Name", comboorder.Name));
                Param.Add(new KeyValuePair<string, object>("@CostCenter", comboorder.CostCenter));
                Param.Add(new KeyValuePair<string, object>("@Description", comboorder.Description));
                Param.Add(new KeyValuePair<string, object>("@ComboCode", comboorder.ComboCode));
                Param.Add(new KeyValuePair<string, object>("@ImagePath", comboorder.ImagePath));
                Param.Add(new KeyValuePair<string, object>("@StartDate", comboorder.StartDate));
                Param.Add(new KeyValuePair<string, object>("@EndDate", comboorder.EndDate));
                Param.Add(new KeyValuePair<string, object>("@SalesPrice", comboorder.SalesPrice));
                Param.Add(new KeyValuePair<string, object>("@ItemsSalesCost", comboorder.ItemsSalesCost));
                Param.Add(new KeyValuePair<string, object>("@IsActive", comboorder.IsActive));
                Param.Add(new KeyValuePair<string, object>("@AddedBy", comboorder.AddedBy));
                //var obj = sqlHandler.ExecuteAsScalar<object>("[USP_RO_COMBOSAVE]", Param);
                //comboorder.ComboID = Convert.ToInt32(obj);
                int ids = sqlHandler.ExecuteAsScalar<int>("[USP_RO_COMBOSAVE]", Param);
                List<KeyValuePair<string, object>> Para = new List<KeyValuePair<string, object>>();
                Para.Add(new KeyValuePair<string, object>("@ComboID", ids));
                sqlHandler.ExecuteNonQuery("[usp_ro_removecombodetails]", Para);
                for (int i = 0; i < comboorder.CumboPackDetails.Count; i++)
                {
                    List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                    Param2.Add(new KeyValuePair<string, object>("@ComboID", ids));
                    Param2.Add(new KeyValuePair<string, object>("@ItemID", comboorder.CumboPackDetails[i].ItemID));
                    Param2.Add(new KeyValuePair<string, object>("@ItemRate", comboorder.CumboPackDetails[i].ItemRate));
                    Param2.Add(new KeyValuePair<string, object>("@Quantity", comboorder.CumboPackDetails[i].Quantity));
                    Param2.Add(new KeyValuePair<string, object>("@TotalPrice", comboorder.CumboPackDetails[i].TotalPrice));
                    sqlHandler.ExecuteNonQuery("[USP_RO_COMBOSAVEDETAILS]", Param2);
                }
                return ids;
            }
            catch
            {
                throw;
            }
        }

        internal List<cumbomain> getcumbolist(bool activeOnly)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@activeOnly", activeOnly));
            List<cumbomain> list = sqlHandler.ExecuteAsList<cumbomain>("[USP_RO_GETCUMBO]", Param);
            return list;
        }

        internal void DELETECOMBO(int comboid, string UserName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ComboID", comboid));
            Param.Add(new KeyValuePair<string, object>("@UserName", UserName));
            sqlHandler.ExecuteNonQuery("[USP_RO_DELETECOMBO]", Param);
        }

        internal List<unitclassforitem> GetAllUnitforItem(int unit)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@smallUnit", unit));
                List<unitclassforitem> Iteminfo = sqlHandler.ExecuteAsList<unitclassforitem>("[usp_LargeUnitBySmallUnit]", Param);
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal List<ROInvItem> GetRoiItemForCategory()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<ROInvItem> Iteminfo = sqlHandler.ExecuteAsList<ROInvItem>("[USP_GetAllItemforCategory]");
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal List<ROInvItem> GetRoiItemForCategoryHirerchy()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                List<ROInvItem> Iteminfo = sqlHandler.ExecuteAsList<ROInvItem>("[USP_GetAllItemforCategoryHirerchy]");
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal int saveItems(ROInvItem itemObject, List<extraItem> extraItemList = null)
        {
            try
            {
                List<KeyValuePair<string, dynamic>> Param = new List<KeyValuePair<string, dynamic>>
                {
                    new KeyValuePair<string, dynamic>("@ITId", itemObject.ITId),
                    new KeyValuePair<string, dynamic>("@PITId", itemObject.PITId),
                    new KeyValuePair<string, dynamic>("@ITName", itemObject.ITName),
                    new KeyValuePair<string, dynamic>("@IsMenu", itemObject.IsMenu),
                    new KeyValuePair<string, dynamic>("@IsActive", itemObject.IsActive),
                    new KeyValuePair<string, dynamic>("@IsTaxable", itemObject.IsTaxable),
                    new KeyValuePair<string, dynamic>("@AddedBy", itemObject.AddedBy),
                    new KeyValuePair<string, dynamic>("@HsCode", itemObject.HsCode)

                };
                int ids = sqlHandler.ExecuteAsScalar<int>("[usp_roi_SaveItemsOfRestro]", Param);

                if (ids > 0)
                {
                    List<KeyValuePair<string, dynamic>> Param4 = new List<KeyValuePair<string, dynamic>>
                    {
                        new KeyValuePair<string, dynamic>("@ITId", ids),
                        new KeyValuePair<string, dynamic>("@ITCode", itemObject.ITCode),
                        new KeyValuePair<string, dynamic>("@ImagePath", itemObject.ImagePath),
                        new KeyValuePair<string, dynamic>("@IsExpirable", itemObject.IsExpirable),
                        new KeyValuePair<string, dynamic>("@IsProdMaterial", itemObject.IsProdMaterial),
                        new KeyValuePair<string, dynamic>("@IsUnitWiseRate", itemObject.IsUnitWiseRate),
                        new KeyValuePair<string, dynamic>("@ItemCostCentreID", itemObject.ItemCostCentreID),
                        new KeyValuePair<string, dynamic>("@Details", itemObject.Details),
                        new KeyValuePair<string, dynamic>("@SmallUnit", itemObject.SmallUnit),
                        new KeyValuePair<string, dynamic>("@AddedBy", itemObject.AddedBy),
                        new KeyValuePair<string, dynamic>("@IsExtra", itemObject.IsExtra),
                        new KeyValuePair<string, dynamic>("@HsCode", itemObject.HsCode)
                    };
                    sqlHandler.ExecuteNonQuery("[usp_roi_SaveItemsDetailsOfRestro]", Param4);

                    if (itemObject.ItemWithUnit != null && itemObject.ItemWithUnit.Count > 0)
                    {
                        foreach (itemWithUnit info in itemObject.ItemWithUnit)
                        {
                            List<KeyValuePair<string, dynamic>> Param2 = new List<KeyValuePair<string, dynamic>>
                            {
                                new KeyValuePair<string, dynamic>("@ItemID", ids),
                                new KeyValuePair<string, dynamic>("@SalesRate", info.SalesRate),
                                new KeyValuePair<string, dynamic>("@ValidFrom", info.ValidFrom),
                                new KeyValuePair<string, dynamic>("@AddedBy", info.AddedBy)
                            };
                            sqlHandler.ExecuteNonQuery("[usp_SaveItemWithUnit]", Param2);
                        }
                    }

                    List<KeyValuePair<string, dynamic>> Para = new List<KeyValuePair<string, dynamic>>();
                    Para.Add(new KeyValuePair<string, dynamic>("@ItemID", ids));
                    sqlHandler.ExecuteNonQuery("[usp_ro_removeextraitemsforitem]", Para);

                    if (extraItemList != null && extraItemList.Count > 0)
                    {
                        foreach (extraItem info2 in extraItemList)
                        {
                            List<KeyValuePair<string, dynamic>> Param3 = new List<KeyValuePair<string, dynamic>>
                            {
                                new KeyValuePair<string, dynamic>("@ItemID", ids),
                                new KeyValuePair<string, dynamic>("@ExtraItemID", info2.ExtraItemID)
                            };
                            sqlHandler.ExecuteNonQuery("[usp_ro_extraitemforitemsave]", Param3);
                        }
                    }

                    if (itemObject.Ingredientdata != null && itemObject.Ingredientdata.Count > 0)
                    {
                        foreach (IngredientItems info in itemObject.Ingredientdata)
                        {
                            List<KeyValuePair<string, dynamic>> Param5 = new List<KeyValuePair<string, dynamic>>
                            {
                                new KeyValuePair<string, dynamic>("@ItemID", ids),
                                new KeyValuePair<string, dynamic>("@Ingredient", info.Ingredient),
                                new KeyValuePair<string, dynamic>("@Quantity", info.Quantity)
                            };
                            sqlHandler.ExecuteNonQuery("[usp_SaveIngredientWithQuantity]", Param5);
                        }
                    }
                }

                return ids;
            }
            catch (Exception e)
            {
                throw;
            }
        }

        internal int saveInventoryItems(ROInvItem itemObject, List<extraItem> extraItemList = null)
        {
            List<KeyValuePair<string, dynamic>> Param = new List<KeyValuePair<string, dynamic>>
            {
                new KeyValuePair<string, dynamic>("@ITId", itemObject.ITId),
                new KeyValuePair<string, dynamic>("@PITId", itemObject.PITId),
                new KeyValuePair<string, dynamic>("@ITName", itemObject.ITName),
                new KeyValuePair<string, dynamic>("@IsMenu", itemObject.IsMenu),
                new KeyValuePair<string, dynamic>("@IsActive", itemObject.IsActive),
                new KeyValuePair<string, dynamic>("@AddedBy", itemObject.AddedBy),
                new KeyValuePair<string, dynamic>("@IsTaxable", itemObject.IsTaxable),
                new KeyValuePair<string, dynamic>("@HsCode", itemObject.HsCode)
            };
            int ids = sqlHandler.ExecuteAsScalar<int>("[usp_roi_SaveItemsOfRestro]", Param);

            if (ids > 0)
            {
                List<KeyValuePair<string, dynamic>> Param4 = new List<KeyValuePair<string, dynamic>>
                {
                    new KeyValuePair<string, dynamic>("@ITId", ids),
                    new KeyValuePair<string, dynamic>("@ITCode", itemObject.ITCode),
                    new KeyValuePair<string, dynamic>("@ImagePath", itemObject.ImagePath),
                    new KeyValuePair<string, dynamic>("@IsExpirable", itemObject.IsExpirable),
                    new KeyValuePair<string, dynamic>("@IsProdMaterial", itemObject.IsProdMaterial),
                    new KeyValuePair<string, dynamic>("@IsUnitWiseRate", itemObject.IsUnitWiseRate),
                    new KeyValuePair<string, dynamic>("@ItemCostCentreID", itemObject.ItemCostCentreID),
                    new KeyValuePair<string, dynamic>("@Details", itemObject.Details),
                    new KeyValuePair<string, dynamic>("@SmallUnit", itemObject.SmallUnit),
                    new KeyValuePair<string, dynamic>("@AddedBy", itemObject.AddedBy),
                    new KeyValuePair<string, dynamic>("@IsExtra", itemObject.IsExtra),
                    new KeyValuePair<string, dynamic>("@HsCode", itemObject.HsCode)
                };
                sqlHandler.ExecuteNonQuery("[usp_roi_SaveItemsDetailsOfRestro]", Param4);

                List<KeyValuePair<string, dynamic>> Param7 = new List<KeyValuePair<string, dynamic>>();
                Param7.Add(new KeyValuePair<string, dynamic>("@ItemId", ids));
                sqlHandler.ExecuteNonQuery("USP_DeleteMinimumSTock", Param7);

                if (itemObject.storeitemstock != null && itemObject.storeitemstock.Count > 0)
                {
                    foreach (StoreItemStock info3 in itemObject.storeitemstock)
                    {
                        List<KeyValuePair<string, dynamic>> Param6 = new List<KeyValuePair<string, dynamic>>
                        {
                            new KeyValuePair<string, dynamic>("@ItemId", ids),
                            new KeyValuePair<string, dynamic>("@StoreId", info3.StoreId),
                            new KeyValuePair<string, dynamic>("@Unit", info3.Unit),
                            new KeyValuePair<string, dynamic>("@Value", info3.Value)
                        };
                        sqlHandler.ExecuteNonQuery("USP_CreateSToreMinimumStock", Param6);
                    }
                }

                if (itemObject.ItemWithUnit != null && itemObject.ItemWithUnit.Count > 0)
                {
                    foreach (itemWithUnit info in itemObject.ItemWithUnit)
                    {
                        List<KeyValuePair<string, dynamic>> Param2 = new List<KeyValuePair<string, dynamic>>
                        {
                            new KeyValuePair<string, dynamic>("@ItemID", ids),
                            new KeyValuePair<string, dynamic>("@SalesRate", info.SalesRate),
                            new KeyValuePair<string, dynamic>("@ValidFrom", info.ValidFrom),
                            new KeyValuePair<string, dynamic>("@AddedBy", info.AddedBy)
                        };
                        sqlHandler.ExecuteNonQuery("[usp_SaveItemWithUnit]", Param2);
                    }
                }

                List<KeyValuePair<string, dynamic>> Para = new List<KeyValuePair<string, dynamic>>();
                Para.Add(new KeyValuePair<string, dynamic>("@ItemID", ids));
                sqlHandler.ExecuteNonQuery("[usp_ro_removeextraitemsforitem]", Para);

                if (extraItemList != null && extraItemList.Count > 0)
                {
                    foreach (extraItem info2 in extraItemList)
                    {
                        List<KeyValuePair<string, dynamic>> Param3 = new List<KeyValuePair<string, dynamic>>
                        {
                            new KeyValuePair<string, dynamic>("@ItemID", ids),
                            new KeyValuePair<string, dynamic>("@ExtraItemID", info2.ExtraItemID)
                        };
                        sqlHandler.ExecuteNonQuery("[usp_ro_extraitemforitemsave]", Param3);
                    }
                }

                if (itemObject.Ingredientdata != null && itemObject.Ingredientdata.Count > 0)
                {
                    foreach (IngredientItems info in itemObject.Ingredientdata)
                    {
                        List<KeyValuePair<string, dynamic>> Param5 = new List<KeyValuePair<string, dynamic>>
                        {
                            new KeyValuePair<string, dynamic>("@ItemID", ids),
                            new KeyValuePair<string, dynamic>("@Ingredient", info.Ingredient),
                            new KeyValuePair<string, dynamic>("@Quantity", info.Quantity)
                        };
                        sqlHandler.ExecuteNonQuery("[usp_SaveIngredientWithQuantity]", Param5);
                    }
                }
            }

            return ids;
        }
        internal List<FiscalYear> getTodayFiscalYr()
        {
            List<FiscalYear> list = sqlHandler.ExecuteAsList<FiscalYear>("[USP_RO_getTodayFiscalYr]");
            return list;
        }
        internal List<AdjustmentDetails> GetdataByPurchaseOrderId(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Id", id));
            return sqlHandler.ExecuteAsList<AdjustmentDetails>("[usp_Ro_GetdataByPurchaseOrderId]", Param);
        }
        internal List<itemWithUnit> ItemWithUnitList(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemID", id));
            List<itemWithUnit> obj = sqlHandler.ExecuteAsList<itemWithUnit>("[usp_ItemWithUnitList]", Param);
            return obj;
        }
        internal List<extraItem> extraItemData(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemID", id));
            List<extraItem> obj = sqlHandler.ExecuteAsList<extraItem>("[usp_editItem]", Param);
            return obj;
        }
        internal List<ROInvItem> CheckItemExistence(string item)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@item", item));
            List<ROInvItem> obj = sqlHandler.ExecuteAsList<ROInvItem>("[usp_Roi_CheckItemExistence]", Param);
            return obj;
        }
        internal List<dailyreport> getPurchaseReportByPuNo(string puNo)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@puNo", puNo));
            List<dailyreport> obj = sqlHandler.ExecuteAsList<dailyreport>("[usp_getPurchaseReportByPuNo]", Param);
            return obj;
        }
        internal List<cumbomainDetails> getcombodatabyid(int comboid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@comboid", comboid));
            List<cumbomainDetails> obj = sqlHandler.ExecuteAsList<cumbomainDetails>("[USP_GETCOMBOBYID]", Param);
            return obj;
        }
        internal void updateisactive(int ComboID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ComboID", ComboID));
            //List<OrderDetailClass> list = new List<OrderDetailClass>();
            sqlHandler.ExecuteNonQuery("[USP_RO_UPDATECOMBOISACTIVE]", Param);
        }
        internal List<CardProvider> getVendorName()
        {
            return sqlHandler.ExecuteAsList<CardProvider>("[USP_GETMEMBERSHIPVENDORNAME]");
        }
        internal List<CardProvider> getdailyVendorReportByMonthly(string year, string month)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            Param.Add(new KeyValuePair<string, object>("@month", month));
            return sqlHandler.ExecuteAsList<CardProvider>("[USP_getdailyVendorReportByMonthly]", Param);
        }
        internal List<CardProvider> getdailyVendorReportByYearly(string year)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@year", year));
            return sqlHandler.ExecuteAsList<CardProvider>("[USP_GETDATABYYEARLY]", Param);
        }
        internal List<CardProvider> GetVenderReportByDate(string DateFrom, string DateTo, int VenderId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@DateFrom", DateFrom));
            Param.Add(new KeyValuePair<string, object>("@DateTo", DateTo));
            Param.Add(new KeyValuePair<string, object>("@VenderId", VenderId));
            return sqlHandler.ExecuteAsList<CardProvider>("[USP_GetVenderReportByDate]", Param);
        }
        internal List<ROInvItem> GetItemList()
        {
            return sqlHandler.ExecuteAsList<ROInvItem>("[USP_GetAllItems]");
        }
        internal List<ROInvItem> GetInventoryItemList()
        {
            return sqlHandler.ExecuteAsList<ROInvItem>("[USP_GetInventoryItems]");
        }
        internal int saveGroupItem(ItemGroup group)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@GroupID", group.GroupID));
            Param.Add(new KeyValuePair<string, object>("@GroupName", group.GroupName));
            Param.Add(new KeyValuePair<string, object>("@GroupCode", group.GroupCode));
            Param.Add(new KeyValuePair<string, object>("@userName", group.userName));
            var obj = sqlHandler.ExecuteAsScalar<int>("[usp_Roi_ItemGroup_InsertData]", Param);
            foreach (GroupWithItem item in group.GroupWithItem)
            {
                List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                Param2.Add(new KeyValuePair<string, object>("@GroupID", obj));
                Param2.Add(new KeyValuePair<string, object>("@ItemID", item.ItemID));
                Param2.Add(new KeyValuePair<string, object>("@userName", group.userName));
                sqlHandler.ExecuteNonQuery("[usp_Roi_GroupWithItem_InsertData]", Param2);
            }
            return obj;
        }
        internal List<ItemGroup> getGroupList()
        {
            return sqlHandler.ExecuteAsList<ItemGroup>("[usp_Roi_GetDataForGroupItem]");
        }
        internal List<GroupWithItem> getGroupByID(int ids)
        {
            List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
            Param2.Add(new KeyValuePair<string, object>("@ids", ids));
            return sqlHandler.ExecuteAsList<GroupWithItem>("[usp_Roi_GetGroupDataByID]", Param2);
        }
        internal List<ROInvItem> ViewItemByID(int ids)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ids", ids));
            return sqlHandler.ExecuteAsList<ROInvItem>("[usp_roi_viewItemByID]", Param);
        }
        internal List<ClosingReport> ClosingReport(DateTime startdate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@DATE", startdate));
            return sqlHandler.ExecuteAsList<ClosingReport>("[usp_RO_SalesDetailStatement]", Param);
        }
        internal List<StatementInfo> StatementReportView(DateTime startdate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@DATE", startdate));
            return sqlHandler.ExecuteAsList<StatementInfo>("[usp_RO_SalesStatement]", Param);
        }
        internal List<MvPurchaseDetails> GetUnitOfItemByID(int ids)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ids", ids));
            return sqlHandler.ExecuteAsList<MvPurchaseDetails>("[usp_GetUnitOfItemByID]", Param);
        }
        internal List<MvPurchaseDetails> GetItemForOpenBalance()
        {
            return sqlHandler.ExecuteAsList<MvPurchaseDetails>("[USP_ROI_GetItemForOpenBalance]");
            //return sqlHandler.ExecuteAsList<MvPurchaseDetails>("[USP_RO_GETITEM_NEW]");
        }
        internal void DeleteGroupItemByID(int ids)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ids", ids));
            sqlHandler.ExecuteNonQuery("[usp_DeleteGroupItemByID]", Param);
        }
        internal List<dailyreport> getCustomerBalanceReport(DateTime startDate, DateTime endDate, int CustomerName)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@CustomerName", CustomerName));
            return sqlHandler.ExecuteAsList<dailyreport>("[usp_getCustomerBalanceReport]", Param);
        }

        internal void CreditCancelWithReason(int id, int memberId, string userName, string reason, string date)
        {
            try
            {

                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@salesMasterId", id));
                Param.Add(new KeyValuePair<string, object>("@MembershipID", memberId));
                Param.Add(new KeyValuePair<string, object>("@Reasons", reason));
                Param.Add(new KeyValuePair<string, object>("@userName", userName));
                Param.Add(new KeyValuePair<string, object>("@cancelledDate", date));
                sqlHandler.ExecuteNonQuery("[USP_RO_Credit_CancelReason]", Param);

            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<itemsales> getiemsalesreport(DateTime Start, DateTime EndDate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Start", Start));
            Param.Add(new KeyValuePair<string, object>("@End", EndDate));
            return sqlHandler.ExecuteAsList<itemsales>("[usp_ro_itemsalesreport]", Param);
        }
        internal void deleteGroupByID(int ids)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ids", ids));
            sqlHandler.ExecuteNonQuery("[usp_DeleteGroupItemByID]", Param);
        }
        internal List<top6Item> getTop6Item()
        {
            return sqlHandler.ExecuteAsList<top6Item>("usp_topLists");
        }
        internal List<top6Table> getTop6Table()
        {
            return sqlHandler.ExecuteAsList<top6Table>("usp_topListsTable");
        }
        internal List<SalesChart> getSalesChart()
        {
            return sqlHandler.ExecuteAsList<SalesChart>("usp_Ro_SalesChart");
        }
        internal List<stockReport> stockreport(int storeID, string searchText)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@storeId", storeID));
            Param.Add(new KeyValuePair<string, object>("@SearchText", searchText));
            //return sqlHandler.ExecuteAsList<stockReport>("USP_STOCKREPORTAll", Param);
            return sqlHandler.ExecuteAsList<stockReport>("USP_ROI_GETALLSTOCKREPORT", Param);
        }
        internal List<dailyreport> getOrderVoidReport(DateTime startDate, DateTime endDate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startdate", startDate));
            Param.Add(new KeyValuePair<string, object>("@enddate", endDate));
            return sqlHandler.ExecuteAsList<dailyreport>("usp_roi_getOrderVoidReport", Param);
        }
        internal List<dailyreports> SaleReportByBillNo(int startBillNo, int endBillNo, int Status)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@StartBill", startBillNo));
            Param.Add(new KeyValuePair<string, object>("@EndBill", endBillNo));
            Param.Add(new KeyValuePair<string, object>("@Status", Status));
            return sqlHandler.ExecuteAsList<dailyreports>("USP_SALES_REPORTByBillNo", Param);
        }
        internal string CheckBillingTermExistence(string term)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@term", term));
            return sqlHandler.ExecuteAsScalar<string>("usp_ro_CheckBillingTermExistence", Param);
        }
        internal List<purchaseMains> getPurchaseDetailsbyID(int mainId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@PurchaseMainID", mainId));
            List<purchaseMains> purDetails = sqlHandler.ExecuteAsList<purchaseMains>("[usp_getPurchaseDetailsbyID]", Param);
            return purDetails;
        }
        internal void deleteAfterEdit(int idForDelete, int MainIdForDelete)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@PurchaseDetailsID", idForDelete));
            Param.Add(new KeyValuePair<string, object>("@PurchaseMainID", MainIdForDelete));
            sqlHandler.ExecuteNonQuery("[dbo].[usp_ro_deleteAfterEdit]", Param);
        }
        internal string CheckPinCodeMatch(string PinCode, string username)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@PinCode", PinCode));
            Param.Add(new KeyValuePair<string, object>("@Username", username));
            return sqlHandler.ExecuteAsScalar<string>("USP_RO_CheckPinCodeMatch", Param);
        }
        internal List<MvPurchaseDetails> GetInventoryItemWithSmallUnit()
        {
            return sqlHandler.ExecuteAsList<MvPurchaseDetails>("[dbo].[USP_ROI_GetInventoryItemWithSmallUnit]");
        }
        internal List<IngredientItems> getIngredientByID(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemID", id));
            return sqlHandler.ExecuteAsList<IngredientItems>("[dbo].[usp_getIngredientByID]", Param);
        }
        internal List<ClosingReport> getClosingReport_StateWise(DateTime startdate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@DATE", startdate));
            return sqlHandler.ExecuteAsList<ClosingReport>("[ClosingReport_StateWise]", Param);
        }
        internal List<ClosingReport> getClosingReport_CategoryWise(DateTime startdate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@DATE", startdate));
            return sqlHandler.ExecuteAsList<ClosingReport>("[ClosingReport_CategoryWise]", Param);
        }
        internal List<StatementInfo> getClosingReport_BillWiseSales(DateTime startdate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@DATE", startdate));
            return sqlHandler.ExecuteAsList<StatementInfo>("[ClosingReport_BillWiseSales]", Param);
        }
        internal List<OrderDetailCancel> getOrderDetailByOrderMasterID(int OrderMasterID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@OrderMasterID", OrderMasterID));
            return sqlHandler.ExecuteAsList<OrderDetailCancel>("usp_ro_getOrderDetailByOrderMasterID", Param);
        }
        internal void SaveCanceledItems(List<OrderDetailCancel> CancelItems)
        {
            DateTime date = DateTime.Now;
            foreach (var item in CancelItems)
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@CanceledBy", item.CanceledBy));
                Param.Add(new KeyValuePair<string, object>("@OrderBy", item.OrderBy));
                Param.Add(new KeyValuePair<string, object>("@Item", item.Item));
                Param.Add(new KeyValuePair<string, object>("@Quantity", item.Quantity));
                Param.Add(new KeyValuePair<string, object>("@Reason", item.Reason));
                Param.Add(new KeyValuePair<string, object>("@Date", date));
                Param.Add(new KeyValuePair<string, object>("@Responsible", item.Responsible));
                Param.Add(new KeyValuePair<string, object>("@tableId", item.tableId));
                Param.Add(new KeyValuePair<string, object>("@orderMasterID", item.orderMasterID));
                sqlHandler.ExecuteNonQuery("usp_saveCanceledOrderDetailItem", Param);
            }
        }
        internal List<billingTerm> getActiveBillTerm()
        {
            return sqlHandler.ExecuteAsList<billingTerm>("getActiveBillTerm");
        }
        internal void deleteBillingTermDetails(int billid)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@billtermId", billid));
                sqlHandler.ExecuteNonQuery("[USP_RO_deleteBillingTermDetails]", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal void saveBillingDetails(billTermDetails btdetails)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@BilingID", btdetails.BilingID));
            Param.Add(new KeyValuePair<string, object>("@FromDate", btdetails.FromDate));
            Param.Add(new KeyValuePair<string, object>("@ToDate", btdetails.ToDate));
            Param.Add(new KeyValuePair<string, object>("@FromTime", btdetails.FromTime));
            Param.Add(new KeyValuePair<string, object>("@ToTime", btdetails.ToTime));
            Param.Add(new KeyValuePair<string, object>("@Sunday", btdetails.Sunday));
            Param.Add(new KeyValuePair<string, object>("@Monday", btdetails.Monday));
            Param.Add(new KeyValuePair<string, object>("@Tuesday", btdetails.Tuesday));
            Param.Add(new KeyValuePair<string, object>("@Wednesday", btdetails.Wednesday));
            Param.Add(new KeyValuePair<string, object>("@Thursday", btdetails.Thursday));
            Param.Add(new KeyValuePair<string, object>("@Friday", btdetails.Friday));
            Param.Add(new KeyValuePair<string, object>("@Saturday", btdetails.Saturday));
            sqlHandler.ExecuteNonQuery("USP_RO_SAVEBILLINGTERMDetails", Param);
        }
        internal billTermDetails getBillTermDetailsByBillTerm(int bilingID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@bilingID", bilingID));
                billTermDetails btdetails = sqlHandler.ExecuteAsObject<billTermDetails>("[USP_RO_getBillTermDetailsByBillTerm]", Param);
                return btdetails;
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        internal List<CreditPayReport> getCreditPayReportByDates(DateTime sdate, DateTime edate, string customer, bool? IsCustomer = null)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@sdate", sdate));
                Param.Add(new KeyValuePair<string, object>("@edate", edate));
                Param.Add(new KeyValuePair<string, object>("@Customer", customer));
                Param.Add(new KeyValuePair<string, object>("@IsCustomer", IsCustomer));
                return sqlHandler.ExecuteAsList<CreditPayReport>("USP_RO_getCreditPayReportByDates", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal List<CreditPayReport> getMixedPayReportByDates(DateTime sdate, DateTime edate, string customer, bool? IsCustomer = null)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@sdate", sdate));
                Param.Add(new KeyValuePair<string, object>("@edate", edate));
                Param.Add(new KeyValuePair<string, object>("@Customer", customer));
                Param.Add(new KeyValuePair<string, object>("@IsCustomer", IsCustomer));
                return sqlHandler.ExecuteAsList<CreditPayReport>("USP_RO_getMixedPayReportByDates", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal PinUser CheckPin(string pin)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@pin", pin));
            return sqlHandler.ExecuteAsObject<PinUser>("usp_getUserByPin", Param);
        }
        internal List<customerBilling> getbillingTermbySalesMasterID(string MID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@salesMasterID", Convert.ToInt32(MID)));
            return sqlHandler.ExecuteAsList<customerBilling>("[USP_RO_GETBILLTERMBYSalesMasterId]", Param);
        }

        internal List<customerBilling> getcakebillingTermbySalesMasterID(string MID, string SalesType = "")
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@salesMasterID", Convert.ToInt32(MID)));
            Param.Add(new KeyValuePair<string, object>("@SalesType", SalesType));
            return sqlHandler.ExecuteAsList<customerBilling>("[USP_RO_GETBILLTERMBYSalesMasterId]", Param);
        }

        internal int ChangePIN(string UserId, string PIN)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@userid", UserId));
            Param.Add(new KeyValuePair<string, object>("@pin", PIN));
            return sqlHandler.ExecuteAsScalar<int>("[USP_RO_ChangePIN]", Param);
        }
        internal List<TargetSales> getTargetSales(DateTime date)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@dates", date));
            List<TargetSales> tg = sqlHandler.ExecuteAsList<TargetSales>("usp_ro_getTargetSales", Param);
            foreach (var item in tg)
            {
                List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                Param1.Add(new KeyValuePair<string, object>("@dates", item.Dates));
                item.SalesItems = sqlHandler.ExecuteAsList<TargetSalesItem>("usp_ro_getTargetSalesItem", Param1);
            }
            return tg;
        }
        internal List<itemsales> getSalesDetailsByDate(DateTime date)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@date", date));
            return sqlHandler.ExecuteAsList<itemsales>("[usp_ro_getSalesDetailsByDate]", Param);
        }
        internal SalesPayment GetSalesPayMode(int salesMasterId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
            return sqlHandler.ExecuteAsObject<SalesPayment>("[usp_ro_GetSalesPayMode]", Param);
        }
        internal void UpdateSalesPayMode(SalesPayment salesPayment)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@salesMasterId", salesPayment.salesMasterId));
                Param.Add(new KeyValuePair<string, object>("@SPMID", Convert.ToInt32(salesPayment.SPMID)));
                Param.Add(new KeyValuePair<string, object>("@ChequeNo", salesPayment.ChequeNo));
                Param.Add(new KeyValuePair<string, object>("@TransactionNo", salesPayment.TransactionNo));
                Param.Add(new KeyValuePair<string, object>("@ProviderID", (salesPayment.ProviderID == "" ? 0 : Convert.ToInt32(salesPayment.ProviderID))));
                Param.Add(new KeyValuePair<string, object>("@CusID", (salesPayment.CusID == "" ? 0 : Convert.ToInt32(salesPayment.CusID))));
                Param.Add(new KeyValuePair<string, object>("@Customer", salesPayment.Customer));
                Param.Add(new KeyValuePair<string, object>("@Address", salesPayment.Address));
                Param.Add(new KeyValuePair<string, object>("@PAN", salesPayment.PAN));
                Param.Add(new KeyValuePair<string, object>("@PayAmount", Convert.ToInt32(salesPayment.SPMID) == 1 ? salesPayment.TenderAmount - salesPayment.ReturnAmount : salesPayment.PayAmount));
                Param.Add(new KeyValuePair<string, object>("@TenderAmount", salesPayment.TenderAmount));
                Param.Add(new KeyValuePair<string, object>("@ReturnAmount", salesPayment.ReturnAmount));
                Param.Add(new KeyValuePair<string, object>("@Remarks", salesPayment.Remarks));
                sqlHandler.ExecuteNonQuery("[usp_ro_UpdateSalesPayMode]", Param);
                List<KeyValuePair<string, object>> param5 = new List<KeyValuePair<string, object>>();
                param5.Add(new KeyValuePair<string, object>("@SalesMasterID", salesPayment.salesMasterId));
                sqlHandler.ExecuteNonQuery("usp_SaveTransactionForSales", param5);
                ts.Complete();
            }
        }
        internal void UpdateSalesPayMode(List<SalesPayment> salesPayment)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                foreach (SalesPayment sp in salesPayment)
                {
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@salesMasterId", sp.salesMasterId));
                    Param.Add(new KeyValuePair<string, object>("@SPMID", Convert.ToInt32(sp.SPMID)));
                    Param.Add(new KeyValuePair<string, object>("@ChequeNo", sp.ChequeNo));
                    Param.Add(new KeyValuePair<string, object>("@TransactionNo", sp.TransactionNo));
                    Param.Add(new KeyValuePair<string, object>("@ProviderID", (sp.ProviderID == "" ? 0 : Convert.ToInt32(sp.ProviderID))));
                    Param.Add(new KeyValuePair<string, object>("@CusID", ((sp.CusID == "" || sp.CusID == null) ? 0 : Convert.ToInt32(sp.CusID))));
                    Param.Add(new KeyValuePair<string, object>("@Customer", sp.Customer));
                    Param.Add(new KeyValuePair<string, object>("@Address", sp.Address));
                    Param.Add(new KeyValuePair<string, object>("@PAN", sp.PAN));
                    Param.Add(new KeyValuePair<string, object>("@PayAmount", sp.PayAmount));
                    Param.Add(new KeyValuePair<string, object>("@TenderAmount", sp.TenderAmount));
                    Param.Add(new KeyValuePair<string, object>("@ReturnAmount", sp.ReturnAmount));
                    Param.Add(new KeyValuePair<string, object>("@Remarks", sp.Remarks));
                    sqlHandler.ExecuteNonQuery("[usp_ro_UpdateSalesPayMode]", Param);
                    if (Convert.ToInt32(sp.SPMID) == 4)
                    {
                        RestoLoyaltyController dpobj = new RestoLoyaltyController();
                        MemberInfo meminfo = new MemberInfo();
                        meminfo.MembershipID = Convert.ToInt32(sp.CusID);
                        meminfo.RemainingBalance = sp.PayAmount;
                        meminfo.PayAmount = 0;
                        meminfo.AddedBy = "";
                        meminfo.GoodReceivedMainId = 0;
                        dpobj.SaveCustomerAmount(meminfo);
                    }
                }
                List<KeyValuePair<string, object>> param5 = new List<KeyValuePair<string, object>>();
                param5.Add(new KeyValuePair<string, object>("@SalesMasterID", salesPayment[0].salesMasterId));
                sqlHandler.ExecuteNonQuery("usp_SaveTransactionForSales", param5);
                ts.Complete();
            }
        }
        internal List<ClosingReport> ClosingMonthlyReportView(DateTime startdate, DateTime enddate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startdate));
            Param.Add(new KeyValuePair<string, object>("@endDate", enddate));
            return sqlHandler.ExecuteAsList<ClosingReport>("[usp_RO_MonthlyClosingSalesDetailStatement]", Param);
        }
        internal List<StatementInfo> StatementMonthlyReportView(DateTime startdate, DateTime enddate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startdate));
            Param.Add(new KeyValuePair<string, object>("@endDate", enddate));
            return sqlHandler.ExecuteAsList<StatementInfo>("[usp_RO_MonthlyClosingTotalSalesStatement]", Param);
        }


        internal List<CostCenterGroup> GetCostCenterGroupClosing(DateTime startdate, DateTime enddate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startdate));
            Param.Add(new KeyValuePair<string, object>("@endDate", enddate));
            return sqlHandler.ExecuteAsList<CostCenterGroup>("[USP_RO_GetCostCenterGroupClosing]", Param);
        }


        internal List<StatementInfo> StatementMonthlyReportDatewise(DateTime startdate, DateTime enddate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startdate));
            Param.Add(new KeyValuePair<string, object>("@endDate", enddate));
            return sqlHandler.ExecuteAsList<StatementInfo>("[usp_RO_MonthlyClosingSalesStatement]", Param);
        }
        internal List<UnpaidBills> GetUnpaidBills()
        {
            return sqlHandler.ExecuteAsList<UnpaidBills>("[usp_ro_GetUnpaidBills]");
        }
        public List<customerBilling> getActiveBILLTERM()
        {
            return sqlHandler.ExecuteAsList<customerBilling>("[USP_RO_ActiveBILLTERM]");
        }
        internal List<MergeTableInfo> GetMergedTables(int tableId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@tableId", tableId));
            return sqlHandler.ExecuteAsList<MergeTableInfo>("USP_RO_GetMergedTables", Param);
        }
        internal void ClearMergeList(int tableId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@tableId", tableId));
            sqlHandler.ExecuteNonQuery("USP_RO_ClearMergeforTable", Param);
        }
        internal void deleteDependentRoomsAndTables(int id, int type)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@id", id));
                Param.Add(new KeyValuePair<string, object>("@type", type));
                sqlHandler.ExecuteNonQuery("[USP_RO_deleteDependentRoomsAndTables]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ROInvItem> CheckItemExistenceForCategory(string item)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@item", item));
            List<ROInvItem> obj = sqlHandler.ExecuteAsList<ROInvItem>("[usp_Roi_CheckItemExistenceForCategory]", Param);
            return obj;
        }
        internal List<unitclassforitem> getOnlySmallUnit()
        {
            return sqlHandler.ExecuteAsList<unitclassforitem>("[getOnlySmallUnit]");
        }
        internal void DeleteIngredientItemByID(int IngredientID, int ItemID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@IngredientID", IngredientID));
            Param.Add(new KeyValuePair<string, object>("@ItemID", ItemID));
            sqlHandler.ExecuteNonQuery("[dbo].[usp_ro_DeleteIngredientItemByID]", Param);
        }
        internal List<MvPurchaseDetails> getUnitsWithConvertion(int ids)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@itemId", ids));
            return sqlHandler.ExecuteAsList<MvPurchaseDetails>("[getUnitsWithConvertion]", Param);
        }
        internal List<OrderDetailClass> getOrderDetailByOrderMasterId(int orderMasterId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@orderMasterId", orderMasterId));
                List<OrderDetailClass> list = new List<OrderDetailClass>();
                list = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_RO_getOrderDetailByOrderMaster]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ComplimentaryOrder> getComplimentaryOrderDetailByOrderMasterId(int orderMasterId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@orderMasterId", orderMasterId));
                List<ComplimentaryOrder> list = new List<ComplimentaryOrder>();
                list = sqlHandler.ExecuteAsList<ComplimentaryOrder>("[USP_RO_GetComplimentaryOrdersByOrderId]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal int saveSalesBill(SalesMaster sm, List<SalesDetails> sds, int splited, List<customerBilling> bt, flatorperdiscount flatorperdiscount)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@billNo", sm.billNo));
                    Param.Add(new KeyValuePair<string, object>("@BillDate", sm.BillDate));
                    Param.Add(new KeyValuePair<string, object>("@RoomId", sm.RoomId));
                    Param.Add(new KeyValuePair<string, object>("@TableId", sm.TableId));
                    Param.Add(new KeyValuePair<string, object>("@NepaliInvoiceDate", sm.NepaliInvoiceDate));
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
                    Param.Add(new KeyValuePair<string, object>("@PhoneNumber", sm.PhoneNumber));
                    Param.Add(new KeyValuePair<string, object>("@CusID", sm.CusID));
                    Param.Add(new KeyValuePair<string, object>("@IsSplit", sm.IsSplit));
                    Param.Add(new KeyValuePair<string, object>("@SeatNo", sm.SeatNo));
                    Param.Add(new KeyValuePair<string, object>("@AddedBy", sm.AddedBy));
                    Param.Add(new KeyValuePair<string, object>("@Address", sm.Address));
                    Param.Add(new KeyValuePair<string, object>("@PAN", sm.PAN));
                    Param.Add(new KeyValuePair<string, object>("@ChequNO", sm.ChequeNo));
                    Param.Add(new KeyValuePair<string, object>("@TransactionNo", sm.TransactionNo));
                    Param.Add(new KeyValuePair<string, object>("@RoomRate", sm.RoomRate));
                    Param.Add(new KeyValuePair<string, object>("@BookedDays", sm.BookedDays));
                    Param.Add(new KeyValuePair<string, object>("@RoomCharge", sm.RoomCharge));
                    Param.Add(new KeyValuePair<string, object>("@AdvancePayment", sm.AdvancePayment));
                    Param.Add(new KeyValuePair<string, object>("@sumBakery", sm.sumBakery));
                    Param.Add(new KeyValuePair<string, object>("@sumPizza", sm.sumPizza));
                    Param.Add(new KeyValuePair<string, object>("@DeliveryCharge", Convert.ToString(sm.DeliveryCharge) == null ? 0 : sm.DeliveryCharge));
                    Param.Add(new KeyValuePair<string, object>("@DeliveredBy", sm.DeliveredBy == null ? "" : sm.DeliveredBy));
                    List<OrderDetailClass> list = new List<OrderDetailClass>();
                    var a = sqlHandler.ExecuteAsScalar<object>("usp_ro_savesalesMaster", Param);
                    int salesMasterId = Convert.ToInt32(a);
                    //save billing term 
                    foreach (customerBilling term in bt)
                    {
                        List<KeyValuePair<string, object>> ParamBill2 = new List<KeyValuePair<string, object>>();
                        ParamBill2.Add(new KeyValuePair<string, object>("@amount", term.Amount));
                        ParamBill2.Add(new KeyValuePair<string, object>("@SaleMasterID", salesMasterId));
                        ParamBill2.Add(new KeyValuePair<string, object>("@BillingID", term.ID));
                        ParamBill2.Add(new KeyValuePair<string, object>("@IsVoid", term.IsAdd));
                        ParamBill2.Add(new KeyValuePair<string, object>("@rate", term.Rate));
                        var billTermList = sqlHandler.ExecuteAsList<customerBilling>("USP_RO_SaveBILLTERM_WITHID", ParamBill2);
                    }

                    foreach (SalesDetails sd in sds)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                        Param1.Add(new KeyValuePair<string, object>("@ItemId", sd.ItemId));
                        Param1.Add(new KeyValuePair<string, object>("@qty", sd.qty));
                        Param1.Add(new KeyValuePair<string, object>("@rate", sd.rate));
                        Param1.Add(new KeyValuePair<string, object>("@Amount", sd.Amount));
                        Param1.Add(new KeyValuePair<string, object>("@NetAmount", sd.NetAmount));
                        Param1.Add(new KeyValuePair<string, object>("@CostCenterId", sd.CostCenterId));
                        Param1.Add(new KeyValuePair<string, object>("@IsCombo", sd.IsCombo));
                        Param1.Add(new KeyValuePair<string, object>("@HsCode", sd.HsCode));
                        var si = sqlHandler.ExecuteAsScalar<object>("usp_ro_savesalesDetail", Param1);
                        int salesdetailId = Convert.ToInt32(si);
                        if (sd.extraSales != null && sd.extraSales.Count > 0)
                        {
                            foreach (SalesDetailExtra se in sd.extraSales)
                            {
                                List<KeyValuePair<string, object>> extParam = new List<KeyValuePair<string, object>>();
                                extParam.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                                extParam.Add(new KeyValuePair<string, object>("@salesDetailId", salesdetailId));
                                extParam.Add(new KeyValuePair<string, object>("@ItemId", se.ItemId));
                                extParam.Add(new KeyValuePair<string, object>("@ExtraItemId", se.ExtraItemId));
                                extParam.Add(new KeyValuePair<string, object>("@ExtraItem", se.ExtraItem));
                                extParam.Add(new KeyValuePair<string, object>("@qty", se.Quantity));
                                extParam.Add(new KeyValuePair<string, object>("@rate", se.Rate));
                                extParam.Add(new KeyValuePair<string, object>("@Amount", se.Amount));
                                sqlHandler.ExecuteNonQuery("usp_ro_saveExtraSales", extParam);
                            }
                        }
                    }

                    List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                    Param2.Add(new KeyValuePair<string, object>("@OrderMasterId", sm.OrderMasterId));
                    Param2.Add(new KeyValuePair<string, object>("@termAmount", sm.TermAmount));
                    Param2.Add(new KeyValuePair<string, object>("@NetAmount", sm.NetAmount));
                    Param2.Add(new KeyValuePair<string, object>("@seatNo", sm.SeatNo));
                    sqlHandler.ExecuteNonQuery("usp_ro_updateOrderMaster", Param2);

                    foreach (CostCenterGroup cg in flatorperdiscount.CCGroup)
                    {
                        List<KeyValuePair<string, object>> Param4 = new List<KeyValuePair<string, object>>();
                        Param4.Add(new KeyValuePair<string, object>("@SalesMasterId", salesMasterId));
                        Param4.Add(new KeyValuePair<string, object>("@GroupId", cg.GroupId));
                        Param4.Add(new KeyValuePair<string, object>("@TotalAmt", cg.TotalAmt));
                        Param4.Add(new KeyValuePair<string, object>("@TotalDis", cg.TotalDis));
                        Param4.Add(new KeyValuePair<string, object>("@isflatdis", flatorperdiscount.isflatdis));
                        Param4.Add(new KeyValuePair<string, object>("@isloyalty", flatorperdiscount.isLoyalty));
                        Param4.Add(new KeyValuePair<string, object>("@loyaltydis", flatorperdiscount.loyaltydis));
                        Param4.Add(new KeyValuePair<string, object>("@roomdis", flatorperdiscount.roomdis));
                        sqlHandler.ExecuteNonQuery("[usp_ro_SaveCostCenterDiscount]", Param4);
                    }

                    ts.Complete();
                    return salesMasterId;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }

        internal int savePOSSalesBill(SalesMaster sm, List<SalesDetails> sds, int splited, List<customerBilling> bt, flatorperdiscount flatorperdiscount)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@billNo", sm.billNo));
                    Param.Add(new KeyValuePair<string, object>("@BillDate", sm.BillDate));
                    Param.Add(new KeyValuePair<string, object>("@RoomId", sm.RoomId));
                    Param.Add(new KeyValuePair<string, object>("@TableId", sm.TableId));
                    Param.Add(new KeyValuePair<string, object>("@NepaliInvoiceDate", sm.NepaliInvoiceDate));
                    Param.Add(new KeyValuePair<string, object>("@NonTaxable", sm.NonTaxable));
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
                    Param.Add(new KeyValuePair<string, object>("@PhoneNumber", sm.PhoneNumber));
                    Param.Add(new KeyValuePair<string, object>("@CusID", sm.CusID));
                    Param.Add(new KeyValuePair<string, object>("@IsSplit", sm.IsSplit));
                    Param.Add(new KeyValuePair<string, object>("@SeatNo", sm.SeatNo));
                    Param.Add(new KeyValuePair<string, object>("@AddedBy", sm.AddedBy));
                    Param.Add(new KeyValuePair<string, object>("@Address", sm.Address));
                    Param.Add(new KeyValuePair<string, object>("@PAN", sm.PAN));
                    Param.Add(new KeyValuePair<string, object>("@ChequNO", sm.ChequeNo));
                    Param.Add(new KeyValuePair<string, object>("@TransactionNo", sm.TransactionNo));
                    Param.Add(new KeyValuePair<string, object>("@RoomRate", sm.RoomRate));
                    Param.Add(new KeyValuePair<string, object>("@BookedDays", sm.BookedDays));
                    Param.Add(new KeyValuePair<string, object>("@RoomCharge", sm.RoomCharge));
                    Param.Add(new KeyValuePair<string, object>("@AdvancePayment", sm.AdvancePayment));
                    Param.Add(new KeyValuePair<string, object>("@sumBakery", sm.sumBakery));
                    Param.Add(new KeyValuePair<string, object>("@sumPizza", sm.sumPizza));
                    Param.Add(new KeyValuePair<string, object>("@DeliveryCharge", Convert.ToString(sm.DeliveryCharge) == null ? 0 : sm.DeliveryCharge));
                    Param.Add(new KeyValuePair<string, object>("@DeliveredBy", sm.DeliveredBy == null ? "" : sm.DeliveredBy));
                    //Param.Add(new KeyValuePair<string, object>("@WaiterId", sm.Waiter));
                    List<OrderDetailClass> list = new List<OrderDetailClass>();
                    var a = sqlHandler.ExecuteAsScalar<object>("[usp_ro_savePOSsalesMaster]", Param);
                    int salesMasterId = Convert.ToInt32(a);
                    //save billing term 
                    foreach (customerBilling term in bt)
                    {
                        List<KeyValuePair<string, object>> ParamBill2 = new List<KeyValuePair<string, object>>();
                        ParamBill2.Add(new KeyValuePair<string, object>("@amount", term.Amount));
                        ParamBill2.Add(new KeyValuePair<string, object>("@SaleMasterID", salesMasterId));
                        ParamBill2.Add(new KeyValuePair<string, object>("@BillingID", term.ID));
                        ParamBill2.Add(new KeyValuePair<string, object>("@IsVoid", term.IsAdd));
                        ParamBill2.Add(new KeyValuePair<string, object>("@rate", term.Rate));
                        var billTermList = sqlHandler.ExecuteAsList<customerBilling>("USP_RO_SaveBILLTERM_WITHID", ParamBill2);
                    }
                    foreach (SalesDetails sd in sds)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                        Param1.Add(new KeyValuePair<string, object>("@ItemId", sd.ItemId));
                        Param1.Add(new KeyValuePair<string, object>("@qty", sd.qty));
                        Param1.Add(new KeyValuePair<string, object>("@rate", sd.rate));
                        Param1.Add(new KeyValuePair<string, object>("@Amount", sd.Amount));
                        Param1.Add(new KeyValuePair<string, object>("@NetAmount", sd.NetAmount));
                        Param1.Add(new KeyValuePair<string, object>("@CostCenterId", sd.CostCenterId));
                        Param1.Add(new KeyValuePair<string, object>("@IsCombo", sd.IsCombo));
                        var si = sqlHandler.ExecuteAsScalar<object>("usp_ro_savesalesDetail", Param1);
                        int salesdetailId = Convert.ToInt32(si);
                        if (sd.extraSales != null && sd.extraSales.Count > 0)
                        {
                            foreach (SalesDetailExtra se in sd.extraSales)
                            {
                                List<KeyValuePair<string, object>> extParam = new List<KeyValuePair<string, object>>();
                                extParam.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                                extParam.Add(new KeyValuePair<string, object>("@salesDetailId", salesdetailId));
                                extParam.Add(new KeyValuePair<string, object>("@ItemId", se.ItemId));
                                extParam.Add(new KeyValuePair<string, object>("@ExtraItemId", se.ExtraItemId));
                                extParam.Add(new KeyValuePair<string, object>("@ExtraItem", se.ExtraItem));
                                extParam.Add(new KeyValuePair<string, object>("@qty", se.Quantity));
                                extParam.Add(new KeyValuePair<string, object>("@rate", se.Rate));
                                extParam.Add(new KeyValuePair<string, object>("@Amount", se.Amount));
                                sqlHandler.ExecuteNonQuery("usp_ro_saveExtraSales", extParam);
                            }
                        }
                    }
                    List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                    Param2.Add(new KeyValuePair<string, object>("@OrderMasterId", sm.OrderMasterId));
                    Param2.Add(new KeyValuePair<string, object>("@termAmount", sm.TermAmount));
                    Param2.Add(new KeyValuePair<string, object>("@NetAmount", sm.NetAmount));
                    Param2.Add(new KeyValuePair<string, object>("@seatNo", sm.SeatNo));
                    sqlHandler.ExecuteNonQuery("usp_ro_updateOrderMaster", Param2);
                    //List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                    //for (int i = 0; i < sds.Count; i++)
                    //{
                    //    Param3.Add(new KeyValuePair<string, object>("@orderDetailsId", sds[i].OrderDetailsID));
                    //    Param3.Add(new KeyValuePair<string, object>("@qty", sds[i].qty));
                    //    Param3.Add(new KeyValuePair<string, object>("@netAmount", sds[i].Amount));
                    //    sqlHandler.ExecuteNonQuery("usp_ro_updateOrderDetails", Param3);
                    //    Param3.Clear();
                    //}
                    foreach (CostCenterGroup cg in flatorperdiscount.CCGroup)
                    {
                        List<KeyValuePair<string, object>> Param4 = new List<KeyValuePair<string, object>>();
                        Param4.Add(new KeyValuePair<string, object>("@SalesMasterId", salesMasterId));
                        Param4.Add(new KeyValuePair<string, object>("@GroupId", cg.GroupId));
                        Param4.Add(new KeyValuePair<string, object>("@TotalAmt", cg.TotalAmt));
                        Param4.Add(new KeyValuePair<string, object>("@NonTaxableAmt", cg.NonTaxableAmt));
                        Param4.Add(new KeyValuePair<string, object>("@TotalDis", cg.TotalDis));
                        Param4.Add(new KeyValuePair<string, object>("@isflatdis", flatorperdiscount.isflatdis));
                        Param4.Add(new KeyValuePair<string, object>("@isloyalty", flatorperdiscount.isLoyalty));
                        Param4.Add(new KeyValuePair<string, object>("@loyaltydis", flatorperdiscount.loyaltydis));
                        Param4.Add(new KeyValuePair<string, object>("@roomdis", flatorperdiscount.roomdis));
                        sqlHandler.ExecuteNonQuery("[usp_ro_SavePOSCostCenterDiscount]", Param4);
                    }


                    //List<KeyValuePair<string, object>> Param4 = new List<KeyValuePair<string, object>>();
                    //Param4.Add(new KeyValuePair<string, object>("@SalesMasterId", salesMasterId));
                    //Param4.Add(new KeyValuePair<string, object>("@kotdis", flatorperdiscount.kotdis));
                    //Param4.Add(new KeyValuePair<string, object>("@bardis", flatorperdiscount.bardis));
                    //Param4.Add(new KeyValuePair<string, object>("@roomdis", flatorperdiscount.roomdis));
                    //Param4.Add(new KeyValuePair<string, object>("@isflatdis", flatorperdiscount.isflatdis));
                    //Param4.Add(new KeyValuePair<string, object>("@isloyalty", flatorperdiscount.isLoyalty));
                    //Param4.Add(new KeyValuePair<string, object>("@loyaltydis", flatorperdiscount.loyaltydis));
                    //Param4.Add(new KeyValuePair<string, object>("@bakerydis", flatorperdiscount.bakerydis));
                    //Param4.Add(new KeyValuePair<string, object>("@pizzadis", flatorperdiscount.pizzadis));
                    ////Param.Add(new KeyValuePair<string, object>("@BasicAmount", fl.BasicAmount));
                    ////Param.Add(new KeyValuePair<string, object>("@TermAmount", fl.TermAmount));
                    ////Param.Add(new KeyValuePair<string, object>("@NetAmount", fl.NetAmount));
                    //sqlHandler.ExecuteNonQuery("[usp_ro_saveflatandPerdiscount]", Param4);
                    ts.Complete();
                    return salesMasterId;
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }
        internal List<CustomerEvent> getCustomerEvents()
        {
            return sqlHandler.ExecuteAsList<CustomerEvent>("usp_GetCustomerEvents");
        }
        internal List<CardProvider> getDueCredit()
        {
            return sqlHandler.ExecuteAsList<CardProvider>("usp_getDueCredit");
        }
        internal List<stockReport> getOutOfStockItems(int storeId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@StoreId", storeId));
            return sqlHandler.ExecuteAsList<stockReport>("usp_getOutOfStockItems", Param);
        }
        internal restroTable getTableInfo(int tableId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@TableId", tableId));
            return sqlHandler.ExecuteAsObject<restroTable>("[usp_ro_getTableInfo]", Param);
        }
        internal int CheckAvailability(string startDate, string endDate, int roombookDetailId, int tableId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@roombookDetailId", roombookDetailId));
            Param.Add(new KeyValuePair<string, object>("@TableId", tableId));
            return sqlHandler.ExecuteAsScalar<int>("[usp_ro_checkRoomAvailability]", Param);
        }
        internal void SaveRoomBoking(RoomBookingsInfo roomBooking, OrderMasterClass orderMaster)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OrderMasterID", orderMaster.OrderMasterID));
                Param.Add(new KeyValuePair<string, object>("@RoomId", orderMaster.RoomId));
                Param.Add(new KeyValuePair<string, object>("@TableId", orderMaster.TableId));
                Param.Add(new KeyValuePair<string, object>("@Date", DateTime.Now));
                Param.Add(new KeyValuePair<string, object>("@BillPaid", orderMaster.BillPaid));
                Param.Add(new KeyValuePair<string, object>("@UserName", orderMaster.UserName));
                Param.Add(new KeyValuePair<string, object>("@BasicAmount", orderMaster.BasicAmount));
                Param.Add(new KeyValuePair<string, object>("@BillNo", orderMaster.BillNo));
                Param.Add(new KeyValuePair<string, object>("@IsCancelled", orderMaster.IsCancelled));
                Param.Add(new KeyValuePair<string, object>("@TermAmount", orderMaster.TermAmount));
                Param.Add(new KeyValuePair<string, object>("@NetAmount", orderMaster.NetAmount));
                Param.Add(new KeyValuePair<string, object>("@Remarks", orderMaster.Remarks));
                Param.Add(new KeyValuePair<string, object>("@IsSplit", orderMaster.IsSplit));
                Param.Add(new KeyValuePair<string, object>("@GuestNo", orderMaster.GuestNo));
                Param.Add(new KeyValuePair<string, object>("@OID", orderMaster.OID));
                Param.Add(new KeyValuePair<string, object>("@OrderStatus", orderMaster.OrderStatus));
                Param.Add(new KeyValuePair<string, object>("@OrderTypeID", orderMaster.OrderTypeID.ToString() == null ? 0 : orderMaster.OrderTypeID));
                var obj = sqlHandler.ExecuteAsScalar<object>("[USP_PO_SAVEPURCHASEMASTER]", Param);
                int m = Convert.ToInt32(obj);
                List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                Param2.Add(new KeyValuePair<string, object>("@TableId", roomBooking.TableId));
                Param2.Add(new KeyValuePair<string, object>("@OrderMasterID", m));
                Param2.Add(new KeyValuePair<string, object>("@BookedFrom", roomBooking.BookedFrom));
                Param2.Add(new KeyValuePair<string, object>("@BookedTo", roomBooking.BookedTo));
                Param2.Add(new KeyValuePair<string, object>("@BookedDays", roomBooking.BookedDays));
                Param2.Add(new KeyValuePair<string, object>("@Rate", roomBooking.Rate));
                Param2.Add(new KeyValuePair<string, object>("@TotalAmount", roomBooking.TotalAmount));
                Param2.Add(new KeyValuePair<string, object>("@AdvancePayment", roomBooking.AdvancePayment));
                Param2.Add(new KeyValuePair<string, object>("@CustomerId", roomBooking.CustomerId));
                Param2.Add(new KeyValuePair<string, object>("@CustomerName", roomBooking.CustomerName));
                Param2.Add(new KeyValuePair<string, object>("@PhoneNo", roomBooking.PhoneNo));
                Param2.Add(new KeyValuePair<string, object>("@EmailAddress", roomBooking.EmailAddress));
                Param2.Add(new KeyValuePair<string, object>("@CtznNo", roomBooking.CtznNo));
                Param2.Add(new KeyValuePair<string, object>("@Remarks", roomBooking.Remarks));
                var id = sqlHandler.ExecuteAsScalar<object>("usp_ro_saveroombooking", Param2);
                int roombookedid = Convert.ToInt32(id);

                if (roomBooking.AdvancePayment > 0)
                {
                    List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                    Param3.Add(new KeyValuePair<string, object>("@MembershipID", roomBooking.CustomerId));
                    string prevVoucherNo = sqlHandler.ExecuteAsScalar<string>("[usp_ac_getPrevousVoucherNo]", Param3);
                    string newVoucherNo = (Convert.ToInt32((prevVoucherNo != null ? prevVoucherNo.Split('-')[1] : "0")) + 1).ToString();

                    List<KeyValuePair<string, object>> Param4 = new List<KeyValuePair<string, object>>();
                    Param4.Add(new KeyValuePair<string, object>("@MembershipID", roomBooking.CustomerId));
                    Param4.Add(new KeyValuePair<string, object>("@PayAmount", roomBooking.AdvancePayment));
                    Param4.Add(new KeyValuePair<string, object>("@NewVoucherNo", newVoucherNo));
                    Param4.Add(new KeyValuePair<string, object>("@PaymentModeID", roomBooking.PaymentModeID));
                    Param4.Add(new KeyValuePair<string, object>("@TransactionNo", roomBooking.TransactionNo));
                    Param4.Add(new KeyValuePair<string, object>("@ProviderID", roomBooking.ProviderID));
                    Param4.Add(new KeyValuePair<string, object>("@Membername", roomBooking.CustomerName));
                    var transactionId = sqlHandler.ExecuteAsScalar<object>("[USP_SaveAdvancePaymentTransaction]", Param4);

                    List<KeyValuePair<string, object>> Param5 = new List<KeyValuePair<string, object>>();
                    Param5.Add(new KeyValuePair<string, object>("@RoomBookDetailsId", roombookedid));
                    Param5.Add(new KeyValuePair<string, object>("@VoucherNo", newVoucherNo));
                    Param5.Add(new KeyValuePair<string, object>("@PaymentModeID", roomBooking.PaymentModeID));
                    Param5.Add(new KeyValuePair<string, object>("@ProviderID", roomBooking.ProviderID));
                    Param5.Add(new KeyValuePair<string, object>("@TransactionNo", roomBooking.TransactionNo));
                    Param5.Add(new KeyValuePair<string, object>("@TransactionId", transactionId));
                    Param5.Add(new KeyValuePair<string, object>("@PayAmount", roomBooking.AdvancePayment));
                    sqlHandler.ExecuteNonQuery("usp_ro_SaveAdvancePaymentMode", Param5);



                    //if (Convert.ToInt32(roomBooking.CustomerId) != 0)
                    //{
                    //    RestoLoyaltyController dpobj = new RestoLoyaltyController();
                    //    MemberInfo meminfo = new MemberInfo();
                    //    meminfo.MembershipID = Convert.ToInt32(roomBooking.CustomerId);
                    //    meminfo.RemainingBalance = roomBooking.RemainingAmount;
                    //    meminfo.PayAmount = roomBooking.AdvancePayment;
                    //    meminfo.AddedBy = "";
                    //    meminfo.GoodReceivedMainId = 0;
                    //    meminfo.SettlementAmount = 0;
                    //    dpobj.SaveCustomerAmount(meminfo);
                    //}

                }

                ts.Complete();
            }
        }
        internal List<RoomBookingsInfo> GetOccupiedRooms()
        {
            return sqlHandler.ExecuteAsList<RoomBookingsInfo>("[usp_ro_getOccupiedRooms]");
        }
        internal RoomBookingsInfo getRoomBookingInfoByOrderMasterID(int orderMasterId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@orderMasterId", orderMasterId));
            return sqlHandler.ExecuteAsObject<RoomBookingsInfo>("[usp_ro_getRoomBookingInfoByOrderMasterID]", Param);
        }
        internal List<ItemsClass> GetPreviousItemByOrderMasterId(int OID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OID", OID));
                List<ItemsClass> list = new List<ItemsClass>();
                list = sqlHandler.ExecuteAsList<ItemsClass>("[usp_ro_GetPreviousItemByOrderMasterId]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<OrderDetailCancel> getOrderItemCancelReport(DateTime startDate, DateTime endDate, string cancelledby, string orderby, int roomid, int tableid, string responsible, string itemname)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startdate", startDate));
            Param.Add(new KeyValuePair<string, object>("@enddate", endDate));
            Param.Add(new KeyValuePair<string, object>("@cancelledby", cancelledby));
            Param.Add(new KeyValuePair<string, object>("@orderby", orderby));
            Param.Add(new KeyValuePair<string, object>("@room", roomid));
            Param.Add(new KeyValuePair<string, object>("@table", tableid));
            Param.Add(new KeyValuePair<string, object>("@responsible", responsible));
            Param.Add(new KeyValuePair<string, object>("@itemname", itemname));
            return sqlHandler.ExecuteAsList<OrderDetailCancel>("usp_roi_getOrderItemCancelReport", Param);
        }
        internal List<OrderDetailClass> getBillBody(int SalesMasterID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@SalesMasterID", SalesMasterID));
            return sqlHandler.ExecuteAsList<OrderDetailClass>("usp_ro_getBillBody", Param);
        }
        internal List<usedBillingTermInfo> GetUsedBillingTerm(int SalesMasterID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@SalesMasterID", SalesMasterID));
            return sqlHandler.ExecuteAsList<usedBillingTermInfo>("usp_ro_GetUsedBillingTerm", Param);
        }
        internal List<ConsumptionReport> getConsumptionReportByDates(DateTime startDate, DateTime endDate)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
                Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
                return sqlHandler.ExecuteAsList<ConsumptionReport>("usp_ro_getConsumptionReportByDate", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }
        internal static OrderMasterClass GetOrderDetailsFromDatabase(string tableId, int orderMasterId)
        {
            SQLHandler sqlHandler = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@TableId", tableId));
            Param.Add(new KeyValuePair<string, object>("@orderMasterId", orderMasterId));
            OrderMasterClass orderMasterinfo = sqlHandler.ExecuteAsObject<OrderMasterClass>("[USP_RO_GETORDERMASTERForRoom]", Param);
            return orderMasterinfo;
        }

        internal static void TempPurchaseDetailTsk(MvTempPurchaseDetail item)
        {
            SQLHandler sqlHandler = new SQLHandler();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemID", item.ItemID));
            Param.Add(new KeyValuePair<string, object>("@Quantity", item.Quantity));
            sqlHandler.ExecuteNonQuery("[SpTempPurchaseDetailTsk]", Param);
        }

        internal List<UserInfos> getUNameNpwdByPIN(string PinCode)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@PinCode", PinCode));
            return sqlHandler.ExecuteAsList<UserInfos>("USP_RO_getUNameNpwdByPIN", Param);
        }
        internal int OrderMasterSaveTodatabase(OrderMasterClass orderMasterInfo, List<OrderDetailClass> addedOrders, List<OrderDetailClass> cancelledOrders)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@OrderMasterID", orderMasterInfo.OrderMasterID));
                    Param.Add(new KeyValuePair<string, object>("@TableId", orderMasterInfo.TableId));
                    Param.Add(new KeyValuePair<string, object>("@BasicAmount", orderMasterInfo.BasicAmount));
                    Param.Add(new KeyValuePair<string, object>("@BillNo", orderMasterInfo.BillNo));
                    Param.Add(new KeyValuePair<string, object>("@Date", DateTime.Now));
                    Param.Add(new KeyValuePair<string, object>("@IsCancelled", orderMasterInfo.IsCancelled));
                    Param.Add(new KeyValuePair<string, object>("@TermAmount", orderMasterInfo.TermAmount));
                    Param.Add(new KeyValuePair<string, object>("@NetAmount", orderMasterInfo.NetAmount));
                    Param.Add(new KeyValuePair<string, object>("@UserName", orderMasterInfo.UserName));
                    Param.Add(new KeyValuePair<string, object>("@Remarks", orderMasterInfo.Remarks));
                    Param.Add(new KeyValuePair<string, object>("@IsSplit", orderMasterInfo.IsSplit));
                    Param.Add(new KeyValuePair<string, object>("@GuestNo", orderMasterInfo.GuestNo));
                    Param.Add(new KeyValuePair<string, object>("@BillPaid", orderMasterInfo.BillPaid));
                    Param.Add(new KeyValuePair<string, object>("@RoomId", orderMasterInfo.RoomId));
                    Param.Add(new KeyValuePair<string, object>("@OID", orderMasterInfo.OID));
                    Param.Add(new KeyValuePair<string, object>("@OrderStatus", orderMasterInfo.OrderStatus));
                    Param.Add(new KeyValuePair<string, object>("@OrderTypeID", orderMasterInfo.OrderTypeID));
                    var obj = sqlHandler.ExecuteAsScalar<object>("[USP_PO_SAVEPURCHASEMASTER]", Param);
                    int m = (orderMasterInfo.OrderMasterID == 0) ? Convert.ToInt32(obj) : orderMasterInfo.OrderMasterID;

                    if (orderMasterInfo.names != null || orderMasterInfo.membershipId != 0 || orderMasterInfo.phoneNo != "" || orderMasterInfo.TokenNo != 0)
                    {
                        List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                        Param2.Add(new KeyValuePair<string, object>("@OrderMasterID", m));
                        Param2.Add(new KeyValuePair<string, object>("@CustomerID", orderMasterInfo.membershipId));
                        Param2.Add(new KeyValuePair<string, object>("@CustomerName", orderMasterInfo.names == null ? "" : orderMasterInfo.names));
                        Param2.Add(new KeyValuePair<string, object>("@Phone", orderMasterInfo.phoneNo == null ? "" : orderMasterInfo.phoneNo));
                        Param2.Add(new KeyValuePair<string, object>("@TokenNo", orderMasterInfo.TokenNo));
                        Param2.Add(new KeyValuePair<string, object>("@Address", orderMasterInfo.Address == null ? "" : orderMasterInfo.Address));
                        sqlHandler.ExecuteNonQuery("USP_SaveOrdeToken", Param2);
                    }


                    foreach (OrderDetailClass OrderDetailInf in addedOrders)
                    {
                        int runningOrder = 0;
                        OrderDetailInf.OrderMasterId = m;
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@OrderMasterID", m));
                        Param1.Add(new KeyValuePair<string, object>("@Quantity", OrderDetailInf.Quantity));
                        Param1.Add(new KeyValuePair<string, object>("@RO_ItemID", OrderDetailInf.ItemId));
                        Param1.Add(new KeyValuePair<string, object>("@IsCombo", OrderDetailInf.IsCombo));
                        Param1.Add(new KeyValuePair<string, object>("@Rate", OrderDetailInf.SRate));
                        Param1.Add(new KeyValuePair<string, object>("@IsCancelled", OrderDetailInf.IsCancelled));
                        Param1.Add(new KeyValuePair<string, object>("@Amount", OrderDetailInf.Amount));
                        Param1.Add(new KeyValuePair<string, object>("@Note", OrderDetailInf.Note));
                        Param1.Add(new KeyValuePair<string, object>("@ExtraCharge", OrderDetailInf.ExtraCharge));
                        Param1.Add(new KeyValuePair<string, object>("@SeatNo", OrderDetailInf.SeatNo));
                        Param1.Add(new KeyValuePair<string, object>("@Status", OrderDetailInf.Status));
                        Param1.Add(new KeyValuePair<string, object>("@IsHomeDelivery", OrderDetailInf.IsHomeDelivery));
                        Param1.Add(new KeyValuePair<string, object>("@HomeDeliveyNumber", OrderDetailInf.HomeDeliveyNumber));
                        Param1.Add(new KeyValuePair<string, object>("@IsRunningOrder", runningOrder));
                        Param1.Add(new KeyValuePair<string, object>("@AddedBy", OrderDetailInf.Waiter == null ? orderMasterInfo.UserName : OrderDetailInf.Waiter));
                        var obj1 = sqlHandler.ExecuteAsScalar<object>("[USP_RO_SAVEORDERDETAIL]", Param1);
                        int ordid = Convert.ToInt32(obj1);
                    }

                    foreach (OrderDetailClass OrderDetailInf in cancelledOrders)
                    {
                        int runningOrder = 1;
                        OrderDetailInf.OrderMasterId = m;
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@OrderMasterID", m));
                        Param1.Add(new KeyValuePair<string, object>("@OrderDetailID", OrderDetailInf.OrderDetailsID));
                        Param1.Add(new KeyValuePair<string, object>("@Quantity", OrderDetailInf.Quantity));
                        Param1.Add(new KeyValuePair<string, object>("@RO_ItemID", OrderDetailInf.ItemId));
                        Param1.Add(new KeyValuePair<string, object>("@IsCombo", OrderDetailInf.IsCombo));
                        Param1.Add(new KeyValuePair<string, object>("@SeatNo", OrderDetailInf.SeatNo));
                        Param1.Add(new KeyValuePair<string, object>("@IsRunningOrder", runningOrder));
                        sqlHandler.ExecuteNonQuery("[USP_RO_CancelORDERDETAIL]", Param1);
                    }
                    ts.Complete();
                    return m;
                }
                catch (Exception)
                {
                    throw;
                }
            }
        }
        internal void ChangeOrderStatus(int orderDetailId, int StatusID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OrderDetailID", orderDetailId));
                Param.Add(new KeyValuePair<string, object>("@StatusID", StatusID));
                sqlHandler.ExecuteNonQuery("[USP_RO_ChangeOrderStatus]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void SaveExtraItem(extraItem extraItem)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@ExtraItemID", extraItem.ExtraItemID));
                    Param.Add(new KeyValuePair<string, object>("@ExtraItem", extraItem.ExtraItem));
                    Param.Add(new KeyValuePair<string, object>("@ExtraPrice", extraItem.ExtraPrice));
                    Param.Add(new KeyValuePair<string, object>("@IsActive", extraItem.IsActive));
                    Param.Add(new KeyValuePair<string, object>("@AddedBy", extraItem.AddedBy));
                    var a = sqlHandler.ExecuteAsScalar<object>("[usp_ro_extraitemsave]", Param);
                    List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                    Param2.Add(new KeyValuePair<string, object>("@ExtraItemID", Convert.ToInt32(a)));
                    sqlHandler.ExecuteNonQuery("[usp_ro_removeExtraIngredient]", Param2);
                    foreach (IngredientItems ing in extraItem.Ingredientdata)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@ExtraItemID", Convert.ToInt32(a)));
                        Param1.Add(new KeyValuePair<string, object>("@IngredientID", ing.IngredientID));
                        Param1.Add(new KeyValuePair<string, object>("@Quantity", ing.Quantity));
                        sqlHandler.ExecuteNonQuery("[usp_ro_extraIngredientSave]", Param1);
                    }
                }
                catch (Exception)
                {
                    throw;
                }
                ts.Complete();
            }
        }
        internal List<extraItem> GetExtraItemList()
        {
            try
            {
                return sqlHandler.ExecuteAsList<extraItem>("[USP_RO_GetExtraItemList]");
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<IngredientItems> GetExtraIngredientList()
        {
            try
            {
                return sqlHandler.ExecuteAsList<IngredientItems>("[USP_RO_GetExtraIngredientList]");
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<extraItem> getExtraItemforItem()
        {
            try
            {
                return sqlHandler.ExecuteAsList<extraItem>("[usp_ro_Getextraitemsforitems]");
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<OrderExtraItem> GetOrderedExtraItemByOrderMaster(int orderMasterID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OrderMasterId", orderMasterID));
                return sqlHandler.ExecuteAsList<OrderExtraItem>("[usp_ro_GetOrderedExtraItemByOrderMaster]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void SaveExtraOrderedItem(List<OrderExtraItem> addedExtra, List<OrderExtraItem> removedExtra)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    if (removedExtra.Count > 0)
                    {
                        foreach (OrderExtraItem ext in removedExtra)
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
                        foreach (OrderExtraItem ext in addedExtra)
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
        internal List<OrderExtraItem> GetExtraSalesForItem(int SalesMasterID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@SalesMasterID", SalesMasterID));
                return sqlHandler.ExecuteAsList<OrderExtraItem>("[usp_ro_GetExtraSalesBySalesMaster]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<OrderExtraItem> GetAllExtraItemByOrderMaster(int orderMasterID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@OrderMasterId", orderMasterID));
                return sqlHandler.ExecuteAsList<OrderExtraItem>("[usp_ro_GetAllExtraItemByOrderMaster]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void DeleteExtraItem(int extraItemId, string deletedBy)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@extraItemId", extraItemId));
                Param.Add(new KeyValuePair<string, object>("@deletedBy", deletedBy));
                sqlHandler.ExecuteNonQuery("[usp_ro_DeleteExtraItem]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void SaveWaiterDetailForNotification(UserClass user)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@WaiterName", user.Username));
            Param.Add(new KeyValuePair<string, object>("@WaiterIP", user.WaiterIP));
            sqlHandler.ExecuteNonQuery("[usp_SaveWaiterDetailForNotification]", Param);
        }
        internal WaiterCallInfo callWaiter(int orderDetailId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@OrderDetailId", orderDetailId));
            return sqlHandler.ExecuteAsObject<WaiterCallInfo>("[usp_callWaiter]", Param);
        }
        internal List<WaiterCallInfo> GetWaiterLog()
        {
            List<WaiterCallInfo> lst = sqlHandler.ExecuteAsList<WaiterCallInfo>("[usp_GetWaiterLog]");
            return lst;
        }
        internal WaiterCallInfo DeleteWaiterFromLog(string waiter)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@WaiterName", waiter));
            return sqlHandler.ExecuteAsObject<WaiterCallInfo>("[usp_DeleteWaiterFromLog]", Param);
        }
        public List<restroTable> getRestroTableByRoomID(int restroRoomId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@restroRoomId", restroRoomId));
                List<restroTable> list = new List<restroTable>();
                list = sqlHandler.ExecuteAsList<restroTable>("[USP_GETRESTROROOMID]", Param);
                return list;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        internal List<RestroRoom> GetRoomByRestroTypeId(int RoomTypeID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RoomTypeID", RoomTypeID));
                List<RestroRoom> list = new List<RestroRoom>();
                list = sqlHandler.ExecuteAsList<RestroRoom>("[USP_GETRESTROROOMIDFROMTYPE]", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal int CompMasterSaveTodatabase(OrderMasterClass orderMasterInfo, List<OrderDetailClass> addedOrders, List<OrderDetailClass> cancelledOrders)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@CompMasterID", orderMasterInfo.CompMasterID));
                    Param.Add(new KeyValuePair<string, object>("@TableId", orderMasterInfo.TableId));
                    Param.Add(new KeyValuePair<string, object>("@BasicAmount", orderMasterInfo.BasicAmount));
                    Param.Add(new KeyValuePair<string, object>("@BillNo", orderMasterInfo.BillNo));
                    Param.Add(new KeyValuePair<string, object>("@Date", DateTime.Now));
                    Param.Add(new KeyValuePair<string, object>("@IsCancelled", orderMasterInfo.IsCancelled));
                    Param.Add(new KeyValuePair<string, object>("@TermAmount", orderMasterInfo.TermAmount));
                    Param.Add(new KeyValuePair<string, object>("@NetAmount", orderMasterInfo.NetAmount));
                    Param.Add(new KeyValuePair<string, object>("@UserName", orderMasterInfo.UserName));
                    Param.Add(new KeyValuePair<string, object>("@Remarks", orderMasterInfo.Remarks));
                    Param.Add(new KeyValuePair<string, object>("@IsSplit", orderMasterInfo.IsSplit));
                    Param.Add(new KeyValuePair<string, object>("@GuestNo", orderMasterInfo.GuestNo));
                    Param.Add(new KeyValuePair<string, object>("@BillPaid", orderMasterInfo.BillPaid));
                    Param.Add(new KeyValuePair<string, object>("@RoomId", orderMasterInfo.RoomId));
                    Param.Add(new KeyValuePair<string, object>("@OID", orderMasterInfo.OID));
                    Param.Add(new KeyValuePair<string, object>("@OrderStatus", orderMasterInfo.OrderStatus));
                    Param.Add(new KeyValuePair<string, object>("@Details", orderMasterInfo.Details));
                    var obj = sqlHandler.ExecuteAsScalar<object>("[USP_SAVECOMPLEMENTARYMASTER]", Param);
                    int m = (orderMasterInfo.OrderMasterID == 0) ? Convert.ToInt32(obj) : orderMasterInfo.OrderMasterID;
                    foreach (OrderDetailClass OrderDetailInf in addedOrders)
                    {
                        int runningOrder = 0;
                        OrderDetailInf.OrderMasterId = m;
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@CompMasterID", m));
                        Param1.Add(new KeyValuePair<string, object>("@Quantity", OrderDetailInf.Quantity));
                        Param1.Add(new KeyValuePair<string, object>("@RO_ItemID", OrderDetailInf.ItemId));
                        Param1.Add(new KeyValuePair<string, object>("@IsCombo", OrderDetailInf.IsCombo));
                        Param1.Add(new KeyValuePair<string, object>("@Rate", OrderDetailInf.SRate));
                        Param1.Add(new KeyValuePair<string, object>("@IsCancelled", OrderDetailInf.IsCancelled));
                        Param1.Add(new KeyValuePair<string, object>("@Amount", OrderDetailInf.Amount));
                        Param1.Add(new KeyValuePair<string, object>("@Note", OrderDetailInf.Note));
                        Param1.Add(new KeyValuePair<string, object>("@ExtraCharge", OrderDetailInf.ExtraCharge));
                        Param1.Add(new KeyValuePair<string, object>("@SeatNo", OrderDetailInf.SeatNo));
                        Param1.Add(new KeyValuePair<string, object>("@Status", OrderDetailInf.Status));
                        Param1.Add(new KeyValuePair<string, object>("@IsHomeDelivery", OrderDetailInf.IsHomeDelivery));
                        Param1.Add(new KeyValuePair<string, object>("@HomeDeliveyNumber", OrderDetailInf.HomeDeliveyNumber));
                        Param1.Add(new KeyValuePair<string, object>("@IsRunningOrder", runningOrder));
                        var obj1 = sqlHandler.ExecuteAsScalar<object>("[USP_SAVECOMPLEMENTARYDETAIL]", Param1);
                        int ordid = Convert.ToInt32(obj1);
                    }
                    foreach (OrderDetailClass OrderDetailInf in cancelledOrders)
                    {
                        int runningOrder = 1;
                        OrderDetailInf.OrderMasterId = m;
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@CompMasterID", m));
                        Param1.Add(new KeyValuePair<string, object>("@CompId", OrderDetailInf.CompId));
                        Param1.Add(new KeyValuePair<string, object>("@Quantity", OrderDetailInf.Quantity));
                        Param1.Add(new KeyValuePair<string, object>("@RO_ItemID", OrderDetailInf.ItemId));
                        Param1.Add(new KeyValuePair<string, object>("@IsCombo", OrderDetailInf.IsCombo));
                        Param1.Add(new KeyValuePair<string, object>("@IsRunningOrder", runningOrder));
                        sqlHandler.ExecuteNonQuery("[USP_CancelComplementaryItems]", Param1);
                    }
                    ts.Complete();
                    return m;
                }
                catch (Exception)
                {
                    throw;
                }
            }
        }
        internal List<OrderExtraItem> GetOrderedExtraItemByCompMaster(int CompMasterID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@CompMasterID", CompMasterID));
                return sqlHandler.ExecuteAsList<OrderExtraItem>("[usp_GetOrderedExtraItemByCompMaster]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<OrderDetailClass> GetCompDetailsByMaster(int CompMasterID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CompMasterID", CompMasterID));
            List<OrderDetailClass> OrderDetailList = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_GETCOMPDETAILS]", Param);
            return OrderDetailList;
        }
        internal void SaveExtraCompItem(List<OrderExtraItem> addedExtra, List<OrderExtraItem> removedExtra)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    if (removedExtra.Count > 0)
                    {
                        foreach (OrderExtraItem ext in removedExtra)
                        {
                            List<KeyValuePair<string, object>> RemParam = new List<KeyValuePair<string, object>>();
                            RemParam.Add(new KeyValuePair<string, object>("@CompMasterID", ext.CompMasterID));
                            RemParam.Add(new KeyValuePair<string, object>("@ItemID", ext.ItemID));
                            RemParam.Add(new KeyValuePair<string, object>("@ExtraItemID", ext.ExtraItemID));
                            RemParam.Add(new KeyValuePair<string, object>("@ExtraItem", ext.ExtraItem));
                            RemParam.Add(new KeyValuePair<string, object>("@Quantity", ext.Quantity));
                            RemParam.Add(new KeyValuePair<string, object>("@ExtraPrice", ext.ExtraPrice));
                            sqlHandler.ExecuteNonQuery("[USP_RemoveExtraCompItems]", RemParam);
                        }
                    }
                    if (addedExtra.Count > 0)
                    {
                        foreach (OrderExtraItem ext in addedExtra)
                        {
                            List<KeyValuePair<string, object>> AddParam = new List<KeyValuePair<string, object>>();
                            AddParam.Add(new KeyValuePair<string, object>("@CompMasterID", ext.CompMasterID));
                            AddParam.Add(new KeyValuePair<string, object>("@ItemID", ext.ItemID));
                            AddParam.Add(new KeyValuePair<string, object>("@ExtraItemID", ext.ExtraItemID));
                            AddParam.Add(new KeyValuePair<string, object>("@ExtraItem", ext.ExtraItem));
                            AddParam.Add(new KeyValuePair<string, object>("@Quantity", ext.Quantity));
                            AddParam.Add(new KeyValuePair<string, object>("@ExtraPrice", ext.ExtraPrice));
                            sqlHandler.ExecuteNonQuery("[USP_SaveExtraCompItems]", AddParam);
                        }
                    }
                    ts.Complete();
                }
                catch (Exception)
                {
                    throw;
                }
            }
        }
        public List<OrderDetailClass> getCompitemprocessing(int costcenterID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CostCenterId", costcenterID));
            List<OrderDetailClass> list = new List<OrderDetailClass>();
            list = sqlHandler.ExecuteAsList<OrderDetailClass>("[USP_GetCompDataFromCostCenterID]", Param);
            return list;
        }
        internal void ChangeCompOrderStatus(int CompId, int StatusID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@CompId", CompId));
                Param.Add(new KeyValuePair<string, object>("@StatusID", StatusID));
                sqlHandler.ExecuteNonQuery("[USP_RO_ChangeCompOrderStatus]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal WaiterCallInfo callWaiterforcomp(int CompId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CompId", CompId));
            return sqlHandler.ExecuteAsObject<WaiterCallInfo>("[usp_callWaiterforcomp]", Param);
        }
        internal List<itemsales> getComplementsalesreport(DateTime Start, DateTime EndDate, int tableid, int roomid, string itemname)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Start", Start));
            Param.Add(new KeyValuePair<string, object>("@End", EndDate));
            Param.Add(new KeyValuePair<string, object>("@tableid", tableid));
            Param.Add(new KeyValuePair<string, object>("@roomid", roomid));
            Param.Add(new KeyValuePair<string, object>("@itemname", itemname));
            return sqlHandler.ExecuteAsList<itemsales>("[USP_RO_ComplementarySALESREPORT]", Param);
        }
        internal DailyClosingReport GenerateDayClosingReport(string date, bool viewOnly)
        {
            try
            {
                //CultureInfo provider = CultureInfo.InvariantCulture;
                //DateTime tempDate = DateTime.ParseExact(date, "dd/mm/yyyy", provider);

                DateTime today = DateTime.Today;

                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@date", today));
                Param.Add(new KeyValuePair<string, object>("@viewOnly ", viewOnly));
                return sqlHandler.ExecuteAsObject<DailyClosingReport>("[usp_ro_generateDailyFinancialReport]", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal void CloseTheDay(int financialID, decimal cashSettlement, decimal cashinCounter, decimal closingBalance, decimal totalexpenses, string remarks)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@financialID", financialID));
                Param.Add(new KeyValuePair<string, object>("@CashSettlement", cashSettlement));
                Param.Add(new KeyValuePair<string, object>("@CashInCounter", cashinCounter));
                Param.Add(new KeyValuePair<string, object>("@ClosingBalance", closingBalance));
                Param.Add(new KeyValuePair<string, object>("@TotalExpenses", totalexpenses));
                Param.Add(new KeyValuePair<string, object>("@ExpensesRemark", remarks));
                sqlHandler.ExecuteNonQuery("[usp_ro_CloseTheDay]", Param);

                //List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                //Param1.Add(new KeyValuePair<string, object>("@financialAcId", financialID));
                //sqlHandler.ExecuteNonQuery("USP_SaveCloseDayExpensesTransaction", Param1);
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ROInvItem> getItemIngreident(int costCenter)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@costCenter", costCenter));
                List<ROInvItem> Iteminfo = sqlHandler.ExecuteAsList<ROInvItem>("[USP_RO_GETINVITEM]", Param);
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ROInvItem> getIngredientsList(int costCenter, int itemID, int categoryID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@costCenter", costCenter));
            Param.Add(new KeyValuePair<string, object>("@ItemId", itemID));
            Param.Add(new KeyValuePair<string, object>("@Category", categoryID));
            List<CogsReport> list = sqlHandler.ExecuteAsList<CogsReport>("usp_getItemIngreidentsList", Param);
            List<int> ids = list.Select(d => d.ItemID).Distinct().ToList();
            List<ROInvItem> items = new List<ROInvItem>();
            foreach (int id in ids)
            {
                ROInvItem item = new ROInvItem();
                item.ITId = id;
                item.ITName = list.Where(d => d.ItemID == id).FirstOrDefault().ItemName;
                item.SRate = (float)list.Where(d => d.ItemID == id).FirstOrDefault().MRP;
                List<CogsReport> lst = list.Where(d => d.ItemID == id).ToList();
                item.Ingredientdata = new List<IngredientItems>();
                foreach (CogsReport cog in lst)
                {
                    IngredientItems itm = new IngredientItems();
                    itm.IngredientID = cog.Ingredient;
                    itm.ITName = cog.IngredientName;
                    itm.Quantity = cog.Quantity;
                    itm.Amount = cog.Amount;
                    item.ImagePath = cog.ImagePath;
                    item.Details = cog.Details;
                    item.COGS += (cog.Amount * cog.Quantity);
                    item.Ingredientdata.Add(itm);
                }
                if (item.SRate > 0)
                {
                    item.COGS = ((item.COGS + (Convert.ToDecimal(0.05) * item.COGS)) / Convert.ToDecimal(item.SRate) * 100);
                }
                items.Add(item);
            }
            return items;
        }
        internal List<StoreItemStock> getstoreitemforstock(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemID", id));
            List<StoreItemStock> obj = sqlHandler.ExecuteAsList<StoreItemStock>("usp_storedetails", Param);
            return obj;
        }
        internal void DeleteMinimumSTock(int ItemId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemId", ItemId));
            sqlHandler.ExecuteNonQuery("USP_DeleteMinimumSTock", Param);
        }
        internal string getAutoRecquistionNo()
        {
            return sqlHandler.ExecuteAsScalar<string>("USP_getAutoRecquistionNo");
        }
        internal void SendRecquistion(Recquistion recquistion)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@RecqId", recquistion.RecqId));
            Param.Add(new KeyValuePair<string, object>("@RecqNo", recquistion.RecqNo));
            Param.Add(new KeyValuePair<string, object>("@StoreId", recquistion.StoreId));
            Param.Add(new KeyValuePair<string, object>("@ParentStore", recquistion.ParentStore));
            Param.Add(new KeyValuePair<string, object>("@RequestedBy", recquistion.RequestedBy));
            var RecqId = sqlHandler.ExecuteAsScalar<object>("USP_Req_SaveRecquistion", Param);
            if (recquistion.RecqId > 0)
            {
                List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                Param3.Add(new KeyValuePair<string, object>("@RecqId", Convert.ToInt32(RecqId)));
                sqlHandler.ExecuteNonQuery("USP_Req_DeletePrevRecquistionDetails", Param3);
            }
            foreach (RecquistionDetails item in recquistion.requestedItems)
            {
                List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                Param2.Add(new KeyValuePair<string, object>("@RecqId", Convert.ToInt32(RecqId)));
                Param2.Add(new KeyValuePair<string, object>("@ItemId", item.ItemId));
                Param2.Add(new KeyValuePair<string, object>("@Quantity", item.Quantity));
                Param2.Add(new KeyValuePair<string, object>("@Unit", item.Unit));
                sqlHandler.ExecuteNonQuery("USP_Req_SaveRecquistionDetails", Param2);
            }
        }
        internal void DeleteRecquistion(Recquistion recquistion)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@RecqId", recquistion.RecqId));
            Param.Add(new KeyValuePair<string, object>("@DeletedBy", recquistion.RequestedBy));
            sqlHandler.ExecuteAsScalar<string>("USP_Req_DeleteRecquistion", Param);
        }
        internal List<Recquistion> GetRecquistions(bool isMainStore)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@IsMainStore", isMainStore));
            List<Recquistion> recquistions = sqlHandler.ExecuteAsList<Recquistion>("USP_Req_GetRecquistion", Param);
            List<RecquistionDetails> recquistionDetails = sqlHandler.ExecuteAsList<RecquistionDetails>("USP_Req_GetRecquistionDetails", Param);
            foreach (Recquistion req in recquistions)
            {
                req.requestedItems = new List<RecquistionDetails>();
                req.requestedItems = recquistionDetails.Where(p => p.RecqId == req.RecqId).ToList();
            }
            return recquistions;
        }
        internal void IssueRecquistions(Recquistion recquistion)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RecqId", recquistion.RecqId));
                Param.Add(new KeyValuePair<string, object>("@IssuedBy", recquistion.RequestedBy));
                Param.Add(new KeyValuePair<string, object>("@ReceivedBy", recquistion.ReceivedBy));
                var a = sqlHandler.ExecuteAsScalar<object>("[USP_Req_SaveIssueForRecquistion]", Param);
                foreach (RecquistionDetails req in recquistion.requestedItems)
                {
                    List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                    Param3.Add(new KeyValuePair<string, object>("@RecqId", recquistion.RecqId));
                    Param3.Add(new KeyValuePair<string, object>("@IssueNo", Convert.ToInt32(a)));
                    Param3.Add(new KeyValuePair<string, object>("@RecqDetailId", req.RecqDetailId));
                    Param3.Add(new KeyValuePair<string, object>("@IssueQuantity", req.IssueQuantity));
                    Param3.Add(new KeyValuePair<string, object>("@IssuedBy", recquistion.RequestedBy));
                    sqlHandler.ExecuteAsScalar<string>("USP_Req_SaveIssueDetailsForRecquistion", Param3);
                }
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<itemsales> getOrderItemReport(DateTime startDate, DateTime endDate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            return sqlHandler.ExecuteAsList<itemsales>("USP_ItemOrderedReport", Param);
        }
        internal void UpdateItemStockStatus(ROInvItemForApi itemInfo)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemId", itemInfo.ItemId));
            //Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            sqlHandler.ExecuteNonQuery("USP_ROI_UpdateItemStockStatus", Param);
        }
        internal List<issueMain> GetIssueDetailsbyId(int imid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@IMId", imid));
            List<issueMain> obj = sqlHandler.ExecuteAsList<issueMain>("USP_GetIssueDetails", Param);
            return obj;
        }
        internal List<goodsReceiveMain> GetGoodRecievedPO()
        {
            List<goodsReceiveMain> Unitinfo = sqlHandler.ExecuteAsList<goodsReceiveMain>("USP_GetGoodRecievedPO");
            return Unitinfo;
        }
        internal void InactiveCombo()
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                sqlHandler.ExecuteNonQuery("USP_InactiveCombo");
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<goodsReceiveMain> getGoodReceived(int detailsId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@PurchaseDetailsID", detailsId));
            List<goodsReceiveMain> obj = sqlHandler.ExecuteAsList<goodsReceiveMain>("USP_CHECKPO_GOODRECEIVED", Param);
            return obj;
        }
        internal List<purchaseMains> getPurchaseDetailsFor(int purchaseid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@PurchaseMainID", purchaseid));
            List<purchaseMains> obj = sqlHandler.ExecuteAsList<purchaseMains>("usp_getPurchaseDetails", Param);
            return obj;
        }
        internal void SaveVendorForRecq(List<RecquistionDetails> recquistion)
        {
            foreach (var req in recquistion)
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@RecqId", req.RecqId));
                Param.Add(new KeyValuePair<string, object>("@RecqDetailId", req.RecqDetailId));
                Param.Add(new KeyValuePair<string, object>("@VendorId", req.VendorId));
                Param.Add(new KeyValuePair<string, object>("@AddedBy", req.AddedBy));
                sqlHandler.ExecuteNonQuery("USP_SaveRecquistionForVendor", Param);
            }
        }
        internal List<purchaseMains> getPoDetailsFromVendor(int vendorid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@VendorId", vendorid));
            List<purchaseMains> obj = sqlHandler.ExecuteAsList<purchaseMains>("USP_getDetailsFromVendor", Param);
            return obj;
        }
        internal void UpdateRoomBoking(RoomBookingsInfo roomBooking)
        {
            List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
            Param2.Add(new KeyValuePair<string, object>("@RoomBookDetailsID", roomBooking.RoomBookDetailsID));
            Param2.Add(new KeyValuePair<string, object>("@BookedFrom", roomBooking.BookedFrom));
            Param2.Add(new KeyValuePair<string, object>("@BookedTo", roomBooking.BookedTo));
            Param2.Add(new KeyValuePair<string, object>("@BookedDays", roomBooking.BookedDays));
            Param2.Add(new KeyValuePair<string, object>("@Rate", roomBooking.Rate));
            Param2.Add(new KeyValuePair<string, object>("@TotalAmount", roomBooking.TotalAmount));
            Param2.Add(new KeyValuePair<string, object>("@AdvancePayment", roomBooking.AdvancePayment));
            Param2.Add(new KeyValuePair<string, object>("@CustomerId", roomBooking.CustomerId));
            Param2.Add(new KeyValuePair<string, object>("@CustomerName", roomBooking.CustomerName));
            Param2.Add(new KeyValuePair<string, object>("@PhoneNo", roomBooking.PhoneNo));
            Param2.Add(new KeyValuePair<string, object>("@EmailAddress", roomBooking.EmailAddress));
            Param2.Add(new KeyValuePair<string, object>("@CtznNo", roomBooking.CtznNo));
            Param2.Add(new KeyValuePair<string, object>("@Remarks", roomBooking.Remarks));
            sqlHandler.ExecuteNonQuery("usp_ro_updateroombooking", Param2);

        }
        internal List<PaymentModes> GetPaymentModes()
        {
            return sqlHandler.ExecuteAsList<PaymentModes>("usp_ro_GetPaymentModes");
        }
        public List<issueMain> getForVerification(string receivedBy)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ReceivedBy", receivedBy));
            List<issueMain> verify = sqlHandler.ExecuteAsList<issueMain>("USP_GetIssueDetailsFromUser", Param);
            return verify;
        }
        internal void UpdateVerification(int imid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@IMId", imid));
            sqlHandler.ExecuteNonQuery("USP_UpdateVerification", Param);
        }
        internal void shiftItems(ShiftItems shift)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                if (shift.shiftType == "Complementary")
                {
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@CompMasterID", 0));
                    Param.Add(new KeyValuePair<string, object>("@TableId", shift.fromTable.ToString()));
                    Param.Add(new KeyValuePair<string, object>("@BasicAmount", shift.BasicAmount));
                    Param.Add(new KeyValuePair<string, object>("@BillNo", ""));
                    Param.Add(new KeyValuePair<string, object>("@Date", DateTime.Now));
                    Param.Add(new KeyValuePair<string, object>("@IsCancelled", false));
                    Param.Add(new KeyValuePair<string, object>("@TermAmount", 0));
                    Param.Add(new KeyValuePair<string, object>("@NetAmount", 0));
                    Param.Add(new KeyValuePair<string, object>("@UserName", shift.shiftedBy));
                    Param.Add(new KeyValuePair<string, object>("@Remarks", ""));
                    Param.Add(new KeyValuePair<string, object>("@IsSplit", false));
                    Param.Add(new KeyValuePair<string, object>("@GuestNo", 1));
                    Param.Add(new KeyValuePair<string, object>("@BillPaid", 0));
                    Param.Add(new KeyValuePair<string, object>("@RoomId", 0));
                    Param.Add(new KeyValuePair<string, object>("@OID", 0));
                    Param.Add(new KeyValuePair<string, object>("@OrderStatus", 0));
                    Param.Add(new KeyValuePair<string, object>("@Details", ""));
                    var obj = sqlHandler.ExecuteAsScalar<object>("[USP_SAVECOMPLEMENTARYMASTER]", Param);
                    int m = Convert.ToInt32(obj);

                    foreach (ShiftItemList item in shift.itemList)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        //Param.Add(new KeyValuePair<string, object>("@shiftType", shift.shiftType));
                        Param1.Add(new KeyValuePair<string, object>("@CompId", m));
                        Param1.Add(new KeyValuePair<string, object>("@fromTable", shift.fromTable));
                        Param1.Add(new KeyValuePair<string, object>("@fromSplitNo", shift.fromSplitNo));
                        Param1.Add(new KeyValuePair<string, object>("@shiftedBy", shift.shiftedBy));
                        Param1.Add(new KeyValuePair<string, object>("@ItemId", item.ItemId));
                        Param1.Add(new KeyValuePair<string, object>("@Quantity", item.Quantity));
                        Param1.Add(new KeyValuePair<string, object>("@IsCombo", item.IsCombo));

                        sqlHandler.ExecuteNonQuery("usp_ro_shiftItemsToComplementary", Param1);
                    }
                }
                else
                {
                    foreach (ShiftItemList item in shift.itemList)
                    {
                        List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                        //Param.Add(new KeyValuePair<string, object>("@shiftType", shift.shiftType));
                        Param.Add(new KeyValuePair<string, object>("@fromTable", shift.fromTable));
                        Param.Add(new KeyValuePair<string, object>("@fromSplitNo", shift.fromSplitNo));
                        Param.Add(new KeyValuePair<string, object>("@toTable", shift.toTable));
                        Param.Add(new KeyValuePair<string, object>("@toSplitNo", shift.toSplitNo));
                        Param.Add(new KeyValuePair<string, object>("@shiftedBy", shift.shiftedBy));
                        Param.Add(new KeyValuePair<string, object>("@ItemId", item.ItemId));
                        Param.Add(new KeyValuePair<string, object>("@Quantity", item.Quantity));
                        Param.Add(new KeyValuePair<string, object>("@IsCombo", item.IsCombo));


                        sqlHandler.ExecuteNonQuery("usp_ro_shiftItems", Param);
                    }
                }
                ts.Complete();
            }
        }
        internal List<restroTable> getTablesDataWithCurrentSplitNo()
        {
            return sqlHandler.ExecuteAsList<restroTable>("usp_ro_getTablesDataWithCurrentSplitNo");
        }
        internal List<SalesSummaryReport> getSalesSummaryReport(string room, string table, int invoiceno, string customer, string waiter, string cashier, int paymentmodeid, string provider, DateTime datefrom, DateTime dateTo, int timefrom, int timeTo)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Room", room));
            Param.Add(new KeyValuePair<string, object>("@Table", table));
            Param.Add(new KeyValuePair<string, object>("@InvoiceNo", invoiceno));
            Param.Add(new KeyValuePair<string, object>("@Customer", customer));
            Param.Add(new KeyValuePair<string, object>("@Waiter", waiter));
            Param.Add(new KeyValuePair<string, object>("@Cashier", cashier));
            Param.Add(new KeyValuePair<string, object>("@PaymentModeID", paymentmodeid));
            Param.Add(new KeyValuePair<string, object>("@Provider", provider));
            Param.Add(new KeyValuePair<string, object>("@DateFrom", datefrom));
            Param.Add(new KeyValuePair<string, object>("@DateTo", dateTo));
            Param.Add(new KeyValuePair<string, object>("@TimeFrom", timefrom));
            Param.Add(new KeyValuePair<string, object>("@TimeTo", timeTo));
            return sqlHandler.ExecuteAsList<SalesSummaryReport>("USP_Sales_Summary_Report", Param);
        }
        internal List<SalesSummaryReport> GetCustomerForReport()
        {
            return sqlHandler.ExecuteAsList<SalesSummaryReport>("USP_GetCustomer");
        }
        internal List<SalesSummaryReport> GetWaiterForReport()
        {
            return sqlHandler.ExecuteAsList<SalesSummaryReport>("USP_GetWaiter");
        }
        internal List<SalesSummaryReport> GetCashierForReport()
        {
            return sqlHandler.ExecuteAsList<SalesSummaryReport>("USP_GetCashier");
        }
        internal List<dailyreport> getPurchaseReport(string startDate, string endDate, int vendorId, string puNo)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@StartDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@EndDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@VendorID", vendorId));
            Param.Add(new KeyValuePair<string, object>("@puNo", puNo));
            List<dailyreport> obj = sqlHandler.ExecuteAsList<dailyreport>("Usp_getPurchaseReport", Param);
            return obj;
        }
        internal List<MvPurchaseDetails> getPurchaseNoForReport()
        {
            List<MvPurchaseDetails> Unitinfo = sqlHandler.ExecuteAsList<MvPurchaseDetails>("USP_ROI_GETPRUCHASENOFORREPORT");
            return Unitinfo;
        }
        internal void saveBevearge(List<ROInvItem> itemlist, List<extraItem> extraItemList = null)
        {
            int i = 0;
            foreach (ROInvItem inv in itemlist)
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ITId", inv.ITId));
                Param.Add(new KeyValuePair<string, object>("@PITId", inv.PITId));
                Param.Add(new KeyValuePair<string, object>("@ITName", inv.ITName));
                Param.Add(new KeyValuePair<string, object>("@IsMenu", inv.IsMenu));
                Param.Add(new KeyValuePair<string, object>("@IsActive", inv.IsActive));
                Param.Add(new KeyValuePair<string, object>("@AddedBy", inv.AddedBy));
                Param.Add(new KeyValuePair<string, object>("@IsTaxable", inv.IsTaxable));
                int ids = sqlHandler.ExecuteAsScalar<int>("[usp_roi_SaveItemsOfRestro]", Param);

                List<KeyValuePair<string, object>> Param4 = new List<KeyValuePair<string, object>>();
                Param4.Add(new KeyValuePair<string, object>("@ITId", ids));
                Param4.Add(new KeyValuePair<string, object>("@ITCode", inv.ITCode));
                Param4.Add(new KeyValuePair<string, object>("@ImagePath", inv.ImagePath));
                Param4.Add(new KeyValuePair<string, object>("@IsExpirable", inv.IsExpirable));
                Param4.Add(new KeyValuePair<string, object>("@IsProdMaterial", inv.IsProdMaterial));
                Param4.Add(new KeyValuePair<string, object>("@IsUnitWiseRate", inv.IsUnitWiseRate));
                Param4.Add(new KeyValuePair<string, object>("@ItemCostCentreID", inv.ItemCostCentreID));
                Param4.Add(new KeyValuePair<string, object>("@Details", inv.Details));
                Param4.Add(new KeyValuePair<string, object>("@SmallUnit", inv.SmallUnit));
                Param4.Add(new KeyValuePair<string, object>("@AddedBy", inv.AddedBy));
                Param4.Add(new KeyValuePair<string, object>("@IsExtra", inv.IsExtra));
                sqlHandler.ExecuteNonQuery("[usp_roi_SaveItemsDetailsOfRestro]", Param4);

                List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                Param2.Add(new KeyValuePair<string, object>("@ItemID", ids));
                Param2.Add(new KeyValuePair<string, object>("@SalesRate", inv.SRate));
                Param2.Add(new KeyValuePair<string, object>("@ValidFrom", DateTime.Now));
                Param2.Add(new KeyValuePair<string, object>("@AddedBy", inv.AddedBy));
                sqlHandler.ExecuteNonQuery("[usp_SaveItemWithUnit]", Param2);

                List<KeyValuePair<string, object>> Param5 = new List<KeyValuePair<string, object>>();
                Param5.Add(new KeyValuePair<string, object>("@ItemID", ids));
                Param5.Add(new KeyValuePair<string, object>("@Ingredient", inv.Ingredient));
                Param5.Add(new KeyValuePair<string, object>("@Quantity", inv.Quantity));
                sqlHandler.ExecuteNonQuery("usp_SaveIngredientWithQuantity", Param5);

                List<KeyValuePair<string, object>> Para = new List<KeyValuePair<string, object>>();
                Para.Add(new KeyValuePair<string, object>("@ItemID", ids));
                sqlHandler.ExecuteNonQuery("[usp_ro_removeextraitemsforitem]", Para);

                if (extraItemList != null && extraItemList.Count > 0)
                {
                    foreach (extraItem info2 in extraItemList)
                    {
                        List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                        Param3.Add(new KeyValuePair<string, object>("@ItemID", ids));
                        Param3.Add(new KeyValuePair<string, object>("@ExtraItemID", info2.ExtraItemID));
                        sqlHandler.ExecuteNonQuery("[usp_ro_extraitemforitemsave]", Param3);
                    }
                }
            }
            i = i + 1;
        }
        internal List<ItemShiftReport> getItemShiftReport(string itemname, string fromtable, string totable, string shiftedby, DateTime fromdate, DateTime todate)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ItemName", itemname));
            Param.Add(new KeyValuePair<string, object>("@FromTable", fromtable));
            Param.Add(new KeyValuePair<string, object>("@ToTable", totable));
            Param.Add(new KeyValuePair<string, object>("@ShiftedBy", shiftedby));
            Param.Add(new KeyValuePair<string, object>("@FromDate", fromdate));
            Param.Add(new KeyValuePair<string, object>("@ToDate", todate));
            List<ItemShiftReport> list = sqlHandler.ExecuteAsList<ItemShiftReport>("[USP_RO_GetShiftItemReport]", Param);
            return list;
        }
        internal List<goodReceiveDetails> GetGoodsReceivedDetailsByGMId(int gmid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@gmid", gmid));
            List<goodReceiveDetails> list = sqlHandler.ExecuteAsList<goodReceiveDetails>("[USP_RO_GetGoodsReceivedDetailsByGMId]", Param);
            return list;
        }
        internal List<ItemLedger> getItemledger(DateTime startDate, DateTime endDate, int itemId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@ToDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@ItemID", itemId));
            List<ItemLedger> obj = sqlHandler.ExecuteAsList<ItemLedger>("USP_getItemledger", Param);
            return obj;
        }
        internal void SaveProduction(ProductionMain production)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ItemId", production.ItemId));
                Param.Add(new KeyValuePair<string, object>("@UnitId", production.UnitId));
                Param.Add(new KeyValuePair<string, object>("@StoreId", production.StoreId));
                Param.Add(new KeyValuePair<string, object>("@Quantity", production.Quantity));
                Param.Add(new KeyValuePair<string, object>("@AddedOn", DateTime.Now));
                Param.Add(new KeyValuePair<string, object>("@AddedBy", production.AddedBy));
                var a = sqlHandler.ExecuteAsScalar<object>("USP_SaveProductionMain", Param);
                foreach (ProductionDetails prod in production.ProductItems)
                {
                    List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
                    Param3.Add(new KeyValuePair<string, object>("@ProductionMainID", Convert.ToInt32(a)));
                    Param3.Add(new KeyValuePair<string, object>("@ItemId", prod.ItemId));
                    Param3.Add(new KeyValuePair<string, object>("@ItemUnitId", prod.ItemUnitId));
                    Param3.Add(new KeyValuePair<string, object>("@Quantity", prod.Quantity));
                    Param3.Add(new KeyValuePair<string, object>("@StoreID", prod.StoreID));
                    sqlHandler.ExecuteAsScalar<string>("USP_SaveProductionDetail", Param3);
                }
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<ProductionMain> getProductionMain(DateTime fromDate, DateTime toDate, int storeid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", fromDate));
            Param.Add(new KeyValuePair<string, object>("@ToDate", toDate));
            Param.Add(new KeyValuePair<string, object>("@StoreId", storeid));
            List<ProductionMain> obj = sqlHandler.ExecuteAsList<ProductionMain>("USP_GetProductionMain", Param);
            return obj;
        }
        internal List<ProductionDetails> GetProductionDetailsByID(int id)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@ProductionMainID", id));
            List<ProductionDetails> list = sqlHandler.ExecuteAsList<ProductionDetails>("USP_GetProductionByID", Param);
            return list;
        }
        internal PinUser GetRolesByUsername(string username)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Username", username));
            return sqlHandler.ExecuteAsObject<PinUser>("USP_UserRolebyUsername", Param);
        }
        internal void SaveCashDenomination(CashDenomination cash)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@Date", DateTime.Now));
                Param.Add(new KeyValuePair<string, object>("@thousand", cash.thousand));
                Param.Add(new KeyValuePair<string, object>("@fivehundred", cash.fivehundred));
                Param.Add(new KeyValuePair<string, object>("@hundred", cash.hundred));
                Param.Add(new KeyValuePair<string, object>("@fifty", cash.fifty));
                Param.Add(new KeyValuePair<string, object>("@twenty", cash.twenty));
                Param.Add(new KeyValuePair<string, object>("@ten", cash.ten));
                Param.Add(new KeyValuePair<string, object>("@five", cash.five));
                Param.Add(new KeyValuePair<string, object>("@two", cash.two));
                Param.Add(new KeyValuePair<string, object>("@one", cash.one));
                sqlHandler.ExecuteNonQuery("USP_InsertCashDenomination", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<ROInvItem> GetItemNameByCatgeoryID(int pitid)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@PITId", pitid));
                List<ROInvItem> list = new List<ROInvItem>();
                list = sqlHandler.ExecuteAsList<ROInvItem>("USP_GETITEMFROMCATEGORY", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal bool SendToCBMS(int salesMasterId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                return sqlHandler.ExecuteAsScalar<bool>("usp_ro_updateInvoiceNo", Param);
            }
            catch (Exception)
            {
                return false;
            }
        }
        internal List<ROInvItem> GetCategoryHirerchy(int categorylevel)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@CategoryLevel", categorylevel));
                List<ROInvItem> Iteminfo = sqlHandler.ExecuteAsList<ROInvItem>("[USP_GetAllItemforCategoryHirerchy]", Param);
                return Iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<purchaseMains> GetPurchaseDetailsbypurchaseID(int purchasemainID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@PurchaseMainID", purchasemainID));
                List<purchaseMains> iteminfo = sqlHandler.ExecuteAsList<purchaseMains>("USP_PO_PurchaseReport", Param);
                return iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<goodsReceiveMain> GetGoodsDetailsbygmID(int gmID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@GMId", gmID));
                List<goodsReceiveMain> iteminfo = sqlHandler.ExecuteAsList<goodsReceiveMain>("USP_PO_GoodsRecieve", Param);
                return iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<OrderDetailCancel> GetOrderCancelledBY()
        {
            List<OrderDetailCancel> Unitinfo = sqlHandler.ExecuteAsList<OrderDetailCancel>("USP_GetOrderCancelledBY");
            return Unitinfo;
        }
        internal List<OrderDetailCancel> GetCancelledOrderBY()
        {
            List<OrderDetailCancel> Unitinfo = sqlHandler.ExecuteAsList<OrderDetailCancel>("USP_GetCancelledOrderBY");
            return Unitinfo;
        }
        internal List<OrderDetailCancel> GetOrderCancelResponsible()
        {
            List<OrderDetailCancel> Unitinfo = sqlHandler.ExecuteAsList<OrderDetailCancel>("USP_GetOrderCancelResponsible");
            return Unitinfo;
        }
        internal List<goodsReceiveMain> getGoodsReceiveReport(string startDate, string endDate, string PoNO, string GmNo, string itemname, int paymentID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@StartDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@EndDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@puNo", PoNO));
            Param.Add(new KeyValuePair<string, object>("@GmNo", GmNo));
            Param.Add(new KeyValuePair<string, object>("@itemname", itemname));
            Param.Add(new KeyValuePair<string, object>("@paymentID", paymentID));
            List<goodsReceiveMain> storeList = sqlHandler.ExecuteAsList<goodsReceiveMain>("[Usp_getGoodsReceiveReport]", Param);
            return storeList;
        }

        internal List<issueMain> getIssueReportDetails(string startDate, string endDate, string ISNo, string itemname)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@StartDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@EndDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@ISNo", ISNo));
            Param.Add(new KeyValuePair<string, object>("@itemname", itemname));
            List<issueMain> issueList = sqlHandler.ExecuteAsList<issueMain>("USP_GETIssueReport", Param);
            return issueList;
        }

        internal List<goodsReceiveMain> GetGoodsReceiveMainList()
        {
            List<goodsReceiveMain> Unitinfo = sqlHandler.ExecuteAsList<goodsReceiveMain>("Usp_getGoodsReceiveMain");
            return Unitinfo;
        }
        internal List<goodReceiveDetails> GetGoodsDetailsbyGMNo(string GMNo)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@GMNo", GMNo));
                List<goodReceiveDetails> iteminfo = sqlHandler.ExecuteAsList<goodReceiveDetails>("Usp_GetGoodReceiveDetailsbyGmNo", Param);
                return iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal List<PurchaseReturnMain> PurchaseReturnAutoNumber()
        {
            List<PurchaseReturnMain> Unitinfo = sqlHandler.ExecuteAsList<PurchaseReturnMain>("USP_ROI_PurchaseReturnAUTONUMBER");
            return Unitinfo;
        }


        internal int PurchaseReturn(PurchaseReturnMain PurchaseReturn)
        {
            using (TransactionScope ts = new TransactionScope())
            {
                try
                {
                    SQLHandler sqh = new SQLHandler();
                    List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                    Param.Add(new KeyValuePair<string, object>("@PRNo", PurchaseReturn.PRNo));
                    Param.Add(new KeyValuePair<string, object>("@PostedBy", PurchaseReturn.PostedBy));
                    Param.Add(new KeyValuePair<string, object>("@PostedOn", DateTime.Now));
                    Param.Add(new KeyValuePair<string, object>("@vendorId", PurchaseReturn.vendorId));
                    var a = sqh.ExecuteAsScalar<object>("Usp_SavePurchaseReturnMain", Param);
                    PurchaseReturn.PurchaseReturnId = Convert.ToInt32(a);

                    for (int i = 0; i < PurchaseReturn.goodReceiveDetails.Count; i++)
                    {
                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@PurchaseReturnId", PurchaseReturn.PurchaseReturnId));
                        Param1.Add(new KeyValuePair<string, object>("@GDId", PurchaseReturn.goodReceiveDetails[i].GDId));
                        Param1.Add(new KeyValuePair<string, object>("@STId", PurchaseReturn.goodReceiveDetails[i].STId));
                        Param1.Add(new KeyValuePair<string, object>("@ItemID", PurchaseReturn.goodReceiveDetails[i].ItemID));
                        Param1.Add(new KeyValuePair<string, object>("@Qnty", PurchaseReturn.goodReceiveDetails[i].Qnty));
                        Param1.Add(new KeyValuePair<string, object>("@UsedUnitID", PurchaseReturn.goodReceiveDetails[i].UsedUnitId));
                        Param1.Add(new KeyValuePair<string, object>("@Rate", PurchaseReturn.goodReceiveDetails[i].Rate));
                        Param1.Add(new KeyValuePair<string, object>("@Total", PurchaseReturn.goodReceiveDetails[i].Total));
                        sqh.ExecuteNonQuery("USP_SavePurchaseReturnDetails", Param1);

                    }
                    for (int i = 0; i < PurchaseReturn.PurchaseObjItemBal.Count; i++)
                    {

                        List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
                        Param1.Add(new KeyValuePair<string, object>("@ItemID", PurchaseReturn.PurchaseObjItemBal[i].ITId));
                        Param1.Add(new KeyValuePair<string, object>("@STId", PurchaseReturn.PurchaseObjItemBal[i].STId));
                        Param1.Add(new KeyValuePair<string, object>("@OPBal", PurchaseReturn.PurchaseObjItemBal[i].OPBal));
                        Param1.Add(new KeyValuePair<string, object>("@CLBal", PurchaseReturn.PurchaseObjItemBal[i].CLBal));
                        var b = sqh.ExecuteAsScalar<object>("[ROI_SavePurchaseReturnitembal]", Param1);
                        //ItemBal
                    }
                    ts.Complete();
                    return PurchaseReturn.PurchaseReturnId;

                }
                catch (Exception)
                {

                    throw;
                }
            }
        }


        internal List<PurchaseReturnMain> GetPurchaseReturnMainList()
        {
            List<PurchaseReturnMain> Unitinfo = sqlHandler.ExecuteAsList<PurchaseReturnMain>("USP_GetPurchaseReturnMain");
            return Unitinfo;
        }


        internal List<PurchaseReturnDetails> GetPurchaseReturnDetailsbyPRNo(string PRNo)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@PRNo", PRNo));
                List<PurchaseReturnDetails> iteminfo = sqlHandler.ExecuteAsList<PurchaseReturnDetails>("USP_GetPurchaseReturnDetailsByPRNo", Param);
                return iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal List<goodsReceiveMain> GetGoodsRecieveFromPurchaseID(int purchasemainID)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@PurchaseMainID", purchasemainID));
                List<goodsReceiveMain> iteminfo = sqlHandler.ExecuteAsList<goodsReceiveMain>("USP_PO_GoodsRecieveFromPurchaseID", Param);
                return iteminfo;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<PinUser> GetAllUserRoles()
        {
            try
            {
                List<PinUser> userroles = sqlHandler.ExecuteAsList<PinUser>("usp_ro_getUserRoles");
                return userroles;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal List<PinUser> GetPinSettings()
        {
            try
            {
                List<PinUser> rolePinSettings = sqlHandler.ExecuteAsList<PinUser>("usp_ro_getPinSettings");
                return rolePinSettings;
            }
            catch (Exception)
            {
                throw;
            }
        }
        internal bool CheckIfCBMSAlreadySent(int salesMasterId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
            return sqlHandler.ExecuteAsScalar<bool>("[usp_cbms_CheckIfCBMSAlreadySent]", Param);
        }
        internal List<goodsReceiveMain> GetPurchaseBook(string startDate, string endDate)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@StartDate", startDate));
                Param.Add(new KeyValuePair<string, object>("@EndDate", endDate));
                List<goodsReceiveMain> iteminfo = sqlHandler.ExecuteAsList<goodsReceiveMain>("USP_PurchaseBook", Param);
                return iteminfo;
            }
            catch (Exception)
            {
                throw;

            }
        }
        public List<restroTable> GetTakeAwayOrders()
        {
            try
            {
                List<restroTable> list = new List<restroTable>();
                list = sqlHandler.ExecuteAsList<restroTable>("[dbo].[USP_RO_GetTakeAwayOrders]");
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }


        internal List<CreditPayReport> getCreditReport(DateTime sdate, DateTime edate, string customer, bool? IsCustomer = null)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@sdate", sdate));
                Param.Add(new KeyValuePair<string, object>("@edate", edate));
                Param.Add(new KeyValuePair<string, object>("@Customer", customer));
                Param.Add(new KeyValuePair<string, object>("@IsCustomer", IsCustomer));
                return sqlHandler.ExecuteAsList<CreditPayReport>("USP_RO_getCreditReport", Param);
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        internal int saveTableReservation(TableReservation table)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@CustomerName", table.CustomerName));
            Param.Add(new KeyValuePair<string, object>("@ReservedDateTime", table.ReservedDateTime));
            Param.Add(new KeyValuePair<string, object>("@People", table.NoOfPeople));
            Param.Add(new KeyValuePair<string, object>("@ReservedBy", table.ReservedBy));
            Param.Add(new KeyValuePair<string, object>("@Phone", table.Phone));
            Param.Add(new KeyValuePair<string, object>("@NotifyBefore", table.NotifyBefore));
            Param.Add(new KeyValuePair<string, object>("@Note", table.Note));
            var obj = sqlHandler.ExecuteAsScalar<int>("USP_ROI_SaveTableReservation", Param);

            foreach (ReservedTable tbl in table.ReservedTable)
            {
                List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                Param2.Add(new KeyValuePair<string, object>("@ReservationID", obj));
                Param2.Add(new KeyValuePair<string, object>("@TableID", tbl.TableID));
                sqlHandler.ExecuteNonQuery("USP_ROI_SaveReservedTable", Param2);
            }

            return obj;
        }

        internal List<TableReservation> getReservedTable()
        {
            return sqlHandler.ExecuteAsList<TableReservation>("Usp_getGetReservedTableinFront");
        }

        internal List<TableReservation> getReservedTableList()
        {
            return sqlHandler.ExecuteAsList<TableReservation>("[Usp_getGetReservedTable]");
        }

        internal void ConfirmReservation(int reserveid, string confirmedby)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ReservationID", reserveid));
                Param.Add(new KeyValuePair<string, object>("@ConfirmedBy", confirmedby));
                sqlHandler.ExecuteNonQuery("USP_ConfirmReservation", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal void CancelReservation(int reserveid, string cancelledby)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ReservationID", reserveid));
                Param.Add(new KeyValuePair<string, object>("@CancelledBy", cancelledby));
                sqlHandler.ExecuteNonQuery("USP_CancelReservation", Param);
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal List<cumbomain> getUpcomingcumbolist()
        {
            return sqlHandler.ExecuteAsList<cumbomain>("USP_RO_GETUpcomingCUMBO");
        }

        internal List<cumbomain> getCancelledcumbolist()
        {
            return sqlHandler.ExecuteAsList<cumbomain>("USP_RO_GETCANCELLEDCUMBO");
        }

        internal List<TableReservation> getReservedTableListReport(string StartDate, string EndDate, string CustomerName, int TableId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@StartDate", StartDate));
                Param.Add(new KeyValuePair<string, object>("@EndDate", EndDate));
                Param.Add(new KeyValuePair<string, object>("@CustomerName", CustomerName));
                Param.Add(new KeyValuePair<string, object>("@TableID", TableId));
                return sqlHandler.ExecuteAsList<TableReservation>("Usp_getGetReservedTableReport", Param);
            }
            catch (Exception e)
            {
                throw e;

            }
        }

        internal List<OrderDetailClass> getAllOrderDetailReport(DateTime startDate, DateTime endDate, int tableid, int costCenter)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@tableId", tableid));
            Param.Add(new KeyValuePair<string, object>("@costCenter", costCenter));
            return sqlHandler.ExecuteAsList<OrderDetailClass>("usp_ro_getOrderDetailsAll", Param);
        }

        internal List<OrderDetailClass> getOrderDetailsReportSummary(DateTime startDate, DateTime endDate, int tableid, int costCenter)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@tableId", tableid));
            Param.Add(new KeyValuePair<string, object>("@costCenter", costCenter));
            return sqlHandler.ExecuteAsList<OrderDetailClass>("[usp_ro_getOrderDetailsSummary]", Param);
        }

        internal List<DailyClosingReport> ClosDayReport(string fromDate, string toDate)
        {

            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@FromDate", fromDate));
            Param.Add(new KeyValuePair<string, object>("@ToDate ", toDate));
            return sqlHandler.ExecuteAsList<DailyClosingReport>("[USP_RO_GetDailyFinancialReport]", Param);
        }

        internal List<RoomBookingsInfo> getRoomBookingReport(string startDate, string endDate, string customer, string table)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@StartDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@EndDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@CustomerName", customer));
            Param.Add(new KeyValuePair<string, object>("@TableName", table));
            return sqlHandler.ExecuteAsList<RoomBookingsInfo>("USP_GETROOMREPORT", Param);
        }

        internal List<RoomBookingsInfo> getCustomerNameFromRoomBooking()
        {
            return sqlHandler.ExecuteAsList<RoomBookingsInfo>("USP_GetCustomerNameFromRoomBooking");
        }

        internal List<unitclassforitem> getMenuForGlobalization(int languageid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@LanguageID", languageid));
            return sqlHandler.ExecuteAsList<unitclassforitem>("USP_GetItemsForGlobalization", Param);
        }

        internal List<LanguageMenu> getLanguage()
        {
            return sqlHandler.ExecuteAsList<LanguageMenu>("sp_LanguageGet");
        }

        internal void saveLanguageMenu(int languageid, List<LanguageMenu> LanguageMenu)
        {
            List<KeyValuePair<string, object>> Param3 = new List<KeyValuePair<string, object>>();
            Param3.Add(new KeyValuePair<string, object>("@LanguageID", languageid));
            sqlHandler.ExecuteNonQuery("USP_DeleteGlobalizedMenubyLanguageId", Param3);

            foreach (LanguageMenu lm in LanguageMenu)
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@ItemId", lm.ItemID));
                Param.Add(new KeyValuePair<string, object>("@LanguageID", lm.LanguageID));
                Param.Add(new KeyValuePair<string, object>("@Text", lm.Text));
                sqlHandler.ExecuteNonQuery("USP_SaveGlobalizedMenu", Param);
            }
        }

        internal List<MenuClass> getGlobalizedMenu(int languageid)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@LanguageID", languageid));
            return sqlHandler.ExecuteAsList<MenuClass>("USP_RO_GETGLOBALIZEDMENU", Param);
        }
        internal List<Token> getOrderTokenByOrderMasterId(int orderMasterId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@orderMasterId", orderMasterId));
                List<Token> list = new List<Token>();
                list = sqlHandler.ExecuteAsList<Token>("USP_getOrderTokenByOrderMasterId", Param);
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }



        public Token getOrderNobyOrderMasterId(int orderMasterId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@orderMasterId", orderMasterId));
                return sqlHandler.ExecuteAsObject<Token>("USP_getordernobyOrdermasterId", Param);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public List<Token> GetOrderDeliveryList()
        {
            try
            {
                List<Token> list = new List<Token>();
                list = sqlHandler.ExecuteAsList<Token>("USP_RO_GetOrderDeliveryList");
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }



        internal void saveTableLayout(List<SaveLayoutTable> table)
        {

            foreach (SaveLayoutTable tbl in table)
            {
                List<KeyValuePair<string, object>> Param2 = new List<KeyValuePair<string, object>>();
                Param2.Add(new KeyValuePair<string, object>("@RoomID", tbl.RoomID));
                Param2.Add(new KeyValuePair<string, object>("@TableID", tbl.TableID));
                Param2.Add(new KeyValuePair<string, object>("@UserModuleID", tbl.UserModuleID));
                sqlHandler.ExecuteNonQuery("usp_saveRestro_layout", Param2);
            }


        }



        internal List<restroTable> getLayoutTable(int UserModuleID)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@UserModuleID", UserModuleID));
            return sqlHandler.ExecuteAsList<restroTable>("usp_GetRestro_layout", Param);
        }

        public List<dailyreports> GetOrderDeliveredList()
        {
            try
            {
                List<dailyreports> list = new List<dailyreports>();
                list = sqlHandler.ExecuteAsList<dailyreports>("USP_GETORDERDELIVEREDTIME");
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<ordertype> GetOrderType()
        {
            try
            {
                List<ordertype> list = new List<ordertype>();
                list = sqlHandler.ExecuteAsList<ordertype>("USP_GETORDERTYPE");
                return list;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal void UpdateAcc()
        {
            try
            {

                sqlHandler.ExecuteNonQuery("USP_UpdateAcc");

            }
            catch (Exception)
            {
                throw;
            }
        }


        internal List<CheckBill> checkOrder(int orderMasterId, int seatNo, int tableId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@OrderMasterId", orderMasterId));
            Param.Add(new KeyValuePair<string, object>("@SeatNo", seatNo));
            Param.Add(new KeyValuePair<string, object>("@TableId", tableId));
            return sqlHandler.ExecuteAsList<CheckBill>("CHECKBILL", Param);
        }

        internal List<CogsReport> getItemDailyProfit(DateTime startDate, DateTime endDate, int itemId)
        {
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            Param.Add(new KeyValuePair<string, object>("@ItemID", itemId));
            return sqlHandler.ExecuteAsList<CogsReport>("usp_RO_ItemDailyProfit", Param);
        }

        internal SalesMaster GetSalesMasterDtll(int salesMasterId)
        {
            try
            {
                List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
                Param.Add(new KeyValuePair<string, object>("@salesMasterId", salesMasterId));
                SalesMaster lst = sqlHandler.ExecuteAsObject<SalesMaster>("[USP_RO_GetSalesMasterDtls]", Param);
                return lst;
            }
            catch (Exception)
            {
                throw;
            }
        }

        internal DataSet GetCostCenterDiscountReport(string startDate, string endDate)
        {
            //[dbo].[usp_ro_getcostcenterdiscountreport]
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@startDate", startDate));
            Param.Add(new KeyValuePair<string, object>("@endDate", endDate));
            return sqlHandler.ExecuteAsDataSet("usp_ro_getcostcenterdiscountreport", Param);
        }

        internal List<ProductionMain> getPreviousProduction()
        {
            List<ProductionMain> list = new List<ProductionMain>();
            list = sqlHandler.ExecuteAsList<ProductionMain>("usp_GetPreviousProduction");
            return list;
        }

        internal List<ProductionDetails> getPreviousProductionDetailsById(int ProductionId)
        {
            List<ProductionDetails> list = new List<ProductionDetails>();
            List<KeyValuePair<string, object>> Param = new List<KeyValuePair<string, object>>();
            Param.Add(new KeyValuePair<string, object>("@Id", ProductionId));
            list = sqlHandler.ExecuteAsList<ProductionDetails>("usp_GetPreviousProductionDetailsById", Param);
            return list;
        }

        internal License getLicense(string companyCode)
        {
            List<KeyValuePair<string, object>> Param1 = new List<KeyValuePair<string, object>>();
            Param1.Add(new KeyValuePair<string, object>("@CompanyCode", companyCode));
            License license = sqlHandler.ExecuteAsObject<License>("SpLicenseSel", Param1);
            return license;
        }

    }
}

