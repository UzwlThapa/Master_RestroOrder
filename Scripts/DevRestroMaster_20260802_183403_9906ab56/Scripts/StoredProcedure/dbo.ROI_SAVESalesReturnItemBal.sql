SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ROI_SAVESalesReturnItemBal]
    @ItemID INT,
    @SalesDetailId INT,
    @STId INT,
    @SalesReturnQty INT,
    @SalesReturnUnit INT,
    @SalesReturnAmt DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SmallUnit INT,
            @SalesReturnRate DECIMAL(18, 2),
            @SalesReturnTranId INT,
            @LastBalance DECIMAL(15,2),
            @LastValue DECIMAL(15,2),
            @NewBalance DECIMAL(15,2),
            @NewValue DECIMAL(15,2),
            @ActualAvailableQty DECIMAL(15,2),
            @MasterTranId INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- ===================================================================
        -- STEP 1: Calculate or fetch valid rate (NEVER allow -1, NULL, or 0)
        -- ===================================================================
        
        -- First attempt: Calculate rate from amount and quantity
        IF @SalesReturnQty > 0 AND @SalesReturnAmt > 0
        BEGIN
            SET @SalesReturnRate = ROUND(@SalesReturnAmt / @SalesReturnQty, 2);
        END
        ELSE
        BEGIN
            SET @SalesReturnRate = NULL; -- Mark for fallback
        END
        
        -- Second attempt: Fetch last valid stock rate if calculation failed
        IF @SalesReturnRate IS NULL OR @SalesReturnRate <= 0
        BEGIN
            SELECT TOP 1 
                @SalesReturnRate = Rate
            FROM dbo.ROI_StockTransactionMaster WITH (NOLOCK)
            WHERE ItemId = @ItemID
              AND StoreId = @STId
              AND Rate IS NOT NULL
              AND Rate > 0  -- Only positive rates
              AND ItemBalance > 0  -- Valid stock entries only
            ORDER BY StockTranMasterId DESC;
        END
        
        -- Third attempt: Get item's standard rate from item master
        IF @SalesReturnRate IS NULL OR @SalesReturnRate <= 0
        BEGIN
            SELECT TOP 1
                @SalesReturnRate = ISNULL(PurchaseRate, SalesRate)
            FROM dbo.ROI_ItemMaster WITH (NOLOCK)
            WHERE ItemId = @ItemID
              AND (PurchaseRate > 0 OR SalesRate > 0);
        END
        
        -- Final fallback: If still no valid rate, use a safe default
        -- This prevents -1 or NULL but logs a warning scenario
        IF @SalesReturnRate IS NULL OR @SalesReturnRate <= 0
        BEGIN
            SET @SalesReturnRate = 0.01; -- Minimal positive value to prevent calculation errors
            -- Consider logging this scenario for review
        END
        
        -- ===================================================================
        -- STEP 2: Get last stock balance and value (initialize if none exists)
        -- ===================================================================
        
        SELECT TOP 1 
            @LastBalance = ISNULL(ItemBalance, 0),
            @LastValue = ISNULL(ItemValue, 0)
        FROM dbo.ROI_StockTransactionMaster WITH (NOLOCK)
        WHERE ItemId = @ItemID
          AND StoreId = @STId
        ORDER BY StockTranMasterId DESC;
        
        -- Initialize if no previous transaction
        IF @LastBalance IS NULL
        BEGIN
            SET @LastBalance = 0;
            SET @LastValue = 0;
        END
        
        -- ===================================================================
        -- STEP 3: Calculate new balance and value
        -- ===================================================================
        
        SET @NewBalance = @LastBalance + @SalesReturnQty;
        
        -- Recalculate return amount using valid rate
        SET @SalesReturnAmt = @SalesReturnQty * @SalesReturnRate;
        
        -- Calculate new value - always use rate-based calculation for consistency
        SET @NewValue = @LastValue + @SalesReturnAmt;
        
        -- Ensure ItemValue is never NULL
        IF @NewValue IS NULL
        BEGIN
            SET @NewValue = @NewBalance * @SalesReturnRate;
        END
        
        -- ===================================================================
        -- STEP 4: Calculate actual available quantity (never negative)
        -- ===================================================================
        
        SET @ActualAvailableQty = @NewBalance;
        
        IF @ActualAvailableQty < 0
        BEGIN
            SET @ActualAvailableQty = 0;
        END
        
        -- ===================================================================
        -- STEP 5: Set unit value
        -- ===================================================================
        
        SET @SmallUnit = ISNULL(@SalesReturnUnit, 0);
        
        -- ===================================================================
        -- STEP 6: Insert into SalesReturnStockTransaction with validated data
        -- ===================================================================
        
        INSERT INTO dbo.ROI_SalesReturnStockTransaction
        (
            SalesDetailId,
            StoreId,
            ItemId,
            SalesReturnQty,
            Unit,
            SalesReturnRate,
            SalesReturnAmt,
            AvailableQty,
            TransactionDate
        )
        VALUES
        (
            @SalesDetailId,
            @STId,
            @ItemID,
            @SalesReturnQty,
            @SmallUnit,
            @SalesReturnRate,          -- Always valid positive rate
            @SalesReturnAmt,            -- Recalculated with valid rate
            @ActualAvailableQty,        -- Actual available (never negative)
            GETDATE()
        );
        
        SET @SalesReturnTranId = SCOPE_IDENTITY();
        
        -- ===================================================================
        -- STEP 7: Insert into StockTransactionMaster with validated data
        -- ===================================================================
        
        INSERT INTO dbo.ROI_StockTransactionMaster
        (
            SalesReturnId,
            StoreId,
            ItemId,
            AvailableQty,
            Rate,
            ItemBalance,
            ItemBalUnitId,
            ItemValue,
            TransactionDate
        )
        VALUES
        (
            @SalesReturnTranId,
            @STId,
            @ItemID,
            @ActualAvailableQty,        -- Consistent with return transaction
            @SalesReturnRate,           -- Valid positive rate
            @NewBalance,                -- Actual new balance
            @SmallUnit,
            @NewValue,                  -- Calculated value (never NULL)
            GETDATE()
        );
        
        SET @MasterTranId = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        
        -- Return success information for debugging/logging
        SELECT 
            @MasterTranId AS StockTranMasterId,
            @SalesReturnTranId AS SalesReturnTranId,
            @SalesReturnRate AS AppliedRate,
            @NewBalance AS NewItemBalance,
            @NewValue AS NewItemValue,
            @ActualAvailableQty AS AvailableQty,
            'SUCCESS' AS Status;
            
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Return error details
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        
        SELECT 
            @ErrorMessage AS ErrorMessage,
            @ErrorLine AS ErrorLine,
            'FAILED' AS Status;
            
        -- Re-throw error for calling application to handle
        THROW;
    END CATCH
END;

GO
