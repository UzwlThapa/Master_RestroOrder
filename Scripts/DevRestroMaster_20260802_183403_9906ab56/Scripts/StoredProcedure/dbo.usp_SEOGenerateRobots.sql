SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SEOGenerateRobots]
@UserAgent NVARCHAR(50)
AS
BEGIN
SELECT PortalID,UserAgent,PagePAth FROM [dbo].[robots] WHERE UserAgent=@UserAgent
END





GO
