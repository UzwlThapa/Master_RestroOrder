SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserAgentGetType] 
@PortalID INT,
 @IsActive BIT AS
BEGIN
 SELECT
  [AgentMode]
 FROM
  [DBO].[UserAgent]
 WHERE
  PortalID =@PortalID
 AND IsActive = @IsActive
 END





GO
