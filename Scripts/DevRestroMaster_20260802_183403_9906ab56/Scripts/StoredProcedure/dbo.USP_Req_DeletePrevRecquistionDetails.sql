SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Req_DeletePrevRecquistionDetails] @RecqId INT
AS
BEGIN
	DELETE
	FROM Req_RecquistionDetails
	WHERE RecqId = @RecqId
END

-----------------------------------------------------------------------------------------------------

GO
