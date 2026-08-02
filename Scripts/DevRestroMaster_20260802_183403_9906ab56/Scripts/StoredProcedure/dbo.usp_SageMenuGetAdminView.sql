SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageMenuGetAdminView] 
     @prefix [nvarchar](10), 
  @IsDeleted [BIT],
  @PortalID [int],
  @UserName [nvarchar](256),
     @CultureCode NVARCHAR(20)
 
AS
BEGIN
 DECLARE @IsActive BIT,@IsVisible BIT,@IsRequiredPage BIT
 SET @IsActive=NULL
 SET @IsVisible=NULL
 SET @IsRequiredPage=NULL

select *,PageName AS LevelPageName FROM dbo.Pages p INNER JOIN dbo.PageMenu pm ON p.PageID=pm.PageID
WHERE (p.IsDeleted=0 OR p.IsDeleted IS NULL) AND (P.PortalID=@PortalID OR p.PortalID=-1)
AND pm.IsAdmin=1
AND pm.PortalID = @PortalID
END





GO
