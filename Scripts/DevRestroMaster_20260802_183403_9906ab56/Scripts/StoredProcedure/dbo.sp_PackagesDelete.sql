SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PackagesDelete]
 @PackageID int,
 @DeletedBy nvarchar(256),
 @PortalID int
AS

UPDATE [dbo].[Packages] SET
 [IsDeleted] = 1, 
 [DeletedOn] = getdate(), 
 [DeletedBy] = @DeletedBy
WHERE
 [PackageID] = @PackageID
 --AND [PortalID]=@PortalID





GO
