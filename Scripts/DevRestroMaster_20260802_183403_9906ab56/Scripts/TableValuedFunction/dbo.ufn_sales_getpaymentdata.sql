SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[ufn_sales_getpaymentdata]
(
    -- Add the parameters for the function here
    @SalesMasterID INT = 36726,
    @PaymentMode NVARCHAR(20) = N'cash'
)
RETURNS @PaymentData TABLE
(
    -- Add the column definitions for the TABLE variable here
    PaidAmount DECIMAL(14, 4),

    PaymentModes NVARCHAR(100)
)
AS
BEGIN
    -- Fill the table variable with the rows for your result set
    DECLARE @PaidAmount DECIMAL(14, 4) = 0,
            @PaymentModes NVARCHAR(100);

    -- Add the T-SQL statements to compute the return value here

    DECLARE @PaymentModeID INT = 0;


    SELECT @PaymentModeID = PaymentModeID
    FROM dbo.RO_PaymentModes
    WHERE PaymentMode = @PaymentMode;
    SELECT @PaidAmount = SUM(PayAmount)
    FROM dbo.RO_SalesPaymentMode
    WHERE salesMasterId = @SalesMasterID
          AND
          (
              (
                  @PaymentModeID = 0
                  AND PaymentModeID = 1
              )
              OR (PaymentModeID = @PaymentModeID)
          );

		  SELECT @PaymentModes = ISNULL(
                                        STUFF(
                                                 (
                                                     SELECT ' & ' + CASE
                                                                        WHEN LOWER(pms.PaymentMode) = 'credit' THEN
                                                                            pms.PaymentMode + '/' + spm.Customer
                                                                        ELSE
                                                                            pms.PaymentMode
                                                                    END
                                                     FROM RO_SalesPaymentMode spm
                                                         INNER JOIN RO_PaymentModes pms
                                                             ON spm.PaymentModeID = pms.PaymentModeID
                                                     WHERE spm.salesMasterId = @SalesMasterID --and spm.PaymentModeID = 4
                                                     FOR XML PATH(''), TYPE
                                                 ).value('.', 'NVARCHAR(MAX)'),
                                                 1,
                                                 3,
                                                 ''
                                             ),
                                        ''
                                    )

    --SELECT @PaymentModes = STRING_AGG(   CASE
    --                                         WHEN LOWER(pms.PaymentMode) = 'credit' THEN
    --                                             pms.PaymentMode + '/' + spm.Customer
    --                                         ELSE
    --                                             pms.PaymentMode
    --                                     END,
    --                                     '&'
    --                                 )
    --FROM dbo.RO_SalesPaymentMode spm
    --    INNER JOIN dbo.RO_PaymentModes pms
    --        ON pms.PaymentModeID = spm.PaymentModeID
    --WHERE spm.salesMasterId = @SalesMasterID;

    INSERT INTO @PaymentData
    (
        PaidAmount,
        PaymentModes
    )
    VALUES
    (   ISNULL(@PaidAmount, 0), -- PaidAmount - decimal(14, 4)
        @PaymentModes           -- PaymentModes - nvarchar(100)
        );

    RETURN;
END;

GO
