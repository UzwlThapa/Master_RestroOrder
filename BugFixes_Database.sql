-- ============================================================
-- PROJECT: Master_RestroOrder Bug Fixes
-- DATE: 2026-03-25
-- DESCRIPTION: Fixes for Bill Splitting, Table Occupation, 
--              and Incorrect Split Flagging.
-- ============================================================

PRINT 'Applying fix for [USP_ROI_SaveSplittedData]...';
GO
ALTER PROCEDURE [dbo].[USP_ROI_SaveSplittedData]
    @OrderDetailsID int,
    @OrderMasterID int, 
    @SeatNo int,
    @restrotableId int
AS
BEGIN
    SET NOCOUNT ON;
    -- Correctly update only the intended record within the specific Order context
    UPDATE RO_Order_Detail 
    SET SeatNo = @SeatNo 
    WHERE OrderDetailsID = @OrderDetailsID 
      AND OrderMasterId = @OrderMasterID;

    -- Ensure the Master record is flagged as split
    UPDATE RO_OrderMasters 
    SET IsSplit = 1 
    WHERE OrderMasterID = @OrderMasterID;
END;
GO

PRINT 'Applying fix for [usp_ro_updateOrderMaster]...';
GO
ALTER PROCEDURE [dbo].[usp_ro_updateOrderMaster] 
    @OrderMasterId INT,
    @termAmount DECIMAL(18, 2),
    @NetAmount DECIMAL(18, 2),
    @seatNo INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- 1. Mark the specific items as paid
    UPDATE RO_Order_Detail
    SET BillPaid = 1
    WHERE IsCancelled = 0
      AND SeatNo = @seatNo
      AND OrderMasterId = @OrderMasterId;

    -- 2. Update Item Status to ''Served'' (StatusID 3)
    UPDATE RO_OrderItemStatus
    SET StatusID = 3
    WHERE OrderDetailID IN (
        SELECT OrderDetailsID FROM RO_Order_Detail 
        WHERE OrderMasterId = @OrderMasterId AND SeatNo = @seatNo
    );

    -- 3. Check if any items remain unpaid for this Master Order
    DECLARE @remaning INT;
    SELECT @remaning = Count(orderdetailsid)
    FROM dbo.ro_order_detail
    WHERE ordermasterid = @OrderMasterId
      AND Isnull(billpaid, 0) = 0
      AND IsCancelled = 0;

    -- 4. If no items remain, close the order and release the table
    IF (@remaning = 0)
    BEGIN
        UPDATE dbo.ro_ordermasters
        SET termamount = @termAmount,
            netamount = @NetAmount,
            billpaid = 1,
            isprinted = 0
        WHERE ordermasterid = @OrderMasterId;

        -- RELEASE TABLE: Set status back to Available (StatusID 6)
        UPDATE RO_restroTable 
        SET restrotablesStatusID = 6 
        WHERE restrotableId = (SELECT TOP 1 TableId FROM RO_OrderMasters WHERE OrderMasterID = @OrderMasterId);
        
        PRINT ''Table released successfully.'';
    END
END;
GO

PRINT 'Applying fix for [usp_ro_shiftItems]...';
GO
-- Note: Simplified update to address the hardcoded IsSplit flag
-- Locate the specific INSERT INTO RO_OrderMasters block in your script if you need full replacement.
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

ALTER PROCEDURE [dbo].[usp_ro_shiftItems]
    @fromTable INT,
    @fromSplitNo INT,
    @toTable INT,
    @toSplitNo INT,
    @shiftedBy NVARCHAR(MAX),
    @ItemId INT,
    @Quantity FLOAT,
    @IsCombo BIT
