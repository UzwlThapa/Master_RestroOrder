SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_AvailableModulesAdd]
 -- Add the parameters for the stored procedure here
  @FriendlyName NVARCHAR(256)
 ,@Description NVARCHAR(256)
 ,@Version NVARCHAR(256) 
 ,@BusinessControllerClass NVARCHAR(256)
 ,@FolderName NVARCHAR(256)
 ,@ModuleName NVARCHAR(256) 
 ,@IsActive BIT
 ,@IsDeleted BIT
 ,@IsModified BIT 
 ,@PortalID INT
 ,@AddedBy NVARCHAR(256)
 


AS
BEGIN
 
 SET NOCOUNT ON;
IF not exists(SELECT [FolderName] FROM [dbo].[AvailableModules] WHERE [FolderName]=@FolderName and [ModuleName]=@ModuleName and [Version]=@Version and [IsDeleted]=0)
BEGIN
INSERT INTO [dbo].[AvailableModules]
(
 [FriendlyName]
 ,[Description]
 ,[Version] 
 ,[BusinessControllerClass]
 ,[FolderName]
 ,[ModuleName] 
 ,[IsActive]
 ,[IsDeleted]
 ,[IsModified]
 ,[AddedOn]
 ,[PortalID]
 ,[AddedBy]
 
)
VALUES
(
 @FriendlyName 
 ,@Description
 ,@Version  
 ,@BusinessControllerClass 
 ,@FolderName
 ,@ModuleName  
 ,@IsActive 
 ,@IsDeleted 
 ,@IsModified 
 ,GETDATE()  
 ,@PortalID 
 ,@AddedBy 
)
End
END





GO
