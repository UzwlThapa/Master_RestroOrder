SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProfileGetByProfileID]
 @ProfileID INT
AS
SELECT
 [ProfileID],
 [Name],
 [PropertyTypeID],
 [DataType],
 [IsRequired],
 [DisplayOrder],
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
FROM [dbo].[Profile]
WHERE
 [ProfileID] = @ProfileID





GO
