SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_UserProfileDeleteByUserProfileID]
 @UserProfileID int,
 @DeletedBy nvarchar(256)
AS

UPDATE [dbo].[UserProfile] SET 
 [IsDeleted] = 1,
 [DeletedOn] = getdate(), 
 [DeletedBy] = @DeletedBy 
WHERE
 UserProfileID = @UserProfileID





GO
