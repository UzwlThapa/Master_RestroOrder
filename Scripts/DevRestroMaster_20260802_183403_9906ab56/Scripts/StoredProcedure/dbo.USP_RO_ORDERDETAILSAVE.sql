SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_ORDERDETAILSAVE]
    @OrderDetailID INT,
    @OrderMasterID INT,
    @RO_ItemID INT,
    @Rate DECIMAL(18, 2),
    @IsCancelled BIT,
    @Quantity FLOAT,
    @Amount DECIMAL(18, 2),
    @Note VARCHAR(256) = NULL,
    @ExtraCharge DECIMAL(18, 2),
    @IsHomeDelivery BIT,
    @HomeDeliveyNumber INT,
    @SeatNo INT,
    @Status NVARCHAR(50),
    @IsRunningOrder INT,
    @IsCombo BIT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Rate1 DECIMAL(18, 2);
    DECLARE @Amount1 DECIMAL(18, 2);
    DECLARE @CostCenterID INT;
    DECLARE @val INT;

    IF @IsCombo = 0
    BEGIN
        SELECT @CostCenterID = ItemCostCentreID
        FROM ROI_ItemDetails
        WHERE ITId = @RO_ItemID;

        SELECT @Rate1 = SRate
        FROM ROI_ItemRate
        WHERE ItemID = @RO_ItemID;
    END;
    ELSE
    BEGIN
        SELECT @Rate1 = SalesPrice,
               @CostCenterID = CostCenterID
        FROM RO_Combo
        WHERE ComboID = @RO_ItemID;
    END;

    SET @Amount1 = @Rate1 * @Quantity;

    INSERT INTO dbo.RO_Order_Detail
    (
        OrderMasterId,
        ROI_ItemId,
        Rate,
        Date,
        IsCancelled,
        Quantity,
        Amount,
        Note,
        ExtraCharge,
        IsHomeDelivery,
        HomeDeliveyNumber,
        SeatNo,
        CostCenterId,
        IsRunningOrder,
        IsCombo
    )
    VALUES
    (@OrderMasterID, @RO_ItemID, @Rate1, GETDATE(), @IsCancelled, @Quantity, @Amount1, @Note, @ExtraCharge,
     @IsHomeDelivery, @HomeDeliveyNumber, @SeatNo, @CostCenterID, @IsRunningOrder, @IsCombo);

    SET @val = SCOPE_IDENTITY();

    INSERT INTO dbo.RO_OrderItemStatus
    (
        OrderDetailID,
        StatusID,
        TimeStamp
    )
    VALUES
    (   @val,
        (
            SELECT StatusID FROM dbo.RO_ItemStatus WHERE ItemStatus = @Status
        ), GETDATE());

    SELECT @val;
END;

GO
