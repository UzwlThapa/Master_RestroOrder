SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerAddFolderRetFolderID]
 (
    @PortalID INT,
 @ParentFolderID INT,
    @FolderPath VARCHAR(300),
 @StorageLocation INT,
    @UniqueId UNIQUEIDENTIFIER,
    @VersionGuid UNIQUEIDENTIFIER,
 @IsActive BIT,
 @AddedBy NVARCHAR(256),
 @FolderID INT OUTPUT
  ) 
AS
BEGIN
    INSERT INTO dbo.Folder (
        PortalID,
  ParentFolderID, 
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
 SET @FolderID=SCOPE_IDENTITY();
 SELECT @FolderID
END





GO
