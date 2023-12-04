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

-- EXEC  Usp_getGetReservedTableReport

*/
ALTER PROCEDURE [dbo].[Usp_getGetReservedTableReport]
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @CustomerName NVARCHAR (250) ,
    @TableID INT = 0
AS
    SELECT   DISTINCT TR.ReservedDateTime ,
                      TR.ReservedOn ,
                      TR.ReservedBy ,
                      TR.IsConfirmed ,
                      TR.ReservationID ,
                      TR.CustomerName ,
                      TR.Phone ,
                      TR.NoOfPeople ,
                      ISNULL (TR.NotifyBefore, 0) AS NotifyBefore ,
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
    FROM     RO_TableReservation TR
             LEFT JOIN RO_ReservedTable rrt ON rrt.ReservationID = TR.ReservationID
    WHERE    ( TR.IsCancelled IS NULL
            OR TR.IsCancelled = 0 )
    AND      ( CAST(TR.ReservedDateTime AS DATE) >= @StartDate
            OR @StartDate = 0
            OR @StartDate IS NULL
            OR @StartDate = '' )
    AND      ( CAST(TR.ReservedDateTime AS DATE) <= @EndDate
            OR @EndDate = 0
            OR @EndDate IS NULL
            OR @EndDate = '' )
    AND      ( TR.CustomerName LIKE '%' + @CustomerName + '%'
            OR @CustomerName = ''
            OR @CustomerName IS NULL )
    AND      ( rrt.TableID = @TableID
            OR @TableID = 0 )
    ORDER BY TR.ReservedDateTime ASC;

GO

