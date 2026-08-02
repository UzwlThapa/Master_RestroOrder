SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_FrontPage_Insert] @id int,@description nvarchar(max),@PortalID int,@UserModuleID int,@Culture nvarchar(50) AS   INSERT INTO [dbo].[FrontPage](id,description,PortalID,UserModuleID,Culture) VALUES (@id,@description,@PortalID,@UserModuleID,@Culture)

GO
