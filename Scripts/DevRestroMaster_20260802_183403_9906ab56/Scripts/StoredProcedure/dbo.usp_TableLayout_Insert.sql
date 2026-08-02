SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_TableLayout_Insert] @name nvarchar(256),@PortalID int,@UserModuleID int,@Culture nvarchar(50) AS   INSERT INTO [dbo].[TableLayout](name,PortalID,UserModuleID,Culture) VALUES (@name,@PortalID,@UserModuleID,@Culture)



GO
