SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getRestroRoom]
AS
SELECT DISTINCT rr.restroRoomId
	,restroRoom
FROM RO_RestroRoom rr
INNER JOIN RO_restroTable rt ON rt.restroRoomId = rr.restroRoomId
	AND rt.IsTable =  0
	order by rr.restroRoom



GO
