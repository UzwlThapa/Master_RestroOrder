SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserAgentSaveType]
( @AgentMode NVARCHAR (50),
 @PortalID INT,
 @ChangedBy NVARCHAR (250),
 @ChangedDate DATETIME,
 @IsActive BIT) AS
BEGIN

IF EXISTS (
 SELECT
  *
 FROM
  [UserAgent]
 WHERE
  PortalID =@PortalID
) UPDATE [dbo].[UserAgent]
SET AgentMode =@AgentMode,
 PortalID =@PortalID,
 ChangedBy =@ChangedBy,
 ChangedDate =@ChangedDate,
 IsActive =@IsActive
 WHERE PortalID = @PortalID
ELSE

BEGIN
 INSERT INTO [dbo].[UserAgent] (
  AgentMode,
  PortalID,
  ChangedBy,
  ChangedDate,
  IsActive
 )
VALUES
 (
  @AgentMode,
  @PortalID,
  @ChangedBy,
  @ChangedDate,
  @IsActive
 )
END
END





GO
