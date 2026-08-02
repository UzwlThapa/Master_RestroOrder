SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Exec [dbo].[usp_getOutOfStockItems] 0
CREATE PROCEDURE [dbo].[usp_getOutOfStockItems] @StoreId INT
AS
BEGIN
    SELECT [vrsrv].ITId,
           [vrsrv].ITCode AS ITName,
           [vrsrv].Symbol,
           SUM([vrsrv].ItemBalance) AS CLBal,
           rs.StName
    --SUM([vrsrv].ItemValue) AS TotalValue
    FROM [dbo].[vw_ROI_StockReportView] AS [vrsrv]
        INNER JOIN
        (
            SELECT MAX(TransactionDate) AS TransactionDate,
                   ITId,
                   SRV.StoreId
            FROM [dbo].[vw_ROI_StockReportView] AS SRV
            WHERE (
                      ISNULL(@StoreId, 0) = 0
                      OR
                      (
                          ISNULL(@StoreId, 0) <> 0
                          AND SRV.StoreId = @StoreId
                      )
                  )
            GROUP BY SRV.ITId,
                     SRV.StoreId
        ) SV
            ON SV.ITId = [vrsrv].ITId
               AND SV.StoreId = vrsrv.StoreId
               AND SV.TransactionDate = [vrsrv].TransactionDate
        INNER JOIN dbo.ROI_Store AS rs
            ON rs.STId = vrsrv.StoreId
        INNER JOIN dbo.StoreItemMinimumStock AS sims
            ON sims.ItemId = vrsrv.ITId
    --WHERE SUM([vrsrv].ItemBalance) <= sims.[Value]
    GROUP BY vrsrv.ITId,
             vrsrv.ITCode,
             vrsrv.Symbol,
             rs.StName,
			 sims.Value
    HAVING SUM([vrsrv].ItemBalance) <= sims.[Value];

END;


GO
