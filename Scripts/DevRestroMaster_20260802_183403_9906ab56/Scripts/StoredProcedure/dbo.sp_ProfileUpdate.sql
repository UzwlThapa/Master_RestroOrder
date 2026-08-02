SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProfileUpdate]
 @ProfileID INT, 
 @Name NVARCHAR(100), 
 @PropertyTypeID INT,
 @DataType NVARCHAR(15), 
 @IsRequired BIT,
 @IsActive BIT, 
 @IsModified BIT, 
 @UpdatedOn DATETIME, 
 @PortalID INT, 
 @UpdatedBy NVARCHAR(256) 
AS
UPDATE [dbo].[Profile] SET
 [Name] = @Name,
 [PropertyTypeID] = @PropertyTypeID,
 [DataType] = @DataType,
 [IsRequired] = @IsRequired,
 [IsActive] = @IsActive, 
 [IsModified] = @IsModified, 
 [UpdatedOn] = @UpdatedOn, 
 [PortalID] = @PortalID, 
 [UpdatedBy] = @UpdatedBy 
WHERE
 [ProfileID] = @ProfileID





GO
