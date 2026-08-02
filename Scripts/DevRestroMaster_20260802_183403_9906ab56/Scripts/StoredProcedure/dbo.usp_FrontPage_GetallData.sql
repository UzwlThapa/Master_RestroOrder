SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_FrontPage_GetallData]  @PortalID int,@UserModuleID int,@Culture nvarchar(50) AS SELECT id,description,PortalID,UserModuleID,Culture FROM FrontPage WHERE PortalID = @PortalID AND UserModuleID = @UserModuleID AND Culture = @Culture

GO
