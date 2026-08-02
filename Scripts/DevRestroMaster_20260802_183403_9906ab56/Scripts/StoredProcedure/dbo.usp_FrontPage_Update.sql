SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_FrontPage_Update] @id int,@description nvarchar(max) AS UPDATE [dbo].[FrontPage]  SET id=  @id,description=  @description WHERE  id= @id

GO
