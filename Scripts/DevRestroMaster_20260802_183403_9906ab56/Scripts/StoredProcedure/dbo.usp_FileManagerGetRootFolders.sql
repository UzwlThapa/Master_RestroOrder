SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerGetRootFolders]
AS
BEGIN
SELECT [FolderID]
      ,[PortalID]
      ,[FolderPath]
      ,[StorageLocation]
      ,[IsProtected]
      ,[IsCached]
      ,[UniqueId]
      ,[VersionGuid]
      ,[IsRoot]
      ,[IsActive]
      ,[IsDeleted]
      ,[IsModified]
      ,[AddedOn]
      ,[UpdatedOn]
      ,[DeletedOn]
      ,[AddedBy]
      ,[UpdatedBy]
      ,[DeletedBy]
  FROM [dbo].[Folder]
  WHERE IsRoot=1
END;





GO
