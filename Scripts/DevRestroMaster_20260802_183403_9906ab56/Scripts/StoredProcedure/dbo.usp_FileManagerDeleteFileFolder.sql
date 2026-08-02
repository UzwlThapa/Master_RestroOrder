SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerDeleteFileFolder]
(
 @FolderID INT,
 @FileID INT
)
AS
BEGIN
    IF @FolderID = 0
      BEGIN
          DELETE FROM [file]
          WHERE  fileid = @FileId
      END
    ELSE
      BEGIN
          DELETE FROM [file]
          WHERE  folderid = @FolderID

          DELETE FROM folder
          WHERE  folderid = @FolderID
      END 
END





GO
