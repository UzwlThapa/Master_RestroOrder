SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_saveExtraSales]
    @salesMasterId INT ,
    @salesDetailId INT ,
    @ItemId INT ,
    @ExtraItemId INT ,
    @ExtraItem NVARCHAR (256) ,
    @qty INT ,
    @rate DECIMAL (10, 2) ,
    @Amount DECIMAL (10, 2)
AS
    BEGIN
        INSERT INTO [dbo].[RO_SalesDetailExtra] ( [SalesMasterId] ,
                                                  [SalesDetailsId] ,
                                                  [ItemId] ,
                                                  [ExtraItemId] ,
                                                  [ExtraItem] ,
                                                  [Quantity] ,
                                                  [Rate] ,
                                                  [Amount] ,
                                                  HSCode )
                    SELECT @salesMasterId ,
                           @salesDetailId ,
                           @ItemId ,
                           @ExtraItemId ,
                           @ExtraItem ,
                           @qty ,
                           @rate ,
                           @Amount ,
                           ISNULL (rid.HSCode, '')
                    FROM   dbo.ROI_ITEMMain AS rid
                    WHERE  rid.ITId = @ItemId;

        BEGIN
            DECLARE @StoreId INT ,
                    @Ingredient INT;

            SELECT @StoreId = ccif.StoreId
            FROM   dbo.ROI_ItemDetails ids
                   JOIN dbo.CostCenterInfo ccif ON ccif.CostCenterId = ids.ItemCostCentreID
            WHERE  ids.ITId = @ItemId;

            UPDATE dbo.ROI_ITEMBal
            SET    CLBal = ( ib.CLBal - ( ri.Quantity * @qty ))
            FROM   dbo.ROI_ITEMBal ib
                   JOIN dbo.RO_ExtraIngredient ri ON ib.ITId = ri.IngredientID
                   JOIN dbo.ROI_ItemDetails ids ON ids.ITId = ib.ITId
                   JOIN dbo.CostCenterInfo ccif ON ccif.CostCenterId = ids.ItemCostCentreID
            WHERE  ri.ExtraItemID = @ExtraItemId
            AND    ib.STId = ccif.StoreId;

        END;
    END;

GO
