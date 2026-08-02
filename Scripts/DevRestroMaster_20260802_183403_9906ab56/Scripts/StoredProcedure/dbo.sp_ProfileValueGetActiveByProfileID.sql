SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProfileValueGetActiveByProfileID]
 @ProfileID INT,
 @PortalID INT
AS
BEGIN
SELECT
 [ProfileValueID],
 [ProfileID],
 [Name],
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
FROM [dbo].[ProfileValue]
WHERE
 [ProfileID]=@ProfileID And PortalID = @PortalID And [IsActive] = 1 And [IsDeleted] = 0
 
END





GO
