SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerAddFile]
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
 @IsActive BIT,
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
   @IsActive,
   @AddedBy,
   GETDATE()
          )
END





GO
