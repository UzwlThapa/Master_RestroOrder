SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_savesalesDetail]
    @salesMasterId INT,
    @ItemId INT,
    @qty FLOAT,
    @rate DECIMAL(18,2),
    @Amount DECIMAL(18,2),
    @NetAmount DECIMAL(18,2),
    @CostCenterId INT,
    @IsCombo BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert main sales detail
    INSERT INTO dbo.RO_SalesDetail 
        (salesMasterId, ItemId, qty, rate, Amount, NetAmount, CostCenterId, IsCombo, HsCode)
    SELECT 
        @salesMasterId,
        @ItemId,
        @qty,
        @rate,
        @Amount,
        @NetAmount,
        @CostCenterId,
        @IsCombo,
        ISNULL(rid.HsCode,'')
    FROM dbo.ROI_ITEMMain AS rid
    WHERE rid.ITId = @ItemId;

    DECLARE @sDetailID INT = SCOPE_IDENTITY();

    -- Temp table for ingredients
    CREATE TABLE #tempItem
    (
        Id INT IDENTITY(1,1),
        ItemBalance DECIMAL(18,2),
        ItemValue DECIMAL(18,2),
        IngredientId INT,
        Quantity DECIMAL(18,2)
    );

    INSERT INTO #tempItem (ItemBalance, ItemValue, IngredientId, Quantity)
    SELECT 
        bal.ItemBalance,
        bal.ItemValue,
        RI.Ingredient AS IngredientId,
        RI.Quantity
    FROM dbo.Ro_Ingredient RI
    INNER JOIN dbo.ROI_ITEMMain RIM ON RIM.ITId = RI.Ingredient
    CROSS APPLY (
        SELECT TOP(1) STM.StockTranMasterId, STM.ItemId, STM.ItemBalance, STM.ItemValue
        FROM dbo.ROI_StockTransactionMaster STM
        WHERE STM.ItemId = RIM.ITId
        ORDER BY STM.StockTranMasterId DESC
    ) AS bal
    WHERE RI.ItemID = @ItemId;

    -- Declare variables
    DECLARE 
        @IngredientId INT,
        @Id INT,
        @ItemBalance DECIMAL(18,2),
        @ItemValue DECIMAL(18,2),
        @IngQuantity DECIMAL(18,2),
        @IngSalesQuantity DECIMAL(18,2),
        @IngSalesValue DECIMAL(18,2),
        @IngPurchaseRate DECIMAL(18,2),
        @StoreId INT,
        @SUnitName INT,
        @ComputedRate DECIMAL(18,2);

    -- Loop through ingredients
    WHILE EXISTS (SELECT 1 FROM #tempItem)
    BEGIN
        SELECT TOP(1)
            @Id = ti.Id,
            @IngredientId = ti.IngredientId,
            @ItemBalance = ti.ItemBalance,
            @ItemValue = ti.ItemValue,
            @IngQuantity = ti.Quantity
        FROM #tempItem ti
        ORDER BY ti.Id;

        SELECT 
            @SUnitName = ID.SmallUnit,
            @StoreId = CC.StoreId
        FROM dbo.ROI_ItemDetails ID
        INNER JOIN dbo.CostCenterInfo CC ON ID.ItemCostCentreID = CC.CostCenterId
        WHERE ID.ITId = @IngredientId;

        SELECT TOP(1) @IngPurchaseRate = ISNULL(PD.UnitRate,0)
        FROM dbo.ROI_PurchaseDetails PD
        INNER JOIN dbo.ROI_PurchaseMain rpm ON rpm.PurchaseMainID = PD.PurchaseMainID
        WHERE PD.ItemID = @IngredientId AND PD.StoreID = @StoreId
        ORDER BY rpm.PbDate DESC;

        SET @IngSalesQuantity = @qty * @IngQuantity;
        SET @IngSalesValue = @qty * @IngPurchaseRate;

        -- Insert into sales stock transaction
        INSERT INTO dbo.ROI_SalesStockTransaction 
            (SalesDetailId, StoreId, ItemId, SalesQty, SalesUnit, TransactionDate)
        VALUES (@sDetailID, @StoreId, @IngredientId, @IngSalesQuantity, @SUnitName, GETDATE());

        DECLARE @SalesTranId INT = SCOPE_IDENTITY();

        -- Compute rate for stock transaction
        SET @ComputedRate = CASE 
                               WHEN @IngSalesQuantity <> 0 THEN ROUND(@IngSalesValue / @IngSalesQuantity,2)
                               ELSE 0 
                            END;

        -- Insert into stock master with rate
        INSERT INTO dbo.ROI_StockTransactionMaster
            (SalesTranId, StoreId, ItemId, ItemBalance, ItemBalUnitId, ItemValue, Rate, TransactionDate)
        VALUES
            (@SalesTranId, @StoreId, @IngredientId, @ItemBalance - @IngSalesQuantity, @SUnitName,
             @ItemValue - @IngSalesValue, @ComputedRate, GETDATE());

        -- Delete processed ingredient
        DELETE FROM #tempItem WHERE Id = @Id;
    END

    DROP TABLE IF EXISTS #tempItem;
END;

GO
