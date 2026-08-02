SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- Create date: 2010-03-29
-- Description: HTML/Text Module
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_HtmlTextGetByPortalAndUserModule] 
 @PortalID INT,
 @UsermoduleID INT, 
 @CultureName NVARCHAR(256)
AS
BEGIN
 SELECT
 [HtmlTextID],
 [UserModuleID],
 [Content],
 [CultureName],
 [IsAllowedToComment],
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
FROM dbo.HtmlText
WHERE
 [PortalID]=@PortalID AND [UsermoduleID]=@UsermoduleID AND [CultureName] = @CultureName AND (IsDeleted=0 OR IsDeleted IS NULL)
END





GO
