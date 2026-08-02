SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED DATE: 2010-03-17
CREATE PROCEDURE [dbo].[sp_GetExtensionSetting]
@ModuleID INT,
@PortalID INT
AS
BEGIN
SELECT * FROM [dbo].Modules WHERE ModuleID=@ModuleID
SELECT * FROM [dbo].ModuleDefinitions WHERE ModuleID=@ModuleID
SELECT * FROM  [dbo].ModuleControls 
    INNER JOIN [dbo].ModuleDefinitions ON [dbo].ModuleDefinitions.ModuleDefID = [dbo].ModuleControls.ModuleDefID
    WHERE [dbo].ModuleDefinitions.ModuleID=@ModuleID AND [dbo].ModuleControls.IsDeleted=0 
SELECT * FROM [dbo].Packages WHERE ModuleID=@ModuleID
END
/****** Object:  StoredProcedure [dbo].[sp_GetListEntriesByNameParentKeyAndPortalID]    Script Date: 12/02/2012 12:19:42 ******/
SET ANSI_NULLS ON





GO
