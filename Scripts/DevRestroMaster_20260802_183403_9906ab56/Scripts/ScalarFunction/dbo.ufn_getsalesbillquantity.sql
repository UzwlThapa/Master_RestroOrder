SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[ufn_getsalesbillquantity]
(
    -- Add the parameters for the function here
    @SalesMasterID INT
)
RETURNS DECIMAL(14,4)
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Qty DECIMAL(14,4) = 0;

    -- Add the T-SQL statements to compute the return value here
    SELECT @Qty = SUM(CAST(qty AS DECIMAL(14,4)))
    FROM dbo.RO_SalesDetail
    WHERE salesMasterId = @SalesMasterID;

    -- Return the result of the function
    RETURN @Qty;

END;

GO
