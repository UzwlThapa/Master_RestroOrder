SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PagesDelete]
  @PageID int,
  @DeletedBy nvarchar(256),
  @PortalID int
AS
BEGIN

  DECLARE @PageOrder INT,@ParentID INT
  SELECT @PageOrder=PageOrder,@ParentID=ParentID FROM [dbo].[Pages] WHERE PageID=@PageID
  DECLARE @tblChildPages TABLE (RowNum INT Identity(1,1), ChildPageID INT)
  
  ----- Delete from pagepermission and update history table ---
  INSERT INTO [PagePermission_History]
  SELECT  Getdate(),'D',@DeletedBy,* FROM [dbo].[PagePermission] WHERE [dbo].[PagePermission].[PageID] = @PageID And [dbo].[PagePermission].[PortalID] = @PortalID; 
 
  --UPDATE [PagePermission_History] SET [IsActive] =0 ,[IsDeleted] = 1  WHERE [dbo].[PagePermission_History].[PageID] = @PageID And [dbo].[PagePermission_History].[PortalID] = @PortalID  
  
     
  DELETE FROM  [PagePermission] WHERE [dbo].[PagePermission].[PageID] = @PageID --And [dbo].[PagePermission].[PortalID] = @PortalID;
  
   ----- Delete from pageModules and update history table ---
   
   INSERT INTO [PageModules_History]
  SELECT  Getdate(),'D',@DeletedBy,* FROM [dbo].[PageModules] WHERE [dbo].[PageModules].[PageID] = @PageID And [dbo].[PageModules].[PortalID] = @PortalID; 
 
  --UPDATE [PageModules_History] SET [IsActive] =0 ,[IsDeleted] = 1  WHERE [dbo]. [PageModules_History].[PageID] = @PageID And [dbo]. [PageModules_History].[PortalID] = @PortalID  
  
     
  DELETE FROM  [PageModules] WHERE [dbo].[PageModules].[PageID] = @PageID And [dbo].[PageModules].[PortalID] = @PortalID;
    
    
  ----- Delete from  usermodules and update history table ---   
  
  EXECUTE [dbo].[usp_UserModuleHistory] @PageID ,@DeletedBy ,@PortalID
  ----------
  ----- Delete from  PagePreviee ---  

  DELETE FROM  [PagePreview] WHERE [dbo].[PagePreview].[PageID] = @PageID --And [dbo].[PagePreview].[PortalID] = @PortalID;
  ---------- 
  
  INSERT INTO [Pages_History]
  SELECT  Getdate(),'D',@DeletedBy,* FROM [dbo].[Pages] WHERE [dbo].[Pages].[PageID] = @PageID And [dbo].[Pages].[PortalID] = @PortalID;
 
  --UPDATE [Pages_History] SET [IsActive] =0 ,[IsDeleted] = 1  WHERE [dbo].[Pages_History].[PageID] = @PageID And [dbo].[Pages_History].[PortalID] = @PortalID  
  
  DELETE FROM  [Pages] WHERE [dbo].[Pages].[PageID] = @PageID And [dbo].[Pages].[PortalID] = @PortalID;
  

   EXECUTE [dbo].[usp_PageMenuDelete] @PageID,@DeletedBy
   
   
   UPDATE [dbo].[Pages]
   SET  PageOrder = PageOrder - 1 
   WHERE PageOrder > @PageOrder AND PortalID = @PortalID 
     AND ParentID=@ParentID AND (IsDeleted = 0 OR IsDeleted IS NULL)
   
   DECLARE @Counter INT, @Count INT
   SET @Counter=1
    
   INSERT INTO @tblChildPages(ChildPageID) SELECT PageID FROM [dbo].Pages WHERE ParentID=@PageID AND (IsDeleted=0 OR IsDeleted IS NULL) 
   SET @Count = @@ROWCOUNT
  
  

 WHILE @Counter<=@Count
  BEGIN
   DECLARE @ChildPageID INT
   SELECT @ChildPageID=ChildPageID FROM @tblChildPages WHERE RowNum=@Counter
   EXECUTE [dbo].[sp_PagesDelete] @ChildPageID,@DeletedBy,@PortalID
   EXECUTE [dbo].[usp_PageMenuDelete] @ChildPageID ,@DeletedBy 
   DELETE FROM [dbo].[MenuItem] WHERE PageID=@ChildPageID 
   SET @Counter=@Counter+1
  END
  
  DELETE FROM [dbo].[MenuItem] WHERE PageID=@PageID 
  DELETE FROM [dbo].[MenuItem] WHERE ParentID=@PageID 

END




GO
