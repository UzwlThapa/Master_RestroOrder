SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getflatandperdiscount]
@SalesMasterId int	
AS
begin
SELECT * FROM dbo.ro_flatandPerDiscount WHERE SalesMasterId=@SalesMasterId
end


-----------------------------------------------------------------------------------------------

GO
