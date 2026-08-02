SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_UserProfileUpdateByProfileID] 
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
 [Value] = @Value,
 [IsActive] = @IsActive, 
 [IsModified] = @IsModified, 
 [UpdatedOn] = @UpdatedOn, 
 [UpdatedBy] = @UpdatedBy 
WHERE
 [ProfileID] = @ProfileID and [Username] = @UserName and [PortalID] = @PortalID





GO
