SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_H_GetRoomNameByID] 
@Roomvalue int
	--select * from Ro_RoomType
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT restrotableId as RoomID,restrotableTitle as RoomType from RO_restroTable

select rr.restroRoom  as Roomvalue, rr.restroRoomId from RO_RestroRoom  rr
join RO_restroTable rt
on rr.restroRoomId = rt.restroRoomId
where rt.restrotableId = @Roomvalue

END

GO
