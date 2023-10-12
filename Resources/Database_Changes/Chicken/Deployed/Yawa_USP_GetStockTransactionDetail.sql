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

EXEC dbo.USP_GetStockTransactionDetail @ItemId = 235 ,                        -- int
                                  @StartDate = '09/01/2023' , -- datetime
                                  @EndDate = '10/08/2023' ,   -- datetime
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
                       INNER JOIN dbo.RO_SalesDetail SD ON SD.salesDetailId = T.SalesDetailId
                WHERE  T.ITId = @ItemId
                AND    T.TransactionDate BETWEEN @StartDate AND DATEADD (DAY, 1, @EndDate);
            END;
        ELSE
            BEGIN
                SELECT StoreId ,
                       CAST (TransactionDate AS DATE) [TransactionDate] ,
                       ItemBalance
                INTO   #Temp1
                FROM   ( SELECT T.StoreId ,
                                T.TransactionDate ,
                                T.ItemBalance ,
                                ROW_NUMBER () OVER ( PARTITION BY CAST (T.TransactionDate AS DATE)
                                                     ORDER BY T.TransactionDate DESC ) AS rownum
                         FROM   [dbo].[vw_ROI_StockReportView] T
                         INNER JOIN dbo.RO_SalesDetail SD ON SD.salesDetailId = T.SalesDetailId
                         WHERE  T.ITId = @ItemId
                         AND    T.StoreId = @StoreId
                         AND    T.TransactionDate BETWEEN @StartDate AND @EndDate ) AS Suv
                WHERE  rownum = 1;
				 
                SELECT    
                         CAST (T.TransactionDate AS DATE) [TransactionDate] ,
                         T.ITId ,
                         T.ITCode ,
                         T.Symbol ,
                         SUM (T.OpeningQty) [OpeningQty] ,
                         SUM (T.PurchaseQty) [PurchaseQty] ,
                         SUM (T.AdjQty) [AdjustQty] ,
                         SUM (T.CompQty) [ComplementQty] ,
                         SUM (T.IssueQty) [IssueQty] ,
						 SUM(T.SalesQty) AS SalesQty,
                         T.SalesReturnQty
                INTO     #Temp2
                FROM     [dbo].[vw_ROI_StockReportView] T
                         INNER JOIN dbo.RO_SalesDetail SD ON SD.salesDetailId = T.SalesDetailId
                WHERE    T.ITId = @ItemId
                AND      T.StoreId = @StoreId
                AND      T.TransactionDate BETWEEN @StartDate AND DATEADD (DAY, 1, @EndDate)
                GROUP BY CAST (TransactionDate AS DATE) ,
                         T.ITId ,
                         T.ITCode ,
                         T.Symbol , 
						 T.SalesReturnQty

                SELECT t1.TransactionDate ,
                       t2.ITId ,
                       t2.ITCode ,
                       t2.Symbol ,
                       t2.OpeningQty ,
                       t2.PurchaseQty ,
                       t2.SalesQty ,
                       t2.SalesReturnQty ,
                       t2.AdjustQty ,
                       t2.ComplementQty ,
                       t2.IssueQty ,
                       t1.ItemBalance
                FROM   #Temp1 t1
                       INNER JOIN #Temp2 t2 ON t1.TransactionDate = t2.TransactionDate;


                DROP TABLE #Temp1;
                DROP TABLE #Temp2;




            END;



    END;
GO
 
