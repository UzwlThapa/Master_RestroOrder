SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProfileDeleteByProfileID]
 @ProfileID INT,
 @DeletedBy NVARCHAR(256)
AS
UPDATE [dbo].[Profile] SET
 [IsDeleted] = 1,
 [DeletedOn] = GETDATE(),
 [DeletedBy] = @DeletedBy
WHERE
 [ProfileID] = @ProfileID





GO