AS
BEGIN
    DECLARE @orderdetail INT,
            @qnty INT,
            @orderMasterId INT,
            @oldOrderMasterId INT,
            @istable BIT;
    DECLARE @continue BIT = 0;

    SET @oldOrderMasterId =
    (
        SELECT MAX(OrderMasterID)
        FROM dbo.RO_OrderMasters
        WHERE TableId = @fromTable
              AND ISNULL(BillPaid, 0) = 0
              AND ISNULL(IsCancelled, 0) = 0
    );


    SET @orderMasterId =
    (
        SELECT MAX(OrderMasterID)
        FROM dbo.RO_OrderMasters
        WHERE TableId = @toTable
              AND ISNULL(BillPaid, 0) = 0
              AND ISNULL(IsCancelled, 0) = 0
    );



    INSERT INTO dbo.RO_ItemShiftLog
    (
        dbo.FromTable,
        FromSplitNo,
        ToTable,
        ToSplitNo,
        ShiftedBy,
        ItemId,
        Quantity,
        IsCombo,
        ShiftedOn,
        OrderMasterId
    )
    VALUES
    (@fromTable, @fromSplitNo, @toTable, @toSplitNo, @shiftedBy, @ItemId, @Quantity, @IsCombo, GETDATE(),
     @oldOrderMasterId);

    IF (@orderMasterId IS NULL)
    BEGIN
        INSERT INTO dbo.RO_OrderMasters
        (
            TableId,
            BillNo,
            Date,
            IsCancelled,
            BasicAmount,
            TermAmount,
            NetAmount,
            UserName,
            Remarks,
            IsSplit,
            GuestNo,
            BillPaid,
            RoomId,
            OID,
            OrderStatus,
            IsPrinted
        )
        VALUES
        (   @toTable, 0, GETDATE(), 0, 0, 0, 0, @shiftedBy, '', CASE
                                                                    WHEN @toSplitNo > 1 THEN
                                                                        1
                                                                    ELSE
                                                                        0
                                                                END, @toSplitNo, 0,
            (
                SELECT restroRoomId FROM dbo.RO_restroTable WHERE restrotableId = @toTable
            ), 0, 1, 0);

        SET @orderMasterId =
        (
            SELECT MAX(OrderMasterID)
            FROM dbo.RO_OrderMasters
            WHERE TableId = @toTable
                  AND ISNULL(BillPaid, 0) = 0
                  AND ISNULL(IsCancelled, 0) = 0
        );

        INSERT INTO dbo.RO_OrderToken
        (
            OrderMasterID,
            CustomerID,
            CustomerName,
            Phone,
            TokenNo,
            AddedBy,
            Address
        )
        VALUES
        (@orderMasterId, 0, '', '', 0, GETDATE(), '');
    END;

    WHILE (@continue = 0)
    BEGIN
        SELECT TOP (1)
               @orderdetail = OrderDetailsID,
               @qnty = Quantity
        FROM dbo.RO_Order_Detail od
            INNER JOIN dbo.RO_OrderMasters om
                ON om.OrderMasterID = od.OrderMasterId
        WHERE od.ROI_ItemId = @ItemId
              AND od.IsCombo = @IsCombo
              AND od.IsCancelled = 0
              AND od.SeatNo = @fromSplitNo
              AND om.OrderMasterID = @oldOrderMasterId
        ORDER BY OrderDetailsID DESC;

        IF (@qnty < @Quantity OR @qnty = @Quantity)
        BEGIN
            UPDATE dbo.RO_Order_Detail
            SET OrderMasterId = @orderMasterId,
                SeatNo = @toSplitNo
            WHERE OrderDetailsID = @orderdetail
                  AND SeatNo = @fromSplitNo;


            DECLARE @GuestNo INT;
            SELECT @GuestNo = MAX(SeatNo)
            FROM dbo.RO_Order_Detail
            WHERE OrderMasterId = @orderMasterId;

            UPDATE dbo.RO_OrderMasters
            SET GuestNo = @GuestNo
            WHERE OrderMasterID = @orderMasterId;

            SET @Quantity = (@Quantity - @qnty);

            IF (@Quantity > 0)
                SET @continue = 0;
            ELSE
                SET @continue = 1;
        END;
        ELSE
        BEGIN
            UPDATE dbo.RO_Order_Detail
            SET Quantity = (Quantity - @Quantity)
            WHERE OrderDetailsID = @orderdetail
                  AND SeatNo = @fromSplitNo;

            INSERT INTO dbo.RO_Order_Detail
            (
                OrderMasterId,
                ROI_ItemId,
                Rate,
                Date,
                IsCancelled,
                Quantity,
                Amount,
                SeatNo,
                CostCenterId,
                IsRunningOrder,
                IsCombo
            )
            SELECT @orderMasterId,
                   @ItemId,
                   SRate,
                   GETDATE(),
                   0,
                   @Quantity,
                   SRate * @Quantity,
                   @toSplitNo,
                   CASE
                       WHEN @IsCombo = 0 THEN
                       (
                           SELECT ItemCostCentreID FROM dbo.ROI_ItemDetails WHERE ITId = @ItemId
                       )
                       ELSE
                   (
                       SELECT CostCenterID FROM dbo.RO_Combo WHERE ComboID = @ItemId
                   )
                   END,
                   0,
                   @IsCombo
            FROM dbo.ROI_ItemRate
            WHERE ItemID = @ItemId;

            INSERT INTO dbo.RO_OrderItemStatus
            (
                OrderDetailID,
                StatusID,
                TimeStamp
            )
            VALUES
            (
                (
                    SELECT MAX(OrderDetailsID)
                    FROM dbo.RO_Order_Detail
                    WHERE OrderMasterId = @orderMasterId
                          AND ROI_ItemId = @ItemId
                          AND IsCombo = @IsCombo
                ), 1, GETDATE());

            SET @continue = 1;
        END;
    END;



    UPDATE dbo.RO_restroTable
    SET restrotablesStatusID = 6
    WHERE restrotableId = @toTable;


    UPDATE dbo.RO_restroTable
    SET restrotablesStatusID = 6
    WHERE restrotableId = @fromTable;

    SET @istable =
    (
        SELECT rt.IsTable
        FROM dbo.Ro_RoomBookings rb
            INNER JOIN dbo.RO_OrderMasters om
                ON om.OrderMasterID = rb.OrderMasterId
            INNER JOIN dbo.RO_restroTable rt
                ON rt.restrotableId = rb.TableId
        WHERE om.OrderMasterID = @oldOrderMasterId
    );

    IF (
       (
           SELECT COUNT(*)
           FROM dbo.RO_Order_Detail
           WHERE OrderMasterId = @oldOrderMasterId
                 AND IsCancelled = 0
       ) = 0
       )
    BEGIN

        /* Update basicAmount in Order Master */
        DECLARE @basicAmount DECIMAL(18, 2);
        SELECT @basicAmount = SUM(ISNULL(od.Rate, 0) * ISNULL(od.Quantity, 0))
        FROM dbo.RO_OrderMasters om
            INNER JOIN dbo.RO_Order_Detail od
                ON om.OrderMasterID = od.OrderMasterId
                   AND od.IsArchived = 0
                   AND od.IsCancelled = 0
                   AND om.OrderMasterID = @oldOrderMasterId
        GROUP BY om.OrderMasterID;

        UPDATE dbo.RO_OrderMasters
        SET BasicAmount = @basicAmount
        WHERE OrderMasterID = @oldOrderMasterId;

        SELECT @basicAmount = SUM(ISNULL(od.Rate, 0) * ISNULL(od.Quantity, 0))
        FROM dbo.RO_OrderMasters om
            INNER JOIN dbo.RO_Order_Detail od
                ON om.OrderMasterID = od.OrderMasterId
                   AND od.IsArchived = 0
                   AND od.IsCancelled = 0
                   AND om.OrderMasterID = @orderMasterId
        GROUP BY om.OrderMasterID;

        UPDATE dbo.RO_OrderMasters
        SET BasicAmount = @basicAmount
        WHERE OrderMasterID = @orderMasterId;

        /* End of Update basicAmount in Order Master */


        UPDATE om
        SET om.IsCancelled = 1
        FROM dbo.RO_OrderMasters AS om
            INNER JOIN dbo.RO_restroTable AS rt
                ON rt.restrotableId = om.TableId
        WHERE om.OrderMasterID = @oldOrderMasterId
              AND rt.IsTable = 1;


        UPDATE dbo.RO_restroTable
        SET restrotablesStatusID = 6
        WHERE restrotableId = @fromTable
              AND IsTable = 1;

        UPDATE dbo.RO_MergeTable
        SET MergeTableList = 0
        WHERE MergeTableList = @fromTable;

    END;

GO

PRINT ''Database bug fixes applied successfully.'';
