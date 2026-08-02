SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProfileAdd]
 @ProfileID INT OUTPUT,
 @Name NVARCHAR(100),
 @PropertyTypeID INT,
 @DataType NVARCHAR(15),
 @IsRequired BIT,
 @IsActive BIT, 
 @AddedOn DATETIME, 
 @PortalID INT,
 @AddedBy NVARCHAR(256)
AS
DECLARE @DisplayOrder INT
SET @DisplayOrder = 0
SELECT @DisplayOrder = (ISNULL(MAX(DisplayOrder),0) + 1) 
FROM [dbo].[Profile]
INSERT INTO [dbo].[Profile] (
 [Name],
 [PropertyTypeID],
 [DataType],
 [IsRequired],
 [DisplayOrder], 
 [IsActive], 
 [AddedOn], 
 [PortalID],
 [AddedBy]
) VALUES (
 @Name,
 @PropertyTypeID,
 @DataType,
 @IsRequired,
 @DisplayOrder,
 @IsActive, 
 @AddedOn, 
 @PortalID,
 @AddedBy
)
SET @ProfileID = SCOPE_IDENTITY()





GO
