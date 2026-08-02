SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Created By Milson Munakami

CREATE PROCEDURE [dbo].[sp_PagePermissionDeleteByPageID]
 @PageID int, 
 @PortalID int,
 @IsAdmin bit
AS
BEGIN
 IF @IsAdmin = 0
 BEGIN
  DELETE [dbo].[PagePermission]
  WHERE [PortalID] = @PortalID AND
   [PageID] = @PageID
 END 
 ELSE
 BEGIN
  DELETE [dbo].[PagePermission]
  WHERE [PageID] = @PageID
 END
END





GO
