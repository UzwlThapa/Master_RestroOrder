GO
CREATE TABLE [dbo].[FrontPage]( id int NOT NULL  PRIMARY KEY , description nvarchar(max) NOT NULL, PortalID int NOT NULL, UserModuleID int NOT NULL, Culture nvarchar(50) NOT NULL )
GO
CREATE PROCEDURE [dbo].[usp_FrontPage_GetallData]  @PortalID int,@UserModuleID int,@Culture nvarchar(50) AS SELECT id,description,PortalID,UserModuleID,Culture FROM FrontPage WHERE PortalID = @PortalID AND UserModuleID = @UserModuleID AND Culture = @Culture
GO
CREATE PROCEDURE [dbo].[usp_FrontPage_GetByID] @id int AS SELECT id,description,PortalID,UserModuleID,Culture from FrontPage WHERE id= @id
GO
CREATE PROCEDURE [dbo].[usp_FrontPage_DeleteByID]  @id int AS  DELETE FROM [dbo].[FrontPage] WHERE  id= @id
GO
CREATE PROCEDURE [dbo].[usp_FrontPage_Insert] @id int,@description nvarchar(max),@PortalID int,@UserModuleID int,@Culture nvarchar(50) AS   INSERT INTO [dbo].[FrontPage](id,description,PortalID,UserModuleID,Culture) VALUES (@id,@description,@PortalID,@UserModuleID,@Culture)
GO
CREATE PROCEDURE [dbo].[usp_FrontPage_Update] @id int,@description nvarchar(max) AS UPDATE [dbo].[FrontPage]  SET id=  @id,description=  @description WHERE  id= @id
