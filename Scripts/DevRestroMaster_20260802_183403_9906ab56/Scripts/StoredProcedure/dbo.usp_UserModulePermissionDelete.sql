SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserModulePermissionDelete] (
 @UserModuleID INT,
 @PortalID INT
) AS
BEGIN

SET nocount ON ; DELETE
FROM
 UserModulePermission
WHERE
 UserModuleID =@UserModuleID
AND PortalID =@PortalID
END





GO
