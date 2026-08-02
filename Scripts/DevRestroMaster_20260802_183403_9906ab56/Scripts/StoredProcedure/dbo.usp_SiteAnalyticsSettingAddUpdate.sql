SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SiteAnalyticsSettingAddUpdate] (
 @UserModuleID INT,
 @SettingKey NVARCHAR (256),
 @SettingValue NVARCHAR (256),
 @IsActive BIT,
 @PortalID INT,
 @UpdatedBy NVARCHAR (50),
 @AddedBy NVARCHAR (50)
) AS
BEGIN

SET nocount ON ;
IF (
 EXISTS (
  SELECT
   DashboardSettingValueID
  FROM
   DashboardSettingValue
  WHERE
   @SettingKey = SettingKey
  AND PortalID =@PortalID
  AND UserModuleID =@UserModuleID
 )
)
BEGIN
 UPDATE DashboardSettingValue
SET SettingValue =@SettingValue
WHERE
 PortalID =@PortalID
AND SettingKey =@SettingKey
AND UserModuleID =@UserModuleID
END
ELSE

BEGIN
 INSERT INTO DashboardSettingValue (
  SettingKey,
  SettingValue,
  IsActive,
  AddedOn,
  PortalID,
  AddedBy,
  UserModuleID
 )
VALUES
 (
  @SettingKey ,@SettingValue,
  1,
  getdate() ,@PortalID ,@AddedBy ,@UserModuleID
 )
END
END





GO
