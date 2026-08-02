SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_ROI_StockReportView]
AS
SELECT        TOP (100) PERCENT dbo.ROI_StockTransactionMaster.StockTranMasterId, dbo.ROI_StockTransactionMaster.TransactionDate, dbo.ROI_ItemDetails.ITId, dbo.ROI_ItemDetails.ITCode, dbo.ROI_StockTransactionMaster.StoreId, 
                         dbo.ROI_Unit1.Symbol, dbo.ROI_StockTransactionMaster.OpeningTranId, dbo.ROI_OpeningStockTransaction.OpeningQty, dbo.ROI_OpeningStockTransaction.OpeningUnit, dbo.ROI_OpeningStockTransaction.OpeningRate, 
                         dbo.ROI_OpeningStockTransaction.OpeningAmt, dbo.ROI_PurchaseStockTransaction.PurchaseDetailId, dbo.ROI_StockTransactionMaster.PurchaseTranId, dbo.ROI_PurchaseStockTransaction.PurchaseQty, 
                         dbo.ROI_PurchaseStockTransaction.PurchaseUnit, dbo.ROI_PurchaseStockTransaction.PurchaseRate, dbo.ROI_PurchaseStockTransaction.PurchaseAmt, dbo.ROI_StockTransactionMaster.SalesTranId, 
                         dbo.ROI_SalesStockTransaction.SalesDetailId, dbo.ROI_SalesStockTransaction.SalesQty, dbo.ROI_SalesStockTransaction.SalesUnit, dbo.ROI_SalesStockTransaction.SalesAmt, dbo.ROI_StockTransactionMaster.AdjustTranId, 
                         dbo.ROI_AdjustStockTransaction.AdjQty, dbo.ROI_AdjustStockTransaction.AdjRate, dbo.ROI_AdjustStockTransaction.AdjUnit, dbo.ROI_AdjustStockTransaction.AdjAmt, dbo.ROI_StockTransactionMaster.CompTranId, 
                         dbo.ROI_ComplementryStockTransaction.CompQty, dbo.ROI_ComplementryStockTransaction.CompUnit, dbo.ROI_ComplementryStockTransaction.CompAmt, dbo.ROI_IssueStockTransaction.IssueTranId, 
                         dbo.ROI_IssueStockTransaction.IssueQty, dbo.ROI_IssueStockTransaction.FromStoreId, dbo.ROI_IssueStockTransaction.ToStoreId, dbo.ROI_IssueStockTransaction.IssueUnit, dbo.ROI_IssueStockTransaction.IssueAmt, 
                         dbo.ROI_StockTransactionMaster.AvailableQty, dbo.ROI_StockTransactionMaster.Rate, dbo.ROI_StockTransactionMaster.ItemBalance, dbo.ROI_StockTransactionMaster.ItemValue, 
                         dbo.ROI_SalesReturnStockTransaction.SalesDetailId AS SalesReturnDetailId, dbo.ROI_SalesReturnStockTransaction.SalesReturnQty, dbo.ROI_SalesReturnStockTransaction.Unit, 
                         dbo.ROI_SalesReturnStockTransaction.SalesReturnRate, dbo.ROI_SalesReturnStockTransaction.SalesReturnAmt
						 , dbo.RO_PurchaseReturnDetails.PurchaseReturnId,  dbo.RO_PurchaseReturnDetails.Qnty as PurchaseReturnQty,  dbo.RO_PurchaseReturnDetails.UsedUnitID,  dbo.RO_PurchaseReturnDetails.Rate as PurchaseReturnRate, dbo.RO_PurchaseReturnDetails.Total as PurchaseReturnAmt 
FROM            dbo.ROI_ItemDetails INNER JOIN
                         dbo.ROI_StockTransactionMaster ON dbo.ROI_ItemDetails.ITId = dbo.ROI_StockTransactionMaster.ItemId LEFT OUTER JOIN
                         dbo.ROI_PurchaseStockTransaction ON dbo.ROI_StockTransactionMaster.PurchaseTranId = dbo.ROI_PurchaseStockTransaction.PurchaseTranId LEFT OUTER JOIN
                         dbo.ROI_SalesStockTransaction ON dbo.ROI_StockTransactionMaster.SalesTranId = dbo.ROI_SalesStockTransaction.SalesTranId LEFT OUTER JOIN
                         dbo.ROI_Unit1 ON dbo.ROI_StockTransactionMaster.ItemBalUnitId = dbo.ROI_Unit1.Unit1Id LEFT OUTER JOIN
                         dbo.ROI_SalesReturnStockTransaction ON dbo.ROI_StockTransactionMaster.SalesReturnId = dbo.ROI_SalesReturnStockTransaction.SalesTranId LEFT OUTER JOIN
                         dbo.ROI_ComplementryStockTransaction ON dbo.ROI_StockTransactionMaster.CompTranId = dbo.ROI_ComplementryStockTransaction.CompTranId LEFT OUTER JOIN
                         dbo.ROI_IssueStockTransaction ON dbo.ROI_StockTransactionMaster.IssueTranId = dbo.ROI_IssueStockTransaction.IssueTranId LEFT OUTER JOIN
                         dbo.ROI_OpeningStockTransaction ON dbo.ROI_StockTransactionMaster.OpeningTranId = dbo.ROI_OpeningStockTransaction.OpeningTranId LEFT OUTER JOIN
                         dbo.ROI_AdjustStockTransaction ON dbo.ROI_StockTransactionMaster.AdjustTranId = dbo.ROI_AdjustStockTransaction.AdjTranId 
						 Left outer join dbo.RO_PurchaseReturnDetails ON dbo.ROI_StockTransactionMaster.PurchaseReturnTranId = dbo.RO_PurchaseReturnDetails.PurchaseReturnId and dbo.ROI_StockTransactionMaster.ItemId = dbo.RO_PurchaseReturnDetails.ItemID
ORDER BY dbo.ROI_StockTransactionMaster.StockTranMasterId

GO
