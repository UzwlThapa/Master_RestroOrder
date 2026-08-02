SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DELETE_ITEMBALANCE]
@ItemBalID INT
AS
BEGIN
DECLARE @code int
--DELETE from dbo.ROI_ITEMBal where ItemBalID = @ItemBalID
if((select OPBal from dbo.ROI_ITEMBal where ItemBalID = @ItemBalID) = (select CLBal from dbo.ROI_ITEMBal where ItemBalID = @ItemBalID))
	BEGIN
		update ROI_ITEMBal set OPBal=0, CLBal=0  where ItemBalID = @ItemBalID
		set @code = 200
	END
	ELSE
		BEGIN
		set @code = 100
	END
	select @code
END



GO
