SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_UserProfileListByPortalID]
 @PortalID int
AS

SELECT
 [UserProfileID],
 [Username],
 [ProfileID],
 [Value],
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
FROM [dbo].[UserProfile]
Where [PortalID]=@PortalID





GO
