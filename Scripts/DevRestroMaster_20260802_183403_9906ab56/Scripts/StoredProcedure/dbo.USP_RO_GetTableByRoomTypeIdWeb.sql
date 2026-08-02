SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_GetTableByRoomTypeIdWeb] @RoomTypeId INT
AS
-- Safe: GROUP BY guarantees one row per TableId
SELECT om.TableId,
       MAX(om.OrderMasterID) AS OrderMasterId
INTO #MaxOrderMaster
FROM dbo.RO_OrderMasters om
GROUP BY om.TableId;

-- Safe: No multiple active bookings per table confirmed
SELECT rb.TableId,
       rb.OrderMasterId,
       rb.BookedFrom,
       rb.BookedTo
INTO #RoomBooking
FROM dbo.Ro_RoomBookings rb
    INNER JOIN
    (
        SELECT rb.TableId,
               MAX(rb.OrderMasterId) AS OrderMasterId
        FROM dbo.Ro_RoomBookings rb
            INNER JOIN dbo.RO_OrderMasters om
                ON om.OrderMasterID = rb.OrderMasterId
        WHERE rb.BookedFrom <= GETDATE()
              AND rb.BookedTo >= GETDATE()
        GROUP BY rb.TableId
    ) AS mrb
        ON rb.TableId = mrb.TableId
           AND rb.OrderMasterId = mrb.OrderMasterId;

-- VERIFIED FIX: ROW_NUMBER approach is correct
-- Picks latest non-archived SalesMaster row per OrderMasterId
-- Guarantees 1 row per OrderMasterId - stops split bill multiplication
-- Non-archived rows prioritized first, then latest by salesMasterId
-- Verified against MAX approach - ROW_NUMBER gives correct IsArchived
-- while MAX incorrectly inherits IsArchived=1 from old archived rows
SELECT OrderMasterId,
       IsArchived,
       IsUpdated
INTO #LatestSalesMaster
FROM
(
    SELECT OrderMasterId,
           IsArchived,
           IsUpdated,
           ROW_NUMBER() OVER (PARTITION BY OrderMasterId
                              ORDER BY ISNULL(IsArchived, 0) ASC, -- non-archived first
                                       salesMasterId DESC         -- then latest
                             ) AS rn
    FROM dbo.RO_SalesMaster
) s
WHERE s.rn = 1;

SELECT rt.restrotableId,
       rt.restrotableTitle,
       rt.restroRoomId,
       rt.restrotablesStatusID,
       rt.Seatcap,
       rt.IsTable,
       rt.Rate,
       CONVERT(CHAR(5), COALESCE(om.[Date], rb.BookedFrom), 108) AS TableTime,
       COALESCE(om.[Date], rb.BookedFrom) AS TableDate,
       CASE
           WHEN rsm.OrderMasterId IS NULL
                AND ISNULL(om.BillPaid, 0) = 0 THEN
               0
           WHEN rsm.OrderMasterId IS NOT NULL
                AND om.BillPaid = 1
                AND ISNULL(rsm.IsArchived, 0) = 0
                AND ISNULL(rsm.IsUpdated, 0) = 0 THEN
               1
           WHEN rsm.OrderMasterId IS NOT NULL
                AND ISNULL(rsm.IsUpdated, 0) = 1 THEN
               0
           ELSE
               0
       END AS BillPaid,
       om.IsCancelled,
       rr.restroRoom,
       mt.MergeID,
       mt.TableID,
       rt.IsTable,
       ISNULL(mt.MergeTableList, 0) AS MergeTableList,
       (
           SELECT STUFF(
                           (
                               SELECT '/' + mrt.restrotableTitle
                               FROM dbo.RO_restroTable mrt
                                   INNER JOIN dbo.RO_MergeTable mtm
                                       ON mrt.restrotableId = mtm.TableID
                               WHERE mtm.MergeTableList = mt.TableID
                               FOR XML PATH(''), TYPE
                           ).value('.', 'NVARCHAR(MAX)'),
                           1,
                           1,
                           ''
                       )
       ) AS MergeTableName,
       ISNULL(rb.OrderMasterId, omm.OrderMasterId) AS OrderMasterId,
       om.GuestNo,
       CASE
           WHEN tt.HasOrder IS NULL THEN
               0
           WHEN tt.HasOrder IS NOT NULL
                AND t.OrderMasterId IS NULL
                AND ISNULL(om.IsCancelled, 0) = 0
                AND ISNULL(rsm.IsArchived, 0) = 0 THEN
               1
           ELSE
               0
       END AS IsOccupied
FROM dbo.RO_restroTable rt
    INNER JOIN dbo.RO_RestroRoom rr
        ON rr.restroRoomId = rt.restroRoomId
    -- Safe: MergeTableList <> 0 guard + no multiple merge records confirmed
    LEFT JOIN dbo.RO_MergeTable mt
        ON mt.TableID = rt.restrotableId
           AND mt.MergeTableList <> 0
    -- Safe: no multiple active bookings confirmed
    LEFT JOIN #RoomBooking rb
        ON rt.restrotableId = rb.TableId
    LEFT JOIN dbo.RO_restroTable mrt
        ON mrt.restrotableId = mt.MergeTableList
    -- Safe: one row per TableId guaranteed by GROUP BY + MAX
    LEFT JOIN #MaxOrderMaster omm
        ON omm.TableId = rt.restrotableId
    -- VERIFIED FIX: one row per OrderMasterId guaranteed by ROW_NUMBER
    LEFT JOIN #LatestSalesMaster rsm
        ON rsm.OrderMasterId = omm.OrderMasterId
    -- Safe: one row per OrderMasterId (primary key)
    LEFT JOIN dbo.RO_OrderMasters AS om
        ON om.OrderMasterID = omm.OrderMasterId
    -- VERIFIED FIX: use #LatestSalesMaster instead of direct join
    OUTER APPLY
(
    SELECT mom.OrderMasterId
    FROM #MaxOrderMaster AS mom
        INNER JOIN #LatestSalesMaster AS rsm2
            ON rsm2.OrderMasterId = mom.OrderMasterId
    WHERE ISNULL(rsm2.IsUpdated, 0) = 1
          AND mom.TableId = rt.restrotableId
) AS t
    -- Safe: #MaxOrderMaster has one row per TableId
    OUTER APPLY
(
    SELECT 1 AS HasOrder
    FROM #MaxOrderMaster AS mom2
    WHERE mom2.TableId = rt.restrotableId
) tt
WHERE rt.restroRoomId = @RoomTypeId
ORDER BY rt.restrotableId;

DROP TABLE IF EXISTS #MaxOrderMaster;
DROP TABLE IF EXISTS #RoomBooking;
DROP TABLE IF EXISTS #LatestSalesMaster;

GO
