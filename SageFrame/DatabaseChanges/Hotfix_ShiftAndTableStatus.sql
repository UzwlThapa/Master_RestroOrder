USE [ProdCityescapeRO_IRD]
GO

/* =======================================================
   HOTFIX 1: Fix Table Shift Data Loss (usp_ro_shiftItems)
   Issue: Items vanished because ToOrdermasterId was never set 
          and destination insert logic failed for existing orders.
   Fix: Added Transaction, proper SCOPE_IDENTITY(), and error handling.
   ======================================================= */

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ro_shiftItems')
    DROP PROCEDURE [dbo].[usp_ro_shiftItems]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_shiftItems]
    @fromTable INT ,
    @fromSplitNo INT ,
    @toTable INT ,
    @toSplitNo INT ,
    @shiftedBy NVARCHAR (MAX) ,
    @ItemId INT ,
    @Quantity FLOAT ,
    @IsCombo BIT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @orderdetail INT ,
            @qnty FLOAT ,
            @orderMasterId INT ,
            @oldOrderMasterId INT ,
            @istable BIT ,
            @newDetailId INT,
            @destBasicAmount DECIMAL(18,2),
            @srcBasicAmount DECIMAL(18,2),
            @itemRate DECIMAL(18,2),
            @itemCostCenter INT;

    DECLARE @continue BIT = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Identify Source Order
        SET @oldOrderMasterId = ( SELECT MAX (OrderMasterID)
                                  FROM   RO_OrderMasters
                                  WHERE  TableId = @fromTable
                                  AND    ISNULL (BillPaid, 0) = 0
                                  AND    ISNULL (IsCancelled, 0) = 0 );

        IF @oldOrderMasterId IS NULL
        BEGIN
            RAISERROR ('Source order not found or already closed.', 16, 1);
            RETURN;
        END

        -- 2. Identify or Create Destination Order
        SET @orderMasterId = ( SELECT MAX (OrderMasterID)
                               FROM   RO_OrderMasters
                               WHERE  TableId = @toTable
                               AND    ISNULL (BillPaid, 0) = 0
                               AND    ISNULL (IsCancelled, 0) = 0 );

        IF ( @orderMasterId IS NULL )
        BEGIN
            INSERT INTO RO_OrderMasters ( TableId , BillNo , Date , IsCancelled , BasicAmount , TermAmount , NetAmount , UserName , Remarks , IsSplit , GuestNo , BillPaid , RoomId , OID , OrderStatus , IsPrinted )
            VALUES ( @toTable, 0, GETDATE (), 0, 0, 0, 0, @shiftedBy, '', 1, @toSplitNo, 0 ,
                     ( SELECT restroRoomId FROM RO_restroTable WHERE restrotableId = @toTable ), 0, 1, 1, 0 );

            SET @orderMasterId = SCOPE_IDENTITY();

            INSERT INTO RO_OrderToken ( OrderMasterID , CustomerID , CustomerName , Phone , TokenNo , AddedBy , Address )
            VALUES ( @orderMasterId, 0, '', '', 0, GETDATE (), '' );
        END;

        -- 3. Log the Shift (CRITICAL FIX: Populate ToOrdermasterId immediately)
        INSERT INTO RO_ItemShiftLog ( FromTable , FromSplitNo , ToTable , ToSplitNo , ShiftedBy , ItemId , Quantity , IsCombo , ShiftedOn , OrderMasterId , ToOrdermasterId, ShiftType )
        VALUES ( @fromTable, @fromSplitNo, @toTable, @toSplitNo, @shiftedBy, @ItemId, @Quantity, @IsCombo, GETDATE (), @oldOrderMasterId, @orderMasterId, 'Regular' );

        -- 4. Process Item Transfer Loop
        WHILE ( @continue = 0 )
        BEGIN
            SELECT TOP ( 1 ) @orderdetail = OrderDetailsID , @qnty = Quantity
            FROM   RO_Order_Detail
            WHERE  ROI_ItemId = @ItemId
            AND    IsCombo = @IsCombo
            AND    IsCancelled = 0
            AND    SeatNo = @fromSplitNo
            AND    OrderMasterId = @oldOrderMasterId
            ORDER BY OrderDetailsID DESC;

            IF @orderdetail IS NULL 
            BEGIN
                SET @continue = 1;
                CONTINUE;
            END

            IF ( @qnty <= @Quantity )
            BEGIN
                -- Move entire detail row to destination
                UPDATE RO_Order_Detail
                SET    OrderMasterId = @orderMasterId , 
                       SeatNo = @toSplitNo
                WHERE  OrderDetailsID = @orderdetail;

                SET @Quantity = @Quantity - @qnty;
                IF ( @Quantity <= 0 ) SET @continue = 1;
            END
            ELSE
            BEGIN
                -- Split detail row: Reduce source, Insert new in destination
                UPDATE RO_Order_Detail
                SET    Quantity = ( Quantity - @Quantity )
                WHERE  OrderDetailsID = @orderdetail;

                -- Get Rate and CostCenter for the new row
                SELECT @itemRate = Rate, @itemCostCenter = CostCenterId
                FROM RO_Order_Detail WHERE OrderDetailsID = @orderdetail;

                INSERT INTO dbo.RO_Order_Detail ( OrderMasterId , ROI_ItemId , Rate , Date , IsCancelled , Quantity , Amount , SeatNo , CostCenterId , IsRunningOrder , IsCombo )
                VALUES ( @orderMasterId , @ItemId , @itemRate , GETDATE () , 0 , @Quantity , (@itemRate * @Quantity) , @toSplitNo , @itemCostCenter , 0 , @IsCombo );
                
                SET @newDetailId = SCOPE_IDENTITY();

                -- Mark as 'Added' in status log
                INSERT INTO RO_OrderItemStatus ( OrderDetailID , StatusID , TimeStamp )
                VALUES ( @newDetailId , 1, GETDATE());

                SET @continue = 1;
            END
        END;

        -- 5. Recalculate Totals for Source and Destination
        SELECT @srcBasicAmount = SUM(ISNULL(Rate, 0) * ISNULL(Quantity, 0))
        FROM RO_Order_Detail WHERE OrderMasterId = @oldOrderMasterId AND IsCancelled = 0;

        UPDATE RO_OrderMasters SET BasicAmount = ISNULL(@srcBasicAmount, 0) WHERE OrderMasterID = @oldOrderMasterId;

        SELECT @destBasicAmount = SUM(ISNULL(Rate, 0) * ISNULL(Quantity, 0))
        FROM RO_Order_Detail WHERE OrderMasterId = @orderMasterId AND IsCancelled = 0;

        UPDATE RO_OrderMasters SET BasicAmount = ISNULL(@destBasicAmount, 0) WHERE OrderMasterID = @orderMasterId;

        -- 6. Close Source Order if Empty
        IF ( (SELECT COUNT(*) FROM RO_Order_Detail WHERE OrderMasterId = @oldOrderMasterId AND IsCancelled = 0) = 0 )
        BEGIN
            UPDATE om SET om.IsCancelled = 1
            FROM RO_OrderMasters om
            INNER JOIN RO_restroTable rt ON rt.restrotableId = om.TableId
            WHERE om.OrderMasterID = @oldOrderMasterId AND rt.IsTable = 1;
        END

        -- 7. Ensure Table Statuses are 'Occupied' (6)
        UPDATE dbo.RO_restroTable SET restrotablesStatusID = 6 WHERE restrotableId IN (@fromTable, @toTable);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR ('Shift Failed: %s', 16, 1, @ErrMsg);
    END CATCH
