SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetMergedTables] @tableId INT
AS
BEGIN
	SELECT mt.*
		,rt.restrotableTitle AS TableName
	FROM RO_MergeTable mt
	INNER JOIN RO_restroTable rt ON mt.TableID = rt.restrotableId
	WHERE MergeTableList = (
			SELECT MergeTableList
			FROM RO_MergeTable
			WHERE TableID = @tableId
			)
END




GO
