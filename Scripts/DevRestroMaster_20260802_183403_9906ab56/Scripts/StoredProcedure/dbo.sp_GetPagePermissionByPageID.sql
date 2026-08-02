SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- Create date: <05 sep 2011>

-- ============================================= 
CREATE PROCEDURE [dbo].[sp_GetPagePermissionByPageID]
 @PageID    INT,
 @portalID INT
AS
BEGIN
 SELECT  * FROM dbo.PagePermission WHERE  PageID = @PageID  AND portalID = @PortalID
END
/****** Object:  StoredProcedure [dbo].[sp_GetPageSetting]    Script Date: 12/02/2012 12:43:32 ******/
SET ANSI_NULLS ON





GO
