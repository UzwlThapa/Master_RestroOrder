SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserModulesAdd] 
(@ModuleDefID INT,
 @UserModuleTitle NVARCHAR (256),
 @AllPages BIT,
 @ShowInPages NVARCHAR (256),
 @InheritViewPermissions BIT,
 @IsActive BIT,
 @AddedOn DATETIME,
 @PortalID INT,
 @AddedBy NVARCHAR (256),
 @SEOName NVARCHAR (100),
 @IsHandheld BIT,
 @SuffixClass NVARCHAR (200),
 @HeaderText NVARCHAR (500),
 @ShowHeaderText BIT,
 @IsInAdmin BIT,
 @UserModuleID INT = NULL OUTPUT,
 @ControlCount INT = NULL OUTPUT )
 AS
 BEGIN

  INSERT INTO dbo.UserModules (
 [ModuleDefID],
 [UserModuleTitle],
 [AllPages],
 [ShowInPages],
 [InheritViewPermissions],
 [IsActive],
 [AddedOn],
 [PortalID],
 [AddedBy],
 [SEOName],
 [IsHandheld],
 [SuffixClass],
 [HeaderText],
 [ShowHeaderText],
 [IsInAdmin]
)
VALUES
 (
  @ModuleDefID,
  @UserModuleTitle,
  @AllPages,
  @ShowInPages,
  @InheritViewPermissions,
  @IsActive,
  getdate(),
  @PortalID,
  @AddedBy,
  @SEOName,
  @IsHandheld,
  @SuffixClass,
  @HeaderText,
  @ShowHeaderText,
  @IsInAdmin
 )
SET @UserModuleID = SCOPE_IDENTITY() SELECT
 @ControlCount = COUNT (*)
FROM
 ModuleControls mc
WHERE
 mc.ModuleDefID =@ModuleDefID ; 
 END





GO
