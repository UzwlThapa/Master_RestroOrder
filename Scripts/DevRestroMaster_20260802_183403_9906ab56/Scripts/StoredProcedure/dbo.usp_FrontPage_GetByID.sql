SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_FrontPage_GetByID] @id int AS SELECT id,description,PortalID,UserModuleID,Culture from FrontPage WHERE id= @id

GO
