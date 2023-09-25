CREATE PROCEDURE [dbo].[usp_getRoomNoByRoomType] @RoomTypeID INT
AS
SELECT restrotableId
	,restrotableTitle
FROM dbo.RO_restroTable
WHERE dbo.RO_restroTable.IsTable = 0
	AND restroRoomId = @RoomTypeID