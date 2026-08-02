SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_BreadCrumbMenuItemPath] 
AS
BEGIN
 DECLARE @Temp TABLE
 (
  RowNum INT IDENTITY(1,1),
  PageName NVARCHAR(256)
 )
 INSERT INTO @Temp
 SELECT PageName FROM dbo.BreadCrumbMenuItem
  DECLARE @Count INT,@Final NVARCHAR(500),@Counter INT
 SET @Final=''
 SELECT @Count=count(RowNum) FROM @Temp
 SET @Counter=1
  WHILE(@Counter<=@Count or @Count=0)
   BEGIN
    DECLARE @Name nvarchar(100)
    SELECT @Name=PageName FROM @Temp WHERE RowNum = @Counter
    SET @Final=@Final+@Name+'/'
 SET @Counter=@Counter+1
   END
  SET @Final=substring(@Final,0,len(@Final))
 IF((substring(@Final,1,1))='-')
  BEGIN
   SET @Final=replace(@Final,'-','')
  END
SELECT +'/'+@Final as TabPath
END





GO
