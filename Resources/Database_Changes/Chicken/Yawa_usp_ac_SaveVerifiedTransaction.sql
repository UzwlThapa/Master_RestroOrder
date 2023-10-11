SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
ALTER PROC [dbo].[usp_ac_SaveVerifiedTransaction]
    @TransactionID INT ,
    @TransactionDate DATETIME ,
    @VoucherTypeID INT ,
    --,@VoucherNo nvarchar(256)  
    @Descriptions NVARCHAR (256) ,
    @PostedBy NVARCHAR (256) ,
    @postedOn NVARCHAR (256) ,
    @verifiedBy NVARCHAR (256)
AS
    BEGIN
        DECLARE @fiscalYearId INT ,
                @VoucherCountId INT ,
                @verifiedtransactionId INT;

        SELECT @fiscalYearId = fyId
        FROM   RO_fiscalYear
        WHERE  @TransactionDate BETWEEN StartDate AND EndDate;

        DECLARE @SalesMasterID INT;
        SELECT @SalesMasterID = t.SalesMasterId
        FROM   dbo.Ac_TempTransaction t
        WHERE  TransactionID = @TransactionID;

        INSERT INTO Ac_Transaction ( [TransactionDate] ,
                                     [VoucherTypeID] ,
                                     --,[VoucherNo]  
                                     [Descriptions] ,
                                     [PostedBy] ,
                                     [PostedOn] ,
                                     [VerifiedOn] ,
                                     [VerifiedBy] ,
                                     SalesMasterId )
        VALUES ( @TransactionDate, @VoucherTypeID , --,@VoucherNo  
                 @Descriptions, @PostedBy, @postedOn, GETDATE (), @verifiedBy, @SalesMasterID );
        SELECT @verifiedtransactionId = CAST (@@IDENTITY AS INT);
        UPDATE Ac_TempTransaction
        SET    IsVerified = 1
        WHERE  TransactionID = @TransactionID;

        SELECT @VoucherCountId = VoucherCountId
        FROM   Ac_VoucherCount
        WHERE  FiscalYearId = @fiscalYearId
        AND    VoucherTypeId = @VoucherTypeID;

        IF ( ISNULL (@VoucherCountId, 0) > 0 )
            BEGIN
                UPDATE Ac_VoucherCount
                SET    VoucherCount = VoucherCount + 1
                WHERE  VoucherCountId = @VoucherCountId;
            END;
        ELSE
            BEGIN
                INSERT INTO Ac_VoucherCount ( VoucherTypeId ,
                                              FiscalYearId ,
                                              VoucherCount )
                VALUES ( @VoucherTypeID, @fiscalYearId, 1 );

                SELECT @VoucherCountId = CAST (@@Identity AS INT);
            END;
        --declare @VoucherTypeID int=1  
        DECLARE @prefix NVARCHAR (256);
        SELECT @prefix = Prefix
        FROM   Ac_VoucherType
        WHERE  [VoucherTypeID] = @VoucherTypeID;

        DECLARE @VoucherNo NVARCHAR (256);
        SET @VoucherNo = @prefix + N'-' + CONVERT (NVARCHAR (256) ,
                                          ( SELECT VoucherCount
                                            FROM   Ac_VoucherCount
                                            WHERE  VoucherCountId = @VoucherCountId ));
        --select @VoucherNo,@prefix  
        UPDATE Ac_Transaction
        SET    [VoucherNo] = @VoucherNo
        WHERE  TransactionID = @verifiedtransactionId;

        SELECT @verifiedtransactionId;
    END;

--select * from Ac_VoucherType  
--update Ac_TempTransaction set IsVerified=0  
--truncate table Ac_Transaction  truncate table Ac_TransactionDetail  
--select * from Ac_Transaction


GO

