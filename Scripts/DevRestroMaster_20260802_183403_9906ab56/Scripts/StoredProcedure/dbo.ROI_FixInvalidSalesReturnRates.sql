SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Additional Utility: Fix Existing Invalid Data
-- =============================================

CREATE   PROCEDURE [dbo].[ROI_FixInvalidSalesReturnRates]
    @ItemID INT = NULL,
    @STId INT = NULL,
    @DryRun BIT = 0  -- Set to 1 to preview changes without applying
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @UpdatedReturn INT = 0;
    DECLARE @UpdatedMaster INT = 0;
    
    -- Temp table to store records that need fixing
    CREATE TABLE #RecordsToFix
    (
        TableName VARCHAR(50),
        RecordId INT,
        ItemId INT,
        StoreId INT,
        CurrentRate DECIMAL(18,2),
        NewRate DECIMAL(18,2),
        Quantity DECIMAL(18,2)
    );
    
    BEGIN TRY
        -- Find invalid rates in SalesReturnStockTransaction
        INSERT INTO #RecordsToFix
        SELECT 
            'SalesReturnStock' AS TableName,
            srst.SalesTranId,
            srst.ItemId,
            srst.StoreId,
            srst.SalesReturnRate AS CurrentRate,
            ISNULL(lastValid.Rate, item.PurchaseRate) AS NewRate,
            srst.SalesReturnQty AS Quantity
        FROM dbo.ROI_SalesReturnStockTransaction srst
        INNER JOIN dbo.ROI_ItemMaster item ON srst.ItemId = item.ItemId
        OUTER APPLY (
            SELECT TOP 1 Rate
            FROM dbo.ROI_StockTransactionMaster stm
            WHERE stm.ItemId = srst.ItemId
              AND stm.StoreId = srst.StoreId
              AND stm.Rate > 0
              AND stm.StockTranMasterId < (
                  SELECT MIN(StockTranMasterId)
                  FROM dbo.ROI_StockTransactionMaster
                  WHERE SalesReturnId = srst.SalesTranId
              )
            ORDER BY stm.StockTranMasterId DESC
        ) lastValid
        WHERE (srst.SalesReturnRate IS NULL OR srst.SalesReturnRate <= 0)
          AND (@ItemID IS NULL OR srst.ItemId = @ItemID)
          AND (@STId IS NULL OR srst.StoreId = @STId);
        
        -- Find invalid rates in StockTransactionMaster
        INSERT INTO #RecordsToFix
        SELECT 
            'StockMaster' AS TableName,
            stm.StockTranMasterId,
            stm.ItemId,
            stm.StoreId,
            stm.Rate AS CurrentRate,
            ISNULL(lastValid.Rate, item.PurchaseRate) AS NewRate,
            stm.AvailableQty AS Quantity
        FROM dbo.ROI_StockTransactionMaster stm
        INNER JOIN dbo.ROI_ItemMaster item ON stm.ItemId = item.ItemId
        OUTER APPLY (
            SELECT TOP 1 Rate
            FROM dbo.ROI_StockTransactionMaster prev
            WHERE prev.ItemId = stm.ItemId
              AND prev.StoreId = stm.StoreId
              AND prev.Rate > 0
              AND prev.StockTranMasterId < stm.StockTranMasterId
            ORDER BY prev.StockTranMasterId DESC
        ) lastValid
        WHERE stm.SalesReturnId IS NOT NULL  -- Sales return transactions only
          AND (stm.Rate IS NULL OR stm.Rate <= 0)
          AND (@ItemID IS NULL OR stm.ItemId = @ItemID)
          AND (@STId IS NULL OR stm.StoreId = @STId);
        
        -- Show what will be fixed
        SELECT * FROM #RecordsToFix;
        
        IF @DryRun = 0
        BEGIN
            BEGIN TRANSACTION;
            
            -- Fix SalesReturnStockTransaction
            UPDATE srst
            SET 
                srst.SalesReturnRate = fix.NewRate,
                srst.SalesReturnAmt = srst.SalesReturnQty * fix.NewRate
            FROM dbo.ROI_SalesReturnStockTransaction srst
            INNER JOIN #RecordsToFix fix 
                ON srst.SalesTranId = fix.RecordId 
                AND fix.TableName = 'SalesReturnStock';
            
            SET @UpdatedReturn = @@ROWCOUNT;
            
            -- Fix StockTransactionMaster
            UPDATE stm
            SET 
                stm.Rate = fix.NewRate,
                stm.ItemValue = stm.ItemBalance * fix.NewRate
            FROM dbo.ROI_StockTransactionMaster stm
            INNER JOIN #RecordsToFix fix 
                ON stm.StockTranMasterId = fix.RecordId 
                AND fix.TableName = 'StockMaster';
            
            SET @UpdatedMaster = @@ROWCOUNT;
            
            COMMIT TRANSACTION;
            
            SELECT 
                @UpdatedReturn AS SalesReturnRecordsFixed,
                @UpdatedMaster AS StockMasterRecordsFixed,
                'SUCCESS - Data has been updated' AS Status;
        END
        ELSE
        BEGIN
            SELECT 
                COUNT(*) AS TotalRecordsToFix,
                'DRY RUN - No changes made. Set @DryRun = 0 to apply fixes.' AS Status
            FROM #RecordsToFix;
        END
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SELECT 
            ERROR_MESSAGE() AS ErrorMessage,
            'FAILED' AS Status;
    END CATCH
    
    DROP TABLE #RecordsToFix;
END;

GO
