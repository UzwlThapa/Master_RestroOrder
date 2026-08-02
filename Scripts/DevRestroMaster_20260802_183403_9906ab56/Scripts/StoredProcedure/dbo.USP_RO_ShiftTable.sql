SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_ShiftTable]
    @FromOrderMasterId INT,
    @ToTableID INT,
    @fromSeatNo INT,
    @toSeatNo INT,
    @shiftedBy VARCHAR(200)
AS
BEGIN
    DECLARE @isTable BIT,
            @isShiftFromTable BIT,
            @roomid INT,
            @prevGuestNo INT,
            @ToOrderMasterId INT,
            @fromTable INT,
            @srcBasicAmount DECIMAL(18, 2),
            @destBasicAmount DECIMAL(18, 2);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Get Source Info
        SELECT @fromTable = TableId
        FROM RO_OrderMasters
        WHERE OrderMasterID = @FromOrderMasterId;
        IF @fromTable IS NULL
        BEGIN
            RAISERROR('Source Order not found.', 16, 1);
            RETURN;
        END;

        SELECT @isShiftFromTable = IsTable
        FROM dbo.RO_restroTable
        WHERE restrotableId = @fromTable;

        -- 2. Find/Create Destination Order
        SELECT @isTable = rt.IsTable,
               @roomid = rt.restroRoomId,
               @prevGuestNo = ISNULL(om.GuestNo, 1)
        FROM dbo.RO_restroTable rt
            LEFT JOIN dbo.RO_OrderMasters om
                ON om.TableId = rt.restrotableId
                   AND om.BillPaid = 0
                   AND om.IsCancelled = 0
        WHERE rt.restrotableId = @ToTableID;

        -- Validate RoomId
        IF @roomid IS NULL
        BEGIN
            RAISERROR('Destination table has no valid RoomId.', 16, 1);
            RETURN;
        END;

        SET @ToOrderMasterId =
        (
            SELECT MAX(OrderMasterID)
            FROM RO_OrderMasters
            WHERE TableId = @ToTableID
                  AND BillPaid = 0
                  AND IsCancelled = 0
        );

        -- 3. Execute Shift Logic
        IF (@ToOrderMasterId IS NULL AND @fromSeatNo = 0 AND @isShiftFromTable = 1)
        BEGIN
            -- Move entire order to new table
            UPDATE RO_OrderMasters
            SET TableId = @ToTableID,
                RoomId = @roomid
            WHERE OrderMasterID = @FromOrderMasterId;
            SET @ToOrderMasterId = @FromOrderMasterId;
        END;
        ELSE
        BEGIN
            -- Create new order or merge logic
            IF @ToOrderMasterId IS NULL
            BEGIN
                INSERT INTO RO_OrderMasters
                (
                    RoomId,
                    TableId,
                    Date,
                    UserName,
                    IsSplit,
                    GuestNo,
                    OrderStatus,
                    BillPaid,
                    IsCancelled,
                    BasicAmount
                )
                VALUES
                (@roomid, @ToTableID, GETDATE(), @shiftedBy, 0, @prevGuestNo, 1, 0, 0, 0);

                SET @ToOrderMasterId = SCOPE_IDENTITY();

                INSERT INTO RO_OrderToken
                (
                    OrderMasterID,
                    CustomerID,
                    AddedBy
                )
                VALUES
                (@ToOrderMasterId, 0, GETDATE());
            END;

            -- Move Details
            IF @fromSeatNo > 0
                UPDATE RO_Order_Detail
                SET OrderMasterId = @ToOrderMasterId,
                    SeatNo = ISNULL(NULLIF(@toSeatNo, 0), SeatNo)
                WHERE OrderMasterId = @FromOrderMasterId
                      AND SeatNo = @fromSeatNo;
            ELSE
                UPDATE RO_Order_Detail
                SET OrderMasterId = @ToOrderMasterId
                WHERE OrderMasterId = @FromOrderMasterId;
        END;

        -- 4. Log the Shift
        INSERT INTO RO_ItemShiftLog
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
        SELECT @fromTable,
               od.SeatNo,
               @ToTableID,
               ISNULL(NULLIF(@toSeatNo, 0), od.SeatNo),
               @shiftedBy,
               od.ROI_ItemId,
               od.Quantity,
               od.IsCombo,
               GETDATE(),
               @FromOrderMasterId,
               @ToOrderMasterId,
               'Table'
        FROM RO_Order_Detail od
        WHERE od.OrderMasterId = @FromOrderMasterId;

        -- 5. Recalculate Totals
        SELECT @srcBasicAmount = SUM(Rate * Quantity)
        FROM RO_Order_Detail
        WHERE OrderMasterId = @FromOrderMasterId
              AND IsCancelled = 0;
        UPDATE RO_OrderMasters
        SET BasicAmount = ISNULL(@srcBasicAmount, 0)
        WHERE OrderMasterID = @FromOrderMasterId;

        SELECT @destBasicAmount = SUM(Rate * Quantity)
        FROM RO_Order_Detail
        WHERE OrderMasterId = @ToOrderMasterId
              AND IsCancelled = 0;
        UPDATE RO_OrderMasters
        SET BasicAmount = ISNULL(@destBasicAmount, 0)
        WHERE OrderMasterID = @ToOrderMasterId;

        -- 6. Close Source if Empty
        IF
        (
            SELECT COUNT(*)
            FROM RO_Order_Detail
            WHERE OrderMasterId = @FromOrderMasterId
                  AND IsCancelled = 0
        ) = 0
        BEGIN
            UPDATE RO_OrderMasters
            SET IsCancelled = 1
            WHERE OrderMasterID = @FromOrderMasterId;
        END;

        -- 7. Update Table Statuses
        UPDATE RO_restroTable
        SET restrotablesStatusID = 6
        WHERE restrotableId IN ( @fromTable, @ToTableID );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        RAISERROR(50000, 16, 1) WITH SETERROR;
    END CATCH;
END;

GO
