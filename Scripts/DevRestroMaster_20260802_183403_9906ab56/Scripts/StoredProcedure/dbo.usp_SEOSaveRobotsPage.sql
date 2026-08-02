SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SEOSaveRobotsPage]
@PortalID INT,
@UserAgent NVARCHAR(50),
@PagePath NVARCHAR(MAX)
AS
BEGIN

INSERT INTO [dbo].[robots] 
(
PortalID,
UserAgent,
PagePAth
)
VALUES
(
@PortalID,
@UserAgent,
@PagePath
)
END





GO
