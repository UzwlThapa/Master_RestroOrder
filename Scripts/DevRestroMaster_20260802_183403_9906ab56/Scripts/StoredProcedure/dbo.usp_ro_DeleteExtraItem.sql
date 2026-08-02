SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_DeleteExtraItem] @extraItemId INT
	,@deletedBy NVARCHAR(max)
AS
BEGIN
	UPDATE RO_ExtraItem
	SET IsDeleted = 1
		,DeletedBy = @deletedBy
		,deletedon = GETDATE()
	WHERE ExtraItemID = @extraItemId
END

GO
