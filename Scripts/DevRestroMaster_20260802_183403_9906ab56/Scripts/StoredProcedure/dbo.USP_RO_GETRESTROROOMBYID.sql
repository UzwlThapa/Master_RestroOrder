SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETRESTROROOMBYID]

@restroRoomId int
AS

BEGIN
	SELECT * FROM dbo.RO_RestroRoom where restroRoomId = @restroRoomId
	order by restroRoom
END	




GO
