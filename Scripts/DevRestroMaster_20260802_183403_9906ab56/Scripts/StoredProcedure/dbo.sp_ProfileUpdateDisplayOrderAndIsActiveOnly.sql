SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProfileUpdateDisplayOrderAndIsActiveOnly]
 @ProfileID INT, 
 @DisplayOrder INT, 
 @IsActive BIT, 
 @UpdatedOn DATETIME, 
 @PortalID INT, 
 @UpdatedBy NVARCHAR(256) 
AS
UPDATE [dbo].[Profile] SET
 [DisplayOrder] = @DisplayOrder,
 [IsActive] = @IsActive,
 [IsModified] = 1, 
 [UpdatedOn] = @UpdatedOn,  
 [UpdatedBy] = @UpdatedBy 
WHERE
 [ProfileID] = @ProfileID and [PortalID] = @PortalID





GO
