SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETROOMBYTABLE]

@TableId int
AS

BEGIN
	SELECT * FROM dbo.RO_RestroRoom inner join dbo.RO_restroTable on RO_RestroRoom.restroRoomId = RO_restroTable.restroRoomId 
	where RO_restroTable.restrotableId = @TableId
END	








GO
