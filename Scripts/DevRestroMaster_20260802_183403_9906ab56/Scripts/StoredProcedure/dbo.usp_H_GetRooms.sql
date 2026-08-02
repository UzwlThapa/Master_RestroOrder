SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_H_GetRooms] 
	--select * from Ro_RoomType
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT restrotableId as RoomID,restrotableTitle as RoomType from RO_restroTable where IsTable = 1
END

GO
