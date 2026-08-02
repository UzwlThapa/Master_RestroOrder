SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PortalGetByPortalID] 
 @PortalID INT,
 @UserName NVARCHAR(256)
AS
BEGIN
                SELECT POR.*,
    (Select SEOName FROM Portal as Port WHERE Por.ParentID = Port.PortalID  ) AS ParentPortalName
     FROM dbo.Portal POR WHERE PortalID=@PortalID
END





GO
