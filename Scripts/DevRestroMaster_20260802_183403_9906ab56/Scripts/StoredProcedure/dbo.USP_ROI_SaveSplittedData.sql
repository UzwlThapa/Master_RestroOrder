SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_SaveSplittedData]
    @OrderDetailsID INT,
    @SeatNo INT,
    @restrotableId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SourceMasterID INT;
    DECLARE @NewMasterID INT;
    DECLARE @ExistingMasterID INT;
    DECLARE @RoomId INT;
    DECLARE @OrderTypeID INT;
    DECLARE @UserName NVARCHAR(100);

    -- 1. Get the source order master from the detail row
    SELECT @SourceMasterID = OrderMasterId
    FROM dbo.RO_Order_Detail
    WHERE OrderDetailsID = @OrderDetailsID;

    IF @SourceMasterID IS NULL
    BEGIN
        RAISERROR('OrderDetailsID %d not found.', 16, 1, @OrderDetailsID);
        RETURN;
    END;

    -- 2. Get context from the source master
    SELECT @RoomId = RoomId,
           @OrderTypeID = OrderTypeID,
           @UserName = UserName
    FROM dbo.RO_OrderMasters
    WHERE OrderMasterID = @SourceMasterID;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 3. Check if a split master already exists for the target table
        SELECT @ExistingMasterID = OrderMasterID
        FROM dbo.RO_OrderMasters
        WHERE TableId = @restrotableId
              AND BillPaid = 0
              AND IsCancelled = 0
              AND IsSplit = 1;

        IF @ExistingMasterID IS NULL
        BEGIN
            -- 4. Create a new order master for the split table
            INSERT INTO dbo.RO_OrderMasters
            (
                RoomId,
                TableId,
                Date,
                IsCancelled,
                UserName,
                BillPaid,
                IsSplit,
                GuestNo,
                IsPrinted,
                OrderTypeID
            )
            VALUES
            (   @RoomId, @restrotableId, GETDATE(), 0, @UserName, 0, 1, -- IsSplit = 1
                1, 0, @OrderTypeID);

            SET @NewMasterID = SCOPE_IDENTITY();
        END;
        ELSE
        BEGIN
            SET @NewMasterID = @ExistingMasterID;
        END;

        -- 5. Move the detail row to the new master and new seat
        UPDATE dbo.RO_Order_Detail
        SET SeatNo = @SeatNo,
            OrderMasterId = @NewMasterID
        WHERE OrderDetailsID = @OrderDetailsID;

        -- 6. Mark original master as split
        UPDATE dbo.RO_OrderMasters
        SET IsSplit = 1
        WHERE OrderMasterID = @SourceMasterID;

        -- 7. Log the shift to the item shift log (like your actual data shows)
        INSERT INTO dbo.RO_ItemShiftLog
        (
            FromTable,
            FromSplitNo,
            ToTable,
            ToSplitNo,
            ShiftedBy,
            ItemId,
            Quantity,
            IsCombo,
            ShiftedOn,
            OrderMasterId,
            ToOrdermasterId,
            ShiftType
        )
        SELECT om.TableId,      -- FromTable
               @SeatNo,         -- FromSplitNo
               @restrotableId,  -- ToTable
               @SeatNo,         -- ToSplitNo
               @UserName,       -- ShiftedBy
               od.ROI_ItemId,   -- ItemId
               od.Quantity,     -- Quantity
               od.IsCombo,      -- IsCombo
               GETDATE(),       -- ShiftedOn
               @SourceMasterID, -- OrderMasterId
               @NewMasterID,    -- ToOrdermasterId
               'Split'          -- ShiftType
        FROM dbo.RO_Order_Detail od
            JOIN dbo.RO_OrderMasters om
                ON om.OrderMasterID = @SourceMasterID
        WHERE od.OrderDetailsID = @OrderDetailsID;

        COMMIT TRANSACTION;

        -- Return the new master ID to the caller
        SELECT @NewMasterID AS NewOrderMasterID;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrLine INT = ERROR_LINE();
        RAISERROR('USP_ROI_SaveSplittedData failed at line %d: %s', 16, 1, @ErrLine, @ErrMsg);
    END CATCH;
END;

GO
