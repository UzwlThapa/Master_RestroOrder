/* ============================================================
   ALL SALES REPORT SPs — CANCELLED-FILTER FIX
   RO-NANEE.  Idempotent.
   ============================================================ */

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

/* ============================================================
   1. USP_RO_ITEMSALESREPORT
   ============================================================ */
ALTER PROCEDURE [dbo].[USP_RO_ITEMSALESREPORT]
    @Start DATETIME,
    @End   DATETIME
AS
BEGIN
    SELECT CAST(SM.BillDate AS DATE) AS BillDate,
           CCI.CostCenterName,
           Im.ITName,
           SUM(SD.qty) AS QTY,
           SD.rate,
           SUM(SD.qty * SD.rate) AS NetAmount,
           SD.IsCombo,
           ru.Symbol AS ITUnit
    FROM RO_SalesMaster SM
        INNER JOIN RO_SalesDetail SD    ON SM.salesMasterId = SD.salesMasterId
        INNER JOIN ROI_ITEMMain Im      ON Im.ITId = SD.ItemId
        LEFT  JOIN CostCenterInfo CCI   ON CCI.CostCenterId = SD.CostCenterId
        LEFT  JOIN ROI_ItemDetails itd  ON Im.ITId = itd.ITId
        LEFT  JOIN ROI_Unit1 ru         ON ru.Unit1Id = itd.SmallUnit
    WHERE SD.IsCombo = 0
          AND CAST(SM.BillDate AS DATE) BETWEEN @Start AND @End
          AND ISNULL(SM.BillCancelled, 0) = 0
          AND ISNULL(SM.IsArchived, 0)    = 0
          AND NOT EXISTS (
                SELECT 1 FROM RO_OrderMasters OM
                WHERE OM.OrderMasterID = SM.OrderMasterId
                  AND ISNULL(OM.IsCancelled, 0) = 1
              )
    GROUP BY CAST(SM.BillDate AS DATE), CCI.CostCenterName, Im.ITName,
             SD.rate, SD.IsCombo, ru.Symbol

    UNION

    SELECT CAST(SM.BillDate AS DATE) AS BillDate,
           CCI.CostCenterName,
           Im.Name,
           SUM(SD.qty) AS QTY,
           SD.rate,
           SUM(SD.qty * SD.rate) AS NetAmount,
           SD.IsCombo,
           'Pack' AS ITUnit
    FROM RO_SalesMaster SM
        INNER JOIN RO_SalesDetail SD  ON SM.salesMasterId = SD.salesMasterId
        INNER JOIN RO_Combo Im        ON Im.ComboID = SD.ItemId
        LEFT  JOIN CostCenterInfo CCI ON CCI.CostCenterId = SD.CostCenterId
    WHERE SD.IsCombo = 1
          AND CAST(SM.BillDate AS DATE) BETWEEN @Start AND @End
          AND ISNULL(SM.BillCancelled, 0) = 0
          AND ISNULL(SM.IsArchived, 0)    = 0
          AND NOT EXISTS (
                SELECT 1 FROM RO_OrderMasters OM
                WHERE OM.OrderMasterID = SM.OrderMasterId
                  AND ISNULL(OM.IsCancelled, 0) = 1
              )
    GROUP BY CAST(SM.BillDate AS DATE), CCI.CostCenterName, Im.Name,
             SD.rate, SD.IsCombo;
END;
GO

/* ============================================================
   2. USP_RO_DailyItemSalesReport
   ============================================================ */
ALTER PROCEDURE [dbo].[USP_RO_DailyItemSalesReport]
    @startDate DATETIME,
    @endDate DATETIME,
    @costCenterID INT,
    @PITId INT,
    @Username NVARCHAR(25) = ''
