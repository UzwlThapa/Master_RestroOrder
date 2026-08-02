SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_TableLayout_DeleteByID]  @id int AS  DELETE FROM [dbo].[TableLayout] WHERE  id= @id



GO
