SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================= 
CREATE PROCEDURE [dbo].[sp_ProfileImageFoldersGet]
 @EditUserName NVARCHAR(256),
 @ProfileID INT,
 @PortalID INT 
AS
BEGIN
 SELECT * FROM dbo.[UserProfile] WHERE [Username]=@EditUserName AND 
 [ProfileID] = @ProfileID AND PortalID=@PortalID
 AND (IsDeleted IS NULL OR IsDeleted=0) AND IsActive = 1
END





GO
