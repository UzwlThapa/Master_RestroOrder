SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_MessageTemplateDelete]
 @MessageTemplateID INT,
 @PortalID INT,
 @DeletedOn DATETIME,
 @DeletedBy NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
UPDATE [dbo].[MessageTemplate] SET
 [IsDeleted] = 1,
 [DeletedOn] = @DeletedOn,
 DeletedBy = @DeletedBy
WHERE PortalID=@PortalID AND
 [MessageTemplateID] = @MessageTemplateID





GO
