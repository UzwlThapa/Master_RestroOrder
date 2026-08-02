SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetAllSecurePages] 
 @PortalID INT,
 @CultureName NVARCHAR(256)
AS
BEGIN
 SELECT SEOName AS SecurePageName, IsSecure FROM dbo.Pages
        WHERE  PortalID = @PortalID AND (IsDeleted =0 OR IsDeleted IS NULL)
 AND IsActive =1 
END





GO
