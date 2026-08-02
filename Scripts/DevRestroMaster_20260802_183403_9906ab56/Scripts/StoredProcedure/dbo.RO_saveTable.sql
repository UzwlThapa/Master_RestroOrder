SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RO_saveTable] @restrotableId INT
	,@restrotableTitle VARCHAR(128)
	,@restroRoomId INT
	,@SeatNo INT
	,@IsTable BIT
	,@Rate DECIMAL(18, 2)
AS
BEGIN
	IF (@restrotableId = 0)
	BEGIN
		INSERT INTO RO_restroTable (
			restrotableTitle
			,restroRoomId
			,Seatcap
			,restrotablesStatusID
			,IsTable
			,Rate
			)
		VALUES (
			@restrotableTitle
			,@restroRoomId
			,@SeatNo
			,6
			,@IsTable
			,@Rate
			)
	END
	ELSE
	BEGIN
		UPDATE RO_restroTable
		SET restrotableTitle = @restrotableTitle
			,restroRoomId = @restroRoomId
			,Seatcap = @SeatNo
			,IsTable = @IsTable
			,Rate = @Rate
		WHERE restrotableId = @restrotableId
	END
END

----------------------------------------------------------------------



GO
