SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ModuleControlsGetByModuleControlID]
 @ModuleControlID INT
AS
BEGIN
 SELECT
 [ModuleControlID],
 [ModuleDefID],
 [ControlKey],
 [ControlTitle],
 [ControlSrc],
 [IconFile],
 [ControlType],
 [DisplayOrder],
 [HelpUrl],
 [SupportsPartialRendering],
 [IsActive],
 [IsDeleted],
 [IsModified],
 [AddedOn],
 [UpdatedOn],
 [DeletedOn],
 [PortalID],
 [AddedBy],
 [UpdatedBy],
 [DeletedBy]
FROM dbo.ModuleControls
WHERE
 [ModuleControlID] = @ModuleControlID 

END





GO
