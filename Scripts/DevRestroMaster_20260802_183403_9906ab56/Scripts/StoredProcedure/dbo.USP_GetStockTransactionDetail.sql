SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 10/09/2023
====================================

EXEC dbo.USP_GetStockTransactionDetail @ItemId = 237 ,                        -- int
                                  @StartDate = '01-01-2024' , -- datetime
                                  @EndDate = '02-02-2024' ,   -- datetime
                                  @StoreId = 2                         -- int
  
*/
CREATE PROCEDURE [dbo].[USP_GetStockTransactionDetail]
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
					   T.PurchaseReturnId,
					   T.UsedUnitID,
					   T.PurchaseReturnRate,
					   T.PurchaseReturnAmt,
                       ISNULL (T.OpeningQty, 0) AS OpeningQty ,
                       ISNULL (T.PurchaseQty, 0) AS PurchaseQty ,
                       ISNULL (T.PurchaseQty, 0) AS PurchaseQty ,
                       ISNULL (T.AdjQty, 0) AS AdjustQty ,
                       ISNULL (T.CompQty, 0) AS ComplementQty ,
                       ISNULL (T.IssueQty, 0) AS [IssueQty] ,
                       ISNULL (T.SalesQty, 0) AS SalesQty ,
                       ISNULL (T.SalesReturnQty, 0) AS SalesReturnQty,
					   ISNULL (T.PurchaseReturnQty, 0) AS PurchaseReturnQty
                FROM   [dbo].[vw_ROI_StockReportView] T
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
                                T.ItemBalance ,
                                ROW_NUMBER () OVER ( PARTITION BY CAST(T.TransactionDate AS DATE)
                                                     ORDER BY T.TransactionDate DESC ) AS rownum
                         FROM   [dbo].[vw_ROI_StockReportView] T
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
                       --  SUM (ISNULL (T.IssueQty, 0)) AS [IssueQty] ,
					   SUM (CASE
						WHEN @StoreId = T.FromStoreId THEN -ISNULL(T.IssueQty, 0)
				        ELSE ISNULL(T.IssueQty, 0)
						END) AS [IssueQty],
                         SUM (ISNULL (T.SalesQty, 0)) AS SalesQty ,
                         SUM (ISNULL (T.SalesReturnQty, 0)) AS SalesReturnQty,
                         SUM (ISNULL (T.PurchaseReturnQty, 0)) AS PurchaseReturnQty

                INTO     #Temp2
                FROM     [dbo].[vw_ROI_StockReportView] T
                WHERE    T.ITId = @ItemId
                AND      T.StoreId = @StoreId
                AND      CAST(T.TransactionDate AS DATE) BETWEEN @StartDate AND @EndDate
                GROUP BY CAST(TransactionDate AS DATE) ,
                         T.ITId ,
                         T.ITCode ,
                         T.Symbol;


                SELECT   DISTINCT t1.TransactionDate ,
                                  t2.ITId ,
                                  t2.ITCode ,
                                  t2.Symbol ,
                                  t2.OpeningQty ,
                                  CAST(t2.PurchaseQty AS DECIMAL) AS PurchaseQty ,
                                  CAST(t2.SalesQty AS DECIMAL) AS SalesQty ,
								  CAST(t2.PurchaseReturnQty AS DECIMAL) AS PurchaseReturnQty,
								  CAST(t2.SalesReturnQty AS DECIMAL) AS SalesReturnQty ,
                              --    t2.SalesReturnQty ,
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
