SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PackagesDeleteByModuleID]
 @PortalID int,
 @ModuleID int,
 @DeletedBy nvarchar(256)
 AS
 BEGIN
 UPDATE [dbo].[Packages] SET
 [IsDeleted]=1,
 [DeletedOn]=getdate(),
 [DeletedBy]=@DeletedBy
 WHERE ModuleID=@ModuleID --AND PortalID=@PortalID
 
 UPDATE [dbo].[ModuleDefinitions] SET 
 [IsDeleted]=1,
 [DeletedOn]=getdate(),
 [DeletedBy]=@DeletedBy
 WHERE ModuleID=@ModuleID 

 UPDATE [dbo].[Modules] SET
 [IsDeleted]=1,
 [DeletedOn]=getdate(),
 [DeletedBy]=@DeletedBy
 WHERE ModuleID=@ModuleID --AND PortalID=@PortalID

 UPDATE [dbo].[PortalModules] SET
 [IsDeleted]=1,
 [DeletedOn]=getdate(),
 [DeletedBy]=@DeletedBy
 WHERE ModuleID=@ModuleID 

 END





GO
