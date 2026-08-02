SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserModulesUpdate] 
(@UserModuleID INT,
 @ModuleDefID INT,
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
 @ShowHeaderText BIT )AS
BEGIN

SET NOCOUNT ON ; 
UPDATE dbo.UserModules
SET AllPages =@AllPages,
 ShowInPages =@ShowInPages,
 InheritViewPermissions =@InheritViewPermissions,
 IsActive =@IsActive,
 IsHandheld =@IsHandheld,
 UserModuleTitle =@UserModuleTitle,
 SuffixClass =@SuffixClass,
 HeaderText =@HeaderText,
 ShowHeaderText =@ShowHeaderText
WHERE
 UserModuleID =@UserModuleID
AND PortalID =@PortalID
END





GO
