SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE  [USP_ROI_GoodReceivedmainSave]
CREATE PROCEDURE [dbo].[USP_ROI_GoodReceivedmainSave]
    @GMNo VARCHAR (200) ,
    @STId INT ,
    @PostedBy VARCHAR (200) ,
    @PostedOn DATETIME ,
    @InvoiceNo NVARCHAR (256) ,
    @InvoiceDate DATETIME ,
    @vendorId INT ,
    @paymentMode INT ,
    @ExtraDiscount DECIMAL (10, 2)
AS
    BEGIN
        DECLARE @prefix VARCHAR (128) = 'GM_';
        DECLARE @val VARCHAR (MAX);
        IF (( SELECT COUNT (*)
              FROM   dbo.RO_GoodsReceivedMain ) > 0 )
            BEGIN
                SELECT @val = CAST(MAX (CAST(SUBSTRING (GMNo, 4, LEN (GMNo) - LEN (@prefix)) AS INT)) + 1 AS VARCHAR (100))
                FROM   dbo.RO_GoodsReceivedMain;
                SET @GMNo = @prefix + @val;

            END;
        ELSE
            BEGIN
                SET @GMNo = @prefix + CAST(1 AS VARCHAR);
            END;


        INSERT INTO RO_GoodsReceivedMain ( GMNo ,
                                           STId ,
                                           PostedBy ,
                                           PostedOn ,
                                           InvoiceNo ,
                                           InvoiceDate ,
                                           vendorId ,
                                           paymentMode ,
                                           ExtraDiscount )
                    SELECT @GMNo ,
                           @STId ,
                           @PostedBy ,
                           GETDATE () ,
                           @InvoiceNo ,
                           @InvoiceDate ,
                           CASE WHEN @vendorId = 0 THEN NULL
                                ELSE @vendorId
                           END ,
                           @paymentMode ,
                           @ExtraDiscount;

        SELECT CAST(@@IDENTITY AS INT);
    END;

GO
