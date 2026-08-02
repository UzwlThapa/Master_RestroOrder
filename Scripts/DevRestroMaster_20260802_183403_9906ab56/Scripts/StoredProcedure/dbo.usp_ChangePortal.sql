SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [dbo].[usp_ChangePortal] 1
CREATE PROCEDURE [dbo].[usp_ChangePortal]
@PortalID INT
AS
BEGIN
 DECLARE @TableNames TABLE
 (
  RowNo INT IDENTITY(1,1),
  table_name NVARCHAR(256)
 )
 DECLARE @HasTemplate INT
  
 IF EXISTS(SELECT TemplateID FROM Template WHERE PortalID=@PortalID)
  BEGIN
   SET @HasTemplate=1 
  END
 ELSE  
  BEGIN
   SET @HasTemplate=0 
  END
 
 INSERT INTO @TableNames  
 SELECT DISTINCT t.name AS table_name
 FROM sys.tables AS t 
 INNER JOIN sys.columns c ON t.object_id=c.object_id
     WHERE c.name ='PortalID' AND t.name!='Portal' AND t.name !='SettingValue'
     AND t.name!='Modules' AND t.name!='Template' AND t.name!='SettingKey'
  AND t.name!= 'ModuleDefPermission' AND t.name!= 'ModuleControls' 
  AND t.name!= 'ModuleDefinitions' AND t.name!= 'ModuleMessage' 
  AND t.name!= 'MenuMgrSettingKey' AND t.name!= 'Permission' 
  AND t.name!='Packages' 
     DECLARE @TotalTable INT,@Counter INT
  SET @TotalTable=(SELECT COUNT(RowNo) FROM @TableNames)
     SET @Counter=1
     DECLARE @NextPortal INT
     declare @name nvarchar(100)
     declare @seoname nvarchar(100)
     set @name =  (SELECT name from Portal WHERE PortalID=1)
     set @seoname = (SELECT SEOName from Portal WHERE PortalID=1)
     SET @NextPortal=(SELECT MAX(PortalID) FROM Portal)+1
     INSERT INTO Portal 
     (
  Name,
  SEOName,
  IsParent
 )
 
      values (
  @name,
   @seoname,
    0
      )
 DECLARE @currentTable NVARCHAR(256),@UpdateSql NVARCHAR(256),@UpdateSql1 NVARCHAR(256)
 WHILE (@Counter<@TotalTable)
 BEGIN
  SET @currentTable=(SELECT table_name from @TableNames WHERE RowNo=@Counter)
  SET @UpdateSql ='UPDATE [dbo].['+@currentTable+'] '+'SET PortalID='+Cast(@NextPortal as NVARCHAR(100))+'  WHERE PortalID=1'
  SET @UpdateSql1='UPDATE [dbo].['+@currentTable+'] SET PortalID=1 WHERE PortalID='+CAST(@PortalID AS NVARCHAR(100) )+''
  EXEC(@UpdateSql)
  EXEC(@UpdateSql1)
  SET @Counter=@Counter+1
 END 
 DECLARE @SettingValuecounter INT
 SET @SettingValuecounter=1
  UPDATE SettingValue SET SettingTypeID=@NextPortal ,PortalID=@NextPortal WHERE SettingTypeID=1 AND SettingType='SiteAdmin'
  UPDATE SettingValue SET SettingTypeID=1 ,PortalID=1 WHERE SettingTypeID=@PortalID;
  DECLARE @chengedName NVARCHAR(256),@ChangedSeoName NVARCHAR(256)
  SET @ChangedSeoName =(SELECT Name from Portal WHERE PortalID=@PortalID)
  SET @ChangedSeoName=(SELECT SEOName from Portal WHERE PortalID=@PortalID)
  DELETE Portal WHERE PortalID=@PortalID
  UPDATE Portal SET Name=@ChangedSeoName,SEOName=@ChangedSeoName WHERE PortalID=1
END





GO
