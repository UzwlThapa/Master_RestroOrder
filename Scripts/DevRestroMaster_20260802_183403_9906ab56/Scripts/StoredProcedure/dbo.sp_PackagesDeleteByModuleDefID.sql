SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PackagesDeleteByModuleDefID]
 @PortalID int,
 @ModuleDefID int,
 @DeletedBy nvarchar(256)
 AS
 BEGIN
 UPDATE [dbo].[ModuleDefinitions] SET
 [IsDeleted]=1,
 [DeletedOn]=getdate(),
 [DeletedBy]=@DeletedBy
 WHERE ModuleDefID=@ModuleDefID --AND PortalID=@PortalID
 END





GO
