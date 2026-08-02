SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetPageModulesByPageID]

 @PageID    INT, 
 @PortalID  INT 
AS
BEGIN
 SELECT PageModules.UserModuleID,PageModules.PaneName,UserModules.UserModuleTitle,PageModules.ModuleOrder
 FROM dbo.PageModules 
        INNER JOIN dbo.UserModules ON PageModules.UserModuleID = UserModules.UserModuleID
 WHERE  PageID = @PageID 
        AND (dbo.PageModules.PortalID = @PortalID OR dbo.PageModules.PortalID = -1) 
        AND (dbo.PageModules.IsDeleted=0 OR dbo.PageModules.IsDeleted IS NULL)    
END





GO
