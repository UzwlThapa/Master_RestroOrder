SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetOccupieRooms]
AS
begin
--declare @val varchar(90)
--	set @val= dbo.fn_getMaxMasterId(@TableId)

SELECT distinct rr.* FROM dbo.RO_RestroRoom rr
INNER JOIN dbo.RO_OrderMasters om ON om.RoomId = rr.restroRoomId 
WHERE om.BillPaid = 0 AND om.RoomId != 0 
and om.IsCancelled = 0 and om.TableId = 0
-- and CONVERT(date,om.Date)=CONVERT(DATE,getdate())
end




GO
