SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_deleteDependentRoomsAndTables] @id INT
	,@type INT
AS
BEGIN
	IF (@type = 1)
	BEGIN
		DELETE
		FROM RO_restroTable
		WHERE restroRoomId = @id

		DELETE
		FROM RO_RestroRoom
		WHERE restroRoomId = @id
	END

	IF (@type = 2)
	BEGIN
		DELETE
		FROM RO_restroTable
		WHERE restroRoomId IN (
				SELECT restroRoomId
				FROM RO_RestroRoom
				WHERE RoomTypeID = @id
				)

		DELETE
		FROM RO_RestroRoom
		WHERE RoomTypeID = @id

		DELETE
		FROM Ro_RoomType
		WHERE RoomTypeID = @id
	END
END




GO
