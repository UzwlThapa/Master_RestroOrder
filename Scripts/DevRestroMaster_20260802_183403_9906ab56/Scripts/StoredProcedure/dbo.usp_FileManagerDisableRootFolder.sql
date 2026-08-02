SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerDisableRootFolder]
 @FolderID INT 
AS
  BEGIN
      SET NOCOUNT ON;
      UPDATE folder
      SET    isactive = 0
      WHERE  folderid = @FolderID
  END





GO
