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
ALTER PROCEDURE [dbo].[USP_GetStockTransactionDetail]
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
                       T.OpeningUnit ,
                       T.OpeningRate ,
                       T.OpeningAmt ,
                       T.PurchaseDetailId ,
                       T.PurchaseTranId ,
                       T.PurchaseUnit ,
                       T.PurchaseRate ,
                       T.PurchaseAmt ,
                       T.SalesTranId ,
                       T.SalesDetailId ,
                       T.SalesUnit ,
                       T.SalesAmt ,
                       T.AdjustTranId ,
                       T.AdjRate ,
                       T.AdjUnit ,
                       T.AdjAmt ,
                       T.CompTranId ,
                       T.CompUnit ,
                       T.CompAmt ,
                       T.IssueTranId ,
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
                       ISNULL (T.OpeningQty, 0) AS OpeningQty ,
                       ISNULL (T.PurchaseQty, 0) AS PurchaseQty ,
                       ISNULL (T.AdjQty, 0) AS AdjustQty ,
                       ISNULL (T.CompQty, 0) AS ComplementQty ,
                       ISNULL (T.IssueQty, 0) AS [IssueQty] ,
                       CASE WHEN tt.ITId IS NULL THEN ISNULL (SD.qty, 0)
                            ELSE ISNULL (T.SalesQty, 0)
                       END AS SalesQty ,
                       CASE WHEN OM.IsCancelled = 1 THEN T.SalesReturnQty
                            ELSE 0
                       END AS SalesReturnQty
                FROM   [dbo].[vw_ROI_StockReportView] T
                       LEFT JOIN dbo.RO_SalesDetail SD ON SD.salesDetailId = T.SalesDetailId
                       LEFT JOIN dbo.RO_SalesMaster SM ON SM.salesMasterId = SD.salesMasterId
                       LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
                       LEFT JOIN ( SELECT rim.ITId ,
                                          rim.PITId ,
                                          ri.Ingredient ,
                                          ri.Quantity ,
                                          u1.Symbol
                                   FROM   dbo.ROI_ITEMMain AS rim
                                          INNER JOIN dbo.Ro_Ingredient AS ri ON ri.ItemID = rim.ITId
                                          JOIN ROI_ItemDetails id ON id.ITId = ri.Ingredient
                                          JOIN ROI_Unit1 u1 ON u1.Unit1Id = id.SmallUnit ) tt ON  tt.Ingredient = T.ITId
                                                                                              AND tt.ITId = SD.ItemId
                                                                                              AND tt.Symbol IN ( 'ml', 'gm' )
                WHERE  T.ITId = @ItemId
                AND    CAST(T.TransactionDate AS DATE) BETWEEN @StartDate AND @EndDate;
            END;
        ELSE
            BEGIN

                SELECT StoreId ,
                       CAST(TransactionDate AS DATE) AS [TransactionDate] ,
                       ItemBalance
                INTO   #Temp1
                FROM   ( SELECT T.StoreId ,
                                T.TransactionDate ,
                                ( T.ItemBalance + ISNULL ([rpst].PurchaseUnit, 0)) AS ItemBalance ,
                                ROW_NUMBER () OVER ( PARTITION BY CAST(T.TransactionDate AS DATE)
                                                     ORDER BY T.TransactionDate DESC ) AS rownum
                         FROM   [dbo].[vw_ROI_StockReportView] T
                                LEFT JOIN dbo.RO_SalesDetail SD ON SD.salesDetailId = T.SalesDetailId
                                LEFT JOIN dbo.[ROI_PurchaseStockTransaction] AS [rpst] ON  rpst.StoreId = T.StoreId
                                                                                       AND rpst.ItemId = SD.ItemId
                                                                                       AND CAST(rpst.TransactionDate AS DATE) = CAST(T.TransactionDate AS DATE)
                         WHERE  T.ITId = @ItemId
                         AND    T.StoreId = @StoreId
                         AND    CAST(T.TransactionDate AS DATE) BETWEEN @StartDate AND @EndDate ) AS Suv
                WHERE  rownum = 1;

                SELECT   CAST(T.TransactionDate AS DATE) AS [TransactionDate] ,
                         T.ITId ,
                         T.ITCode ,
                         T.Symbol ,
                         SUM (ISNULL (T.OpeningQty, 0)) AS [OpeningQty] ,
                         SUM (ISNULL (T.PurchaseQty, 0)) AS [PurchaseQty] ,
                         SUM (ISNULL (T.AdjQty, 0)) AS [AdjustQty] ,
                         SUM (ISNULL (T.CompQty, 0)) AS [ComplementQty] ,
                         SUM (ISNULL (T.IssueQty, 0)) AS [IssueQty] ,
                         SUM (CASE WHEN tt.ITId IS NULL THEN ISNULL (SD.qty, 0)
                                   ELSE ISNULL (tt.Quantity, 0) * ISNULL (SD.qty, 0)
                              END) AS SalesQty ,
                         SUM (CASE WHEN OM.IsCancelled = 1 THEN T.SalesReturnQty
                                   ELSE 0
                              END) AS SalesReturnQty
                INTO     #Temp2
                FROM     [dbo].[vw_ROI_StockReportView] T
                         LEFT JOIN dbo.RO_SalesDetail SD ON SD.salesDetailId = T.SalesDetailId
                         LEFT JOIN dbo.RO_SalesMaster SM ON SM.salesMasterId = SD.salesMasterId
                         LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
                         LEFT JOIN ( SELECT rim.ITId ,
                                            rim.PITId ,
                                            ri.Ingredient ,
                                            ri.Quantity ,
                                            u1.Symbol
                                     FROM   dbo.ROI_ITEMMain AS rim
                                            INNER JOIN dbo.Ro_Ingredient AS ri ON ri.ItemID = rim.ITId
                                            JOIN ROI_ItemDetails id ON id.ITId = ri.Ingredient
                                            JOIN ROI_Unit1 u1 ON u1.Unit1Id = id.SmallUnit ) tt ON  tt.Ingredient = T.ITId
                                                                                                AND tt.ITId = SD.ItemId
                                                                                                AND tt.Symbol IN ( 'ml', 'gm' )
                WHERE    T.ITId = @ItemId
                AND      T.StoreId = @StoreId
                AND      CAST(T.TransactionDate AS DATE) BETWEEN @StartDate AND @EndDate
                GROUP BY CAST(TransactionDate AS DATE) ,
                         T.ITId ,
                         T.ITCode ,
                         T.Symbol ,
                         T.SalesReturnQty;


                SELECT   DISTINCT t1.TransactionDate ,
                                  t2.ITId ,
                                  t2.ITCode ,
                                  t2.Symbol ,
                                  t2.OpeningQty ,
                                  CAST(t2.PurchaseQty AS DECIMAL) AS PurchaseQty ,
                                  CAST(t2.SalesQty AS DECIMAL) AS SalesQty ,
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

