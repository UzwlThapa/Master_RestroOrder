SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--usp_H_GetRoomName
CREATE PROCEDURE [dbo].[usp_H_GetRoomName] 
--@Roomvalue varchar(128)
	--select * from Ro_RoomType
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT restrotableId as RoomID,restrotableTitle as RoomType from RO_restroTable

	SELECT restroRoom as Roomvalue,restroRoomId as RoomTypeID from RO_RestroRoom
END

GO
