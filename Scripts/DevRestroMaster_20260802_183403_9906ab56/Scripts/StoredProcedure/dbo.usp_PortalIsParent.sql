SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PortalIsParent]
@PortalID int
AS
BEGIN
SELECT IsParent From [dbo].[Portal] WHERE PortalID=@PortalID
END





GO
