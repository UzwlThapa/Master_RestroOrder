SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 12/3/2023
====================================

-- EXEC  Usp_getGetReservedTableinFront

*/
ALTER PROCEDURE [dbo].Usp_getGetReservedTableinFront
AS
    SELECT t.ReservedDateTime ,
           t.CustomerName ,
           t.Phone ,
           t.NoOfPeople ,
           t.Time ,
           t.Tablename ,
           t.Note
    FROM   ( SELECT TR.ReservedDateTime ,
                    TR.CustomerName ,
                    TR.Phone ,
                    TR.NoOfPeople ,
                    DATEDIFF (MINUTE, GETDATE (), TR.ReservedDateTime) AS Time ,
                    STUFF (( SELECT   ',' + tbl.restrotableTitle
                             FROM     RO_ReservedTable RT
                                      INNER JOIN RO_restroTable tbl ON tbl.restrotableId = RT.TableID
                             WHERE    RT.ReservationID = TR.ReservationID
                             ORDER BY TR.ReservationID
                           FOR XML PATH ('')) ,
                           1 ,
                           1 ,
                           '') AS Tablename ,
                    TR.Note
             FROM   RO_TableReservation TR
             WHERE  ( TR.IsCancelled IS NULL
                   OR TR.IsCancelled = 0 )
             AND    GETDATE () BETWEEN DATEADD (MINUTE, ISNULL (- ( TR.NotifyBefore ), 0), TR.ReservedDateTime) AND TR.ReservedDateTime
             UNION ALL
             SELECT BookedFrom AS [ReservedDateTime] ,
                    CustomerName ,
                    PhoneNo AS [Phone] ,
                    1 AS [NoOfPeople] ,
                    DATEDIFF (MINUTE, GETDATE (), BookedFrom) AS Time ,
                    RO_restroTable.restrotableTitle AS [TableName]
             FROM   Ro_RoomBookings
                    INNER JOIN RO_restroTable ON Ro_RoomBookings.TableId = RO_restroTable.restrotableId
             WHERE  BookedFrom > GETDATE ()) AS t;
GO

