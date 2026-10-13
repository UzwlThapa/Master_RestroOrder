/* =====================================================================
   FIX_CANCELLED_REPORTS.sql  —  run AFTER LATESTBUGFIXESSP.sql
   Fixes for:
     1) Cancelled Bill Report (getdailyReport -> USP_CancelledBillREPORTBtoday)
        - HTTP 500: deployed SP still has only 2 params (@startdate,@enddate),
          C# now sends @cancelledby too  -> "too many arguments" error.
        - INNER JOIN CBMS_BillPostLog hid cake / never-posted cancelled bills.
        - Cake cancellations flagged via BillCancelled were excluded by
          om.IsArchived = 1 in some deployments.
     2) Order Item Cancel Report (usp_roi_getOrderItemCancelReport)
        - UNION collapsed legitimate duplicate item rows -> use UNION ALL.
        - DATEADD(HOUR,4,...) shifted the window so today's cancels were
          missing; filter on real date range instead.
   Idempotent: uses ALTER if exists, CREATE otherwise.
   ===================================================================== */

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

/* ---------------------------------------------------------------
   1) USP_CancelledBillREPORTBtoday  (3 params + cake-safe filters)
   --------------------------------------------------------------- */
IF OBJECT_ID('dbo.USP_CancelledBillREPORTBtoday', 'P') IS NOT NULL
    EXEC('CREATE PROCEDURE dbo.USP_CancelledBillREPORTBtoday AS SELECT 1');
GO
ALTER PROCEDURE [dbo].[USP_CancelledBillREPORTBtoday]
    @startdate   DATETIME,
    @enddate     DATETIME,
    @cancelledby NVARCHAR(250)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @code VARCHAR(10);
    SELECT TOP (1) @code = Code FROM dbo.RO_CompanyInfo;

    SELECT
        CONVERT(VARCHAR(16), om.BillDate, 20) AS BillDate,
        om.NetAmount,
        om.Waiter,
        rt.restrotableTitle,
        rr.restroRoom,
        @code + CONVERT(NVARCHAR(10),
                (SELECT fyName FROM dbo.RO_fiscalYear fy WHERE fy.fyId = om.FiscalYearID))
              + '-' + CONVERT(NVARCHAR(10),
                (om.InvoiceNo - (SELECT fy.FirstSalesMasterID
                                 FROM dbo.RO_fiscalYear fy
                                 WHERE fy.fyId = om.FiscalYearID))) AS billNo,
        om.TableId,
        om.salesMasterId,
        om.OrderMasterId,
        om.Reasons,
        om.ArchivedBy,
        om.IsArchived,
        om.ArchivedOn
    FROM dbo.RO_SalesMaster om
    /* FIX: LEFT JOIN — cancelled bills that were never CBMS-posted
       (incl. cake bills) must still appear in the report */
    LEFT JOIN dbo.CBMS_BillPostLog bp ON bp.SalesMasterId = om.salesMasterId
    LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
    LEFT JOIN dbo.RO_RestroRoom  rr ON rr.restroRoomId = om.RoomId
    WHERE
        CAST(om.BillDate AS DATETIME) BETWEEN @startdate AND @enddate
        AND (om.ArchivedBy = @cancelledby OR @cancelledby = '' OR @cancelledby IS NULL)
        /* FIX: archived OR cake-cancelled (BillCancelled) both count as cancelled */
        AND (ISNULL(om.IsArchived, 0) = 1 OR ISNULL(om.BillCancelled, 0) = 1)
    ORDER BY BillDate DESC;
END;
GO

/* ---------------------------------------------------------------
   2) usp_roi_getOrderItemCancelReport (UNION ALL + true date window)
   --------------------------------------------------------------- */
IF OBJECT_ID('dbo.usp_roi_getOrderItemCancelReport', 'P') IS NOT NULL
    EXEC('CREATE PROCEDURE dbo.usp_roi_getOrderItemCancelReport AS SELECT 1');
