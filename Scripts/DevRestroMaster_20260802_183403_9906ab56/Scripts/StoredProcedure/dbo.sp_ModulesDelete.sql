SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ModulesDelete]
 @ModuleID int,
 @DeletedBy nvarchar(256),
 @PortalID int
AS
UPDATE [dbo].[Modules] SET
 [IsDeleted] = 1, 
 [DeletedOn] = getdate(), 
 [DeletedBy] = @DeletedBy
WHERE
 [ModuleID] = @ModuleID --And PortalID = @PortalID





GO
