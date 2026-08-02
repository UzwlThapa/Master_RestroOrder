SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Req_DeleteRecquistion] @RecqId INT
	,@DeletedBy NVARCHAR(max)
AS
BEGIN
	UPDATE Req_Recquistion
	SET IsDeleted = 1
		,DeletedBy = @DeletedBy
		,DeletedOn = GetDate()
	WHERE RecqId = @RecqId
END

-----------------------------------------------------------------------------------------------------

GO
