SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_SalesReturn]
	@SalesMasterId INT
AS
BEGIN
	SET NOCOUNT ON;

	Update RO_SalesMaster SET IsUpdated=0 where salesMasterId=@SalesMasterId

END

GO
