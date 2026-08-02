SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_AvailableModulesGet]

 @PortalID INT
AS 
BEGIN

 SET NOCOUNT ON;
SELECT AvailableModuleID 
 ,[ModuleName] AS [Name]
 ,[ModuleName]
 ,[FriendlyName]
 ,[Description]
 ,[Version]
 ,[IsPremium]
 ,[IsAdmin]
 ,[BusinessControllerClass]
 ,[FolderName] 
 ,[SupportedFeatures]
 ,[CompatibleVersions]
 ,[Dependencies]
 ,[Permissions]
 ,[PackageID]
 ,[IsActive]
 ,[IsDeleted]
 ,[IsModified]
 ,[AddedOn]
 ,[PortalID]
 ,[AddedBy]
 ,[UpdatedBy]
 ,[DeletedBy]
FROM [dbo].[AvailableModules]
WHERE [IsActive]=1 AND [IsDeleted] =0 AND PortalID=@PortalID
  
END
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON





GO
