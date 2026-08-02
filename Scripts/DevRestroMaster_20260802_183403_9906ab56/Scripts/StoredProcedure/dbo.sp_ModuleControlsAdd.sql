SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ModuleControlsAdd]
 @ModuleControlID INT OUTPUT,
 @ModuleDefID INT,
 @ControlKey NVARCHAR(50),
 @ControlTitle NVARCHAR(50),
 @ControlSrc NVARCHAR(256),
 @IconFile NVARCHAR(100),
 @ControlType INT,
 @DisplayOrder INT,
 @HelpUrl NVARCHAR(200),
 @SupportsPartialRendering BIT,
 @IsActive BIT,
 @AddedOn DATETIME,
 @PortalID INT,
 @AddedBy NVARCHAR(256)
AS
SET @PortalID = 1

INSERT INTO [dbo].[ModuleControls] (
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
 [AddedOn],
 [PortalID],
 [AddedBy]
) VALUES (
 @ModuleDefID,
 @ControlKey,
 @ControlTitle,
 @ControlSrc,
 @IconFile,
 @ControlType,
 @DisplayOrder,
 @HelpUrl,
 @SupportsPartialRendering,
 @IsActive,
 @AddedOn,
 @PortalID,
 @AddedBy
)

SET @ModuleControlID=SCOPE_IDENTITY()





GO
