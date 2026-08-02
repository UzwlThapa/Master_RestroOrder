SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProfileList]
 @PortalID INT
AS
BEGIN
SELECT 
dbo.[Profile].ProfileID, 
dbo.[Profile].[Name], 
dbo.[Profile].PropertyTypeID,
dbo.[Profile].[DataType],
dbo.[Profile].[IsRequired], 
CAST((ROW_NUMBER() OVER (ORDER BY dbo.[Profile].DisplayOrder)) AS INT) AS [DisplayOrder], 
dbo.[Profile].IsActive, 
dbo.[Profile].IsDeleted, 
dbo.[Profile].IsModified, 
dbo.[Profile].AddedOn, 
dbo.[Profile].UpdatedOn, 
dbo.[Profile].DeletedOn, 
dbo.[Profile].PortalID, 
dbo.[Profile].AddedBy, 
dbo.[Profile].UpdatedBy, 
dbo.[Profile].DeletedBy, 
dbo.[PropertyType].[Name] AS PropertyTypeName
FROM         
dbo.[Profile] INNER JOIN
dbo.[PropertyType] ON dbo.[Profile].PropertyTypeID = dbo.PropertyType.PropertyTypeID
Where
dbo.[Profile].PortalID = @PortalID AND 
dbo.[Profile].[IsDeleted] = 0 ORDER BY dbo.[Profile].DisplayOrder ASC

END





GO
