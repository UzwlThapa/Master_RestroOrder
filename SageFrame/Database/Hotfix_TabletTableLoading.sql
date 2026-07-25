/* ==========================================================================================
   HOTFIX 3: UNIFY TABLE FETCHING LOGIC (CRITICAL FOR TABLET LOADING)
   Problem: USP_RO_GetTableByRoomTypeId (used by Tablet) filters too aggressively, returning 
            NULLs for empty tables, causing JSON parsing errors in the APK.
   Solution: Replace the old logic with the robust 'Web' version that guarantees non-null 
             defaults for all columns (OrderMasterId, BillPaid, GuestNo).
   ========================================================================================== */

PRINT 'Patching USP_RO_GetTableByRoomTypeId for Tablet Stability...';
GO

-- Drop the old, fragile procedure
IF OBJECT_ID('[dbo].[USP_RO_GetTableByRoomTypeId]') IS NOT NULL
    DROP PROCEDURE [dbo].[USP_RO_GetTableByRoomTypeId];
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

-- Recreate with Robust Logic (Merged from USP_RO_GetTableByRoomTypeIdWeb)
CREATE PROCEDURE [dbo].[USP_RO_GetTableByRoomTypeId] 
    @RoomTypeId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Safe: GROUP BY guarantees one row per TableId (regardless of Order Status)
    SELECT om.TableId,
           MAX(om.OrderMasterID) AS OrderMasterId
    INTO #MaxOrderMaster
    FROM dbo.RO_OrderMasters om
    GROUP BY om.TableId;

    -- Safe: Handle active bookings
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

    -- VERIFIED FIX: ROW_NUMBER approach to get latest SalesMaster
    -- Guarantees 1 row per OrderMasterId - stops split bill multiplication
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

    -- MAIN SELECT: Returns ALL tables, with safe defaults for NULLs
    SELECT rt.restrotableId,
           rt.restrotableTitle,
           rt.restroRoomId,
           rt.restrotablesStatusID,
           rt.Seatcap,
           rt.IsTable,
           rt.Rate,
           CONVERT(CHAR(5), COALESCE(om.[Date], rb.BookedFrom), 108) AS TableTime,
           COALESCE(om.[Date], rb.BookedFrom) AS TableDate,
           -- Safe BillPaid Calculation: Defaults to 0 if no order exists
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
           ISNULL(om.IsCancelled, 0) AS IsCancelled,
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
           -- CRITICAL FIX: COALESCE ensures OrderMasterId is never NULL (defaults to 0)
           ISNULL(rb.OrderMasterId, ISNULL(omm.OrderMasterId, 0)) AS OrderMasterId,
           ISNULL(om.GuestNo, 1) AS GuestNo, -- Default GuestNo to 1
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
        LEFT JOIN dbo.RO_MergeTable mt
            ON mt.TableID = rt.restrotableId
               AND mt.MergeTableList <> 0
        LEFT JOIN #RoomBooking rb
            ON rt.restrotableId = rb.TableId
        LEFT JOIN dbo.RO_restroTable mrt
            ON mrt.restrotableId = mt.MergeTableList
        LEFT JOIN #MaxOrderMaster omm
            ON omm.TableId = rt.restrotableId
        LEFT JOIN #LatestSalesMaster rsm
            ON rsm.OrderMasterId = omm.OrderMasterId
        LEFT JOIN dbo.RO_OrderMasters AS om
            ON om.OrderMasterID = omm.OrderMasterId
        OUTER APPLY
    (
        SELECT mom.OrderMasterId
        FROM #MaxOrderMaster AS mom
            INNER JOIN #LatestSalesMaster AS rsm2
                ON rsm2.OrderMasterId = mom.OrderMasterId
        WHERE ISNULL(rsm2.IsUpdated, 0) = 1
              AND mom.TableId = rt.restrotableId
    ) AS t
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
END
GO
