SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_getsystemuser]
AS
SELECT [UserID]
	,[UserName]
FROM [dbo].[UserDetails]



GO
