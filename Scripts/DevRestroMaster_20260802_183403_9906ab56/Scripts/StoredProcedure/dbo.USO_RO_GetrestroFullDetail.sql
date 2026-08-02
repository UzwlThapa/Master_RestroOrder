SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USO_RO_GetrestroFullDetail]
AS
SELECT * FROM dbo.RO_restroTable rt 
JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId = rt.restroRoomId
JOIN dbo.Ro_RoomType rmt ON rmt.RoomTypeID = rr.RoomTypeID




GO
