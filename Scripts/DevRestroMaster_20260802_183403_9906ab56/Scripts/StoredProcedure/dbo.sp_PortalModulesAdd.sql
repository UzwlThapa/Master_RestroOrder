SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PortalModulesAdd]
 -- Add the parameters for the stored procedure here
 @PortalModuleID INT=NULL OUTPUT,
 @PortalID INT,
 @ModuleID INT,
 @IsActive BIT,
 @AddedOn DATETIME,
 @AddedBy NVARCHAR(256)
AS
BEGIN
IF (@PortalID !=1)
 BEGIN
 INSERT INTO dbo.PortalModules (
 [PortalID],
 [ModuleID],
 [IsActive],
 [AddedOn],
 [AddedBy]
) VALUES (
 @PortalID,
 @ModuleID,
 @IsActive,
 @AddedOn,
 @AddedBy
)
SET @PortalModuleID = SCOPE_IDENTITY()
 END
SET @PortalID=1
 INSERT INTO dbo.PortalModules (
 [PortalID],
 [ModuleID],
 [IsActive],
 [AddedOn],
 [AddedBy]
) VALUES (
 @PortalID,
 @ModuleID,
 @IsActive,
 @AddedOn,
 @AddedBy
)
SET @PortalModuleID = SCOPE_IDENTITY()
END





GO
