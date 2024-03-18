using System;
using System.Collections.Generic;
using SageFrame.RestoLoyalty;
using SageFrame.FiscalYear;
using System.Data;
using SageFrame.Security.Entities;
using OfficeOpenXml.FormulaParsing.Excel.Functions.DateTime;
namespace SageFrame.RestroOrder
{
    public class RestrOrderController
    {
        private RestrOrderProvider restroOrderProvider;
        public RestrOrderController()
        {
            restroOrderProvider = new RestrOrderProvider();
        }


        #region cbms
        public bool CheckIfCBMSAlreadySent(int salesMasterId)
        {
            return restroOrderProvider.CheckIfCBMSAlreadySent(salesMasterId);
        }
        public int savePostedBill(BillViewModel bill, string statusCode, string status, DateTime postedDate, int salesMasterId, string englishInvDate)
        {
            return restroOrderProvider.savePostedBill(bill, statusCode, status, postedDate, salesMasterId, englishInvDate);
        }
        public List<BillPostLog> getErrorBillPostLog()
        {
            return restroOrderProvider.getErrorBillPostLog();
        }
        public void updatePostedBill(int logId, string statusCode, string status, DateTime postedDate, int salesMasterId, bool isRealTime)
        {
            restroOrderProvider.updatePostedBill(logId, statusCode, status, postedDate, salesMasterId, isRealTime);
        }
        public CbmsData getCbmsData()
        {
            return restroOrderProvider.getCbmsData();
        }
        public List<CbmsSyncedData> getCbmsSyncedData(int days)
        {
            return restroOrderProvider.getCbmsSyncedData(days);
        }
        public List<BillPostLog> GetSalesBook(string fromDate, string toDate)
        {
            return restroOrderProvider.GetSalesBook(fromDate, toDate);
        }
        public List<ReturnBillPostLog> GetReturnedSalesBook(string fromDate, string toDate)
        {
            //var splitData = mnthYear.Split('/');
            //int month = Convert.ToInt32(splitData[0]);
            //int year = Convert.ToInt32(splitData[1]);
            return restroOrderProvider.GetReturnedSalesBook(fromDate, toDate);
        }
        public BillPostLog GetPostedBillBySalesMasterId(int salesMasterId)
        {
            return restroOrderProvider.GetPostedBillBySalesMasterId(salesMasterId);
        }
        public ReturnBillPostLog saveReturnedBill(BillReturnViewModel billreturn, string statusCode, string status, DateTime postedDate, int salesMasterId)
        {
            return restroOrderProvider.saveReturnedBill(billreturn, statusCode, status, postedDate, salesMasterId);
        }

        public void CancelSalesBook(int salesMasterId)
        {
            restroOrderProvider.CancelSalesBook(salesMasterId);
        }

        public List<ReturnBillPostLog> getErrorReturnBillPostLog()
        {
            return restroOrderProvider.getErrorReturnBillPostLog();
        }
        public void updateReturnedBill(int returnLogId, string statusCode, string status, DateTime postedDate, int salesMasterId, bool isRealTime)
        {
            restroOrderProvider.updateReturnedBill(returnLogId, statusCode, status, postedDate, salesMasterId, isRealTime);
        }
        #endregion
        #region Read json from Database
        public List<ROGETITEMResulttest> GetItemJsonFromDatabase()
        {
            return restroOrderProvider.GetItemJsonFromDatabase();
        }
        #endregion
        #region Read json For Restro Room Database
        public List<RestroRoom> GetRoomWithTable()
        {
            return restroOrderProvider.GetRoomWithTable();
        }
        public List<restroTable> GetTableByRoomId(int roomId)
        {
            return RestrOrderProvider.GetTableByRoomId(roomId);
        }
        #endregion
        #region Unit Table
        public void UnitSaveTodatabase(UnitClass UnitInf)
        {
            restroOrderProvider.UnitSaveTodatabase(UnitInf);
        }
        public List<Unit> GetUnitFromDatabase()
        {
            return RestrOrderProvider.GetUnitFromDatabase();
        }
        public void UnitDelete(int ID)
        {
            restroOrderProvider.UnitDelete(ID);
        }
        #endregion
        #region Menu Table
        public void MenuSaveTodatabase(MenuClass MenuInf)
        {
            restroOrderProvider.MenuSaveTodatabase(MenuInf);
        }
        //public List<MenuClass> GetMenuFromDatabase()
        //{
        //    
        //    return RestrOrderProvider.GetMenuFromDatabase();
        //}
        public void MenuDelete(int ID)
        {
            restroOrderProvider.MenuDelete(ID);
        }
        #endregion
        #region ItemClass
        public void ItemSaveTodatabase(ItemsClass ItemInf)
        {
            restroOrderProvider.ItemSaveTodatabase(ItemInf);
        }
        public List<ItemsClass> GetItemFromDatabase()
        {
            return RestrOrderProvider.GetItemFromDatabase();
        }
        public ROInvItem GetItemDetail(int itemID, bool IsCombo)
        {
            return restroOrderProvider.GetItemDetail(itemID, IsCombo);
        }
        public void ItemDelete(int ItemID)
        {
            restroOrderProvider.ItemDelete(ItemID);
        }
        #endregion
        #region InventItem
        public List<ROInvItem> GetInvItemFromDatabase()
        {
            return RestrOrderProvider.GetInvItemFromDatabase();
        }
        public List<OrderMasterClass> GetAllOrder(int BillPayed, bool IsCancel, string TableID)
        {
            return RestrOrderProvider.GetAllOrder(BillPayed, IsCancel, TableID);
        }
        #endregion
        #region CategoriesClass
        public void CategoriesSaveTodatabase(CategoriesClass CategoriesInf)
        {
            restroOrderProvider.CategoriesSaveTodatabase(CategoriesInf);
        }
        public List<CategoriesClass> GetCategoriesFromDatabase()
        {
            return RestrOrderProvider.GetCategoriesFromDatabase();
        }
        public void CategoriesDelete(int CategoriesID)
        {
            restroOrderProvider.CategoriesDelete(CategoriesID);
        }
        #endregion
        #region OrderMasterClass
        public void OrderMasterSaveTodatabase(OrderMasterClass OrderMasterInf)
        {
            restroOrderProvider.OrderMasterSaveTodatabase(OrderMasterInf);
        }
        public List<OrderDetailClass> OrderMasterSaveTodatabase(OrderMasterClass orderMasterInfo, List<OrderDetailClass> repeateditem)
        {
            List<OrderDetailClass> orderList = restroOrderProvider.OrderMasterSaveTodatabase(orderMasterInfo, repeateditem);
            return orderList;
        }
        //public List<OrderMasterClass> GetOrderMasterFromDatabase()
        //{
        //    
        //    return RestrOrderProvider.GetOrderMasterFromDatabase();
        //}
        public OrderMasterClass GetOrderDetailsFromDatabase(string tableId)
        {
            return RestrOrderProvider.GetOrderDetailsFromDatabase(tableId);
        } 
        public void TempPurchaseDetailTsk(MvTempPurchaseDetail item)
        {
            RestrOrderProvider.TempPurchaseDetailTsk(item);
        }
        public List<OrderMasterClass> GetAllOrder()
        {
            return RestrOrderProvider.GetAllOrder();
        }
        public List<OrderMasterClass> GetAllPickOrder()
        {
            return RestrOrderProvider.GetAllPickOrder();
        }
        public void DeleteOrderDetailByMaster(int OrderMasterID, string UserName)
        {
            restroOrderProvider.DeleteOrderDetailsByMaster(OrderMasterID, UserName);
        }
        public List<RestrOrderInfo> GetTableName()
        {
            return RestrOrderProvider.GetTableName();
        }
        public restroTable GetTableNoBYId(int restrotableId)
        {
            return restroOrderProvider.getRestroTableByID(restrotableId);
        }
        public List<OrderDetailClass> GetOrderDetailWithStatus(int tableId)
        {
            return restroOrderProvider.GetOrderDetailWithStatus(tableId);
        }
        public List<OrderDetailClass> GetOrderDetailsByMaster(int orderMasterId)
        {
            return restroOrderProvider.GetOrderDetailsByMaster(orderMasterId);
        }
        public void OrderCancel(OrderMasterClass orderMaster)
        {
            restroOrderProvider.OrderCancel(orderMaster);
        }
        public void CancelOrder(OrderMasterClass orderMaster)
        {
            restroOrderProvider.CancelOrder(orderMaster);
        }
        #endregion
        #region Currency
        public void CurrencySaveTodatabase(CurrencyClass CurrencyInf)
        {
            restroOrderProvider.CurrencySaveTodatabase(CurrencyInf);
        }
        public void SaveDBLog(string Operation, string destinationPath, string UserName)
        {
            restroOrderProvider.SaveDBLog(Operation, destinationPath, UserName);
        }
        public List<CurrencyClass> GetCurrencyFromDatabase()
        {
            return RestrOrderProvider.GetCurrencyFromDatabase();
        }
        public void CurrencyDelete(int ID)
        {
            restroOrderProvider.CurrencyDelete(ID);
        }
        public CurrencyClass GetCurrencyBYId(int currenctId)
        {
            return restroOrderProvider.getCurrencyByID(currenctId);
        }
        #endregion
        #region Account Section
        #region Enum
        public void EnumSaveTodatabase(EnumClass EnumInf)
        {
            restroOrderProvider.EnumSaveTodatabase(EnumInf);
        }
        public List<EnumClass> GetEnumFromDatabase()
        {
            return RestrOrderProvider.GetEnumFromDatabase();
        }
        public void EnumDelete(int ID)
        {
            restroOrderProvider.EnumDelete(ID);
        }
        public EnumClass GetEnumBYId(int EnumId)
        {
            return restroOrderProvider.getEnumByID(EnumId);
        }
        #endregion
        #region AccountGroup
        public void AccountGroupSaveTodatabase(modalAccountGroup AccountGroupInf)
        {
            restroOrderProvider.AccountGroupSaveTodatabase(AccountGroupInf);
        }
        public List<modalAccountGroup> GetAccountGroupfromDatabase()
        {
            return RestrOrderProvider.GetAccountGroupfromDatabase();
        }
        public void AccountGroupDelete(int id)
        {
            restroOrderProvider.AccountGroupDelete(id);
        }
        #endregion
        #region AccountSubGroup
        public void AccountSubGroupSaveTodatabase(modalAccountSubGroup AccountSubGroupInf)
        {
            restroOrderProvider.AccountSubGroupSaveTodatabase(AccountSubGroupInf);
        }
        public List<modalAccountSubGroup> GetAccountSubGroupfromDatabase()
        {
            return RestrOrderProvider.GetAccountSubGroupfromDatabase();
        }
        public modalAccountSubGroup GetAccountSubGroupfromDatabaseById(int Id)
        {
            return RestrOrderProvider.GetAccountSubGroupfromDatabaseById(Id);
        }
        public void AccountSubGroupDelete(int id)
        {
            restroOrderProvider.AccountSubGroupDelete(id);
        }
        #endregion
        #endregion
        #region Company
        public void saveCompany(companyInfo ci)
        {
            restroOrderProvider.savecompanyInfo(ci);
        }
        public List<companyInfo> getcompanyInfo()
        {
            return restroOrderProvider.getCompanyInfo();
        }
        public void deleteCompanyinfo(int id)
        {
            restroOrderProvider.deleteCompany(id);
        }
        public companyInfo getcompany()
        {
            return restroOrderProvider.getcompany();
        }
        #endregion
        #region Billing Term
        public int saveBillingTerm(billingTerm bt)
        {
            return restroOrderProvider.saveBillingTerm(bt);
        }
        public void deleteBillTerm(int id)
        {
            restroOrderProvider.deleteBillTerm(id);
        }
        public List<billingTerm> getbillInfo()
        {
            return restroOrderProvider.getbillInfo();
        }
        public billingTerm getbillInfoById(int index)
        {
            return restroOrderProvider.getbillInfoById(index);
        }
        #endregion
        #region Table
        public void saveTable(restroTable rt)
        {
            restroOrderProvider.saveRestrotable(rt);
        }
        public List<restroTable> getRestroTable()
        {
            return restroOrderProvider.getrestroTable();
        }
        public void deleteTable(int id)
        {
            restroOrderProvider.deleteTable(id);
        }
        public void SaveMergeTable(List<MergeTableInfo> mergeTable, string[] occupiedTableIds)
        {
            restroOrderProvider.SaveMergeTableList(mergeTable, occupiedTableIds);
        }
        #endregion
        #region ROOM
        public void saveRoom(RestroRoom rt)
        {
            restroOrderProvider.saveRestroRoom(rt);
        }
        public List<RestroRoom> getRestroRoom()
        {
            return restroOrderProvider.getrestroRoom();
        }
        public RestroRoom getRestroRoomById(int id)
        {
            return restroOrderProvider.getRestroRoomByID(id);
        }
        public void deleteRoom(int id)
        {
            restroOrderProvider.deleteRoom(id);
        }
        public RestroRoom GetRoomNoBYId(int restroroomId)
        {
            return restroOrderProvider.getRestroRoomByID(restroroomId);
        }
        public void saveRoomType(RoomType srt)
        {
            restroOrderProvider.saveRoomType(srt);
        }
        #endregion
        #region other
        public List<CategoriesClass> getCategory()
        {
            return RestrOrderProvider.getCategory();
        }
        public List<MenuClass> GetMenuFromDatabase()
        {
            return RestrOrderProvider.GetMenuFromDatabase();
        }
        public List<ClassforMenuItem> GetMenuFromDatabase1(int pitId, int level)
        {
            return RestrOrderProvider.GetMenuFromDatabase1(pitId, level);
        }
        public decimal GetnetAmount(decimal amount)
        {
            return restroOrderProvider.GetNetAmount(amount);
        }
        public string GetInWord(decimal amount, string currencyname, string subcurrencyname)
        {
            return restroOrderProvider.GetInWord(amount, currencyname, subcurrencyname);
        }
        public List<ItemsClass> GetItemFromDatabaseByPagination(int offset, int limit)
        {
            return RestrOrderProvider.GetItemFromDatabaseByPagination(offset, limit);
        }
        #endregion Other
        #region SMS
        public int savePostedSMS(string mobile, string message)
        {
            return restroOrderProvider.savePostedSMS(mobile, message);
        }
        #endregion
        public List<ActivityLog> GetActivityLog(DateTime StartDate, DateTime EndDate, string User)
        {
            return restroOrderProvider.GetActivityLog(StartDate, EndDate, User);
        }
        public List<StockDetail> getStockDetailByItem(StockDetailItem obj)
        {
            return restroOrderProvider.getStockDetailByItem(obj);
        }

