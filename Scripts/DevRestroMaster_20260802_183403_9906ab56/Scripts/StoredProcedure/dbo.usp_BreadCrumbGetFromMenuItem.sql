SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [dbo].[usp_BreadCrumbGetFromMenuItem]'Services',1,0,'ne-NP'
CREATE PROCEDURE [dbo].[usp_BreadCrumbGetFromMenuItem] 
@SEOName NVARCHAR(100),
@PortalID INT,
@MenuID INT,
@CultureCode NVARCHAR(100)
AS
BEGIN
 TRUNCATE TABLE BreadCrumbMenuItem
  DECLARE @ParentId INT,@SubChild NVARCHAR(100),@Final NVARCHAR(256)

 SET @ParentId=(SELECT DISTINCT mi.parentid FROM  dbo.MenuItem mi 
 WHERE (REPLACE(Title,'-','')=REPLACE(@SEOName,'-',' ') or @SEOName=Title)
 AND mi.PortalID=@PortalID  AND (mi.IsDeleted=0 OR mi.IsDeleted is NULL)
 AND mi.IsVisible=1 AND mi.IsActive=1 AND mi.MenuID=@MenuID)

  SELECT @SubChild=Title FROM MenuItem WHERE 
 MenuItemID=@ParentId and PortalID=@PortalID AND(IsDeleted=0 OR IsDeleted is NULL) 
 AND IsVisible=1 AND IsActive=1

 IF((SUBSTRING(@SubChild,1,1))='-')
  BEGIN
   SET @SubChild=REPLACE(@SubChild,'-','')
  END
 SET @SubChild=REPLACE(@SubChild,' ','-')
 IF(@SubChild is not null)
 BEGIN
  EXEC [dbo].[usp_BreadCrumbGetFromMenuItem] @SubChild,@PortalID,@MenuID
 END
  INSERT INTO BreadCrumbMenuItem
  SELECT @SEOName
END





GO
