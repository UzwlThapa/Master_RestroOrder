SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--usp_getRoomNoByRoomType 2
--drop procedure getRoomNoByRoomType
CREATE PROCEDURE [dbo].[usp_getRoomNoByRoomType] @RoomTypeID INT
AS
SELECT restrotableId
	,restrotableTitle
FROM dbo.RO_restroTable
WHERE dbo.RO_restroTable.IsTable = 0
	AND restroRoomId = @RoomTypeID

GO
