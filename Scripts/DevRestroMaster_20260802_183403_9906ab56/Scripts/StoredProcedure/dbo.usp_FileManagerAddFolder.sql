SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerAddFolder]
 (
    @PortalID    INT,
 @ParentFolderID  INT,
    @FolderPath   varchar(300),
 @StorageLocation  INT,
    @UniqueId    UNIQUEIDENTIFIER,
    @VersionGuid   UNIQUEIDENTIFIER,
 @IsActive   BIT,
 @AddedBy   NVARCHAR(256)
) 
   
AS
BEGIN
    INSERT INTO dbo.Folder (
        PortalID,
  ParentFolderID ,
  FolderPath, 
        StorageLocation, 
        UniqueId,
        VersionGuid,        
        IsActive,
  IsRoot,
  AddedBy,
  AddedOn
    )
    VALUES (
        @PortalID,
  @ParentFolderID,
  @FolderPath, 
        @StorageLocation,  
        @UniqueId,
        @VersionGuid,        
        @IsActive,
  0,
  @AddedBy,
  GETDATE()
    )
END





GO
