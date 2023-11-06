
GO
/****** Object:  StoredProcedure [dbo].[usp_ac_SaveVerifiedTransaction]    Script Date: 15/10/2023 11:10:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 10/05/2023
====================================

EXEC dbo.usp_ac_SaveVerifiedTransaction @TransactionID = 0 ,                       -- int
                                        @TransactionDate = '2023-10-12 04:14:58' , -- datetime
                                        @VoucherTypeID = 0 ,                       -- int
                                        @Descriptions = N'' ,                      -- nvarchar(256)
                                        @PostedBy = N'' ,                          -- nvarchar(256)
                                        @postedOn = N'' ,                          -- nvarchar(256)
                                        @verifiedBy = N''                          -- nvarchar(256)
*/
ALTER PROC [dbo].[usp_ac_SaveVerifiedTransaction]
    @TransactionID INT ,
    @TransactionDate DATETIME ,
    @VoucherTypeID INT ,
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
        FROM   dbo.RO_fiscalYear
        WHERE  @TransactionDate BETWEEN StartDate AND EndDate;

        DECLARE @SalesMasterID INT;
        DECLARE @BillDate DATETIME;
        SELECT @SalesMasterID = t.SalesMasterId ,
               @BillDate = ISNULL(t.BillDate,@postedOn)
        FROM   dbo.Ac_TempTransaction t
        WHERE  t.TransactionID = @TransactionID;

        INSERT INTO dbo.Ac_Transaction ( [TransactionDate] ,
                                         BillDate ,
                                         [VoucherTypeID] ,
                                         [Descriptions] ,
                                         [PostedBy] ,
                                         [PostedOn] ,
                                         [VerifiedOn] ,
                                         [VerifiedBy] ,
                                         SalesMasterId )
        VALUES ( @TransactionDate, @BillDate, @VoucherTypeID, @Descriptions, @PostedBy, @postedOn, GETDATE () ,
                 @verifiedBy , @SalesMasterID );

        SELECT @verifiedtransactionId = CAST (SCOPE_IDENTITY () AS INT);

        UPDATE dbo.Ac_TempTransaction
        SET    IsVerified = 1
        WHERE  TransactionID = @TransactionID;

        SELECT @VoucherCountId = VoucherCountId
        FROM   dbo.Ac_VoucherCount
        WHERE  FiscalYearId = @fiscalYearId
        AND    VoucherTypeId = @VoucherTypeID;

        IF ( ISNULL (@VoucherCountId, 0) > 0 )
            BEGIN
                UPDATE dbo.Ac_VoucherCount
                SET    VoucherCount = VoucherCount + 1
                WHERE  VoucherCountId = @VoucherCountId;
            END;
        ELSE
            BEGIN
                INSERT INTO dbo.Ac_VoucherCount ( VoucherTypeId ,
                                                  FiscalYearId ,
                                                  VoucherCount )
                VALUES ( @VoucherTypeID, @fiscalYearId, 1 );

                SELECT @VoucherCountId = CAST (SCOPE_IDENTITY () AS INT);
            END;

        DECLARE @prefix NVARCHAR (256);
        SELECT @prefix = Prefix
        FROM   dbo.Ac_VoucherType
        WHERE  [VoucherTypeID] = @VoucherTypeID;

        DECLARE @VoucherNo NVARCHAR (256);
        SET @VoucherNo = @prefix + N'-' + CONVERT (NVARCHAR (256) ,
                                          ( SELECT VoucherCount
                                            FROM   dbo.Ac_VoucherCount
                                            WHERE  VoucherCountId = @VoucherCountId ));

        UPDATE dbo.Ac_Transaction
        SET    [VoucherNo] = @VoucherNo
        WHERE  TransactionID = @verifiedtransactionId;

        SELECT @verifiedtransactionId;
    END;
