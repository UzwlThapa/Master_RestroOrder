SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Milson Munakami
-- Create date: 2010-06-27
-- Description: Package IsActive Management
-- =============================================
CREATE PROCEDURE [dbo].[sp_PackagesUpdateChanges]
 @ModuleIDs [nvarchar](4000),
 @IsActives [nvarchar](4000),
 @UpdatedBy [nvarchar](256)
WITH EXECUTE AS CALLER
AS
BEGIN
 DECLARE @tblModuleIDs AS TABLE (
        rowno int identity(1,1), 
        ModuleID nvarchar(256)
        )
        
 DECLARE @tblIsActive AS TABLE(
        rowno int identity(1,1), 
        IsActive bit
       )
 DECLARE @Counter int
 DECLARE @Count int
 
 INSERT INTO @tblModuleIDs(ModuleID)
 SELECT rtrim(ltrim(items)) FROM split(@ModuleIDs,',')
 
 INSERT INTO @tblIsActive(IsActive)
   SELECT rtrim(ltrim(items)) FROM split(@IsActives,',')
 
 SELECT @Count=count(rowno) FROM @tblModuleIDs
 SET @counter=1
 WHILE(@counter<=@Count or @counter=1)
 BEGIN  

 UPDATE [dbo].[Packages] SET
 IsActive=(SELECT IsActive FROM @tblIsActive where rowno=@counter)
       ,UpdatedOn=getdate()
       ,UpdatedBy=@UpdatedBy
  WHERE [ModuleID] = (SELECT ModuleID FROM @tblModuleIDs where rowno=@counter ) 

 UPDATE [dbo].[ModuleDefinitions] SET 
 IsActive=(SELECT IsActive FROM @tblIsActive where rowno=@counter)
       ,UpdatedOn=getdate()
       ,UpdatedBy=@UpdatedBy
  WHERE [ModuleID] = (SELECT ModuleID FROM @tblModuleIDs where rowno=@counter )

 UPDATE [dbo].[Modules] SET
 IsActive=(SELECT IsActive FROM @tblIsActive where rowno=@counter)
       ,UpdatedOn=getdate()
       ,UpdatedBy=@UpdatedBy
  WHERE [ModuleID] = (SELECT ModuleID FROM @tblModuleIDs where rowno=@counter )

 UPDATE [dbo].[PortalModules] SET
 IsActive=(SELECT IsActive FROM @tblIsActive where rowno=@counter)
       ,UpdatedOn=getdate()
       ,UpdatedBy=@UpdatedBy
  WHERE [ModuleID] = (SELECT ModuleID FROM @tblModuleIDs where rowno=@counter )
SET @counter=@counter+1
 END
END





GO
