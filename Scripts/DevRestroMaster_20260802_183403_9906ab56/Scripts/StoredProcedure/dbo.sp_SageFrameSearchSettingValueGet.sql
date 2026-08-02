SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SageFrameSearchSettingValueGet]
 @PortalID INT,
 @CultureName NVARCHAR(256)
AS

 IF(EXISTS(
    SELECT * FROM dbo.SageFrameSearchSettingValue 
    WHERE 
     [PortalID] = @PortalID 
    AND [CultureName] = @CultureName
   ))
  BEGIN
   SELECT * FROM dbo.SageFrameSearchSettingValue 
   WHERE 
    [PortalID] = @PortalID 
   AND [CultureName] = @CultureName
  END
 Else
  BEGIN
   IF(EXISTS(
      SELECT * FROM dbo.SageFrameSearchSettingValue 
      WHERE PortalID = @PortalID
     ))
    BEGIN
     INSERT INTO dbo.SageFrameSearchSettingValue
      SELECT 
       [SettingKey],
       [SettingValue],
       @CultureName,
       [IsActive],
       [IsDeleted],
       [IsModified],
       [AddedOn],
       [UpdatedOn],
       [DeletedOn],
       [PortalID],
       [AddedBy],
       [UpdatedBy],
       [DeletedBy]
       FROM 
       dbo.[SageFrameSearchSettingValue] 
       WHERE
       [PortalID] = @PortalID

     SELECT * FROM dbo.SageFrameSearchSettingValue 
     WHERE 
      [PortalID] = @PortalID 
     AND [CultureName] = @CultureName
    END
   ELSE
    BEGIN     
     INSERT INTO dbo.SageFrameSearchSettingValue
      SELECT 
       [SettingKey],
       [SettingValue],
       @CultureName,
       [IsActive],
       [IsDeleted],
       [IsModified],
       [AddedOn],
       [UpdatedOn],
       [DeletedOn],
       @PortalID,
       [AddedBy],
       [UpdatedBy],
       [DeletedBy]
       FROM
       dbo.[SageFrameSearchSettingValue] 
      WHERE
       [PortalID] = 1

     SELECT * FROM dbo.SageFrameSearchSettingValue 
     WHERE 
       [PortalID] = @PortalID 
      AND [CultureName] = @CultureName
    END
  END





GO