AS
BEGIN
    DECLARE @StartDateTime DATETIME = @startDate;
    DECLARE @EndDateTime   DATETIME = @endDate;

    IF @PITId = 0
    BEGIN
        SELECT CAST(SM.BillDate AS DATE) AS BillDate,
               SUM(CASE WHEN ISNULL(OM.IsCancelled, 0) = 0
                        THEN ISNULL(SD.qty, 0) - ISNULL(t.SalesReturnQty, 0)
                        ELSE 0 END) AS Quantity,
               SD.rate AS Rate,
               rim.ITId, rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName,
               SM.Waiter
        FROM dbo.RO_SalesMaster SM
            INNER JOIN dbo.CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
            INNER JOIN dbo.RO_SalesDetail SD    ON SM.salesMasterId = SD.salesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim     ON rim.ITId = SD.ItemId
            LEFT  JOIN dbo.ROI_ItemDetails rid  ON rid.ITId = rim.ITId
            LEFT  JOIN dbo.ROI_Unit1 ru         ON ru.Unit1Id = rid.SmallUnit
            LEFT  JOIN dbo.CostCenterInfo cci   ON cci.CostCenterId = SD.CostCenterId
            LEFT  JOIN dbo.RO_OrderMasters OM   ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY (SELECT SUM(SalesReturnQty) AS SalesReturnQty
                         FROM dbo.vw_ROI_StockReportView
                         WHERE SalesDetailId = SD.salesDetailId) t
        WHERE SD.IsCombo = 0
              AND (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
              AND CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
              AND ISNULL(SM.IsArchived, 0)     = 0
              AND ISNULL(SM.BillCancelled, 0)  = 0
              AND (SM.Waiter = @Username OR @Username = '')
        GROUP BY CAST(SM.BillDate AS DATE), SD.rate, rim.ITName,
                 ru.Symbol, cci.CostCenterName, rim.ITId, SM.Waiter

        UNION

        SELECT CAST(SM.BillDate AS DATE) AS BillDate,
               SUM(CASE WHEN ISNULL(OM.IsCancelled, 0) = 0
                        THEN ISNULL(SD.Quantity, 0) - ISNULL(t.SalesReturnQty, 0)
                        ELSE 0 END) AS Quantity,
               SD.Rate AS Rate,
               rim.ITId, rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName,
               SM.AddedBy AS Waiter
        FROM dbo.RO_CakeSalesMaster SM
            INNER JOIN dbo.RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim      ON rim.ITId = SD.ItemId
            LEFT  JOIN dbo.ROI_ItemDetails rid   ON rid.ITId = rim.ITId
            LEFT  JOIN dbo.ROI_Unit1 ru          ON ru.Unit1Id = rid.SmallUnit
            LEFT  JOIN dbo.CostCenterInfo cci    ON cci.CostCenterId = SD.CostCenterId
            LEFT  JOIN dbo.RO_OrderMasters OM    ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY (SELECT SUM(SalesReturnQty) AS SalesReturnQty
                         FROM dbo.vw_ROI_StockReportView
                         WHERE SalesDetailId = SD.SalesDetailId) t
        WHERE (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
              AND CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
              AND ISNULL(SM.IsArchived, 0) = 0
              AND (SM.AddedBy = @Username OR @Username = '')
        GROUP BY CAST(SM.BillDate AS DATE), SD.Rate, rim.ITName,
                 ru.Symbol, cci.CostCenterName, rim.ITId, SM.AddedBy
        ORDER BY rim.ITName;
    END
    ELSE
    BEGIN
        ;WITH CTE (ITid, PITId, ITName) AS (
            SELECT ITId, PITId, ITName FROM dbo.ROI_ITEMMain WHERE ITId = @PITId
            UNION ALL
            SELECT m.ITId, m.PITId, m.ITName
            FROM dbo.ROI_ITEMMain m INNER JOIN CTE c ON m.PITId = c.ITid
        )
        SELECT ITid, PITId, ITName INTO #Items FROM CTE;

        SELECT CAST(SM.BillDate AS DATE) AS BillDate,
               SUM(CASE WHEN ISNULL(OM.IsCancelled, 0) = 0
                        THEN ISNULL(SD.qty, 0) - ISNULL(t.SalesReturnQty, 0)
                        ELSE 0 END) AS Quantity,
               SD.rate AS Rate,
               rim.ITId, rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName,
               SM.Waiter
        FROM dbo.RO_SalesMaster SM
            INNER JOIN dbo.CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
            INNER JOIN dbo.RO_SalesDetail SD    ON SM.salesMasterId = SD.salesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim     ON rim.ITId = SD.ItemId
            INNER JOIN #Items i                 ON rim.ITId = i.ITid
            LEFT  JOIN dbo.ROI_ItemDetails rid  ON rid.ITId = rim.ITId
            LEFT  JOIN dbo.ROI_Unit1 ru         ON ru.Unit1Id = rid.SmallUnit
            LEFT  JOIN dbo.CostCenterInfo cci   ON cci.CostCenterId = SD.CostCenterId
            LEFT  JOIN dbo.RO_OrderMasters OM   ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY (SELECT SUM(SalesReturnQty) AS SalesReturnQty
                         FROM dbo.vw_ROI_StockReportView
                         WHERE SalesDetailId = SD.salesDetailId) t
        WHERE SD.IsCombo = 0
              AND (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
              AND CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
              AND ISNULL(SM.IsArchived, 0)     = 0
              AND ISNULL(SM.BillCancelled, 0)  = 0
              AND (SM.Waiter = @Username OR @Username = '')
        GROUP BY CAST(SM.BillDate AS DATE), SD.rate, rim.ITName,
                 ru.Symbol, cci.CostCenterName, rim.ITId, SM.Waiter

        UNION

        SELECT CAST(SM.BillDate AS DATE) AS BillDate,
               SUM(CASE WHEN ISNULL(OM.IsCancelled, 0) = 0
                        THEN ISNULL(SD.Quantity, 0) - ISNULL(t.SalesReturnQty, 0)
                        ELSE 0 END) AS Quantity,
               SD.Rate AS Rate,
               rim.ITId, rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName,
               SM.AddedBy AS Waiter
        FROM dbo.RO_CakeSalesMaster SM
            INNER JOIN dbo.RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim      ON rim.ITId = SD.ItemId
            INNER JOIN #Items i                  ON rim.ITId = i.ITid
            LEFT  JOIN dbo.ROI_ItemDetails rid   ON rid.ITId = rim.ITId
            LEFT  JOIN dbo.ROI_Unit1 ru          ON ru.Unit1Id = rid.SmallUnit
            LEFT  JOIN dbo.CostCenterInfo cci    ON cci.CostCenterId = SD.CostCenterId
            LEFT  JOIN dbo.RO_OrderMasters OM    ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY (SELECT SUM(SalesReturnQty) AS SalesReturnQty
                         FROM dbo.vw_ROI_StockReportView
                         WHERE SalesDetailId = SD.SalesDetailId) t
        WHERE (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
              AND CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
              AND ISNULL(SM.IsArchived, 0) = 0
              AND (SM.AddedBy = @Username OR @Username = '')
        GROUP BY CAST(SM.BillDate AS DATE), SD.Rate, rim.ITName,
                 ru.Symbol, cci.CostCenterName, rim.ITId, SM.AddedBy
        ORDER BY rim.ITName;

        DROP TABLE #Items;
    END;
END;
GO

/* ============================================================
   3. USP_RO_SummaryItemSalesReport
   ============================================================ */
ALTER PROCEDURE [dbo].[USP_RO_SummaryItemSalesReport]
    @startDate DATETIME,
    @endDate DATETIME,
    @costCenterID INT,
    @PITId INT
AS
BEGIN
    DECLARE @StartDateTime DATETIME = @startDate;
    DECLARE @EndDateTime   DATETIME = @endDate;

    IF @PITId = 0
    BEGIN
        SELECT SUM(CASE WHEN ISNULL(OM.IsCancelled, 0) = 0
                        THEN ISNULL(SD.qty, 0) - ISNULL(t.SalesReturnQty, 0)
                        ELSE 0 END) AS Quantity,
               SD.rate AS Rate,
               rim.ITId, rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName
        FROM dbo.RO_SalesMaster SM
            INNER JOIN dbo.CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
            INNER JOIN dbo.RO_SalesDetail SD    ON SM.salesMasterId = SD.salesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim     ON rim.ITId = SD.ItemId
            LEFT  JOIN dbo.ROI_ItemDetails rid  ON rid.ITId = rim.ITId
            LEFT  JOIN dbo.ROI_Unit1 ru         ON ru.Unit1Id = rid.SmallUnit
            LEFT  JOIN dbo.CostCenterInfo cci   ON cci.CostCenterId = SD.CostCenterId
            LEFT  JOIN dbo.RO_OrderMasters OM   ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY (SELECT SUM(SalesReturnQty) AS SalesReturnQty
                         FROM dbo.vw_ROI_StockReportView
                         WHERE SalesDetailId = SD.salesDetailId) t
        WHERE SD.IsCombo = 0
              AND (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
              AND CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
              AND ISNULL(SM.IsArchived, 0)     = 0
              AND ISNULL(SM.BillCancelled, 0)  = 0
        GROUP BY rim.ITName, ru.Symbol, cci.CostCenterName, SD.rate, rim.ITId

        UNION

        SELECT SUM(CASE WHEN ISNULL(OM.IsCancelled, 0) = 0
                        THEN ISNULL(SD.Quantity, 0) - ISNULL(t.SalesReturnQty, 0)
                        ELSE 0 END) AS Quantity,
               SD.Rate AS Rate,
               rim.ITId, rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName
        FROM dbo.RO_CakeSalesMaster SM
            INNER JOIN dbo.RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim      ON rim.ITId = SD.ItemId
            LEFT  JOIN dbo.ROI_ItemDetails rid   ON rid.ITId = rim.ITId
            LEFT  JOIN dbo.ROI_Unit1 ru          ON ru.Unit1Id = rid.SmallUnit
            LEFT  JOIN dbo.CostCenterInfo cci    ON cci.CostCenterId = SD.CostCenterId
            LEFT  JOIN dbo.RO_OrderMasters OM    ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY (SELECT SUM(SalesReturnQty) AS SalesReturnQty
                         FROM dbo.vw_ROI_StockReportView
                         WHERE SalesDetailId = SD.SalesDetailId) t
        WHERE (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
              AND CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
              AND ISNULL(SM.IsArchived, 0) = 0
        GROUP BY rim.ITName, ru.Symbol, cci.CostCenterName, SD.Rate, rim.ITId

        ORDER BY rim.ITName;
    END
    ELSE
    BEGIN
        ;WITH CTE (ITid, PITId, ITName) AS (
            SELECT ITId, PITId, ITName FROM dbo.ROI_ITEMMain WHERE (ITId = @PITId OR @PITId = 0)
            UNION ALL
            SELECT m.ITId, m.PITId, m.ITName
            FROM dbo.ROI_ITEMMain m INNER JOIN CTE c ON m.PITId = c.ITid
        )
        SELECT ITid, PITId, ITName INTO #Items FROM CTE;

        SELECT SUM(CASE WHEN ISNULL(OM.IsCancelled, 0) = 0
                        THEN ISNULL(SD.qty, 0) - ISNULL(t.SalesReturnQty, 0)
                        ELSE 0 END) AS Quantity,
               SD.rate AS Rate,
               rim.ITId, rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName
        FROM dbo.RO_SalesMaster SM
            INNER JOIN dbo.CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
            INNER JOIN dbo.RO_SalesDetail SD    ON SM.salesMasterId = SD.salesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim     ON rim.ITId = SD.ItemId
            INNER JOIN #Items i                 ON rim.ITId = i.ITid
            LEFT  JOIN dbo.ROI_ItemDetails rid  ON rid.ITId = rim.ITId
            LEFT  JOIN dbo.ROI_Unit1 ru         ON ru.Unit1Id = rid.SmallUnit
            LEFT  JOIN dbo.CostCenterInfo cci   ON cci.CostCenterId = SD.CostCenterId
            LEFT  JOIN dbo.RO_OrderMasters OM   ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY (SELECT SUM(SalesReturnQty) AS SalesReturnQty
                         FROM dbo.vw_ROI_StockReportView
                         WHERE SalesDetailId = SD.salesDetailId) t
        WHERE SD.IsCombo = 0
              AND (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
              AND CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
              AND ISNULL(SM.IsArchived, 0)     = 0
              AND ISNULL(SM.BillCancelled, 0)  = 0
        GROUP BY rim.ITName, ru.Symbol, cci.CostCenterName, SD.rate, rim.ITId

        UNION

        SELECT SUM(CASE WHEN ISNULL(OM.IsCancelled, 0) = 0
                        THEN ISNULL(SD.Quantity, 0) - ISNULL(t.SalesReturnQty, 0)
                        ELSE 0 END) AS Quantity,
               SD.Rate AS Rate,
               rim.ITId, rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName
        FROM dbo.RO_CakeSalesMaster SM
            INNER JOIN dbo.RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim      ON rim.ITId = SD.ItemId
            INNER JOIN #Items i                  ON rim.ITId = i.ITid
            LEFT  JOIN dbo.ROI_ItemDetails rid   ON rid.ITId = rim.ITId
            LEFT  JOIN dbo.ROI_Unit1 ru          ON ru.Unit1Id = rid.SmallUnit
            LEFT  JOIN dbo.CostCenterInfo cci    ON cci.CostCenterId = SD.CostCenterId
            LEFT  JOIN dbo.RO_OrderMasters OM    ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY (SELECT SUM(SalesReturnQty) AS SalesReturnQty
                         FROM dbo.vw_ROI_StockReportView
                         WHERE SalesDetailId = SD.SalesDetailId) t
        WHERE (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
              AND CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
              AND ISNULL(SM.IsArchived, 0) = 0
        GROUP BY rim.ITName, ru.Symbol, cci.CostCenterName, SD.Rate, rim.ITId;

        DROP TABLE #Items;
    END;
END;
GO

/* ============================================================
   VERIFY — all three should now return the same live total
   for Sept 2026 when filtered by the same conditions.
   ============================================================ */
PRINT '=== USP_RO_ITEMSALESREPORT ===';
IF OBJECT_ID('tempdb..#a') IS NOT NULL DROP TABLE #a;
CREATE TABLE #a (BillDate DATE, CostCenterName NVARCHAR(200), ITName NVARCHAR(400),
                 QTY FLOAT, rate DECIMAL(18,4), NetAmount DECIMAL(18,4),
                 IsCombo BIT, ITUnit NVARCHAR(50));
INSERT INTO #a EXEC dbo.USP_RO_ITEMSALESREPORT '2026-09-01','2026-09-30';
SELECT SUM(QTY) AS TotalQty, SUM(NetAmount) AS TotalNet FROM #a;

PRINT '=== USP_RO_DailyItemSalesReport ===';
IF OBJECT_ID('tempdb..#b') IS NOT NULL DROP TABLE #b;
CREATE TABLE #b (BillDate DATE, Quantity FLOAT, Rate DECIMAL(18,4),
                 ITId INT, ITName NVARCHAR(400), ITUnit NVARCHAR(50),
                 CostCenterName NVARCHAR(200), Waiter NVARCHAR(200));
INSERT INTO #b EXEC dbo.USP_RO_DailyItemSalesReport
    @startDate='2026-09-01', @endDate='2026-09-30',
    @costCenterID=0, @PITId=0, @Username='';
SELECT SUM(Quantity) AS TotalQty, SUM(Quantity*Rate) AS TotalNet FROM #b;

PRINT '=== USP_RO_SummaryItemSalesReport ===';
IF OBJECT_ID('tempdb..#c') IS NOT NULL DROP TABLE #c;
CREATE TABLE #c (Quantity FLOAT, Rate DECIMAL(18,4),
                 ITId INT, ITName NVARCHAR(400),
                 ITUnit NVARCHAR(50), CostCenterName NVARCHAR(200));
INSERT INTO #c EXEC dbo.USP_RO_SummaryItemSalesReport
    @startDate='2026-09-01', @endDate='2026-09-30',
    @costCenterID=0, @PITId=0;
SELECT SUM(Quantity) AS TotalQty, SUM(Quantity*Rate) AS TotalNet FROM #c;

DROP TABLE #a, #b, #c;