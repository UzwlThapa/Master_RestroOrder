SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- [usp_BreadCrumbGetFromPageName]'Currency',1,'en-US'  
CREATE PROCEDURE [dbo].[usp_BreadCrumbGetFromPageName] @SEOName NVARCHAR(100)  
 ,@PortalID INT  
 ,@CultureCode NVARCHAR(100)  
AS  
BEGIN  
 DECLARE @PageID INT  
 DECLARE @DefaultPage NVARCHAR(200)  
  
 SET @DefaultPage = (  
   SELECT SettingValue  
   FROM SettingValue  
   WHERE SettingKey = 'PortalDefaultPage'  
    AND settingTypeID = @portalID  
   )  
  
 DECLARE @TabPath NVARCHAR(max)  
  
 SET @TabPath = (  
   SELECT Top 1 TabPath  
   FROM [dbo].[Pages]  
   WHERE SEOName = @SEOName  
    AND (  
     PortalID = @PortalID  
     OR PortalID = - 1  
     )  
    AND IsDeleted = 0  
	AND IsActive = 1
   ) + '/'  
 SET @TabPath = '/' + @DefaultPage + @TabPath  
  
 DECLARE @tblFinal TABLE (  
  RowNum INT identity(1, 1)  
  ,TabPath NVARCHAR(500)  
  ,LocalPage NVARCHAR(500)  
  )  
 DECLARE @Count INT  
  
 SET @Count = CHARINDEX('/', @TabPath)  
  
 DECLARE @EIND INT  
  
 SET @EIND = 0  
  
 DECLARE @PageName NVARCHAR(500)  
  
 WHILE (@Count != LEN(@TabPath))  
 BEGIN  
  SET @EIND = ISNULL(((CHARINDEX('/', @TabPath, @Count + 1)) - @Count - 1), 0)  
  SET @PageName = (  
    SELECT (SUBSTRING(@TabPath, (@Count + 1), @EIND))  
    )  
  SET @PageID = (  
    SELECT PageID  
    FROM Pages  
    WHERE SEOName = @PageName  
     AND PortalID = @PortalID  
     AND IsDeleted = 0  
    )  
  
  INSERT INTO @tblFinal  
  SELECT (SUBSTRING(@TabPath, (@Count + 1), @EIND))  
   ,(  
    SELECT LocalPageName  
    FROM [dbo].[LocalPage]  
    WHERE PageID = @PageID  
     AND CultureCode = @CultureCode  
    )  
  
  SELECT @Count = ISNULL(CHARINDEX('/', @TabPath, @Count + 1), 0)  
 END  
  
 SELECT *  
 FROM @tblFinal  
END  
  



GO