GO
ALTER PROCEDURE [dbo].[usp_roi_getOrderItemCancelReport]
    @startDate   DATETIME,
    @endDate     DATETIME,
    @cancelledby VARCHAR(250),
    @orderby     VARCHAR(250),
    @room        INT,
    @table       INT,
    @responsible VARCHAR(250),
    @itemname    VARCHAR(250),
    @CostCenterId INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @itemname <> ''
        SET @itemname = '%' + @itemname + '%';

    /* FIX: UNION ALL — do not collapse distinct cancelled item rows */
    SELECT odc.CanceledBy
         , odc.OrderBy
         , odc.item
         , odc.Quantity
         , odc.Reason
         , odc.[Date]
         , odc.Responsible
         , CASE WHEN rom.OrderTypeID = 4 THEN 'Food Delivery'
                WHEN rom.OrderTypeID = 3 THEN 'Food Court'
                ELSE ISNULL(rt.restrotableTitle, 'Take Away') END restrotableTitle
         , CASE WHEN rom.OrderTypeID = 4 THEN 'Food Delivery'
                WHEN rom.OrderTypeID = 3 THEN 'Food Court'
                ELSE ISNULL(rr.restroRoom, 'Take Away') END restroRoom
         , CAST(LEFT(CONVERT(TIME(0), odc.[Date]), 5) AS VARCHAR(128)) AS billtime
         , '' AS ImagePath
    FROM dbo.Order_Detail_Cancel odc
    LEFT JOIN RO_restroTable rt  ON odc.tableId = rt.restrotableId
    LEFT JOIN RO_RestroRoom  rr  ON rr.restroRoomId = rt.restroRoomId
    LEFT JOIN RO_OrderMasters rom ON rom.OrderMasterID = odc.orderMasterID
    LEFT JOIN ROI_ITEMMain it  ON odc.Item = it.ITName
    LEFT JOIN ROI_ItemDetails itd ON it.ITId = itd.ITId
    /* FIX: filter on the actual submitted window (no +4h shift) */
    WHERE odc.[date] BETWEEN @startDate AND @endDate
      AND (odc.CanceledBy = @cancelledby OR @cancelledby = '' OR @cancelledby IS NULL)
      AND (odc.OrderBy     = @orderby     OR @orderby     = '' OR @orderby     IS NULL)
      AND (rt.restrotableId = @table OR @table = 0)
      AND (rr.restroRoomId  = @room  OR @room  = 0)
      AND (odc.Responsible = @responsible OR @responsible = '' OR @responsible IS NULL)
      AND (odc.item LIKE @itemname OR @itemname = '' OR @itemname IS NULL)
      AND (itd.ItemCostCentreID = @CostCenterId OR @CostCenterId = 0)

    UNION ALL

    SELECT rom.CancelBy
         , rom.UserName AS Waiter
         , ri.ITName
         , od.quantity
         , rom.cancelreason
         , rom.canceldate
         , rom.UserName AS Waiter
         , CASE WHEN rom.OrderTypeID = 4 THEN 'Order Delivery'
                ELSE ISNULL(rt.restrotableTitle, 'Take Away') END restrotableTitle
         , CASE WHEN rom.OrderTypeID = 4 THEN 'Order Delivery'
                ELSE ISNULL(rr.restroRoom, 'Take Away') END restroRoom
         , CAST(LEFT(CONVERT(TIME(0), od.[Date]), 5) AS VARCHAR(128)) AS billtime
         , itd.ImagePath
    FROM dbo.RO_OrderMasters rom
    LEFT JOIN RO_Order_Detail od ON rom.OrderMasterID = od.OrderMasterId
    LEFT JOIN ROI_ITEMMain ri    ON ri.ITId = od.ROI_ItemId
    LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = rom.TableId
    LEFT JOIN RO_RestroRoom rr      ON rr.restroRoomId = rom.RoomId
    LEFT JOIN ROI_ItemDetails itd   ON od.ItemId = itd.ITId
    WHERE rom.[date] BETWEEN @startDate AND @endDate
      AND rom.IsCancelled = 1
      AND (rom.CancelBy = @cancelledby OR @cancelledby = '' OR @cancelledby IS NULL)
      AND (rom.UserName = @orderby     OR @orderby     = '' OR @orderby     IS NULL)
      AND (rt.restrotableId = @table OR @table = 0)
      AND (rr.restroRoomId  = @room  OR @room  = 0)
      AND (rom.UserName = @responsible OR @responsible = '' OR @responsible IS NULL)
      AND (ri.ITName LIKE @itemname OR @itemname IS NULL)
      AND (itd.ItemCostCentreID = @CostCenterId OR @CostCenterId = 0)

    ORDER BY [Date] DESC;
END;
GO

/* ---------------------------------------------------------------
   3) Dropdown binder sanity checks (these power the filter dropdowns)
   --------------------------------------------------------------- */
IF OBJECT_ID('dbo.USP_GetOrderCancelledBY', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.USP_GetOrderCancelledBY AS
          SELECT DISTINCT CanceledBy FROM dbo.Order_Detail_Cancel WHERE CanceledBy IS NOT NULL');
GO
IF OBJECT_ID('dbo.USP_GetCancelledOrderBY', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.USP_GetCancelledOrderBY AS
          SELECT DISTINCT OrderBy FROM dbo.Order_Detail_Cancel WHERE OrderBy IS NOT NULL');
GO
IF OBJECT_ID('dbo.USP_GetOrderCancelResponsible', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.USP_GetOrderCancelResponsible AS
          SELECT DISTINCT Responsible FROM dbo.Order_Detail_Cancel WHERE Responsible IS NOT NULL');
GO
