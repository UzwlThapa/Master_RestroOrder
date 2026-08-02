SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetSageFramePortalList]
AS
BEGIN
SELECT pr.PortalID, ar.RoleName
FROM dbo.PortalRole pr
INNER JOIN dbo.aspnet_roles ar
ON pr.RoleID=ar.RoleID
END





GO
