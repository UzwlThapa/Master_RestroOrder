SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerEnableRootFolder]
 @FolderID INT
AS
  BEGIN
      SET NOCOUNT ON;
      UPDATE folder
      SET    isactive = 1
      WHERE  folderid = @FolderID
  END





GO
