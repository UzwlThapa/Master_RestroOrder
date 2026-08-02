SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC [dbo].[usp_ro_UpdateSalesPayMode]
CREATE PROCEDURE [dbo].[usp_ro_UpdateSalesPayMode]
    @salesMasterId INT,
    @SPMID INT,
    @ChequeNo NVARCHAR(MAX),
    @TransactionNo NVARCHAR(MAX),
    @ProviderID INT,
    @CusID INT,
    @Customer NVARCHAR(MAX),
    @Address NVARCHAR(MAX),
    @PAN NVARCHAR(MAX),
    @PayAmount DECIMAL(18, 2),
    @TenderAmount DECIMAL(18, 2),
    @ReturnAmount DECIMAL(18, 2),
    @Remarks NVARCHAR(MAX),
    @ReturnPayment DECIMAL(18, 2) = 0
AS
BEGIN


    INSERT INTO dbo.RO_SalesPaymentMode
    (
        salesMasterId,
        PaymentModeID,
        ChequeNo,
        TransactionNo,
        ProviderID,
        CusID,
        Customer,
        Address,
        PAN,
        PayAmount,
        Remarks,
        ReturnPayment
    )
    VALUES
    (@salesMasterId, @SPMID, @ChequeNo, @TransactionNo, @ProviderID, @CusID, @Customer, @Address, @PAN, @PayAmount,
     @Remarks, @ReturnPayment);

    IF (@SPMID = 1)
    BEGIN
        UPDATE dbo.RO_SalesMaster
        SET IsUpdated = 1,
            UpdatedOn = GETDATE(),
            TenderAmount = @TenderAmount,
            ReturnAmount = @ReturnAmount
        WHERE salesMasterId = @salesMasterId;
    END;
    ELSE
    BEGIN
        UPDATE dbo.RO_SalesMaster
        SET IsUpdated = 1,
            UpdatedOn = GETDATE()
        WHERE salesMasterId = @salesMasterId;
    END;

    BEGIN
        DECLARE @tableId NVARCHAR(50),
                @ordermasterid INT;

        SELECT @tableId = sm.TableId,
               @ordermasterid = sm.OrderMasterId
        FROM dbo.RO_SalesMaster sm
        WHERE sm.salesMasterId = @salesMasterId;

        IF (
           (
               SELECT COUNT(1)
               FROM dbo.RO_Order_Detail od
               WHERE od.OrderMasterId = @ordermasterid
                     AND ISNULL(od.BillPaid, 0) = 0
                     AND ISNULL(od.IsCancelled, 0) = 0
           ) = 0
           AND
           (
               SELECT COUNT(1)
               FROM dbo.RO_SalesMaster
               WHERE OrderMasterId = @ordermasterid
                     AND ISNULL(IsUpdated, 0) = 0
                     AND ISNULL(IsArchived, 0) = 0
           ) = 0
           )
        BEGIN
            UPDATE dbo.RO_MergeTable
            SET MergeTableList = 0
            WHERE MergeTableList = @tableId;


            IF
            (
                SELECT IsTable FROM dbo.RO_restroTable WHERE restrotableId = @tableId
            ) = 1
            BEGIN
                UPDATE dbo.RO_restroTable
                SET restrotablesStatusID = 6
                WHERE restrotableId = @tableId;

            END;
            ELSE
            BEGIN
                IF (EXISTS
                (
                    SELECT 1
                    FROM dbo.Ro_RoomBookings rb
                        INNER JOIN dbo.RO_OrderMasters om
                            ON rb.OrderMasterId = om.OrderMasterID
                        LEFT JOIN dbo.RO_SalesMaster sm
                            ON om.OrderMasterID = sm.OrderMasterId
                               AND sm.IsUpdated = 0
                    WHERE rb.TableId = @tableId
                          AND om.BillPaid = 0
                          AND rb.IsCancelled = 0
                          AND (GETDATE()
                          BETWEEN rb.BookedFrom AND rb.BookedTo
                              )
                )
                   )
                BEGIN
                    UPDATE dbo.RO_restroTable
                    SET restrotablesStatusID = 7
                    WHERE restrotableId = @tableId;
                END;
                ELSE
                BEGIN
                    UPDATE dbo.RO_restroTable
                    SET restrotablesStatusID = 6
                    WHERE restrotableId = @tableId;
                END;

            --select * from RO_SalesMaster
            END;
        END;
    END;

END;



GO
