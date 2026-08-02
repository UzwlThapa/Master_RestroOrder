SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_ClearMergeforTable] @tableId INT
AS
BEGIN
	UPDATE RO_restroTable
	SET restrotablesStatusID = 6
	WHERE restrotableId IN (
			SELECT TableID
			FROM RO_MergeTable
			WHERE MergeTableList = @tableId
			)

	UPDATE RO_MergeTable
	SET MergeTableList = 0
	WHERE MergeTableList = (
			SELECT MergeTableList
			FROM RO_MergeTable
			WHERE TableID = @tableId
			)
END




GO
