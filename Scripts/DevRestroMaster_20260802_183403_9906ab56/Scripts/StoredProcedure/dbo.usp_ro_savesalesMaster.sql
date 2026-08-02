SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_savesalesMaster]
    @billNo VARCHAR(128),
    @BillDate DATETIME,
    @RoomId INT,
    @TableId INT,
    @NepaliInvoiceDate NVARCHAR(MAX),
    @BasicAmount DECIMAL(18, 2),
    @TermAmount DECIMAL(18, 2),
    @NetAmount DECIMAL(18, 2),
    @OrderMasterId INT,
    @WaiterId VARCHAR(128),
    @totaldiscount DECIMAL(18, 2),
    @sumKot DECIMAL(18, 2),
    @sumBev DECIMAL(18, 2),
    @SPMID INT,
    @ProviderID INT,
    @CusName VARCHAR(256) = NULL,
    @PhoneNumber VARCHAR(20) = NULL,
    @CusID INT = NULL,
    @AddedBy NVARCHAR(256),
    @IsSplit INT,
    @SeatNo INT,
    @Address NVARCHAR(250) = NULL,
    @PAN NVARCHAR(250) = NULL,
    @ChequNO NVARCHAR(250),
    @TransactionNo NVARCHAR(250),
    @RoomRate DECIMAL(18, 2),
    @RoomCharge DECIMAL(18, 2),
    @AdvancePayment DECIMAL(18, 2),
    @BookedDays DECIMAL(18, 2),
    @sumBakery DECIMAL(18, 2),
    @sumPizza DECIMAL(18, 2),
    @DeliveryCharge DECIMAL(18, 2),
    @DeliveredBy NVARCHAR(250)
AS
BEGIN
    DECLARE @InvoiceNo INT = 0;
    DECLARE @fiscalid INT,
            @firstsalesmasterid INT;
    SELECT @fiscalid = fyId,
           @firstsalesmasterid = FirstSalesMasterID
    FROM dbo.RO_fiscalYear
    WHERE (StartDate <= GETDATE())
          AND (EndDate >= GETDATE());

    SELECT @InvoiceNo = CASE
                            WHEN @billNo = '1234' THEN
                                MAX(InvoiceNo)
                            ELSE
                                MAX(InvoiceNo) + 1
                        END
    FROM
    (
        SELECT MAX(InvoiceNo) InvoiceNo
        FROM dbo.RO_SalesMaster
        WHERE FiscalYearID = @fiscalid
        UNION
        SELECT MAX(InvoiceNo) InvoiceNo
        FROM dbo.RO_CakeSalesMaster
    ) t;
    SET @InvoiceNo = ISNULL(@InvoiceNo, 1);
    IF (@firstsalesmasterid IS NULL)
    BEGIN
        DECLARE @lastsalesmasterid INT;
        SET @lastsalesmasterid = @InvoiceNo - 1;

        UPDATE dbo.RO_fiscalYear
        SET FirstSalesMasterID = @lastsalesmasterid
        WHERE fyId = @fiscalid;
    END;
    INSERT INTO dbo.RO_SalesMaster
    (
        billNo,
        BillDate,
        NepaliInvoiceDate,
        RoomId,
        TableId,
        BasicAmount,
        TermAmount,
        NetAmount,
        OrderMasterId,
        Waiter,
        totaldiscount,
        sumBev,
        sumKot,
        SPMID,
        ProviderID,
        CusName,
        PhoneNumber,
        CusID,
        FiscalYearID,
        AddedOn,
        AddedBy,
        IsSplit,
        SeatNo,
        IsArchived,
        IsUpdated,
        PAN,
        ChequeNO,
        TransactionNo,
        [Address],
        [InvoiceNo],
        RoomRate,
        RoomCharge,
        BookedDays,
        AdvancePayment,
        PrintCount,
        PrintDate,
        sumBakery,
        sumPizza,
        DeliveryCharge,
        DeliveredBy
    )
    VALUES
    (@billNo, GETDATE(), @NepaliInvoiceDate, @RoomId, @TableId, @BasicAmount, @TermAmount, @NetAmount, @OrderMasterId,
     @WaiterId, @totaldiscount, @sumBev, @sumKot, 0, @ProviderID, @CusName, @PhoneNumber, @CusID, @fiscalid, GETDATE(),
     @AddedBy, @IsSplit, @SeatNo, 0, 0, @PAN, @ChequNO, @TransactionNo, @Address, @InvoiceNo, @RoomRate, @RoomCharge,
     @BookedDays, @AdvancePayment, 1, GETDATE(), @sumBakery, @sumPizza, @DeliveryCharge, @DeliveredBy);
    SELECT @@IDENTITY;
END;

GO
