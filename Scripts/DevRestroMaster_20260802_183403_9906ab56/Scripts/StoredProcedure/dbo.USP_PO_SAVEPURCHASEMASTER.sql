SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_PO_SAVEPURCHASEMASTER]
(
    @OrderMasterID INT,
    @TableId NVARCHAR(50),
    @BillNo NVARCHAR(128),
    @Date DATETIME,
    @IsCancelled BIT,
    @BasicAmount DECIMAL,
    @TermAmount DECIMAL(18, 2),
    @NetAmount DECIMAL(18, 2),
    @UserName NVARCHAR(128),
    @Remarks NVARCHAR(512),
    @IsSplit BIT,
    @GuestNo INT,
    @BillPaid INT,
    @RoomId INT,
    @OID INT,
    @OrderStatus INT,
    @OrderTypeID INT
)
AS
BEGIN
    SET NOCOUNT ON; -- prevents extra rowcount messages

    DECLARE @val INT;
    DECLARE @OrderNo INT = 0;

    IF (@OrderTypeID = 0)
        SET @OrderTypeID = 1;

    -- Find an existing open order for this table
    SET @val =
    (
        SELECT MAX(OrderMasterID)
        FROM RO_OrderMasters
            LEFT JOIN RO_restroTable
                ON restrotableId = TableId
        WHERE TableId = @TableId
              AND TableId <> 0
              AND ISNULL(BillPaid, 0) = 0
              AND ISNULL(IsCancelled, 0) = 0
              AND IsTable = 1
    );

    IF (@OrderMasterID = 0 AND ISNULL(@val, 0) = 0)
    BEGIN
        -- Generate a new OrderNo with a lock to prevent duplicates
        SET @OrderNo = ISNULL(
                       (
                           SELECT TOP 1
                                  OrderNo
                           FROM RO_OrderMasters WITH (UPDLOCK)
                           WHERE CAST([Date] AS DATE) = CAST(GETDATE() AS DATE)
                           ORDER BY OrderNo DESC
                       ),
                       0
                             ) + 1;

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
            IsPrinted,
            OrderNo,
            OrderTypeID
        )
        VALUES
        (@TableId, @BillNo, @Date, @IsCancelled, @BasicAmount, @TermAmount, @NetAmount, @UserName, @Remarks, @IsSplit,
         @GuestNo, @BillPaid, @RoomId, @OID, 0, 0, @OrderNo, @OrderTypeID);

        SELECT CAST(SCOPE_IDENTITY() AS INT);
    END;
    ELSE
    BEGIN
        -- If no explicit OrderMasterID, reuse the existing open one
        IF (@OrderMasterID = 0)
            SET @OrderMasterID = @val;

        -- Retrieve the existing OrderNo
        SET @OrderNo =
        (
            SELECT ISNULL(OrderNo, 0)
            FROM dbo.RO_OrderMasters
            WHERE OrderMasterID = @OrderMasterID
        );

        UPDATE dbo.RO_OrderMasters
        SET TableId = @TableId,
            BillNo = @BillNo,
            IsCancelled = @IsCancelled,
            BasicAmount = @BasicAmount,
            TermAmount = @TermAmount,
            NetAmount = @NetAmount,
            UserName = @UserName,
            Remarks = @Remarks,
            IsSplit = @IsSplit,
            GuestNo = @GuestNo,
            BillPaid = @BillPaid,
            RoomId = @RoomId,
            OID = @OID,
            OrderStatus = @OrderStatus, -- FIX: was "@OrderStatus = 1"
            OrderNo = @OrderNo
        WHERE OrderMasterID = @OrderMasterID;

        SELECT CAST(@OrderMasterID AS INT);
    END;

    -- Update table status
    IF (@IsCancelled = 0)
    BEGIN
        UPDATE dbo.RO_restroTable
        SET restrotablesStatusID = 7
        WHERE restrotableId = @TableId;
    END;
    ELSE
    BEGIN
        UPDATE dbo.RO_restroTable
        SET restrotablesStatusID = 6
        WHERE restrotableId = @TableId;

        UPDATE dbo.RO_MergeTable
        SET MergeTableList = 0
        WHERE MergeTableList = @TableId;

        UPDATE dbo.RO_OrderMasters
        SET CancelBy = @UserName,
            CancelDate = GETDATE(),
            CancelReason = @Remarks
        WHERE OrderMasterID = @OrderMasterID;
    END;
END;

GO
