SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_TableLayout_Update] @id int,@name nvarchar(256) AS UPDATE [dbo].[TableLayout]  SET name=  @name WHERE  id= @id



GO
