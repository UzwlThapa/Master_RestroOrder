SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_getGetReservedTableinFront]
AS
SELECT * FROM (
select TR.ReservedDateTime, TR.CustomerName, TR.Phone, TR.NoOfPeople,DATEDIFF(minute, getdate(), TR.ReservedDateTime) as Time,
Tablename = STUFF((SELECT ',' + tbl.restrotableTitle
     FROM RO_ReservedTable RT
inner Join RO_restroTable tbl on tbl.restrotableId = RT.TableID
           WHERE RT.ReservationID = TR.ReservationID
		     order by TR.ReservationID
        for xml path('')
    ),1,1,'')
 from RO_TableReservation TR
where (TR.IsCancelled is null or TR.IsCancelled = 0)
and getdate() between DATEADD(MINUTE, isnull(-(TR.NotifyBefore),0), TR.ReservedDateTime)  and TR.ReservedDateTime

UNION ALL 

select BookedFrom [ReservedDateTime],CustomerName,PhoneNo [Phone], 1 [NoOfPeople],DATEDIFF(minute, getdate(), BookedFrom) as Time, RO_restroTable.restrotableTitle [TableName] from Ro_RoomBookings 
INNER JOIN RO_restroTable ON Ro_RoomBookings.TableId = RO_restroTable.restrotableId
Where BookedFrom > GETDATE()
) as t

GO
