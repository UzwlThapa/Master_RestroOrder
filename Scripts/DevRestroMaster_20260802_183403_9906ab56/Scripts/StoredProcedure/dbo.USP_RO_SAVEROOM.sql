SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--create table RO_restroTable
--(
--	restrotableId int primary key identity(1,1),
--	restrotableTitle varchar(128)
--)

CREATE PROCEDURE [dbo].[USP_RO_SAVEROOM]
@restroRoomId int,
@restroRoom varchar(128),
@RoomTypeID int
as
begin
	if(@restroRoomId=0)
	begin
	insert into RO_RestroRoom(restroRoom, RoomTypeID) values(@restroRoom, @RoomTypeID)
	end
	else
	begin
		update RO_RestroRoom set
		restroRoom=@restroRoom,
		RoomTypeID = @RoomTypeID
		where restroRoomId=@restroRoomId
	end
end






GO
