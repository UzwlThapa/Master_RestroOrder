SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_TableLayout_GetallData]  @PortalID int,@UserModuleID int,@Culture nvarchar(50) AS SELECT id,name,PortalID,UserModuleID,Culture FROM TableLayout WHERE PortalID = @PortalID AND UserModuleID = @UserModuleID AND Culture = @Culture



GO
