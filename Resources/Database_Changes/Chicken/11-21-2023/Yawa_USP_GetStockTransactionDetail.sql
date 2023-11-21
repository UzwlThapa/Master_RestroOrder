SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 10/09/2023
====================================

EXEC dbo.USP_GetStockTransactionDetail @ItemId = 239 ,                        -- int
                                  @StartDate = '10-01-2023' , -- datetime
                                  @EndDate = '10-01-2023' ,   -- datetime
                                  @StoreId = 2                         -- int
  
*/
ALTER PROCEDURE [dbo].USP_GetStockTransactionDetail
    @ItemId INT ,
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @StoreId INT
AS
    BEGIN
        IF ( @StoreId = 0 )
            BEGIN
                SELECT T.StockTranMasterId ,
                       T.TransactionDate ,
                       T.ITId ,
                       T.ITCode ,
                       T.StoreId ,
                       T.Symbol ,
                       T.OpeningTranId ,
                       T.OpeningQty ,
                       T.OpeningUnit ,
                       T.OpeningRate ,
                       T.OpeningAmt ,
                       T.PurchaseDetailId ,
                       T.PurchaseTranId ,
                       T.PurchaseQty ,
                       T.PurchaseUnit ,
                       T.PurchaseRate ,
                       T.PurchaseAmt ,
                       T.SalesTranId ,
                       T.SalesDetailId ,
                       T.SalesUnit ,
                       T.SalesAmt ,
                       T.AdjustTranId ,
                       T.AdjQty ,
                       T.AdjRate ,
                       T.AdjUnit ,
                       T.AdjAmt ,
                       T.CompTranId ,
                       T.CompQty ,
                       T.CompUnit ,
                       T.CompAmt ,
                       T.IssueTranId ,
                       T.IssueQty ,
                       T.FromStoreId ,
                       T.ToStoreId ,
                       T.IssueUnit ,
                       T.IssueAmt ,
                       T.AvailableQty ,
                       T.Rate ,
                       T.ItemBalance ,
                       T.ItemValue ,
                       T.SalesReturnDetailId ,
                       T.Unit ,
                       T.SalesReturnRate ,
                       T.SalesReturnAmt ,
                       T.SalesQty ,
                       T.SalesReturnQty
                FROM   [dbo].[vw_ROI_StockReportView] T
                       LEFT JOIN dbo.RO_SalesDetail SD ON SD.salesDetailId = T.SalesDetailId
                WHERE  T.ITId = @ItemId
                AND    CAST(T.TransactionDate AS DATE) BETWEEN @StartDate AND @EndDate;
            END;
        ELSE
            BEGIN

                SELECT StoreId ,
                       CAST(TransactionDate AS DATE) AS [TransactionDate] ,
                       ItemBalance
                INTO   #Temp1
                FROM   ( SELECT rstm.StoreId ,
                                tt.TransactionDate ,
                                rstm.ItemBalance ,
                                ROW_NUMBER () OVER ( PARTITION BY CAST(tt.TransactionDate AS DATE)
                                                     ORDER BY tt.TransactionDate DESC ) AS rownum
                         FROM   dbo.Ac_TransactionDetail ttd
                                JOIN dbo.Ac_FinancialAc fa ON ttd.FinancialAcID = fa.FinancialAcID
                                JOIN dbo.Ac_Transaction tt ON tt.TransactionID = ttd.TransactionID
                                LEFT JOIN dbo.Ac_VoucherType AS avt ON avt.VoucherTypeID = tt.VoucherTypeID
                                JOIN dbo.RO_GoodsReceivedMain AS rgrm ON rgrm.GMNo = REVERSE (
                                                                                         SUBSTRING (
                                                                                             REVERSE (tt.Descriptions) ,
                                                                                             0 ,
                                                                                             CHARINDEX (
                                                                                                 '-:' ,
                                                                                                 REVERSE (tt.Descriptions))))
                                JOIN dbo.RO_GoodsReceivedDetls AS rgrd ON rgrd.GMId = rgrm.GMId
                                JOIN dbo.ROI_PurchaseDetails AS rpd ON rgrd.PDId = rpd.PurchaseDetailsID
                                LEFT JOIN dbo.ROI_ITEMMain IM ON IM.ITId = rpd.ItemID
                                INNER JOIN dbo.ROI_StockTransactionMaster AS rstm ON rstm.ItemId = rpd.ItemID
                                LEFT JOIN dbo.ROI_SalesStockTransaction AS rsst ON rsst.SalesTranId = rstm.SalesTranId
                                LEFT JOIN dbo.RO_SalesDetail SD ON SD.salesDetailId = rsst.SalesDetailId
                                LEFT JOIN dbo.RO_SalesMaster SM ON SM.salesMasterId = SD.salesMasterId
                                LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
                                LEFT JOIN dbo.ROI_ItemDetails AS rid ON rid.ITId = rstm.ItemId
                                LEFT JOIN dbo.ROI_Unit1 AS ru ON rstm.ItemBalUnitId = ru.Unit1Id
                                LEFT JOIN dbo.ROI_SalesReturnStockTransaction AS rsrst ON rstm.SalesReturnId = rsrst.SalesTranId
                                LEFT JOIN dbo.ROI_OpeningStockTransaction AS rost ON rstm.OpeningTranId = rost.OpeningTranId
                                LEFT JOIN dbo.ROI_PurchaseStockTransaction AS rpst ON rstm.PurchaseTranId = rpst.PurchaseTranId
                                LEFT JOIN dbo.ROI_AdjustStockTransaction AS rast ON rast.AdjTranId = rstm.AdjustTranId
                                LEFT JOIN dbo.ROI_ComplementryStockTransaction AS rasc ON rasc.CompTranId = rstm.CompTranId
                                LEFT JOIN dbo.ROI_IssueStockTransaction AS rasi ON rasi.IssueTranId = rstm.IssueTranId
                         WHERE  IM.ITId = @ItemId
                         AND    rstm.StoreId = @StoreId
                         AND    CAST(tt.TransactionDate AS DATE) BETWEEN @StartDate AND @EndDate ) AS Suv
                WHERE  rownum = 1;

                SELECT   CAST(tt.TransactionDate AS DATE) AS [TransactionDate] ,
                         rid.ITId ,
                         rid.ITCode ,
                         ru.Symbol ,
                         SUM (ISNULL (rost.OpeningQty, 0)) AS [OpeningQty] ,
                         SUM (ISNULL (rpst.PurchaseQty, 0)) AS [PurchaseQty] ,
                         SUM (ISNULL (rast.AdjQty, 0)) AS [AdjustQty] ,
                         SUM (ISNULL (rasc.CompQty, 0)) AS [ComplementQty] ,
                         SUM (ISNULL (rasi.IssueQty, 0)) AS [IssueQty] ,
                         SUM (ISNULL (rsst.SalesQty, 0)) AS SalesQty ,
                         SUM (CASE WHEN OM.IsCancelled = 1 THEN rsrst.SalesReturnQty
                                   ELSE 0
                              END) AS SalesReturnQty
                INTO     #Temp2
                FROM     dbo.Ac_TransactionDetail ttd
                         JOIN dbo.Ac_FinancialAc fa ON ttd.FinancialAcID = fa.FinancialAcID
                         JOIN dbo.Ac_Transaction tt ON tt.TransactionID = ttd.TransactionID
                         LEFT JOIN dbo.Ac_VoucherType AS avt ON avt.VoucherTypeID = tt.VoucherTypeID
                         JOIN dbo.RO_GoodsReceivedMain AS rgrm ON rgrm.GMNo = REVERSE (
                                                                                  SUBSTRING (
                                                                                      REVERSE (tt.Descriptions) ,
                                                                                      0 ,
                                                                                      CHARINDEX (
                                                                                          '-:' , REVERSE (tt.Descriptions))))
                         JOIN dbo.RO_GoodsReceivedDetls AS rgrd ON rgrd.GMId = rgrm.GMId
                         JOIN dbo.ROI_PurchaseDetails AS rpd ON rgrd.PDId = rpd.PurchaseDetailsID
                         LEFT JOIN dbo.ROI_ITEMMain IM ON IM.ITId = rpd.ItemID
                         INNER JOIN dbo.ROI_StockTransactionMaster AS rstm ON rstm.ItemId = rpd.ItemID
                         LEFT JOIN dbo.ROI_SalesStockTransaction AS rsst ON rsst.SalesTranId = rstm.SalesTranId
                         LEFT JOIN dbo.RO_SalesDetail SD ON SD.salesDetailId = rsst.SalesDetailId
                         LEFT JOIN dbo.RO_SalesMaster SM ON SM.salesMasterId = SD.salesMasterId
                         LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
                         LEFT JOIN dbo.ROI_ItemDetails AS rid ON rid.ITId = rstm.ItemId
                         LEFT JOIN dbo.ROI_Unit1 AS ru ON rstm.ItemBalUnitId = ru.Unit1Id
                         LEFT JOIN dbo.ROI_SalesReturnStockTransaction AS rsrst ON rstm.SalesReturnId = rsrst.SalesTranId
                         LEFT JOIN dbo.ROI_OpeningStockTransaction AS rost ON rstm.OpeningTranId = rost.OpeningTranId
                         LEFT JOIN dbo.ROI_PurchaseStockTransaction AS rpst ON rstm.PurchaseTranId = rpst.PurchaseTranId
                         LEFT JOIN dbo.ROI_AdjustStockTransaction AS rast ON rast.AdjTranId = rstm.AdjustTranId
                         LEFT JOIN dbo.ROI_ComplementryStockTransaction AS rasc ON rasc.CompTranId = rstm.CompTranId
                         LEFT JOIN dbo.ROI_IssueStockTransaction AS rasi ON rasi.IssueTranId = rstm.IssueTranId
                WHERE    IM.ITId = @ItemId
                AND      rstm.StoreId = @StoreId
                AND      CAST(tt.TransactionDate AS DATE) BETWEEN @StartDate AND @EndDate
                GROUP BY CAST(tt.TransactionDate AS DATE) ,
                         rid.ITId ,
                         rid.ITCode ,
                         ru.Symbol ,
                         rsrst.SalesReturnQty;


                SELECT   DISTINCT t1.TransactionDate ,
                                  t2.ITId ,
                                  t2.ITCode ,
                                  t2.Symbol ,
                                  t2.OpeningQty ,
                                  CAST(t2.PurchaseQty AS DECIMAL) AS PurchaseQty ,
                                  t2.SalesQty ,
                                  t2.SalesReturnQty ,
                                  t2.AdjustQty ,
                                  t2.ComplementQty ,
                                  t2.IssueQty ,
                                  t1.ItemBalance
                FROM     #Temp1 t1
                         INNER JOIN #Temp2 t2 ON t1.TransactionDate = t2.TransactionDate
                ORDER BY t1.TransactionDate;

                DROP TABLE #Temp1;
                DROP TABLE #Temp2;
            END;
    END;
GO

