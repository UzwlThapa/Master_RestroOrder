SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_rename USP_RO_GetTableByRoomTypeId 3,'USP_RO_GetTableByRoomTypeId_backup2'
-- drop PROCEDURE [USP_RO_GetOccupiedTable];
CREATE PROCEDURE [dbo].[USP_RO_GetOccupiedTable]
AS
IF OBJECT_ID('tempdb..#MaxOrderMaster') IS NOT NULL
    DROP TABLE #MaxOrderMaster;

IF OBJECT_ID('tempdb..#RoomBooking') > 0
    DROP TABLE #RoomBooking;


SELECT om.TableId,
       MAX(om.OrderMasterID) OrderMasterId
INTO #MaxOrderMaster
FROM dbo.RO_OrderMasters om
WHERE ISNULL(BillPaid, 0) = 0
      AND ISNULL(IsCancelled, 0) = 0
GROUP BY TableId;

SELECT rb.TableId,
       MAX(rb.OrderMasterId) OrderMasterId
INTO #RoomBooking
FROM Ro_RoomBookings rb
    INNER JOIN RO_OrderMasters om
        ON om.OrderMasterID = rb.OrderMasterId
WHERE rb.BookedFrom <= GETDATE()
      AND rb.BookedTo >= GETDATE()
      AND om.BillPaid != 1
      AND om.IsCancelled != 1
GROUP BY rb.TableId;

SELECT rt.restrotableId,
       rt.restrotableTitle,
       rt.restroRoomId,
       CASE
           WHEN om.OrderCount > 0 THEN
               7
           ELSE
               rt.restrotablesStatusID
       END restrotablesStatusID,
       rt.Seatcap,
       rt.IsTable,
       rt.Rate,
       CONVERT(CHAR(5), om.[Date], 108) TableTime,
       om.[Date] TableDate,
       (CASE
            WHEN
            (
                rt.restrotablesStatusID = 7
                AND om.BillPaid IS NULL
            ) THEN
                1
            ELSE
                ISNULL(om.BillPaid, 0)
        END
       ) AS BillPaid,
       om.IsCancelled,
       rr.restroRoom,
       mt.MergeID,
       mt.TableID,
       --rt.IsTable,
       ISNULL(mt.MergeTableList, 0) AS MergeTableList,
       (
           SELECT STUFF(
                           (
                               SELECT '/' + restrotableTitle
                               FROM RO_restroTable mrt
                                   INNER JOIN RO_MergeTable mtm
                                       ON mrt.restrotableId = mtm.TableID
                               WHERE mtm.MergeTableList = mt.TableID
                               FOR XML PATH(''), TYPE
                           ).value('.', 'NVARCHAR(MAX)'),
                           1,
                           1,
                           ''
                       )
       ) AS MergeTableName,
       rb.OrderMasterId,
       om.GuestNo
INTO #temp
FROM dbo.RO_restroTable rt
    INNER JOIN dbo.RO_RestroRoom rr
        ON rr.restroRoomId = rt.restroRoomId
    LEFT JOIN dbo.RO_MergeTable mt
        ON mt.TableID = rt.restrotableId
    LEFT JOIN
    (
        SELECT m.OrderMasterID,
               m.TableId,
               m.BillPaid,
               m.[Date],
               m.IsCancelled,
               COUNT(d.OrderDetailsID) AS OrderCount,
               m.GuestNo
        FROM dbo.RO_OrderMasters m
            INNER JOIN #MaxOrderMaster mom
                ON mom.TableId = m.TableId
            INNER JOIN RO_Order_Detail d
                ON d.OrderMasterId = mom.OrderMasterId
                   AND d.IsCancelled = 0
                   AND mom.OrderMasterId = m.OrderMasterID
        GROUP BY m.OrderMasterID,
                 m.TableId,
                 m.BillPaid,
                 m.[Date],
                 m.IsCancelled,
                 m.GuestNo
    ) om
        ON om.TableId = rt.restrotableId
    LEFT JOIN #RoomBooking rb
        ON rt.restrotableId = rb.TableId
    LEFT JOIN dbo.RO_restroTable mrt
        ON mrt.restrotableId = mt.MergeTableList
WHERE rt.restrotablesStatusID <> 6
      AND rt.IsTable = 1;

SELECT restrotableId,
       CASE
           WHEN MergeTableList = 0 THEN
               restrotableTitle
           ELSE
               MergeTableName
       END AS restrotableTitle,
       restroRoomId,
       restrotablesStatusID,
       Seatcap,
       Rate,
       TableTime,
       TableDate,
       BillPaid,
       IsCancelled,
       restroRoom,
       MergeID,
       TableID,
       #temp.IsTable,
       MergeTableList,
       MergeTableName,
       OrderMasterId,
       GuestNo
FROM #temp;




GO
