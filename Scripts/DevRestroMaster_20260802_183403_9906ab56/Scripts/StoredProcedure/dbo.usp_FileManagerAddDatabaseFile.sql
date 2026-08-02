SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerAddDatabaseFile]
  (
    @PortalId INT,
    @UniqueId UNIQUEIDENTIFIER,
    @VersionGuid UNIQUEIDENTIFIER,
    @FileName NVARCHAR(100),
    @Extension NVARCHAR(100),
    @Size INT,  
    @ContentType NVARCHAR(200),
    @Folder NVARCHAR(200),
    @FolderID INT,
 @Content IMAGE,
 @IsActive INT,
 @AddedBy NVARCHAR(256)
) 
AS  
        BEGIN
          INSERT INTO dbo.[File](
            PortalId,
            UniqueId,
            VersionGuid,
            FileName,
            Extension,
            Size,           
            ContentType,
            Folder,
            FolderID,
   [Content],
   IsActive,
   AddedBy,
   AddedOn
          )
          VALUES (
            @PortalId,
            @UniqueId,
            @VersionGuid,
            @FileName,
            @Extension,
            @Size,           
            @ContentType,
            @Folder,
            @FolderID,
   @Content,
   @IsActive,
   @AddedBy,
   GETDATE()
          )
END





GO