END
GO

/* =======================================================
   HOTFIX 2: Auto-Free Tables when Orders are Closed
   Issue: Tables stuck as 'Occupied' after payment/cancel.
   Fix: Trigger checks if ALL orders for a table are closed.
   ======================================================= */

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_UpdateTableStatus_OnOrderClose')
DROP TRIGGER trg_UpdateTableStatus_OnOrderClose
GO

CREATE TRIGGER trg_UpdateTableStatus_OnOrderClose
ON RO_OrderMasters
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF (UPDATE(IsCancelled) OR UPDATE(BillPaid))
    BEGIN
        DECLARE @TableId INT;
        
        -- Find tables where the updated order is closed AND no other active orders exist
        SELECT @TableId = i.TableId
        FROM inserted i
        WHERE (i.IsCancelled = 1 OR i.BillPaid = 1)
        AND NOT EXISTS (
            SELECT 1 FROM RO_OrderMasters om
            WHERE om.TableId = i.TableId
            AND om.IsCancelled = 0
            AND om.BillPaid = 0
        );

        -- Free the table
        IF @TableId IS NOT NULL
        BEGIN
            UPDATE RO_restroTable
            SET restrotablesStatusID = 1 -- 1 = Free
            WHERE restrotableId = @TableId
            AND restrotablesStatusID != 1;
        END
    END
END
GO