SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_CheckCostCenterValid] 
	@cid INT
AS
BEGIN

DECLARE @ReturnId AS INT

	IF EXISTS(SELECT * From ROI_ItemDetails Where ItemCostCentreID=@cid AND IsArchived=0)
	BEGIN
		SET @ReturnId = 0
	END
	ELSE
	BEGIN
		SET @ReturnId = 1
	END

	SELECT @ReturnId

END

GO
