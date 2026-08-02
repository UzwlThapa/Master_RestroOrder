SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_FileManagerDeleteExistingPermissions]
@FolderID INT
AS
BEGIN
 DECLARE @Count INT 

      SELECT @Count = COUNT(*) 
      FROM   folderpermission 
      WHERE  folderid = @FolderID 

      IF @Count <> 0 
        BEGIN 
            DELETE FROM folderpermission 
            WHERE  folderid = @FolderID 
        END 
END





GO
