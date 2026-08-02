SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_UserProfileUpdate]
 @UserProfileID int, 
 @UserName  nvarchar(256), 
 @ProfileID int, 
 @Value nvarchar(255), 
 @IsActive bit,  
 @IsModified bit, 
 @UpdatedOn datetime, 
 @PortalID int,  
 @UpdatedBy nvarchar(256) 
 
AS

UPDATE [dbo].[UserProfile] SET
 [Username] = @UserName,
 [ProfileID] = @ProfileID,
 [Value] = @Value,
 [IsActive] = @IsActive, 
 [IsModified] = @IsModified, 
 [UpdatedOn] = @UpdatedOn, 
 [PortalID] = @PortalID, 
 [UpdatedBy] = @UpdatedBy
 
WHERE
 [UserProfileID] = @UserProfileID





GO
