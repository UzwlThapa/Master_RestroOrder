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

-- EXEC  [Usp_getGetReservedTable]

*/
ALTER PROCEDURE [dbo].[Usp_getGetReservedTable]
AS
    SELECT   TR.ReservedDateTime ,
             TR.ReservedOn ,
             TR.ReservedBy ,
             TR.IsConfirmed ,
             TR.ReservationID ,
             TR.CustomerName ,
             TR.Phone ,
             TR.NoOfPeople ,
             TR.Note ,
             ISNULL (TR.NotifyBefore, 0) AS NotifyBefore ,
             STUFF (( SELECT   ',' + tbl.restrotableTitle
                      FROM     RO_ReservedTable RT
                               INNER JOIN RO_restroTable tbl ON tbl.restrotableId = RT.TableID
                      WHERE    RT.ReservationID = TR.ReservationID
                      ORDER BY TR.ReservationID
                    FOR XML PATH ('')) ,
                    1 ,
                    1 ,
                    '') AS Tablename
    FROM     RO_TableReservation TR
    WHERE    ( TR.IsCancelled IS NULL
            OR TR.IsCancelled = 0 )
    AND      TR.ReservedDateTime > GETDATE ()
    ORDER BY TR.ReservedDateTime ASC;
GO

