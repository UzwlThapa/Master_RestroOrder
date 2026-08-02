SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_UserProfileAdd]
 @UserProfileID INT OUTPUT,
 @UserName  NVARCHAR(256),
 @ProfileID INT,
 @Value NVARCHAR(255),
 @IsActive BIT, 
 @AddedOn DATETIME, 
 @PortalID INT,
 @AddedBy NVARCHAR(256) 
AS
IF(NOT EXISTS(SELECT * FROM [dbo].[UserProfile] WHERE [ProfileID] = @ProfileID and [Username] = @UserName and [PortalID] = @PortalID))
 BEGIN
  INSERT INTO [dbo].[UserProfile] (
   [Username],
   [ProfileID],
   [Value],
   [IsActive], 
   [AddedOn], 
   [PortalID],
   [AddedBy]
  ) VALUES (
   @UserName,
   @ProfileID,
   @Value,
   @IsActive, 
   @AddedOn, 
   @PortalID,
   @AddedBy
  )

  SET @UserProfileID = SCOPE_IDENTITY()
 End
ElSE
 BEGIN
  UPDATE [dbo].[UserProfile] SET 
   [Value] = @Value,
   [IsActive] = @IsActive, 
   [IsModified] = 1, 
   [UpdatedOn] = @AddedOn, 
   [UpdatedBy] = @AddedBy 
  WHERE
   [ProfileID] = @ProfileID and [Username] = @UserName and [PortalID] = @PortalID

  SET @UserProfileID = 0
 End





GO
