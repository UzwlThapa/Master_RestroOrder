SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[usp_UserModulesDelete] 141, 1, 'superuser'
   ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 CREATE PROCEDURE [dbo].[usp_UserModulesDelete] 
   (@UserModuleID INT,
    @PortalID INT,
    @DeletedBy NVARCHAR (256))
 AS
 BEGIN
 DECLARE
  @PageID INT DECLARE
  @CurrentSortValue INT,
  @PaneName NVARCHAR (256)
  SELECT  @CurrentSortValue = [ModuleOrder] ,@PageID = PageID,
     @PaneName = PaneName
  FROM  [dbo].[PageModules]
  WHERE UserModuleID =@UserModuleID
  
  UPDATE [dbo].[UserModules] SET [IsDeleted] = 1, [DeletedOn] = getdate(),[DeletedBy] = @DeletedBy
  WHERE [UserModuleID] = @UserModuleID
  
  --UPDATE [dbo].[PageModules] SET ModuleOrder = 9999, [IsDeleted] = 1, [DeletedOn] = getdate(),[DeletedBy] = @DeletedBy 
  --WHERE [UserModuleID] = @UserModuleID
  
  INSERT INTO [PageModules_History]
  SELECT  Getdate(),'D',@DeletedBy,* FROM [dbo].[PageModules] WHERE [UserModuleID] = @UserModuleID;
  UPDATE [PageModules_History] SET [IsActive] =0 ,[IsDeleted] = 1  WHERE [UserModuleID] = @UserModuleID;

  DELETE FROM  PageModules WHERE  [UserModuleID] = @UserModuleID
END





GO
