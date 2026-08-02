SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  
-- Create date: 2010-04-19
-- Description: Log Viewer Module
-- =============================================

CREATE PROCEDURE [dbo].[sp_LogDeleteByLogID]
 @LogID INT,
 @PortalID INT,
 @DeletedBy NVARCHAR(256)
AS

UPDATE [dbo].[Log] SET
[IsDeleted] = 1,
[DeletedOn] = GETDATE(),
[DeletedBy] = @DeletedBy
WHERE
 [LogID] = @LogID AND PortalID=@PortalID





GO
