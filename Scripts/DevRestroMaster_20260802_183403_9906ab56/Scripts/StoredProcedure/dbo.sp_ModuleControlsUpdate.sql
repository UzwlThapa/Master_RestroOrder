SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_ModuleControlsUpdate]
 @ModuleControlID INT,  
 @ControlKey NVARCHAR(50), 
 @ControlTitle NVARCHAR(50), 
 @ControlSrc NVARCHAR(256), 
 @IconFile NVARCHAR(100), 
 @ControlType INT, 
 @DisplayOrder INT, 
 @HelpUrl NVARCHAR(200), 
 @SupportsPartialRendering BIT, 
 @IsActive BIT,  
 @IsModified BIT,  
 @UpdatedOn DATETIME,
 @PortalID INT,  
 @UpdatedBy NVARCHAR(256) 
AS
SET @PortalID = 1

BEGIN
 UPDATE dbo.ModuleControls SET
 [ControlKey] = @ControlKey,
 [ControlTitle] = @ControlTitle,
 [ControlSrc] = @ControlSrc,
 [IconFile] = @IconFile,
 [ControlType] = @ControlType,
 [DisplayOrder] = @DisplayOrder,
 [HelpUrl] = @HelpUrl,
 [SupportsPartialRendering] = @SupportsPartialRendering,
 [IsActive] = @IsActive,
 [IsModified] = @IsModified,
 [UpdatedOn] = @UpdatedOn,
 [PortalID] = @PortalID,
 [UpdatedBy] = @UpdatedBy
WHERE
 [ModuleControlID] = @ModuleControlID
END





GO
