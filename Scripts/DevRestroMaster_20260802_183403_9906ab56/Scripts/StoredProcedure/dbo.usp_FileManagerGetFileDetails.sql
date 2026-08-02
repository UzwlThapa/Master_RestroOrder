SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerGetFileDetails]
 @FileID INT
AS
BEGIN
SELECT fi.FileId
      ,fi.PortalId
      ,fi.FileName
      ,fi.Extension
      ,fi.Size
      ,fi.Width
      ,fi.Height
      ,fi.ContentType
      ,fi.Folder
      ,fi.FolderID
      ,fi.Content
      ,fi.UniqueId
      ,fi.VersionGuid
   ,fo.StorageLocation
      ,fi.IsActive
      ,fi.IsDeleted
      ,fi.IsModified
      ,fi.AddedOn
      ,fi.UpdatedOn
      ,fi.DeletedOn
      ,fi.AddedBy
      ,fi.UpdatedBy
      ,fi.DeletedBy
  FROM [dbo].[File] fi
 LEFT JOIN Folder fo
 ON fi.FolderID=fo.FolderID
 WHERE fi.FileId=@FileID
END





GO
