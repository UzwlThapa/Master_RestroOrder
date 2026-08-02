SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ROI_GETALLSTOCKREPORT]
    @storeId INT,
    @SearchText NVARCHAR(100)
AS
BEGIN
    -- Get the latest stock balance per item and store
    ;WITH LatestBalance AS (
        SELECT 
            ITId,
            ITCode,
            Symbol,
            ItemBalance,
            StoreId,
            ROW_NUMBER() OVER (
                PARTITION BY ITId, StoreId
                ORDER BY TransactionDate DESC
            ) AS rn
        FROM dbo.vw_ROI_StockReportView
        WHERE 
            (ISNULL(@storeId, 0) = 0 OR StoreId = @storeId)
            AND ITCode LIKE '%' + @SearchText + '%'
    ),

    LatestRate AS (
        SELECT 
            ITId,
            StoreId,
            Rate,
            ROW_NUMBER() OVER (
                PARTITION BY ITId, StoreId
                ORDER BY 
                    CASE WHEN Rate IS NULL OR Rate = 0 THEN 1 ELSE 0 END,
                    TransactionDate DESC
            ) AS rn
        FROM dbo.vw_ROI_StockReportView
        WHERE 
            (ISNULL(@storeId, 0) = 0 OR StoreId = @storeId)
            AND ITCode LIKE '%' + @SearchText + '%'
    )

    SELECT 
        lb.ITId,
        lb.ITCode AS ITName,
        lb.Symbol,
        lb.ItemBalance AS CLBal,
        ISNULL(lb.ItemBalance, 0) * ISNULL(lr.Rate, 0) AS TotalValue
    FROM LatestBalance lb
    LEFT JOIN LatestRate lr
        ON lb.ITId = lr.ITId
        AND lb.StoreId = lr.StoreId
        AND lr.rn = 1
    WHERE lb.rn = 1
    ORDER BY lb.ITCode;
END

GO
