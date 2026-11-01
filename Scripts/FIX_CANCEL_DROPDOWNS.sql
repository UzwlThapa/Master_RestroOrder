/* =====================================================================
   FIX_CANCEL_DROPDOWNS.sql  --  run ONCE on prod (idempotent)
   ---------------------------------------------------------------------
   Problem: the three "Cancelled Bill / Order Item Cancel" filter
   dropdowns are populated by USP_GetOrderCancelledBY, USP_GetCancelledOrderBY
   and USP_GetOrderCancelResponsible.  The versions that shipped read ONLY
   dbo.Order_Detail_Cancel, so every cake-era cancellation (which lives in
   dbo.RO_OrderMasters with IsCancelled = 1) is missing from the lists and
   the user cannot filter by those names.

   The main report SP (usp_roi_getOrderItemCancelReport) already UNIONs both
   sources, so the dropdowns must offer exactly the same value domain or the
   filter silently returns nothing.

   These scripts use CREATE-or-ALTER (never "IF NOT EXISTS ... CREATE"), so a
   stale prod version is genuinely replaced instead of being skipped.
   Column names verified against:
     Scripts/.../Table/dbo.Order_Detail_Cancel.sql
        ID, CanceledBy, OrderBy, Item, Quantity, Reason, Date, Responsible,
        tableId, orderMasterID
     Scripts/.../Table/dbo.RO_OrderMasters.sql
        OrderMasterID, RoomId, TableId, Date, IsCancelled, UserName,
        CancelReason, CancelBy, CancelDate, OrderNo, OrderTypeID
   Result-set column names are unchanged (CanceledBy / OrderBy / Responsible),
   so RestrOrderProvider's ExecuteAsList<OrderDetailCancel> mapping still works.
   ===================================================================== */
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

---------------------------------------------------------------------
-- 1) "Cancelled By"  -> dbo.USP_GetOrderCancelledBY
---------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[USP_GetOrderCancelledBY]', N'P') IS NULL
    EXEC(N'CREATE PROCEDURE [dbo].[USP_GetOrderCancelledBY] AS SELECT 1;');
GO
ALTER PROCEDURE [dbo].[USP_GetOrderCancelledBY]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT LTRIM(RTRIM(v.Name)) AS CanceledBy
    FROM (
            SELECT odc.CanceledBy AS Name
            FROM dbo.Order_Detail_Cancel odc

            UNION ALL

            SELECT rom.CancelBy AS Name
            FROM dbo.RO_OrderMasters rom
            WHERE rom.IsCancelled = 1
         ) v
    WHERE v.Name IS NOT NULL
      AND LTRIM(RTRIM(v.Name)) <> ''
    ORDER BY CanceledBy;
END
GO

---------------------------------------------------------------------
-- 2) "Ordered By"  -> dbo.USP_GetCancelledOrderBY
--    RO_OrderMasters has no separate "ordered by" column; the waiter on
--    the cancelled master (UserName) is what the report SP exposes as
--    OrderBy, so the dropdown must mirror that.
---------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[USP_GetCancelledOrderBY]', N'P') IS NULL
    EXEC(N'CREATE PROCEDURE [dbo].[USP_GetCancelledOrderBY] AS SELECT 1;');
GO
ALTER PROCEDURE [dbo].[USP_GetCancelledOrderBY]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT LTRIM(RTRIM(v.Name)) AS OrderBy
    FROM (
            SELECT odc.OrderBy AS Name
            FROM dbo.Order_Detail_Cancel odc

            UNION ALL

            SELECT rom.UserName AS Name
            FROM dbo.RO_OrderMasters rom
            WHERE rom.IsCancelled = 1
         ) v
    WHERE v.Name IS NOT NULL
      AND LTRIM(RTRIM(v.Name)) <> ''
    ORDER BY OrderBy;
END
GO

---------------------------------------------------------------------
-- 3) "Responsible"  -> dbo.USP_GetOrderCancelResponsible
---------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[USP_GetOrderCancelResponsible]', N'P') IS NULL
    EXEC(N'CREATE PROCEDURE [dbo].[USP_GetOrderCancelResponsible] AS SELECT 1;');
GO
ALTER PROCEDURE [dbo].[USP_GetOrderCancelResponsible]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT LTRIM(RTRIM(v.Name)) AS Responsible
    FROM (
            SELECT odc.Responsible AS Name
            FROM dbo.Order_Detail_Cancel odc

            UNION ALL

            SELECT rom.UserName AS Name
            FROM dbo.RO_OrderMasters rom
            WHERE rom.IsCancelled = 1
         ) v
    WHERE v.Name IS NOT NULL
      AND LTRIM(RTRIM(v.Name)) <> ''
    ORDER BY Responsible;
END
GO

/* ------------------- quick self-check (optional) -------------------
EXEC dbo.USP_GetOrderCancelledBY;
EXEC dbo.USP_GetCancelledOrderBY;
EXEC dbo.USP_GetOrderCancelResponsible;

-- If any list is still empty while the report itself returns rows, the
-- JS double-parse was the real blocker, not these SPs (see parseResult()).
-------------------------------------------------------------------- */