        public List<RoomType> getRoomType()
        {
            return restroOrderProvider.getRoomType();
        }
        public RoomType getRoomTypeByID(int ID)
        {
            return restroOrderProvider.getRoomTypeByID(ID);
        }
        public void deleteRoomType(string ID)
        {
            restroOrderProvider.deleteRoomType(ID);
        }
        public List<RoomType> GetrestroFullDetail()
        {
            return restroOrderProvider.GetrestroFullDetail();
        }
        public List<restroTable> Gettabledataforshift()
        {
            return restroOrderProvider.Gettabledataforshift();
        }
        public void shiftTable(int fromordermasterid, int totableID, int fromSeatNo, int toSeatNo, string shiftedby)
        {
            restroOrderProvider.shiftTable(fromordermasterid, totableID, fromSeatNo, toSeatNo, shiftedby);
        }
        public List<RestroRoom> GetRoomByRoomTypeId(int RoomTypeID)
        {
            return restroOrderProvider.GetRoomByRoomTypeId(RoomTypeID);
        }
        public List<restroTable> GetOccupiedTables(bool isTable)
        {
            return restroOrderProvider.GetOccupiedTables(isTable);
        }
        public List<restroTable> GetComplimentaryOccupiedTables(bool isTable)
        {
            return restroOrderProvider.GetComplimentaryOccupiedTables(isTable);
        }
        public List<restroTable> GetTableByRoomTypeId(int RoomId)
        {
            return restroOrderProvider.GetTableByRoomTypeId(RoomId);
        }
        public List<OrderDetailClass> GettabledataById(int TableId)
        {
            return restroOrderProvider.GettabledataById(TableId);
        }
        public List<OrderDetailClass> Getpickdata(int TableId)
        {
            return restroOrderProvider.GetPickData(TableId);
        }
        public List<OrderDetailClass> GettabledataByIdforMenu(int TableId)
        {
            return restroOrderProvider.GettabledataByIdforMenu(TableId);
        }
        public List<RoomBookingsInfo> GetroomdataByIdforMenu(int tableId)
        {
            return restroOrderProvider.GetroomdataByIdforMenu(tableId);
        }
        public List<costCenter> getcostcenter()
        {
            return restroOrderProvider.getcostcenter();
        }
        public List<costCenterReport> getAllCostCenterReport(DateTime startDate, DateTime endDate, int costCenter)
        {
            return restroOrderProvider.getAllCostCenterReport(startDate, endDate, costCenter);
        }
        public List<costCenterReport> getDailyCostCenterReport(DateTime startDate, DateTime endDate, int costCenter)
        {
            return restroOrderProvider.getDailyCostCenterReport(startDate, endDate, costCenter);
        }
        public List<costCenterReport> getSummaryCostCenterReport(DateTime startDate, DateTime endDate, int costCenter)
        {
            return restroOrderProvider.getSummaryCostCenterReport(startDate, endDate, costCenter);
        }
        public List<OrderDetailClass> getitemprocessing(int costcenterID)
        {
            return restroOrderProvider.getitemprocessing(costcenterID);
        }
        public List<OrderDetailClass> inprocess(int ItemID, int StatusID)
        {
            return restroOrderProvider.inprocess(ItemID, StatusID);
        }
        public List<customerBilling> getbillingTerm(decimal val)
        {
            return restroOrderProvider.getbillingTerm(val);
        }
        //public List<dailyreport> getdailyReport(DateTime dateTime)
        //{
        //    
        //    return restroOrderProvider.getdailyReport(dateTime);
        //}
        public void saveSalesBill(SalesMaster sm, List<SalesDetails> sd, int splited, List<customerBilling> bt)
        {
            restroOrderProvider.saveSalesBill(sm, sd, splited, bt);
        }
        public List<CategoriesClass> GetCategoriesBymenuID(int MenuId, int languageid)
        {
            return restroOrderProvider.GetCategoriesBymenuID(MenuId, languageid);
        }
        public List<ItemsClass> GetItemByCategoryID(int CategoriesID, int LanguageID)
        {
            return restroOrderProvider.GetItemByCategoryID(CategoriesID, LanguageID);
        }
        public void SaveOrderIntoDataBase(OrderMasterClass OrderMasterInf)
        {
            restroOrderProvider.OrderMasterSaveTodatabase(OrderMasterInf);
        }
        public List<ItemsClass> GetPreviousItemByID(int Id)
        {
            return restroOrderProvider.GetPreviousItemByID(Id);
        }
        public List<ItemsClass> GetPreviousItemByRoomID(int Id)
        {
            return restroOrderProvider.GetPreviousItemByRoomID(Id);
        }
        public List<dailyreport> getdailyReport(DateTime dateTime)
        {
            return restroOrderProvider.getdailyReport(dateTime);
        }
        public List<dailyreports> getSalesReport(DateTime startDate, DateTime endDate, string PaymentMode, int Status, int OrdertypeID, string custName = "")
        {
            List<dailyreports> salesReport = restroOrderProvider.getSalesReport(startDate, endDate, PaymentMode, Status, OrdertypeID, custName);
            return salesReport;//.Where(p => p.PaymentModes.ToLower().Contains(PaymentMode.ToLower()) && (p.Status == Status || Status == -1)).ToList();
        }

