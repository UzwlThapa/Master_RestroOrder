SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ModulesGetByModuleName]
 @ModuleName nvarchar(128),
 @PortalID int
 
 
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

    -- Insert statements for procedure here
 SELECT 
 [ModuleID],
 [FriendlyName],
 [Description],
 [Version],
 [IsPremium],
 [IsAdmin],
 [BusinessControllerClass],
 [FolderName],
 [ModuleName],
 [SupportedFeatures],
 [CompatibleVersions],
 [Dependencies],
 [Permissions],
 [PackageID],
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
FROM [dbo].[Modules]
WHERE
 [ModuleName] = @ModuleName --AND PortalID = @PortalID

END





GO
