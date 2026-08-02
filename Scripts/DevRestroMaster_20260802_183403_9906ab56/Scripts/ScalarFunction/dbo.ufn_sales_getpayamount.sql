SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[ufn_sales_getpayamount]
(
    -- Add the parameters for the function here
    @SalesMasterID INT = 36726,
    @PaymentMode NVARCHAR(20) = N'cash'
)
RETURNS DECIMAL(14, 4)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @PaidAmount DECIMAL(14, 4)=0;

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
    -- Return the result of the function
    RETURN ISNULL(@PaidAmount,0);

END;

GO
