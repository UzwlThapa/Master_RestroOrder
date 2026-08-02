SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_ClearMergeTableList] @TableId INT
AS
BEGIN
	DECLARE @var INT

	SET @var = (
			SELECT MergeTableList
			FROM RO_MergeTable
			WHERE TableID = @TableId
			)

	UPDATE RO_restroTable
	SET restrotablesStatusID = 6
	WHERE restrotableId IN (
			SELECT TableID
			FROM RO_MergeTable
			WHERE MergeTableList = @var
			)
		AND restrotableId != @var

	UPDATE dbo.RO_MergeTable
	SET MergeTableList = 0
	WHERE MergeTableList = @var
END




GO
