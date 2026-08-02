SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerCopyFile]
(
 @FileID INT,
 @FolderID INT,
 @Folder NVARCHAR(200),
 @UniqueId UNIQUEIDENTIFIER,
 @VersionGuid UNIQUEIDENTIFIER
) 
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO [File]
 (
  PortalId,[FileName],
  Extension,Size,
  Width,Height,
  ContentType,Folder,
  FolderID,Content,
  UniqueId,VersionGuid,
  IsActive,IsDeleted,
  IsModified,AddedOn,
  UpdatedOn,DeletedOn,
  AddedBy,UpdatedBy,
  DeletedBy
  )
  select 
  PortalId,[FileName],
  Extension, [Size],
  Width, Height,
  ContentType,@Folder,
  @FolderID,Content,
  @UniqueId,@VersionGuid,
  IsActive,IsDeleted,
  IsModified,AddedOn,
  UpdatedOn,DeletedOn,
  AddedBy,UpdatedBy,
  DeletedBy FROM [File]
  WHERE FileId=@FileID
END





GO
