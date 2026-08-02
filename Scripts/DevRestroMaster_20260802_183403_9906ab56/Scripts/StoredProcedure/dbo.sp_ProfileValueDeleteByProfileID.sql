SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProfileValueDeleteByProfileID]
 @ProfileID INT,
 @PortalID INT,
 @DeletedBy NVARCHAR(256)
AS
UPDATE [dbo].[ProfileValue] SET 
 [IsDeleted] = 1, 
 [DeletedOn] = GETDATE(), 
 [DeletedBy] = @DeletedBy
WHERE
 [ProfileID] = @ProfileID And [PortalID] = @PortalID





GO