        public List<dailyreports> getSalesReportForSalesReturn(DateTime startDate, DateTime endDate, string billNo = "")
        {
            List<dailyreports> salesReport = restroOrderProvider.getSalesReportForSalesReturn(startDate, endDate, billNo);
            return salesReport;//.Where(p => p.PaymentModes.ToLower().Contains(PaymentMode.ToLower()) && (p.Status == Status || Status == -1)).ToList();
        }

        public List<dailyreports> getAccSalesReport(DateTime startDate, DateTime endDate, string PaymentMode, int Status, int OrdertypeID, string custName = "")
        {
            List<dailyreports> salesReport = restroOrderProvider.getAccSalesReport(startDate, endDate, PaymentMode, Status, OrdertypeID, custName);
            return salesReport;//.Where(p => p.PaymentModes.ToLower().Contains(PaymentMode.ToLower()) && (p.Status == Status || Status == -1)).ToList();
        }


        public List<dailyreport> getdailyReportBySum(DateTime dateTime)
        {
            return restroOrderProvider.getdailyReportBySum(dateTime);
        }
        public List<dailyreport> getweeklysumbyDate(DateTime dateTime)
        {
            return restroOrderProvider.getweeklysumbyDate(dateTime);
        }
        public List<dailyreport> getdailyReportByWeekly(DateTime dateTime)
        {
            return restroOrderProvider.getdailyReportByWeekly(dateTime);
        }
        public List<dailyreport> getdailyReportByMonthly(string year, string month)
        {
            return restroOrderProvider.getdailyReportByMonthly(year, month);
        }
        public List<dailyreport> getdailyReportByYearly(string year)
        {
            return restroOrderProvider.getdailyReportByYearly(year);
        }
        public List<itemsales> getDailyItemSalesReport(DateTime startDate, DateTime endDate, int costCenterID, int pitid)
        {
            return restroOrderProvider.getDailyItemSalesReport(startDate, endDate, costCenterID, pitid);
        }
        public List<itemsales> getSummaryItemSalesReport(DateTime startDate, DateTime endDate, int costCenterID, int pitid)
        {
            return restroOrderProvider.getSummaryItemSalesReport(startDate, endDate, costCenterID, pitid);
        }
        public List<bestby> getdatabyBest()
        {
            return restroOrderProvider.getdatabyBest();
        }
        public RestroRoom GetRoomByTable(int p)
        {
            return restroOrderProvider.GetRoomByTable(p);
        }
        public List<OrderDetailClass> GetDataforPrint(int TableId)
        {
            return restroOrderProvider.GetDataforPrint(TableId);
            //Getpickdata
            //GetDataforPrint
        }
        public void updateIsPrinted(int id)
        {
            restroOrderProvider.updateIsprinted(id);
        }
        public int SaveCus(Cusinfo Cusinfo)
        {
            int OrderId = restroOrderProvider.SaveCus(Cusinfo);
            return OrderId;
        }
        public string DoesTableNameExist(string tableName)
        {
            return restroOrderProvider.DoesTableNameExist(tableName);
        }
        public string DoesRoomNameExist(string roomName)
        {
            return restroOrderProvider.DoesRoomNameExist(roomName);
        }
        public string DoesRoomTypeExist(string roomType)
        {
            return restroOrderProvider.DoesRoomTypeExist(roomType);
        }
        public List<OrderDetailClass> Getdataforsplitbill(int TableId)
        {
            return restroOrderProvider.Getdataforsplitbill(TableId);
        }
        public List<MemberInfo> CheckLoyaltyForDiscount(string MembershipID, string TelMobile)
        {
            return restroOrderProvider.CheckLoyaltyForDiscount(MembershipID, TelMobile);
        }
        public List<costCenter> getdiscountfromcostcenter()
        {
            return restroOrderProvider.getdiscountfromcostcenter();
        }
        public void Unit1Save1Todatabase(UnitClass UnitInf)
        {
            restroOrderProvider.Unit1Save1Todatabase(UnitInf);
        }
        public List<UnitClass> GetUnit1fromDatabase()
        {
            return RestrOrderProvider.GetUnit1fromDatabase();
        }
        public void UnitDelete1(int UnitID1)
        {
            restroOrderProvider.UnitDelete1(UnitID1);
        }
        public string Unit1Save2Todatabase(UnitClass UnitInf)
        {
            return restroOrderProvider.Unit1Save2Todatabase(UnitInf);
        }
        public List<UnitConversion> GetUnit2fromDatabase()
        {
            return restroOrderProvider.GetUnit2fromDatabase();
        }
        public void UnitDelete2(int UnitID2)
        {
            restroOrderProvider.UnitDelete2(UnitID2);
        }
        public int RestroPurchaseOrder(MvPurchaseMain PurchaseObject)
        {
            return restroOrderProvider.RestroPurchaseOrder(PurchaseObject);
        }
        public List<salesSummary> GetSalesSummary(DateTime dailyDate, DateTime weeklyDate, int value, int month, int year, DateTime fromDate, DateTime toDate)
        {
            return restroOrderProvider.GetSalesSummary(dailyDate, weeklyDate, value, month, year, fromDate, toDate);
        }
        public List<OrderDetailClass> GetPickDataForPront(int p)
        {
            return restroOrderProvider.GetPickDataforPrint(p);
        }
        public void saveflatorperdis(flatorperdiscount fl)
        {
            restroOrderProvider.saveflatorperdis(fl);
        }
        public List<flatorperdiscount> getflatorperdiscount(int id)
        {
            return restroOrderProvider.getflarorperdiscount(id);
        }

        public List<flatorperdiscount> getcakediscount(int id)
        {
            return restroOrderProvider.getcakediscount(id);
        }

        public void TransfterTableForOrder(int OldTable, int NewTable)
        {
            restroOrderProvider.TransfterTableForOrder(OldTable, NewTable);
        }
        public List<SalesMaster> getdailysalesReport(DateTime dt)
        {
            return restroOrderProvider.getdailysalesReport(dt);
        }
        public List<SalesMaster> getweeklysalesReport(DateTime dt)
        {
            return restroOrderProvider.getweeklysalesReport(dt);
        }
        public List<SalesMaster> getmonthlysalesReport(string year, string month)
        {
            return restroOrderProvider.getmonthlysalesReport(year, month);
        }
        public List<SalesMaster> getyearlysalesReport(string year)
        {
            return restroOrderProvider.getyearlysalesReport(year);
        }
        public void UnMergeTable(int tableId)
        {
            restroOrderProvider.UnMergeTable(tableId);
        }
        #region CardProvider
        public void saveCardProvider(CardProvider cd)
        {
            restroOrderProvider.SaveCardProvider(cd);
        }
        public List<CardProvider> getCardProvider()
        {
            return restroOrderProvider.getCardProvider();
        }
        public List<providersReport> getAllProvidersReport(DateTime startDate, DateTime endDate, int paymentMode, int provider)
        {
            return restroOrderProvider.getAllProvidersReport(startDate, endDate, paymentMode, provider);
        }
        public List<providersReport> getDayProvidersReport(DateTime startDate, DateTime endDate, int paymentMode, int provider)
        {
            return restroOrderProvider.getDayProvidersReport(startDate, endDate, paymentMode, provider);
        }
        public List<providersReport> getSummaryProvidersReport(DateTime startDate, DateTime endDate, int paymentMode, int provider)
        {
            return restroOrderProvider.getSummaryProvidersReport(startDate, endDate, paymentMode, provider);
        }
        public CardProvider getCardProviderById(int id)
        {
            return restroOrderProvider.getCardProviderById(id);
        }
        public void deleteCardProvider(int id)
        {
            restroOrderProvider.deleteCardProvider(id);
        }
        #endregion
        #region Report By Provider List
        public List<SalesMaster> GetReportByPaymentMode(DateTime dt, int SPMID)
        {
            return restroOrderProvider.GetReportByPaymentMode(dt, SPMID);
        }
        #endregion
        public List<salesSummaryByProviderMode> GetSalesSummaryByProviderMode(int mode, int id, DateTime dailyDate, DateTime weeklyDate, int month, int year)
        {
            return restroOrderProvider.GetSalesSummaryByProviderMode(mode, id, dailyDate, weeklyDate, month, year);
        }
        public List<salesSummaryByProviderMode> GetSalesSummaryByProviderList(int id, int providerId, DateTime dailyDate, DateTime weeklyDate, int month, int year)
        {
            return restroOrderProvider.GetSalesSummaryByProviderList(id, providerId, dailyDate, weeklyDate, month, year);
        }
        public List<fiscalyear> getfiscalYear()
        {
            return restroOrderProvider.getfiscalYear();
        }
        public List<ROInvItem> getitemfromdatabase()
        {
            return restroOrderProvider.getitemfromdatabase();
        }
        public List<ROInvItemForApi> getItemListForApi()
        {
            return restroOrderProvider.getItemListForApi();
        }
        //public List<unitclassforitem> GetAllUnitforItema()
        //{
        //    
        //    return restroOrderProvider.GetAllUnitforItem();
        //}
        public void SaveRoiItem(ROInvItem info, itemRate inforate)
        {
            restroOrderProvider.SaveRoiItem(info, inforate); ;
        }
        public List<unitclassforitem> GetPareintItem(bool IsMenu = true)
        {
            return restroOrderProvider.GetPareintItem(IsMenu); ;
        }
        public List<ROInvItem> GetRoiItemfromDatabase()
        {
            return restroOrderProvider.GetRoiItemfromDatabase(); ;
        }
        public void DeleteROIiTEM(int Itemid, string userName)
        {
            restroOrderProvider.DeleteROIiTEM(Itemid, userName);
        }
        public List<UnitClass> getunitbyItem(string itemID)
        {
            return RestrOrderProvider.getunitbyItem(itemID);
        }
        public List<unitclassforitem> GetAllUnitforItem()
        {
            return restroOrderProvider.GetAllUnitforItem();
        }
        public List<roistore> getIssueToDDl()
        {
            return restroOrderProvider.getIssueToDDl();
        }

        public List<CostCenterGroup> GetCostCenterGroup()
        {
            return restroOrderProvider.GetCostCenterGroup();
        }
        public List<CostCenterGroup> GetPOSCostCenterGroup()
        {
            return restroOrderProvider.GetPOSCostCenterGroup();
        }

