--Clear Items
TRUNCATE TABLE RO_Categories
TRUNCATE TABLE ROI_ITEMMain
TRUNCATE TABLE ROI_ItemDetails
TRUNCATE TABLE ROI_ItemRateHistory
TRUNCATE TABLE ROI_ItemRate
TRUNCATE TABLE RO_Combo
TRUNCATE TABLE RO_ComboDetails
TRUNCATE TABLE RO_ExtraItem
TRUNCATE TABLE [Roi_ExtraItemForItem]
TRUNCATE TABLE [dbo].[RO_ExtraIngredient]
TRUNCATE TABLE [dbo].[Ro_Ingredient]
TRUNCATE TABLE StoreItemMinimumStock
-- clear tables
TRUNCATE TABLE RO_restroTable
TRUNCATE TABLE RO_RestroRoom
TRUNCATE TABLE Ro_RoomType
TRUNCATE TABLE [RO_MergeTable]
--clear item purchases and details
TRUNCATE TABLE Ro_AdjustmentType
TRUNCATE TABLE ROI_AdjustmentDetls
TRUNCATE TABLE ROI_AdjustmentMain
TRUNCATE TABLE ROI_PurchaseDetails
TRUNCATE TABLE ROI_PurchaseLotNo
TRUNCATE TABLE ROI_PurchaseMain
TRUNCATE TABLE RO_PurchaseReturnDetails
TRUNCATE TABLE RO_PurchaseReturnMain

--TRUNCATE TABLE ROI_Store
TRUNCATE TABLE RO_GoodsReceivedMain
TRUNCATE TABLE RO_GoodsReceivedDetls
TRUNCATE TABLE ROI_IssueMain
TRUNCATE TABLE ROI_IssueDetails
TRUNCATE TABLE [Roi_GroupWithItem]
TRUNCATE TABLE [ROI_ITEMBal]
TRUNCATE TABLE [Roi_ItemGroup]
TRUNCATE TABLE Roi_ItemWithUnit
TRUNCATE TABLE RO_Units
-- clear account transactions
TRUNCATE TABLE ac_bankinfo
TRUNCATE TABLE ac_temptransaction
TRUNCATE TABLE ac_temptransactiondetail
TRUNCATE TABLE ac_transaction
TRUNCATE TABLE ac_transactiondetail
TRUNCATE TABLE Ac_VoucherCount
update Ac_VoucherType set VoucherCount=0
alter table Ac_FinancialAc
disable trigger Ac_FinancialAc_Delete
update Ac_FinancialAc set openingbalance=0
alter table Ac_FinancialAc
enable trigger Ac_FinancialAc_Delete
-- clear customer data
TRUNCATE TABLE RO_LoyaltyMembership
TRUNCATE TABLE Roi_CustomerBalance
TRUNCATE TABLE [RO_MemberPay]
TRUNCATE TABLE RO_MemberPaymentMode
--clear order data
TRUNCATE TABLE RO_Order_Detail
TRUNCATE TABLE RO_OrderMasters
TRUNCATE TABLE Order_Detail_Cancel
TRUNCATE TABLE [RO_OrderItemStatus]
TRUNCATE TABLE ro_order_extraitem
TRUNCATE TABLE ro_roombookings
TRUNCATE TABLE RO_ItemShiftLog
TRUNCATE TABLE [RO_ComplementaryItems]
TRUNCATE TABLE [tblComplementaryMaster]
TRUNCATE TABLE [Comp_ExtraItem]
TRUNCATE TABLE [CompItemStatus]
TRUNCATE TABLE RO_OrderToken
-- clear sales data
TRUNCATE TABLE RO_SalesPaymentMode
TRUNCATE TABLE RO_SalesDetail
TRUNCATE TABLE RO_SalesMaster
TRUNCATE TABLE [RO_SalesDetailExtra]
TRUNCATE TABLE RO_BillingAmount
TRUNCATE TABLE [ro_flatandPerDiscount]
TRUNCATE TABLE PrintDetail
-- clear production
TRUNCATE TABLE RO_ProductionDetails
TRUNCATE TABLE RO_ProductionMain
TRUNCATE TABLE PR_ProductionInstant
TRUNCATE TABLE PR_ProductRelease
TRUNCATE TABLE PR_RawUsed
-- clear sms
TRUNCATE TABLE RO_SMS_Message
-- clear housekeeping
TRUNCATE TABLE [dbo].[H_HouseKeeping]
--TRUNCATE TABLE [dbo].[H_HouseKeepingStatus]
TRUNCATE TABLE [dbo].[H_LostAndFound]
--clear etc
TRUNCATE TABLE WaiterNotificationLog
TRUNCATE TABLE [log]
TRUNCATE TABLE SessionTracker
TRUNCATE TABLE DailyChalanIssueDetails
TRUNCATE TABLE DailyChalanMaster
TRUNCATE TABLE DailyChalanReturnedDetail
TRUNCATE TABLE RO_PinSetting
TRUNCATE TABLE RO_PointScheme
-- clear reports sections
TRUNCATE TABLE [DailyFinancialReport]
TRUNCATE TABLE [CashDenomination]
TRUNCATE TABLE [DailySalesReport]
TRUNCATE TABLE [DailyStockReport]
TRUNCATE TABLE [CBMS_BillPostLog]
TRUNCATE TABLE [CBMS_BillReturnPostLog]
TRUNCATE TABLE [RO_Sales_View]
-- Recquistions
TRUNCATE Table Req_Recquistion
TRUNCATE Table Req_RecquistionDetails
TRUNCATE Table [dbo].[RO_VendorPurchase]
TRUNCATE Table [dbo].[Req_IssueLog]

-- hangfire
DROP TABLE HangFire.[Schema]
DROP TABLE HangFire.[State]
DROP TABLE HangFire.[JobParameter]
DROP TABLE HangFire.[JobQueue]
DROP TABLE HangFire.[Server]
DROP TABLE HangFire.[List]
DROP TABLE HangFire.[Set]
DROP TABLE HangFire.[Counter]
DROP TABLE HangFire.[Hash]
DROP TABLE HangFire.[AggregatedCounter]
DROP TABLE HangFire.[Job]

UPDATE costcenterinfo SET coDiscount=0, storeid = 0

--UPDATE RO_restroTable SET restrotablesStatusID = 6

--update RO_LoyaltyMembership set RemainingBalance = 0

--DELETE From ROI_Unit1 where IsArchived=1
--DELETE From ROI_Unit2 where IsArchived=1