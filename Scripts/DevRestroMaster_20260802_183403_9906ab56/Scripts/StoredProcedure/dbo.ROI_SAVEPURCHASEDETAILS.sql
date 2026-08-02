SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- DROP PROCEDURE [dbo].[ROI_SAVEPURCHASEDETAILS]
CREATE PROCEDURE [dbo].[ROI_SAVEPURCHASEDETAILS]
    @PurchaseDetailsID INT ,
    @PurchaseMainID INT ,
    @ItemID INT ,
    @UsedUnitID INT ,
    @Quentity DECIMAL (18, 2) ,
    @QuentityText NVARCHAR (200) ,
    @UnitRate DECIMAL (18, 2) ,
    @Total DECIMAL (18, 2) ,
    @Conversion INT ,
    @RecqDetailId INT ,
    @VendorPurchaseId INT ,
    @IsVat BIT ,
    @Discount DECIMAL (10, 2)
AS
    BEGIN
        DECLARE @StoreId INT;
        SELECT @StoreId = CC.StoreId
        FROM   dbo.ROI_ItemDetails ID
               INNER JOIN dbo.CostCenterInfo CC ON ID.ItemCostCentreID = CC.CostCenterId
        WHERE  ID.ITId = @ItemID;

        INSERT INTO dbo.ROI_PurchaseDetails ( PurchaseMainID ,
                                              ItemID ,
                                              StoreID ,
                                              UsedUnitID ,
                                              Quentity ,
                                              QuentityText ,
                                              UnitRate ,
                                              Total ,
                                              Conversion ,
                                              RecqDetailId ,
                                              VendorPurchaseId ,
                                              IsVat ,
                                              Discount )
        VALUES ( @PurchaseMainID, @ItemID, @StoreId, @UsedUnitID, @Quentity, @QuentityText, @UnitRate, @Total ,
                 @Conversion , @RecqDetailId, @VendorPurchaseId, @IsVat, @Discount );

        SELECT SCOPE_IDENTITY () AS INT;
    END;



GO
