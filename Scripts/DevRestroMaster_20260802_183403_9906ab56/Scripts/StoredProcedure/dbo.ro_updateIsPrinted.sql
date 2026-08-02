SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ro_updateIsPrinted]
@OrderMasterId int	
AS
DECLARE @val BIT=1
BEGIN
	UPDATE dbo.RO_OrderMasters SET
	isPrinted=@val
	WHERE OrderMasterID=@OrderMasterId
END	




GO