        public List<roistore> getIssueToDDlHirerchy()
        {
            return restroOrderProvider.getIssueToDDlHirerchy();
        }

        public List<ProductionMain> getPreviousProduction()
        {
            return restroOrderProvider.getPreviousProduction();
        }

        public List<ProductionDetails> getPreviousProductionDetailsById(int ProductionId)
        {
            return restroOrderProvider.getPreviousProductionDetailsById(ProductionId);
        }


        public string IssueSave(issueMain IssueObject)
        {
            return restroOrderProvider.IssueSave(IssueObject);
        }
        public List<MvPurchaseMain> getAutoNumber()
        {
            return restroOrderProvider.getAutoNumber();
        }
        public List<MvPurchaseDetails> getPurchaseDetails()
        {
            return restroOrderProvider.getPurchaseDetails();
        }
        //public void GoodsReceived(purchaseMain GoodReived)
        //{
        //    
        //     restroOrderProvider.GoodsReceived(GoodReived);
        //}
        public int GoodsReceivedss(goodsReceiveMain GoodReived, MemberInfo memberInfo, List<PurchasePayment> purchasePayment = null)
        {
            return restroOrderProvider.GoodsReceivedss(GoodReived, memberInfo, purchasePayment);
        }

        public List<goodsReceiveMain> GoodReceiveAutoNumber()
        {
            return restroOrderProvider.GoodReceiveAutoNumber();
        }
        public void savestore(roistore rc, string UserName)
        {
            restroOrderProvider.savestore(rc, UserName);
        }
        public string deleteStore(int empid, string UserName)
        {
            return restroOrderProvider.deleteStore(empid, UserName);
        }
        public List<itemRate> GetItemRateList()
        {
            return restroOrderProvider.GetItemRateList(); ;
        }
        public void DeleteItemRate(int ItemRateID)
        {
            restroOrderProvider.DeleteItemRate(ItemRateID);
        }
        public void SaveItemRate(itemRate itemRate)
        {
            restroOrderProvider.SaveItemRate(itemRate);
        }
        public List<roistore> getStoreList()
        {
            return restroOrderProvider.getStoreList();
        }
        public void SaveStoreDataTodatabase(roistore storeInfo)
        {
            restroOrderProvider.SaveStoreDataTodatabase(storeInfo);
        }
        public List<ROInvItem> GetInvItemForOrderLevelFromDatabase(int p)
        {
            return restroOrderProvider.GetInvItemForOrderLevelFromDatabase(p);
        }
        public List<issueMain> issueautonumber()
        {
            return restroOrderProvider.issueautonumber();
        }
        public List<MvPurchaseDetails> getitemidbyname(string itemname)
        {
            return restroOrderProvider.getitemidbyname(itemname);
        }
        public List<goodsReceiveMain> getGoodsReceive(string PoNO)
        {
            return restroOrderProvider.getGoodsReceive(PoNO);
        }
        public void GoodsDelete(int GMId)
        {
            restroOrderProvider.GoodsDelete(GMId);
        }
        public List<MemberInfo> getVender()
        {
            return restroOrderProvider.getVender();
        }
        public List<MvPurchaseDetails> GETITEMIDPOIDBYNAME(string ItemName)
        {
            return restroOrderProvider.GETITEMIDPOIDBYNAME(ItemName);
        }
        public void SaveAdjsment(adjustmentMain AdjustMain)
        {
            restroOrderProvider.SaveAdjsment(AdjustMain);
        }
        public List<purchaseMains> getPurchaseList(string startDate, string endDate)
        {
            return restroOrderProvider.getPurchaseList(startDate, endDate);
        }
        public List<adjustmentMain> getadjustment()
        {
            return restroOrderProvider.getadjustment();
        }
        public List<adjustmentMain> getAdjustmentAutoNumber()
        {
            return restroOrderProvider.getAdjustmentAutoNumber();
        }
        public void ajustdelete(int AMId)
        {
            restroOrderProvider.ajustdelete(AMId);
        }
        public List<issueMain> getissuemain()
        {
            return restroOrderProvider.getissuemain();
        }
        public void DELETEissue(int IMId)
        {
            restroOrderProvider.DELETEissue(IMId);
        }
        public void deletePurchase(int mainId, int detailsId)
        {
            restroOrderProvider.deletePurchase(mainId, detailsId);
        }
        public List<stockReport> stockreportdaily(DateTime TodayDate)
        {
            return restroOrderProvider.stockreportdaily(TodayDate);
        }
        public List<stockReport> stockreportWeekly(DateTime TodayDate)
        {
            return restroOrderProvider.stockreportWeekly(TodayDate);
        }
        public List<stockReport> stockreportMonthly(string year, string month)
        {
            return restroOrderProvider.stockreportMonthly(year, month);
        }
        public List<stockReport> stockreportYear(string year)
        {
            return restroOrderProvider.stockreportYear(year);
        }
        public List<stockReport> stockreportRange(DateTime StartDate, DateTime EndDate)
        {
            return restroOrderProvider.stockreportRange(StartDate, EndDate);
        }
        public List<MvPurchaseDetails> getgoodreceiveforissue()
        {
            return restroOrderProvider.getgoodreceiveforissue();
        }
        public int GetItemRateIdByItemId(int empid)
        {
            return restroOrderProvider.GetItemRateIdByItemId(empid);
        }
        public List<CategoriesClass> txtSearchForItem(string ItemName, int languageid)
        {
            return restroOrderProvider.txtSearchForItem(ItemName, languageid);
        }
        public List<MvPurchaseDetails> GetItemForSearch()
        {
            return restroOrderProvider.GetItemForSearch();
        }
        public List<MvPurchaseDetails> GetItemForWholeSaleSearch(string LookUpName)
        {
            return restroOrderProvider.GetItemForWholeSaleSearch(LookUpName);
        }
        public void saveExtraItem(List<extraItem> dd)
        {
            throw new NotImplementedException();
        }
        public List<extraItem> GetItemExtraListByItemID(int ItemId)
        {
            try
            {
                return restroOrderProvider.GetItemExtraListByItemID(ItemId);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<OrderDetailClass> GetdataforViewBill(int TableId)
        {
            return restroOrderProvider.GetdataforViewBill(TableId);
        }
        public List<OrderDetailClass> GetdataforViewCakeBill(int TableId, string SalesType)
        {
            return restroOrderProvider.GetdataforViewCakeBill(TableId, SalesType);
        }
        public List<CardProvider> getCusName(int IsCustomer)
        {
            return restroOrderProvider.getCusName(IsCustomer);
        }
        public List<dailyreport> getdailyCusReportByMonthly(string year, string month)
        {
            return restroOrderProvider.getdailyCusReportByMonthly(year, month);
        }
        public List<dailyreport> getdailyCusReportByYearly(string year)
        {
            return restroOrderProvider.getdailyCusReportByYearly(year);
        }
        public List<dailyreport> GetMemberReport(int MembershipID)
        {
            return restroOrderProvider.GetMemberReport(MembershipID);
        }
        public string SavePrintCountDetail(int Printcount, string BillNo, string PrintedBy, string SalesType = "")
        {
            return restroOrderProvider.SavePrintCountDetail(Printcount, BillNo, PrintedBy, SalesType);
        }
        public List<costCenter> KitchenOrderApi()
        {
            return restroOrderProvider.KitchenOrderApi();
        }
        public FiscalYear GetRONumberByFiscalYear()
        {
            return restroOrderProvider.GetRONumberByFiscalYear();
        }
        public List<FiscalYearInfo> GetCurrentActiveFiscalYear()
        {
            return restroOrderProvider.GetCurrentActiveFiscalYear();
        }
        public List<ROInvItem> getitemwithRate(int ItemID)
        {
            return restroOrderProvider.getitemwithRate(ItemID);
        }
        public List<ROInvItem> getitemwithRateForCombo(int ItemID)
        {
            return restroOrderProvider.getitemwithRateForCombo(ItemID);
        }
        public void CancelBillWithReason(int id, string userName, string reason, bool restoreOrder)
        {
            restroOrderProvider.CancelBillWithReason(id, userName, reason, restoreOrder);
        }

        public void CancelBill(int id, string userName, string reason, bool restoreOrder)
        {
            restroOrderProvider.CancelBill(id, userName, reason, restoreOrder);
        }

        public void ChangePaymentMode(List<SalesPayment> salesPayment)
        {
            restroOrderProvider.ChangePaymentMode(salesPayment);
        }

        //}
        public static List<UserInfo> GetUsersDetail(Guid guid, string Username)
        {
            RestrOrderProvider restroOrderProvider = new RestrOrderProvider();
            return restroOrderProvider.GetUsersDetail(guid, Username);
        }
        public List<PrintDetail> getPrintedDetailByBillNo(string billNo)
        {
            return restroOrderProvider.getPrintedDetailByBillNo(billNo);
        }
        public List<dailyreport> getdailyReportByReportNumber(DateTime startdate, DateTime enddate, int ReportNum)
        {
            return restroOrderProvider.getdailyReportByReportNumber(startdate, enddate, ReportNum);
        }
        public List<dailyreport> getdailyReportByWeeklyByReportNumber(DateTime dateTime, int ReportNum)
        {
            return restroOrderProvider.getdailyReportByWeeklyByReportNumber(dateTime, ReportNum);
        }
        public List<dailyreport> getdailyReportByMonthlyByReportNumber(string year, string month, int ReportNum)
        {
            return restroOrderProvider.getdailyReportByMonthlyByReportNumber(year, month, ReportNum);
        }
        public List<dailyreport> getdailyReportByYearlyByReportNumber(string year, int ReportNum)
        {
            return restroOrderProvider.getdailyReportByYearlyByReportNumber(year, ReportNum);
        }
        public List<dailyreport> getdailyReportBySumByReportNumber(DateTime dateTime, int ReportNum)
        {
            return restroOrderProvider.getdailyReportBySumByReportNumber(dateTime, ReportNum);
        }
        public List<dailyreport> getweeklysumbyDateByReportNumber(DateTime dateTime, int ReportNum)
        {
            return restroOrderProvider.getweeklysumbyDateByReportNumber(dateTime, ReportNum);
        }
        public List<dailyreport> getdailyReportForCancelledBill(DateTime startdate, DateTime enddate, string cancelledby)
        {
            return restroOrderProvider.getdailyReportForCancelledBill(startdate, enddate, cancelledby);
        }
        public List<dailyreport> getdailyReportByWeeklyForCancelledBill(DateTime dateTime)
        {
            return restroOrderProvider.getdailyReportByWeeklyForCancelledBill(dateTime);
        }
        public List<dailyreport> getdailyReportByMonthlyForCancelledBill(string year, string month)
        {
            return restroOrderProvider.getdailyReportByMonthlyForCancelledBill(year, month);
        }
        public List<dailyreport> getdailyReportByYearlyForCancelledBill(string year)
        {
            return restroOrderProvider.getdailyReportByYearlyForCancelledBill(year);
        }
        public List<MaterializedReport> MaterializedReportView(DateTime StartDate, DateTime EndDate, int Valid)
        {
            return restroOrderProvider.MaterializedReportView(StartDate, EndDate, Valid);
        }
        public DataTable GetAllTableDataByTableName(string TableName)
        {
            return restroOrderProvider.GetAllTableDataByTableName(TableName);
        }
        public DataSet GetAllTableName()
        {
            return restroOrderProvider.GetAllTableName();
        }
        public void PayseatnoBill(List<OrderDetailClass> lst)
        {
            restroOrderProvider.PayseatnoBill(lst);
        }
        public List<OrderDetailClass> GetDataforPrintBySeatNo(int TableId, string Seatno)
        {
            return restroOrderProvider.GetDataforPrintBySeatNo(TableId, Seatno);
        }
        public List<unitclassforitem> getchangeunit(int unitid)
        {
            return restroOrderProvider.getchangeunit(unitid);
        }
        public void SaveSplittedData(List<OrderDetailClass> ItemsArray)
        {
            restroOrderProvider.SaveSplittedData(ItemsArray);
        }
        public void SaveAdjustmentType(AdjustmentType type)
        {
            restroOrderProvider.SaveAdjustmentType(type);
        }
        public List<AdjustmentType> getadjustmentType()
        {
            return restroOrderProvider.getadjustmentType();
        }
        public AdjustmentType GettypedatabyId(int TypeId)
        {
            return restroOrderProvider.GettypedatabyId(TypeId);
        }
        public void EditAdjustmentType(int TypeId, string Name, bool IsActive, string Username)
        {
            restroOrderProvider.EditAdjustmentType(TypeId, Name, IsActive, Username);
        }
        public List<ItemsClass> getItemRateByItem(string ItemName)
        {
            return restroOrderProvider.getItemRateByItem(ItemName);
        }
        public List<ItemsClass> getitemforcumbo()
        {
            return restroOrderProvider.getitemforcumbo();
        }
        public int comboorder(cumbomain comboorder)
        {
            return restroOrderProvider.restroCombo(comboorder);
        }
        public List<cumbomain> getcumbolist(bool activeOnly)
        {
            return restroOrderProvider.getcumbolist(activeOnly);
        }
        public void DELETECOMBO(int comboid, string UserName)
        {
            restroOrderProvider.DELETECOMBO(comboid, UserName);
        }
        public List<unitclassforitem> GetUNITbySmallUnit(int unit)
        {
            return restroOrderProvider.GetAllUnitforItem(unit);
        }
        public int saveItems(ROInvItem itemObject, List<extraItem> extraItemList)
        {
            return restroOrderProvider.saveItems(itemObject, extraItemList);
        }
        public int saveInventoryItems(ROInvItem itemObject, List<extraItem> extraItemList)
        {
            return restroOrderProvider.saveInventoryItems(itemObject, extraItemList);
        }
        public void DeleteAdjustmentType(int id, string Username)
        {
            restroOrderProvider.DeleteAdjustmentType(id, Username);
        }
        public List<FiscalYear> getTodayFiscalYr()
        {
            return restroOrderProvider.getTodayFiscalYr();
        }
        public List<AdjustmentDetails> GetdataByPurchaseOrderId(int id)
        {
            return restroOrderProvider.GetdataByPurchaseOrderId(id);
        }
        public List<ROInvItem> GetRoiItemForCategory()
        {
            return restroOrderProvider.GetRoiItemForCategory(); ;
        }
        public List<ROInvItem> GetRoiItemForCategoryHirerchy()
        {
            return restroOrderProvider.GetRoiItemForCategoryHirerchy();
        }
        public List<itemWithUnit> ItemWithUnitList(int id)
        {
            return restroOrderProvider.ItemWithUnitList(id); ;
        }
        public List<extraItem> extraItemData(int id)
        {
            return restroOrderProvider.extraItemData(id);
        }
        public List<ROInvItem> CheckItemExistence(string item)
        {
            return restroOrderProvider.CheckItemExistence(item);
        }
        public List<ROInvItem> CheckItemExistenceForCategory(string item)
        {
            return restroOrderProvider.CheckItemExistenceForCategory(item);
        }
        public List<dailyreport> getPurchaseReportByPuNo(string puNo)
        {
            return restroOrderProvider.getPurchaseReportByPuNo(puNo);
        }
        public List<cumbomainDetails> getcombodatabyid(int comboid)
        {
            return restroOrderProvider.getcombodatabyid(comboid);
        }
        public void updateisactive(int ComboID)
        {
            restroOrderProvider.updateisactive(ComboID);
        }
        public List<CardProvider> getVendorName()
        {
            return restroOrderProvider.getVendorName();
        }
        public List<CardProvider> getdailyVendorReportByMonthly(string year, string month)
        {
            return restroOrderProvider.getdailyVendorReportByMonthly(year, month);
        }
        public List<CardProvider> getdailyVendorReportByYearly(string year)
        {
            return restroOrderProvider.getdailyVendorReportByYearly(year);
        }
        public List<CardProvider> GetVenderReportByDate(string DateFrom, string DateTo, int VenderId)
        {
            return restroOrderProvider.GetVenderReportByDate(DateFrom, DateTo, VenderId);
        }
        public List<ROInvItem> GetItemList()
        {
            return restroOrderProvider.GetItemList();
        }
        public List<ROInvItem> GetInventoryItemList()
        {
            return restroOrderProvider.GetInventoryItemList();
        }
        public int saveGroupItem(ItemGroup group)
        {
            return restroOrderProvider.saveGroupItem(group);
        }
        public List<ItemGroup> getGroupList()
        {
            return restroOrderProvider.getGroupList();
        }
        public List<GroupWithItem> getGroupByID(int ids)
        {
            return restroOrderProvider.getGroupByID(ids);
        }
        public List<ROInvItem> ViewItemByID(int ids)
        {
            return restroOrderProvider.ViewItemByID(ids);
        }
        public List<ClosingReport> ClosingReportView(DateTime startdate)
        {
            return restroOrderProvider.ClosingReport(startdate);
        }
        public List<StatementInfo> StatementReportView(DateTime startdate)
        {
            return restroOrderProvider.StatementReportView(startdate);
        }
        public List<MvPurchaseDetails> GetUnitOfItemByID(int ids)
        {
            return restroOrderProvider.GetUnitOfItemByID(ids);
        }
        public List<MvPurchaseDetails> GetItemForOpenBalance()
        {
            return restroOrderProvider.GetItemForOpenBalance();
        }
        public void DeleteGroupItemByID(int ids)
        {
            restroOrderProvider.DeleteGroupItemByID(ids);
        }
        public List<dailyreport> getCustomerBalanceReport(DateTime startDate, DateTime endDate, int CustomerName)
        {
            return restroOrderProvider.getCustomerBalanceReport(startDate, endDate, CustomerName);
        }

        public void CreditCancelWithReason(int id, int memberId, string userName, string reason, string date)
        {
            restroOrderProvider.CreditCancelWithReason(id, memberId, userName, reason, date);
        }

        public List<itemsales> getiemsalesreport(DateTime Start, DateTime EndDate)
        {
            return restroOrderProvider.getiemsalesreport(Start, EndDate);
        }
        public void deleteGroupByID(int ids)
        {
            restroOrderProvider.deleteGroupByID(ids);
        }
        public List<top6Item> getTop6Item()
        {
            return restroOrderProvider.getTop6Item();
        }
        public List<top6Table> getTop6Table()
        {
            return restroOrderProvider.getTop6Table();
        }
        public List<SalesChart> getSalesChart()
        {
            return restroOrderProvider.getSalesChart();
        }
        public List<stockReport> stockreport(int storeID, string searchText)
        {
            return restroOrderProvider.stockreport(storeID, searchText);
        }
        public List<dailyreport> getOrderVoidReport(DateTime startDate, DateTime endDate)
        {
            return restroOrderProvider.getOrderVoidReport(startDate, endDate);
        }
        public List<dailyreports> SaleReportByBillNo(int startBillNo, int endBillNo, int Status)
        {
            return restroOrderProvider.SaleReportByBillNo(startBillNo, endBillNo, Status);
        }
        public string CheckBillingTermExistence(string term)
        {
            return restroOrderProvider.CheckBillingTermExistence(term);
        }
        public List<purchaseMains> getPurchaseDetailsbyID(int mainId)
        {
            return restroOrderProvider.getPurchaseDetailsbyID(mainId);
        }
        public List<MvPurchaseDetails> GetInventoryItemWithSmallUnit()
        {
            return restroOrderProvider.GetInventoryItemWithSmallUnit();
        }
        public List<IngredientItems> getIngredientByID(int id)
        {
            return restroOrderProvider.getIngredientByID(id);
        }
        public void deleteAfterEdit(int idForDelete, int MainIdForDelete)
        {
            restroOrderProvider.deleteAfterEdit(idForDelete, MainIdForDelete);
        }
        public string CheckPinCodeMatch(string PinCode, string username)
        {
            return restroOrderProvider.CheckPinCodeMatch(PinCode, username);
        }
        public List<unitclassforitem> getOnlySmallUnit()
        {
            return restroOrderProvider.getOnlySmallUnit();
        }
        public List<ClosingReport> getClosingReport_StateWise(DateTime startdate)
        {
            return restroOrderProvider.getClosingReport_StateWise(startdate);
        }
        public List<ClosingReport> getClosingReport_CategoryWise(DateTime startdate)
        {
            return restroOrderProvider.getClosingReport_CategoryWise(startdate);
        }
        public List<StatementInfo> getClosingReport_BillWiseSales(DateTime startdate)
        {
            return restroOrderProvider.getClosingReport_BillWiseSales(startdate);
        }
        public List<OrderDetailCancel> getOrderDetailByOrderMasterID(int OrderMasterID)
        {
            return restroOrderProvider.getOrderDetailByOrderMasterID(OrderMasterID);
        }
        public void SaveCanceledItems(List<OrderDetailCancel> CancelItems)
        {
            restroOrderProvider.SaveCanceledItems(CancelItems);
        }
        public List<billingTerm> getActiveBillTerm()
        {
            return restroOrderProvider.getActiveBillTerm();
        }
        public void deleteBillingTermDetails(int billid)
        {
            restroOrderProvider.deleteBillingTermDetails(billid);
        }
        public void saveBillingDetails(billTermDetails btdetails)
        {
            restroOrderProvider.saveBillingDetails(btdetails);
        }
        public billTermDetails getBillTermDetailsByBillTerm(int bilingID)
        {
            return restroOrderProvider.getBillTermDetailsByBillTerm(bilingID);
        }
        public List<CreditPayReport> getCreditPayReportByDates(DateTime sdate, DateTime edate, string customer, bool? isCustomer)
        {
            return restroOrderProvider.getCreditPayReportByDates(sdate, edate, customer, isCustomer);
        }

        public List<CreditPayReport> getMixedPayReportByDates(DateTime sdate, DateTime edate, string customer, bool? isCustomer)
        {
            return restroOrderProvider.getMixedPayReportByDates(sdate, edate, customer, isCustomer);
        }
        public PinUser CheckPin(string pin)
        {
            return restroOrderProvider.CheckPin(pin);
        }
        public List<customerBilling> getbillingTermbySalesMasterID(string MID)
        {
            return restroOrderProvider.getbillingTermbySalesMasterID(MID);
        }

        public List<customerBilling> getcakebillingTermbySalesMasterID(string MID, string SalesType = "")
        {
            return restroOrderProvider.getcakebillingTermbySalesMasterID(MID, SalesType);
        }

        public static int ChangePIN(string UserId, string PIN)
        {
            RestrOrderProvider restroOrderProvider = new RestrOrderProvider();
            return restroOrderProvider.ChangePIN(UserId, PIN);
        }
        public List<TargetSales> getTargetSales(DateTime date)
        {
            return restroOrderProvider.getTargetSales(date);
        }
        public List<itemsales> getSalesDetailsByDate(DateTime date)
        {
            return restroOrderProvider.getSalesDetailsByDate(date);
        }
        public SalesPayment GetSalesPayMode(int salesMasterId)
        {
            return restroOrderProvider.GetSalesPayMode(salesMasterId);
        }
        public void UpdateSalesPayMode(SalesPayment salesPayment)
        {
            restroOrderProvider.UpdateSalesPayMode(salesPayment);
        }
        public void UpdateSalesPayMode(List<SalesPayment> salesPayment)
        {
            restroOrderProvider.UpdateSalesPayMode(salesPayment);
        }
        public List<ClosingReport> ClosingMonthlyReportView(DateTime startdate, DateTime enddate)
        {
            return restroOrderProvider.ClosingMonthlyReportView(startdate, enddate);
        }

        public List<CostCenterGroup> GetCostCenterGroupClosing(DateTime startdate, DateTime enddate)
        {
            return restroOrderProvider.GetCostCenterGroupClosing(startdate, enddate);
        }

        public List<StatementInfo> StatementMonthlyReportView(DateTime startdate, DateTime enddate)
        {
            return restroOrderProvider.StatementMonthlyReportView(startdate, enddate);
        }
        public List<StatementInfo> StatementMonthlyReportDatewise(DateTime startdate, DateTime enddate)
        {
            return restroOrderProvider.StatementMonthlyReportDatewise(startdate, enddate);
        }
        public List<UnpaidBills> GetUnpaidBills()
        {
            return restroOrderProvider.GetUnpaidBills();
        }
        public List<customerBilling> getActiveBILLTERM()
        {
            return restroOrderProvider.getActiveBILLTERM();
        }
        public List<MergeTableInfo> GetMergedTables(int tableId)
        {
            return restroOrderProvider.GetMergedTables(tableId);
        }
        public void ClearMergeList(int tableId)
        {
            restroOrderProvider.ClearMergeList(tableId);
        }
        public void deleteDependentRoomsAndTables(int id, int type)
        {
            restroOrderProvider.deleteDependentRoomsAndTables(id, type);
        }
        //Inventory Pranesh
        //public List<MvPurchaseDetails> getUnitsWithConvertion(int ids)
        //{
        //    
        //    return restroOrderProvider.getUnitsWithConvertion(ids);
        //}
        //public List<MvPurchaseDetails> GetUnitOfItemByName(string ids)
        //{
        //    
        //    return restroOrderProvider.GetUnitOfItemByName(ids);
        //}
        public void DeleteIngredientItemByID(int IngredientID, int ItemID)
        {
            restroOrderProvider.DeleteIngredientItemByID(IngredientID, ItemID);
        }
        public List<MvPurchaseDetails> getUnitsWithConvertion(int ids)
        {
            return restroOrderProvider.getUnitsWithConvertion(ids);
        }
        public List<OrderDetailClass> getOrderDetailByOrderMasterId(int orderMasterId)
        {
            return restroOrderProvider.getOrderDetailByOrderMasterId(orderMasterId);
        }
        public List<ComplimentaryOrder> getComplimentaryOrderDetailByOrderMasterId(int orderMasterId)
        {
            return restroOrderProvider.getComplimentaryOrderDetailByOrderMasterId(orderMasterId);
        }
        public int saveSalesBill(SalesMaster sm, List<SalesDetails> sd, int splited, List<customerBilling> bt, flatorperdiscount flatorperdiscount)
        {
            return restroOrderProvider.saveSalesBill(sm, sd, splited, bt, flatorperdiscount);
        }
        public int savePOSSalesBill(SalesMaster sm, List<SalesDetails> sd, int splited, List<customerBilling> bt, flatorperdiscount flatorperdiscount)
        {
            return restroOrderProvider.savePOSSalesBill(sm, sd, splited, bt, flatorperdiscount);
        }
        public List<CustomerEvent> getCustomerEvents()
        {
            return restroOrderProvider.getCustomerEvents();
        }
        public List<CardProvider> getDueCredit()
        {
            return restroOrderProvider.getDueCredit();
        }
        public List<stockReport> getOutOfStockItems(int storeId)
        {
            return restroOrderProvider.getOutOfStockItems(storeId);
        }
        public restroTable getTableInfo(int tableId)
        {
            return restroOrderProvider.getTableInfo(tableId);
        }
        public int CheckAvailability(string startDate, string endDate, int roombookDetailId, int tableId)
        {
            return restroOrderProvider.CheckAvailability(startDate, endDate, roombookDetailId, tableId);
        }
        public void SaveRoomBoking(RoomBookingsInfo roomBooking, OrderMasterClass orderMaster)
        {
            if (roomBooking.RoomBookDetailsID == 0)
            {
                restroOrderProvider.SaveRoomBoking(roomBooking, orderMaster);
            }
            else
            {
                restroOrderProvider.UpdateRoomBoking(roomBooking);
            }
        }
        public List<RoomBookingsInfo> GetOccupiedRooms()
        {
            return restroOrderProvider.GetOccupiedRooms();
        }
        public RoomBookingsInfo getRoomBookingInfoByOrderMasterID(int orderMasterId)
        {
            return restroOrderProvider.getRoomBookingInfoByOrderMasterID(orderMasterId);
        }
        public List<ItemsClass> GetPreviousItemByOrderMasterId(int OID)
        {
            return restroOrderProvider.GetPreviousItemByOrderMasterId(OID);
        }
        public List<OrderDetailCancel> getOrderItemCancelReport(DateTime startDate, DateTime endDate, string cancelledby, string orderby, int roomid, int tableid, string responsible, string itemname)
        {
            return restroOrderProvider.getOrderItemCancelReport(startDate, endDate, cancelledby, orderby, roomid, tableid, responsible, itemname);
        }
        public List<OrderDetailClass> getBillBody(int SalesMasterID)
        {
            return restroOrderProvider.getBillBody(SalesMasterID);
        }
        public List<usedBillingTermInfo> GetUsedBillingTerm(int SalesMasterID)
        {
            return restroOrderProvider.GetUsedBillingTerm(SalesMasterID);
        }
        public List<ConsumptionReport> getConsumptionReportByDates(DateTime startDate, DateTime endDate)
        {
            return restroOrderProvider.getConsumptionReportByDates(startDate, endDate);
        }
        public OrderMasterClass GetOrderDetailsFromDatabase(string tableId, int orderMasterId)
        {
            return RestrOrderProvider.GetOrderDetailsFromDatabase(tableId, orderMasterId);
        }
        public List<UserInfos> getUNameNpwdByPIN(string PinCode)
        {
            return restroOrderProvider.getUNameNpwdByPIN(PinCode);
        }
        public int SaveOrderIntoDataBase(OrderMasterClass orderMasterInfo, List<OrderDetailClass> addedOrders, List<OrderDetailClass> cancelledOrders)
        {
            return restroOrderProvider.OrderMasterSaveTodatabase(orderMasterInfo, addedOrders, cancelledOrders);
        }
        public void ChangeOrderStatus(int orderDetailId, int StatusID)
        {
            restroOrderProvider.ChangeOrderStatus(orderDetailId, StatusID);
        }
        public void SaveExtraItem(extraItem extraItem)
        {
            restroOrderProvider.SaveExtraItem(extraItem);
        }
        public List<extraItem> GetExtraItemList()
        {
            return restroOrderProvider.GetExtraItemList();
        }
        public List<extraItem> getExtraItemforItem()
        {
            return restroOrderProvider.getExtraItemforItem();
        }
        public List<OrderExtraItem> GetOrderedExtraItemByOrderMaster(int orderMasterID)
        {
            return restroOrderProvider.GetOrderedExtraItemByOrderMaster(orderMasterID);
        }
        public void SaveExtraOrderedItem(List<OrderExtraItem> addedExtra, List<OrderExtraItem> removedExtra)
        {
            restroOrderProvider.SaveExtraOrderedItem(addedExtra, removedExtra);
        }
        public List<OrderExtraItem> GetExtraSalesForItem(int SalesMasterID)
        {
            return restroOrderProvider.GetExtraSalesForItem(SalesMasterID);
        }
        public List<OrderExtraItem> GetAllExtraItemByOrderMaster(int orderMasterId)
        {
            return restroOrderProvider.GetAllExtraItemByOrderMaster(orderMasterId);
        }
        public void DeleteExtraItem(int extraItemId, string deletedBy)
        {
            restroOrderProvider.DeleteExtraItem(extraItemId, deletedBy);
        }
        public List<IngredientItems> getExtraIngredientsList()
        {
            return restroOrderProvider.GetExtraIngredientList();
        }
        public static void SaveWaiterDetailForNotification(UserClass user)
        {
            RestrOrderProvider restroOrderProvider = new RestrOrderProvider();
            restroOrderProvider.SaveWaiterDetailForNotification(user);
        }
        public WaiterCallInfo callWaiter(int orderDetailId)
        {
            return restroOrderProvider.callWaiter(orderDetailId);
        }
        public List<WaiterCallInfo> GetWaiterLog()
        {
            return restroOrderProvider.GetWaiterLog();
        }
        //public void DeleteWaiterFromLog(string waiter)
        //{
        //    
        //    restroOrderProvider.DeleteWaiterFromLog(waiter);
        //}
        public WaiterCallInfo DeleteWaiterFromLog(string waiter)
        {
            return restroOrderProvider.DeleteWaiterFromLog(waiter);
        }
        public List<restroTable> getRestroTableByRoomID(int restroRoomId)
        {
            return restroOrderProvider.getRestroTableByRoomID(restroRoomId);
        }
        public List<RestroRoom> GetRoomByRestroTypeId(int RoomTypeID)
        {
            return restroOrderProvider.GetRoomByRestroTypeId(RoomTypeID);
        }
        public int CompMasterSaveTodatabase(OrderMasterClass orderMasterInfo, List<OrderDetailClass> addedOrders, List<OrderDetailClass> cancelledOrders)
        {
            return restroOrderProvider.CompMasterSaveTodatabase(orderMasterInfo, addedOrders, cancelledOrders);
        }
        public List<OrderExtraItem> GetOrderedExtraItemByCompMaster(int CompMasterID)
        {
            return restroOrderProvider.GetOrderedExtraItemByCompMaster(CompMasterID);
        }
        public void SaveExtraCompItem(List<OrderExtraItem> addedExtra, List<OrderExtraItem> removedExtra)
        {
            restroOrderProvider.SaveExtraCompItem(addedExtra, removedExtra);
        }
        public List<OrderDetailClass> GetCompDetailsByMaster(int CompMasterID)
        {
            return restroOrderProvider.GetCompDetailsByMaster(CompMasterID);
        }
        public List<OrderDetailClass> getCompitemprocessing(int costcenterID)
        {
            return restroOrderProvider.getCompitemprocessing(costcenterID);
        }
        public void ChangeCompOrderStatus(int CompId, int StatusID)
        {
            restroOrderProvider.ChangeCompOrderStatus(CompId, StatusID);
        }
        public WaiterCallInfo callWaiterforcomp(int CompId)
        {
            return restroOrderProvider.callWaiterforcomp(CompId);
        }
        public List<itemsales> getComplementsalesreport(DateTime Start, DateTime EndDate, int tableid, int roomid, string itemname)
        {
            return restroOrderProvider.getComplementsalesreport(Start, EndDate, tableid, roomid, itemname);
        }
        public DailyClosingReport GenerateDayClosingReport(string date, bool viewOnly)
        {
            return restroOrderProvider.GenerateDayClosingReport(date, viewOnly);
        }
        public void CloseTheDay(int financialID, decimal cashSettlement, decimal cashinCounter, decimal closingBalance, decimal totalexpenses, string remarks)
        {
            restroOrderProvider.CloseTheDay(financialID, cashSettlement, cashinCounter, closingBalance, totalexpenses, remarks);
        }
        public List<ROInvItem> getItemIngreident(int costCenter)
        {
            return restroOrderProvider.getItemIngreident(costCenter);
        }
        public List<ROInvItem> getIngredientsList(int costCenter, int itemID, int categoryID)
        {
            return restroOrderProvider.getIngredientsList(costCenter, itemID, categoryID);
        }
        public List<itemsales> getOrderItemReport(DateTime startDate, DateTime endDate)
        {
            return restroOrderProvider.getOrderItemReport(startDate, endDate);
        }
        public void UpdateItemStockStatus(ROInvItemForApi itemInfo)
        {
            restroOrderProvider.UpdateItemStockStatus(itemInfo);
        }
        public List<issueMain> GetIssueDetailsbyId(int imid)
        {
            return restroOrderProvider.GetIssueDetailsbyId(imid);
        }
        public List<goodsReceiveMain> GetGoodRecievedPO()
        {
            return restroOrderProvider.GetGoodRecievedPO();
        }
        public void InactiveCombo()
        {
            try
            {
                restroOrderProvider.InactiveCombo();
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<goodsReceiveMain> getGoodReceived(int detailsId)
        {
            return restroOrderProvider.getGoodReceived(detailsId);
        }
        public List<purchaseMains> getPurchaseDetailsFor(int purchaseid)
        {
            return restroOrderProvider.getPurchaseDetailsFor(purchaseid);
        }
        public string IsFoodCourtAutoBilling()
        {
            return System.Configuration.ConfigurationManager.AppSettings["foodCourtAutoBillGenerate"];
        }
        public List<PaymentModes> GetPaymentModes()
        {
            return restroOrderProvider.GetPaymentModes();
        }
        public object GetPaymentModesAndProviders(int salesMasterId)
        {
            var objects = new { providers = restroOrderProvider.getCardProvider(), paymentModes = restroOrderProvider.GetPaymentModes(), billInfo = restroOrderProvider.getbillInfo(salesMasterId) };
            return objects;
        }
        public SalesMaster GetSalesMasterDtll(int salesMasterId)
        {
            var obj = restroOrderProvider.GetSalesMasterDtll(salesMasterId);
            return obj;
        }

        public List<StoreItemStock> getstoreitemforstock(int id)
        {
            return restroOrderProvider.getstoreitemforstock(id);
        }
        public void DeleteMinimumSTock(int StoreItemId)
        {
            restroOrderProvider.DeleteMinimumSTock(StoreItemId);
        }
        public string SendRecquistion(Recquistion recquistion)
        {
            string reqNo = restroOrderProvider.getAutoRecquistionNo();
            recquistion.RecqNo = reqNo;
            restroOrderProvider.SendRecquistion(recquistion);
            return reqNo;
        }
        public void DeleteRecquistion(Recquistion recquistion)
        {
            restroOrderProvider.DeleteRecquistion(recquistion);
        }
        public List<Recquistion> GetRecquistions(bool isMainStore)
        {
            return restroOrderProvider.GetRecquistions(isMainStore);
        }
        public void IssueRecquistions(Recquistion recquistion)
        {
            restroOrderProvider.IssueRecquistions(recquistion);
        }
        public void SaveVendorForRecq(List<RecquistionDetails> recquistion)
        {
            restroOrderProvider.SaveVendorForRecq(recquistion);
        }
        public List<purchaseMains> getPoDetailsFromVendor(int vendorid)
        {
            return restroOrderProvider.getPoDetailsFromVendor(vendorid);
        }
        public List<issueMain> getForVerification(string receivedBy)
        {
            return restroOrderProvider.getForVerification(receivedBy);
        }
        public void UpdateVerification(int imid)
        {
            restroOrderProvider.UpdateVerification(imid);
        }
        public void shiftItems(ShiftItems shift)
        {
            restroOrderProvider.shiftItems(shift);
        }
        public List<restroTable> getTablesDataWithCurrentSplitNo()
        {
            return restroOrderProvider.getTablesDataWithCurrentSplitNo();
        }
        public List<SalesSummaryReport> getSalesSummaryReport(string room, string table, int invoiceno, string customer, string waiter, string cashier, int paymentmodeid, string provider, DateTime datefrom, DateTime dateTo, int timefrom, int timeTo)
        {
            return restroOrderProvider.getSalesSummaryReport(room, table, invoiceno, customer, waiter, cashier, paymentmodeid, provider, datefrom, dateTo, timefrom, timeTo);
        }
        public List<SalesSummaryReport> GetCustomerForReport()
        {
            return restroOrderProvider.GetCustomerForReport();
        }
        public List<SalesSummaryReport> GetWaiterForReport()
        {
            return restroOrderProvider.GetWaiterForReport();
        }
        public List<SalesSummaryReport> GetCashierForReport()
        {
            return restroOrderProvider.GetCashierForReport();
        }
        public List<dailyreport> getPurchaseReport(string startDate, string endDate, int vendorId, string puNo)
        {
            return restroOrderProvider.getPurchaseReport(startDate, endDate, vendorId, puNo);
        }
        public List<MvPurchaseDetails> getPurchaseNoForReport()
        {
            return restroOrderProvider.getPurchaseNoForReport();
        }
        public void saveBevearge(List<ROInvItem> itemlist, List<extraItem> extraItemList)
        {
            restroOrderProvider.saveBevearge(itemlist, extraItemList);
        }
        public List<ItemShiftReport> getItemShiftReport(string itemname, string fromtable, string totable, string shiftedby, DateTime fromdate, DateTime todate)
        {
            return restroOrderProvider.getItemShiftReport(itemname, fromtable, totable, shiftedby, fromdate, todate);
        }
        public List<goodReceiveDetails> GetGoodsReceivedDetailsByGMId(int gmid)
        {
            return restroOrderProvider.GetGoodsReceivedDetailsByGMId(gmid);
        }
        public List<ItemLedger> getItemledger(DateTime startDate, DateTime endDate, int itemId)
        {
            return restroOrderProvider.getItemledger(startDate, endDate, itemId);
        }
        public void SaveProduction(ProductionMain production)
        {
            restroOrderProvider.SaveProduction(production);
        }
        public List<ProductionMain> getProductionMain(DateTime fromDate, DateTime toDate, int storeid)
        {
            return restroOrderProvider.getProductionMain(fromDate, toDate, storeid);
        }
        public List<ProductionDetails> GetProductionDetailsByID(int id)
        {
            return restroOrderProvider.GetProductionDetailsByID(id);
        }
        public PinUser GetRolesByUsername(string username)
        {
            return restroOrderProvider.GetRolesByUsername(username);
        }
        public void SaveCashDenomination(CashDenomination cash)
        {
            restroOrderProvider.SaveCashDenomination(cash);
        }
        public List<ROInvItem> GetItemNameByCatgeoryID(int pitid)
        {
            return restroOrderProvider.GetItemNameByCatgeoryID(pitid);
        }
        public bool SendToCBMS(int salesMasterId)
        {
            return restroOrderProvider.SendToCBMS(salesMasterId);
        }
        public List<ROInvItem> GetCategoryHirerchy(int categorylevel)
        {
            return restroOrderProvider.GetCategoryHirerchy(categorylevel);
        }
        public List<purchaseMains> GetPurchaseDetailsbypurchaseID(int purchasemainID)
        {
            return restroOrderProvider.GetPurchaseDetailsbypurchaseID(purchasemainID);
        }
        public List<goodsReceiveMain> GetGoodsDetailsbygmID(int gmID)
        {
            return restroOrderProvider.GetGoodsDetailsbygmID(gmID);
        }
        public List<OrderDetailCancel> GetOrderCancelledBY()
        {
            return restroOrderProvider.GetOrderCancelledBY();
        }
        public List<OrderDetailCancel> GetCancelledOrderBY()
        {
            return restroOrderProvider.GetCancelledOrderBY();
        }
        public List<OrderDetailCancel> GetOrderCancelResponsible()
        {
            return restroOrderProvider.GetOrderCancelResponsible();
        }
        public List<goodsReceiveMain> getGoodsReceiveReport(string startDate, string endDate, string PoNO, string GmNo, string itemname, int paymentID)
        {
            return restroOrderProvider.getGoodsReceiveReport(startDate, endDate, PoNO, GmNo, itemname, paymentID);
        }

        public List<issueMain> getIssueReportDetails(string startDate, string endDate, string ISNo, string itemname)
        {
            return restroOrderProvider.getIssueReportDetails(startDate, endDate, ISNo, itemname);
        }

        public List<goodsReceiveMain> GetGoodsReceiveMainList()
        {
            return restroOrderProvider.GetGoodsReceiveMainList();
        }


        public List<goodReceiveDetails> GetGoodsDetailsbyGMNo(string GMNo)
        {
            return restroOrderProvider.GetGoodsDetailsbyGMNo(GMNo);
        }

        public List<PurchaseReturnMain> PurchaseReturnAutoNumber()
        {
            return restroOrderProvider.PurchaseReturnAutoNumber();
        }

        public int PurchaseReturn(PurchaseReturnMain PurchaseReturn)
        {
            return restroOrderProvider.PurchaseReturn(PurchaseReturn);
        }

        public List<PurchaseReturnMain> GetPurchaseReturnMainList()
        {
            return restroOrderProvider.GetPurchaseReturnMainList();
        }

        public List<PurchaseReturnDetails> GetPurchaseReturnDetailsbyPRNo(string PRNo)
        {
            return restroOrderProvider.GetPurchaseReturnDetailsbyPRNo(PRNo);
        }

        public List<goodsReceiveMain> GetGoodsRecieveFromPurchaseID(int purchasemainID)
        {
            return restroOrderProvider.GetGoodsRecieveFromPurchaseID(purchasemainID);
        }
        public List<PinUser> GetAllUserRoles()
        {
            return restroOrderProvider.GetAllUserRoles();
        }
        public List<PinUser> GetPinSettings()
        {
            return restroOrderProvider.GetPinSettings();
        }
        public BillInfo getbillInfo(int salesMasterId)
        {
            return restroOrderProvider.getbillInfo(salesMasterId);
        }
        public List<goodsReceiveMain> GetPurchaseBook(string startDate, string endDate)
        {
            return restroOrderProvider.GetPurchaseBook(startDate, endDate);
        }
        public List<restroTable> GetTakeAwayOrders()
        {
            return restroOrderProvider.GetTakeAwayOrders();
        }

        public List<CreditPayReport> getCreditReport(DateTime sdate, DateTime edate, string customer, bool? isCustomer)
        {
            return restroOrderProvider.getCreditReport(sdate, edate, customer, isCustomer);
        }

        public int saveTableReservation(TableReservation table)
        {
            return restroOrderProvider.saveTableReservation(table);
        }

        public List<TableReservation> getReservedTable()
        {
            return restroOrderProvider.getReservedTable();
        }

        public List<TableReservation> getReservedTableList()
        {
            return restroOrderProvider.getReservedTableList();
        }

        public void ConfirmReservation(int reserveid, string confirmedby)
        {
            restroOrderProvider.ConfirmReservation(reserveid, confirmedby);
        }

        public void CancelReservation(int reserveid, string cancelledby)
        {
            restroOrderProvider.CancelReservation(reserveid, cancelledby);
        }


        public List<cumbomain> getUpcomingcumbolist()
        {
            return restroOrderProvider.getUpcomingcumbolist();
        }
        public List<cumbomain> getCancelledcumbolist()
        {
            return restroOrderProvider.getCancelledcumbolist();
        }

        public List<TableReservation> getReservedTableListReport(string StartDate, string EndDate, string CustomerName, int TableId)
        {
            return restroOrderProvider.getReservedTableListReport(StartDate, EndDate, CustomerName, TableId);
        }

        public List<OrderDetailClass> getAllOrderDetailReport(DateTime startDate, DateTime endDate, int tableid, int costCenter)
        {
            return restroOrderProvider.getAllOrderDetailReport(startDate, endDate, tableid, costCenter);
        }

        public List<OrderDetailClass> getOrderDetailsReportSummary(DateTime startDate, DateTime endDate, int tableid, int costCenter)
        {
            return restroOrderProvider.getOrderDetailsReportSummary(startDate, endDate, tableid, costCenter);
        }

        public List<DailyClosingReport> ClosDayReport(string fromDate, string toDate)
        {
            return restroOrderProvider.ClosDayReport(fromDate, toDate);
        }

        public object GetPaymentModesAndProvidersForAdvancePayment()
        {
            var objects = new { providers = restroOrderProvider.getCardProvider(), paymentModes = restroOrderProvider.GetPaymentModes() };
            return objects;
        }

        public List<RoomBookingsInfo> getRoomBookingReport(string startDate, string endDate, string customer, string table)
        {
            return restroOrderProvider.getRoomBookingReport(startDate, endDate, customer, table);
        }

        public List<RoomBookingsInfo> getCustomerNameFromRoomBooking()
        {
            return restroOrderProvider.getCustomerNameFromRoomBooking();
        }

        public List<unitclassforitem> getMenuForGlobalization(int languageid)
        {
            return restroOrderProvider.getMenuForGlobalization(languageid);
        }

        public List<LanguageMenu> getLanguage()
        {
            return restroOrderProvider.getLanguage();
        }

        public void saveLanguageMenu(int languageid, List<LanguageMenu> LanguageMenu)
        {
            restroOrderProvider.saveLanguageMenu(languageid, LanguageMenu);
        }

        public List<MenuClass> getGlobalizedMenu(int languageid)
        {
            return restroOrderProvider.getGlobalizedMenu(languageid);
        }

        public List<Token> getOrderTokenByOrderMasterId(int orderMasterId)
        {
            return restroOrderProvider.getOrderTokenByOrderMasterId(orderMasterId);
        }
        public Token getOrderNobyOrderMasterId(int orderMasterId)
        {
            return restroOrderProvider.getOrderNobyOrderMasterId(orderMasterId);
        }
        public List<Token> GetOrderDeliveryList()
        {
            return restroOrderProvider.GetOrderDeliveryList();
        }


        public void saveTableLayout(List<SaveLayoutTable> table)
        {
            restroOrderProvider.saveTableLayout(table);
        }

        public List<restroTable> getLayoutTable(int UserModuleID)
        {
            return restroOrderProvider.getLayoutTable(UserModuleID);
        }

        public List<dailyreports> GetOrderDeliveredList()
        {
            return restroOrderProvider.GetOrderDeliveredList();
        }


        public List<ordertype> GetOrderType()
        {
            return restroOrderProvider.GetOrderType();
        }

        public void UpdateAcc()
        {
            restroOrderProvider.UpdateAcc();
        }

        public List<CheckBill> checkOrder(int orderMasterId, int seatNo, int tableId)
        {
            return restroOrderProvider.checkOrder(orderMasterId, seatNo, tableId);
        }

        public List<CogsReport> getItemDailyProfit(DateTime startDate, DateTime endDate, int itemId)
        {
            return restroOrderProvider.getItemDailyProfit(startDate, endDate, itemId);
        }

        public DataSet GetCostCenterDiscountReport(string startDate, string endDate)
        {
            return restroOrderProvider.GetCostCenterDiscountReport(startDate, endDate);
        }

        public License getLicense(string companyCode)
        {
            return restroOrderProvider.getLicense(companyCode);
        }
    }
}