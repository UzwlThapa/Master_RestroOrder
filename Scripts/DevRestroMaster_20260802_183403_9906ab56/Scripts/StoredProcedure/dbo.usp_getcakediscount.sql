SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getcakediscount]
@SalesMasterId int	
AS
begin
SELECT SalesMasterId,DiscountValue,IsFlatDis,TotalDiscount as cakedis,BasicAmount, SalesType FROM RO_Discount WHERE SalesMasterId=@SalesMasterId
end


-----------------------------------------------------------------------------------------------

GO
