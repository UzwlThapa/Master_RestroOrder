SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_ModuleDefinitionsUpdate]
 @ModuleDefID INT, 
 @FriendlyName NVARCHAR(128), 
 @DefaultCacheTime INT, 
 @IsActive BIT,  
 @IsModified BIT, 
 @UpdatedOn DATETIME, 
 @PortalID INT,
 @UpdatedBy NVARCHAR(256)
AS
SET @PortalID = 1
BEGIN
 UPDATE dbo.ModuleDefinitions SET
 [FriendlyName] = @FriendlyName,
 [DefaultCacheTime] = @DefaultCacheTime,
 [IsActive] = @IsActive,
 [IsModified] = @IsModified,
 [UpdatedOn] = @UpdatedOn,
 [PortalID] = @PortalID,
 [UpdatedBy] = @UpdatedBy
WHERE
 [ModuleDefID] = @ModuleDefID 
END





GO
