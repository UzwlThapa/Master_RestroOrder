SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Req_SaveRecquistionDetails] @RecqId INT
	,@ItemId INT
	,@Quantity DECIMAL(18, 2)
	,@Unit INT
AS
BEGIN
	INSERT INTO Req_RecquistionDetails (
		RecqId
		,ItemId
		,Quantity
		,Unit
		,StatusId
		)
	VALUES (
		@RecqId
		,@ItemId
		,@Quantity
		,@Unit
		,8
		)
END



GO
