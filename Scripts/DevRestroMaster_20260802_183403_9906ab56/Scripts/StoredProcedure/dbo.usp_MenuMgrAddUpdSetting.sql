SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrAddUpdSetting]   
@MenuID INT,
@SettingKey NVARCHAR(256),
@SettingValue NVARCHAR(256),
@PortalID INT,
@Updatedby NVARCHAR(256),
@AddedBy NVARCHAR(256) 

WITH EXECUTE AS CALLER
AS
 DECLARE @IsActive AS BIT
 SET @IsActive='True'
BEGIN
 IF(EXISTS(
    SELECT 
      * 
    FROM 
     dbo.MenuMgrSettingValue 
    WHERE 
      [MenuID] = @MenuID 
     AND [SettingKey] = @SettingKey 
     AND PortalID = @PortalID
   ))
  BEGIN
      UPDATE 
    dbo.MenuMgrSettingValue 
   SET 
    [SettingValue] = @SettingValue,
    [IsActive] = @IsActive,
    [IsModified] = 1,
    [UpdatedOn] = GETDATE(),
    [PortalID] = @PortalID,
    [UpdatedBy] = @UpdatedBy
      WHERE 
     [MenuID] = @MenuID 
    AND [SettingKey] = @SettingKey 
    AND PortalID = @PortalID
  END
 ELSE
  BEGIN
   INSERT INTO MenuMgrSettingValue 
           ( 
            [MenuID],
            [SettingKey],
            [SettingValue], 
            [AddedOn],
            [PortalID],
            [AddedBy]
           ) 
          VALUES 
           (
            @MenuID,
            @SettingKey,
            @SettingValue, 
            GETDATE(),
            @PortalID,
            @AddedBy
           )
  END
END





GO
