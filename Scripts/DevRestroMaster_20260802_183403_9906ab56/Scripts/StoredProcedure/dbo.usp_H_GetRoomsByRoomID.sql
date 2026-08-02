SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_H_GetRoomsByRoomID]
@restroRoomID int 
	--select * from Ro_RoomType
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT rt.restrotableId as RoomID,rt.restrotableTitle as RoomType from RO_restroTable rt
	join RO_RestroRoom  rr
	on rt.restroRoomId = rr.restroRoomId
	where rr.restroRoomId = @restroRoomID
END


GO
