/*
Run this script on:

        (local).DevRestroMaster    -  This database will be modified

to synchronize it with:

        (local).Akuj_RO_IRD

You are recommended to back up your database before running this script

Script created by SQL Compare version 14.4.4.16824 from Red Gate Software Ltd at 13/10/2026 03:17:45 PM

*/
SET NUMERIC_ROUNDABORT OFF;
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON;
GO
SET XACT_ABORT ON;
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
GO
BEGIN TRANSACTION;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Refreshing [dbo].[Materialized_View]';
GO
EXEC sp_refreshview N'[dbo].[Materialized_View]';
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[USP_RO_SummaryItemSalesReport]';
GO

ALTER PROCEDURE [dbo].[USP_RO_SummaryItemSalesReport]
    @startDate DATETIME,
    @endDate DATETIME,
    @costCenterID INT,
    @PITId INT
AS
BEGIN
    DECLARE @StartDateTime DATETIME = @startDate;
    DECLARE @EndDateTime DATETIME = @endDate;

    IF @PITId = 0
    BEGIN
        -- ---- Regular sales ------------------------------------------------
        SELECT SUM(   CASE
                          WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN
                              ISNULL(SD.qty, 0) - ISNULL(t.SalesReturnQty, 0)
                          ELSE
                              0
                      END
                  ) AS Quantity,
               SD.rate AS Rate,
               rim.ITId,
               rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName
        FROM dbo.RO_SalesMaster SM
            INNER JOIN dbo.CBMS_BillPostLog bp
                ON bp.SalesMasterId = SM.salesMasterId
            INNER JOIN dbo.RO_SalesDetail SD
                ON SM.salesMasterId = SD.salesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim
                ON rim.ITId = SD.ItemId
            LEFT JOIN dbo.ROI_ItemDetails rid
                ON rid.ITId = rim.ITId
            LEFT JOIN dbo.ROI_Unit1 ru
                ON ru.Unit1Id = rid.SmallUnit
            LEFT JOIN dbo.CostCenterInfo cci
                ON cci.CostCenterId = SD.CostCenterId
            LEFT JOIN dbo.RO_OrderMasters OM
                ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY
        (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView
            WHERE SalesDetailId = SD.salesDetailId
        ) t
        WHERE SD.IsCombo = 0
              AND
              (
                  SD.CostCenterId = @costCenterID
                  OR @costCenterID = 0
              )
              AND (CAST(SM.BillDate AS DATE)
              BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
                  )
              AND ISNULL(SM.IsArchived, 0) = 0
              AND ISNULL(SM.BillCancelled, 0) = 0 -- ← ADDED
        GROUP BY rim.ITName,
                 ru.Symbol,
                 cci.CostCenterName,
                 SD.rate,
                 rim.ITId
        UNION

        -- ---- Cake sales ---------------------------------------------------
        SELECT SUM(   CASE
                          WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN
                              ISNULL(SD.Quantity, 0) - ISNULL(t.SalesReturnQty, 0)
                          ELSE
                              0
                      END
                  ) AS Quantity,
               SD.Rate AS Rate,
               rim.ITId,
               rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName
        FROM dbo.RO_CakeSalesMaster SM
            INNER JOIN dbo.RO_CakeSalesDetail SD
                ON SM.SalesMasterId = SD.SalesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim
                ON rim.ITId = SD.ItemId
            LEFT JOIN dbo.ROI_ItemDetails rid
                ON rid.ITId = rim.ITId
            LEFT JOIN dbo.ROI_Unit1 ru
                ON ru.Unit1Id = rid.SmallUnit
            LEFT JOIN dbo.CostCenterInfo cci
                ON cci.CostCenterId = SD.CostCenterId
            LEFT JOIN dbo.RO_OrderMasters OM
                ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY
        (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView
            WHERE SalesDetailId = SD.SalesDetailId
        ) t
        WHERE (
                  SD.CostCenterId = @costCenterID
                  OR @costCenterID = 0
              )
              AND (CAST(SM.BillDate AS DATE)
              BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
                  )
              AND ISNULL(SM.IsArchived, 0) = 0
        GROUP BY rim.ITName,
                 ru.Symbol,
                 cci.CostCenterName,
                 SD.Rate,
                 rim.ITId
        ORDER BY rim.ITName;
    END;
    ELSE
    BEGIN
        ;WITH CTE (ITid, PITId, ITName)
         AS (SELECT ITId,
                    PITId,
                    ITName
             FROM dbo.ROI_ITEMMain i
             WHERE (
                       i.ITId = @PITId
                       OR @PITId = 0
                   )
             UNION ALL
             SELECT m.ITId,
                    m.PITId,
                    m.ITName
             FROM dbo.ROI_ITEMMain m
                 INNER JOIN CTE c
                     ON m.PITId = c.ITid)
        SELECT CTE.ITid,
               CTE.PITId,
               CTE.ITName
        INTO #Items
        FROM CTE;

        -- ---- Regular sales, filtered items --------------------------------
        SELECT SUM(   CASE
                          WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN
                              ISNULL(SD.qty, 0) - ISNULL(t.SalesReturnQty, 0)
                          ELSE
                              0
                      END
                  ) AS Quantity,
               SD.rate AS Rate,
               rim.ITId,
               rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName
        FROM dbo.RO_SalesMaster SM
            INNER JOIN dbo.CBMS_BillPostLog bp
                ON bp.SalesMasterId = SM.salesMasterId
            INNER JOIN dbo.RO_SalesDetail SD
                ON SM.salesMasterId = SD.salesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim
                ON rim.ITId = SD.ItemId
            INNER JOIN #Items i
                ON rim.ITId = i.ITid
            LEFT JOIN dbo.ROI_ItemDetails rid
                ON rid.ITId = rim.ITId
            LEFT JOIN dbo.ROI_Unit1 ru
                ON ru.Unit1Id = rid.SmallUnit
            LEFT JOIN dbo.CostCenterInfo cci
                ON cci.CostCenterId = SD.CostCenterId
            LEFT JOIN dbo.RO_OrderMasters OM
                ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY
        (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView
            WHERE SalesDetailId = SD.salesDetailId
        ) t
        WHERE SD.IsCombo = 0
              AND
              (
                  SD.CostCenterId = @costCenterID
                  OR @costCenterID = 0
              )
              AND (CAST(SM.BillDate AS DATE)
              BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
                  )
              AND ISNULL(SM.IsArchived, 0) = 0
              AND ISNULL(SM.BillCancelled, 0) = 0 -- ← ADDED
        GROUP BY rim.ITName,
                 ru.Symbol,
                 cci.CostCenterName,
                 SD.rate,
                 rim.ITId
        UNION

        -- ---- Cake sales, filtered items -----------------------------------
        SELECT SUM(   CASE
                          WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN
                              ISNULL(SD.Quantity, 0) - ISNULL(t.SalesReturnQty, 0)
                          ELSE
                              0
                      END
                  ) AS Quantity,
               SD.Rate AS Rate,
               rim.ITId,
               rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName
        FROM dbo.RO_CakeSalesMaster SM
            INNER JOIN dbo.RO_CakeSalesDetail SD
                ON SM.SalesMasterId = SD.SalesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim
                ON rim.ITId = SD.ItemId
            INNER JOIN #Items i
                ON rim.ITId = i.ITid
            LEFT JOIN dbo.ROI_ItemDetails rid
                ON rid.ITId = rim.ITId
            LEFT JOIN dbo.ROI_Unit1 ru
                ON ru.Unit1Id = rid.SmallUnit
            LEFT JOIN dbo.CostCenterInfo cci
                ON cci.CostCenterId = SD.CostCenterId
            LEFT JOIN dbo.RO_OrderMasters OM
                ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY
        (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView
            WHERE SalesDetailId = SD.SalesDetailId
        ) t
        WHERE (
                  SD.CostCenterId = @costCenterID
                  OR @costCenterID = 0
              )
              AND (CAST(SM.BillDate AS DATE)
              BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
                  )
              AND ISNULL(SM.IsArchived, 0) = 0
        GROUP BY rim.ITName,
                 ru.Symbol,
                 cci.CostCenterName,
                 SD.Rate,
                 rim.ITId;

        DROP TABLE #Items;
    END;
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Creating [dbo].[Usp_getPurchaseReportCostCenterWise]';
GO

ALTER PROCEDURE [dbo].[Usp_getPurchaseReportCostCenterWise]
    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @VendorID INT = 0,
    @puNo VARCHAR(250) = NULL,
    @CostCenterId INT = 0 -- 0 = all cost centers
AS
BEGIN
    SET NOCOUNT ON;

    IF (ISNULL(@StartDate, '')) = ''
        SET @StartDate = '2000-01-01';
    IF (ISNULL(@EndDate, '')) = ''
        SET @EndDate
            = GETDATE();

        /* ===================================================================
       SECTION A: Cost-center summary (Gross / Return / Net)
       Attribution: pd.ItemID -> ROI_ItemDetails.ItemCostCentreID
       =================================================================== */
        ;
    WITH PurchaseCTE
        AS (SELECT ISNULL(id.ItemCostCentreID, -1) AS CostCenterKey, -- -1 = Unassigned
                   SUM(pd.Total) AS GrossPurchase
            FROM dbo.ROI_PurchaseMain pm
                INNER JOIN dbo.ROI_PurchaseDetails pd
                    ON pm.PurchaseMainID = pd.PurchaseMainID
                LEFT JOIN dbo.ROI_ItemDetails id
                    ON id.ITId = pd.ItemID
            WHERE CAST(pm.PbDate AS DATE)
                  BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
                  AND
                  (
                      pm.Vid = @VendorID
                      OR @VendorID = 0
                  )
                  AND
                  (
                      pm.PuNo = @puNo
                      OR @puNo = ''
                      OR @puNo IS NULL
                  )
            GROUP BY ISNULL(id.ItemCostCentreID, -1)),
         ReturnCTE
        AS (SELECT ISNULL(id.ItemCostCentreID, -1) AS CostCenterKey,
                   SUM(prd.Total) AS ReturnAmount
            FROM dbo.RO_PurchaseReturnMain prm
                INNER JOIN dbo.RO_PurchaseReturnDetails prd
                    ON prm.PurchaseReturnId = prd.PurchaseReturnId
                LEFT JOIN dbo.ROI_ItemDetails id
                    ON id.ITId = prd.ItemID
            WHERE CAST(prm.PostedOn AS DATE)
                  BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
                  AND
                  (
                      prm.vendorId = @VendorID
                      OR @VendorID = 0
                  )
            GROUP BY ISNULL(id.ItemCostCentreID, -1))
    SELECT cc.CostCenterId,
           ISNULL(cc.CostCenterName, 'Unassigned') AS CostCenterName,
           cc.GroupId,
           grp.GroupName,
           ISNULL(p.GrossPurchase, 0) AS GrossPurchase,
           ISNULL(r.ReturnAmount, 0) AS ReturnAmount,
           ISNULL(p.GrossPurchase, 0) - ISNULL(r.ReturnAmount, 0) AS NetPurchase
    FROM
    (
        SELECT CostCenterKey
        FROM PurchaseCTE
        UNION
        SELECT CostCenterKey
        FROM ReturnCTE
        UNION
        SELECT CostCenterId
        FROM dbo.CostCenterInfo -- ensures 0-activity cost centers still appear
    ) AS AllKeys
        LEFT JOIN dbo.CostCenterInfo cc
            ON cc.CostCenterId = AllKeys.CostCenterKey
        LEFT JOIN dbo.RO_CostCenterGroup grp
            ON grp.GroupId = cc.GroupId
        LEFT JOIN PurchaseCTE p
            ON p.CostCenterKey = AllKeys.CostCenterKey
        LEFT JOIN ReturnCTE r
            ON r.CostCenterKey = AllKeys.CostCenterKey
    WHERE (
              @CostCenterId = 0
              OR cc.CostCenterId = @CostCenterId
              OR
              (
                  @CostCenterId = -1
                  AND cc.CostCenterId IS NULL
              )
          )
    ORDER BY cc.CostCenterId;

    /* ===================================================================
       SECTION B: Per-purchase-line detail, tagged with its real cost center
       Now correctly one row per (purchase line, its actual cost center) --
       no more 5x fan-out.
       =================================================================== */
    SELECT pm.PurchaseMainID,
           pm.PuNo,
           FORMAT(pm.PbDate, 'yyyy-MM-dd') AS BillDate,
           pd.ItemID,
           im.ITName,
           ISNULL(id.ItemCostCentreID, -1) AS CostCenterKey,
           ISNULL(cc.CostCenterName, 'Unassigned') AS CostCenterName,
           lm.Fname AS VendorName,
           pd.Total AS GrossPurchase
    FROM dbo.ROI_PurchaseMain pm
        INNER JOIN dbo.ROI_PurchaseDetails pd
            ON pm.PurchaseMainID = pd.PurchaseMainID
        LEFT JOIN dbo.ROI_ITEMMain im
            ON im.ITId = pd.ItemID
        LEFT JOIN dbo.ROI_ItemDetails id
            ON id.ITId = pd.ItemID
        LEFT JOIN dbo.CostCenterInfo cc
            ON cc.CostCenterId = id.ItemCostCentreID
        LEFT JOIN dbo.RO_LoyaltyMembership lm
            ON lm.MembershipID = pm.Vid
    WHERE CAST(pm.PbDate AS DATE)
          BETWEEN CAST(@StartDate AS DATE) AND CAST(@EndDate AS DATE)
          AND
          (
              pm.Vid = @VendorID
              OR @VendorID = 0
          )
          AND
          (
              pm.PuNo = @puNo
              OR @puNo = ''
              OR @puNo IS NULL
          )
          AND
          (
              @CostCenterId = 0
              OR cc.CostCenterId = @CostCenterId
              OR
              (
                  @CostCenterId = -1
                  AND cc.CostCenterId IS NULL
              )
          )
    ORDER BY pm.PurchaseMainID DESC;
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[USP_RO_CAKE_GetdataforViewBill]';
GO

ALTER PROCEDURE [dbo].[USP_RO_CAKE_GetdataforViewBill]
    @SalesMasterId INT,
    @SalesType VARCHAR(30)
AS
BEGIN
    DECLARE @code VARCHAR(10);

    SET @code =
    (
        SELECT TOP (1) Code FROM RO_CompanyInfo
    );

    SELECT *
    FROM
    (
        SELECT SD.ItemId,
               ISNULL(SD.Quantity, 0) Quantity,
               ISNULL(SD.Rate, 0) Rate,
               ISNULL(SD.Amount, ISNULL(SD.Quantity, 0) * ISNULL(SD.Rate, 0)) Amount,
               it.HsCode,
               SM.OrderMasterId OrderMasterId,
               '' Note,
               0 ExtraCharge,
               it.ITName,
               SM.BillDate DATE,
               SM.NepaliInvoiceDate,
               SM.BasicAmount,
               SM.NetAmount,
               SM.TenderAmount,
               SM.ReturnAmount,
               ISNULL(SM.PrintCount, 0) AS PrintCount,
               @code + fy.fyName + '-' + CAST((SM.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR) AS BillNo,
               (fy.fyName) AS fiscalYear,
               SM.CustomerId CusID,
               CASE
                   WHEN sp.Customer = '' THEN
                       SM.CustomerName
                   ELSE
                       ISNULL(sp.Customer, SM.CustomerName)
               END CusName,
               SM.ContactNo,
               SM.PAN,
               SM.Address,
               SM.SalesMasterId,
               SM.AddedBy AS Cashier,
               ISNULL(SM.AdvancePayment, 0) AS AdvancePayment,
               ISNULL(OM.DeliveryService, '') DeliveryService,
               ISNULL(OM.DeliveryTime, '') DeliveryTime
        FROM RO_CakeSalesMaster SM
            LEFT JOIN RO_CakeSalesDetail SD
                ON SM.SalesMasterId = SD.SalesMasterId
                   AND LOWER(SM.SalesType) = LOWER(SD.SalesType)
            LEFT JOIN RO_fiscalYear fy
                ON fy.fyId = SM.FiscalYearID
            LEFT JOIN ROI_ITEMMain it
                ON it.ITId = SD.ItemId
            LEFT JOIN RO_CAKE_SalesPaymentMode sp
                ON sp.salesMasterId = SM.SalesMasterId
                   AND LOWER(sp.SalesType) = LOWER(SM.SalesType)
            LEFT JOIN RO_CakeOrderMaster OM
                ON OM.OrderMasterID = SM.OrderMasterId
        WHERE SM.SalesMasterId = @SalesMasterId
              AND LOWER(ISNULL(SM.SalesType, '')) = LOWER(ISNULL(@SalesType, ''))
    ) AS x
    ORDER BY ITName;

    UPDATE RO_CakeOrderMaster
    SET StatusId =
        (
            SELECT Id
            FROM RO_StatusMaster
            WHERE LookUpName = 'paid'
                  AND LOWER(UseFor) = LOWER(@SalesMasterId)
        )
    WHERE OrderMasterID =
    (
        SELECT OrderMasterId
        FROM RO_CakeSalesMaster
        WHERE SalesMasterId = @SalesMasterId
              AND LOWER(ISNULL(SalesType, '')) = LOWER(ISNULL(@SalesType, ''))
    );
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[USP_RO_DailyItemSalesReport]';
GO

ALTER PROCEDURE [dbo].[USP_RO_DailyItemSalesReport]
    @startDate DATETIME,
    @endDate DATETIME,
    @costCenterID INT,
    @PITId INT,
    @Username NVARCHAR(25) = ''
AS
BEGIN
    DECLARE @StartDateTime DATETIME = @startDate;
    DECLARE @EndDateTime DATETIME = @endDate;

    IF @PITId = 0
    BEGIN
        -- ---- Regular sales ------------------------------------------------
        SELECT CAST(SM.BillDate AS DATE) AS BillDate,
               SUM(   CASE
                          WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN
                              ISNULL(SD.qty, 0) - ISNULL(t.SalesReturnQty, 0)
                          ELSE
                              0
                      END
                  ) AS Quantity,
               SD.rate AS Rate,
               rim.ITId,
               rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName,
               SM.Waiter
        FROM dbo.RO_SalesMaster SM
            INNER JOIN dbo.CBMS_BillPostLog bp
                ON bp.SalesMasterId = SM.salesMasterId
            INNER JOIN dbo.RO_SalesDetail SD
                ON SM.salesMasterId = SD.salesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim
                ON rim.ITId = SD.ItemId
            LEFT JOIN dbo.ROI_ItemDetails rid
                ON rid.ITId = rim.ITId
            LEFT JOIN dbo.ROI_Unit1 ru
                ON ru.Unit1Id = rid.SmallUnit
            LEFT JOIN dbo.CostCenterInfo cci
                ON cci.CostCenterId = SD.CostCenterId
            LEFT JOIN dbo.RO_OrderMasters OM
                ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY
        (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView
            WHERE SalesDetailId = SD.salesDetailId
        ) t
        WHERE SD.IsCombo = 0
              AND
              (
                  SD.CostCenterId = @costCenterID
                  OR @costCenterID = 0
              )
              AND (CAST(SM.BillDate AS DATE)
              BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
                  )
              AND ISNULL(SM.IsArchived, 0) = 0
              AND ISNULL(SM.BillCancelled, 0) = 0 -- ← ADDED
              AND
              (
                  SM.Waiter = @Username
                  OR @Username = ''
              )
        GROUP BY CAST(SM.BillDate AS DATE),
                 SD.rate,
                 rim.ITName,
                 ru.Symbol,
                 cci.CostCenterName,
                 rim.ITId,
                 SM.Waiter
        UNION

        -- ---- Cake sales ---------------------------------------------------
        SELECT CAST(SM.BillDate AS DATE) AS BillDate,
               SUM(   CASE
                          WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN
                              ISNULL(SD.Quantity, 0) - ISNULL(t.SalesReturnQty, 0)
                          ELSE
                              0
                      END
                  ) AS Quantity,
               SD.Rate AS Rate,
               rim.ITId,
               rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName,
               SM.AddedBy AS Waiter
        FROM dbo.RO_CakeSalesMaster SM
            INNER JOIN dbo.RO_CakeSalesDetail SD
                ON SM.SalesMasterId = SD.SalesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim
                ON rim.ITId = SD.ItemId
            LEFT JOIN dbo.ROI_ItemDetails rid
                ON rid.ITId = rim.ITId
            LEFT JOIN dbo.ROI_Unit1 ru
                ON ru.Unit1Id = rid.SmallUnit
            LEFT JOIN dbo.CostCenterInfo cci
                ON cci.CostCenterId = SD.CostCenterId
            LEFT JOIN dbo.RO_OrderMasters OM
                ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY
        (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView
            WHERE SalesDetailId = SD.SalesDetailId
        ) t
        WHERE (
                  SD.CostCenterId = @costCenterID
                  OR @costCenterID = 0
              )
              AND (CAST(SM.BillDate AS DATE)
              BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
                  )
              AND ISNULL(SM.IsArchived, 0) = 0
              AND
              (
                  SM.AddedBy = @Username
                  OR @Username = ''
              )
        GROUP BY CAST(SM.BillDate AS DATE),
                 SD.Rate,
                 rim.ITName,
                 ru.Symbol,
                 cci.CostCenterName,
                 rim.ITId,
                 SM.AddedBy
        ORDER BY rim.ITName;
    END;
    ELSE
    BEGIN
        ;WITH CTE (ITid, PITId, ITName)
         AS (SELECT ITId,
                    PITId,
                    ITName
             FROM dbo.ROI_ITEMMain i
             WHERE i.ITId = @PITId
             UNION ALL
             SELECT m.ITId,
                    m.PITId,
                    m.ITName
             FROM dbo.ROI_ITEMMain m
                 INNER JOIN CTE c
                     ON m.PITId = c.ITid)
        SELECT CTE.ITid,
               CTE.PITId,
               CTE.ITName
        INTO #Items
        FROM CTE;

        -- ---- Regular sales, filtered items --------------------------------
        SELECT CAST(SM.BillDate AS DATE) AS BillDate,
               SUM(   CASE
                          WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN
                              ISNULL(SD.qty, 0) - ISNULL(t.SalesReturnQty, 0)
                          ELSE
                              0
                      END
                  ) AS Quantity,
               SD.rate AS Rate,
               rim.ITId,
               rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName,
               SM.Waiter
        FROM dbo.RO_SalesMaster SM
            INNER JOIN dbo.CBMS_BillPostLog bp
                ON bp.SalesMasterId = SM.salesMasterId
            INNER JOIN dbo.RO_SalesDetail SD
                ON SM.salesMasterId = SD.salesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim
                ON rim.ITId = SD.ItemId
            INNER JOIN #Items i
                ON rim.ITId = i.ITid
            LEFT JOIN dbo.ROI_ItemDetails rid
                ON rid.ITId = rim.ITId
            LEFT JOIN dbo.ROI_Unit1 ru
                ON ru.Unit1Id = rid.SmallUnit
            LEFT JOIN dbo.CostCenterInfo cci
                ON cci.CostCenterId = SD.CostCenterId
            LEFT JOIN dbo.RO_OrderMasters OM
                ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY
        (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView
            WHERE SalesDetailId = SD.salesDetailId
        ) t
        WHERE SD.IsCombo = 0
              AND
              (
                  SD.CostCenterId = @costCenterID
                  OR @costCenterID = 0
              )
              AND (CAST(SM.BillDate AS DATE)
              BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
                  )
              AND ISNULL(SM.IsArchived, 0) = 0
              AND ISNULL(SM.BillCancelled, 0) = 0 -- ← ADDED
              AND
              (
                  SM.Waiter = @Username
                  OR @Username = ''
              )
        GROUP BY CAST(SM.BillDate AS DATE),
                 SD.rate,
                 rim.ITName,
                 ru.Symbol,
                 cci.CostCenterName,
                 rim.ITId,
                 SM.Waiter
        UNION

        -- ---- Cake sales, filtered items -----------------------------------
        SELECT CAST(SM.BillDate AS DATE) AS BillDate,
               SUM(   CASE
                          WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN
                              ISNULL(SD.Quantity, 0) - ISNULL(t.SalesReturnQty, 0)
                          ELSE
                              0
                      END
                  ) AS Quantity,
               SD.Rate AS Rate,
               rim.ITId,
               rim.ITName,
               ru.Symbol AS ITUnit,
               cci.CostCenterName,
               SM.AddedBy AS Waiter
        FROM dbo.RO_CakeSalesMaster SM
            INNER JOIN dbo.RO_CakeSalesDetail SD
                ON SM.SalesMasterId = SD.SalesMasterId
            INNER JOIN dbo.ROI_ITEMMain rim
                ON rim.ITId = SD.ItemId
            INNER JOIN #Items i
                ON rim.ITId = i.ITid
            LEFT JOIN dbo.ROI_ItemDetails rid
                ON rid.ITId = rim.ITId
            LEFT JOIN dbo.ROI_Unit1 ru
                ON ru.Unit1Id = rid.SmallUnit
            LEFT JOIN dbo.CostCenterInfo cci
                ON cci.CostCenterId = SD.CostCenterId
            LEFT JOIN dbo.RO_OrderMasters OM
                ON OM.OrderMasterID = SM.OrderMasterId
            OUTER APPLY
        (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView
            WHERE SalesDetailId = SD.SalesDetailId
        ) t
        WHERE (
                  SD.CostCenterId = @costCenterID
                  OR @costCenterID = 0
              )
              AND (CAST(SM.BillDate AS DATE)
              BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE)
                  )
              AND ISNULL(SM.IsArchived, 0) = 0
              AND
              (
                  SM.AddedBy = @Username
                  OR @Username = ''
              )
        GROUP BY CAST(SM.BillDate AS DATE),
                 SD.Rate,
                 rim.ITName,
                 ru.Symbol,
                 cci.CostCenterName,
                 rim.ITId,
                 SM.AddedBy
        ORDER BY rim.ITName;

        DROP TABLE #Items;
    END;
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[usp_ro_GetSalesBook]';
GO

ALTER PROCEDURE [dbo].[usp_ro_GetSalesBook]
    @FromDate NVARCHAR(256),
    @ToDate NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FromDot NVARCHAR(20) = REPLACE(@FromDate, '-', '.');
    DECLARE @ToDot NVARCHAR(20) = REPLACE(@ToDate, '-', '.');

    SELECT *
    FROM
    (
        /* -------- Part A: IRD-submitted bills -------- */
        SELECT cbpl.LogID,
               cbpl.seller_pan,
               cbpl.buyer_pan,
               cbpl.fiscal_year,
               CASE
                   WHEN NULLIF(RTRIM(LTRIM(cbpl.buyer_name)), '') IS NULL THEN
                       STUFF(
                       (
                           SELECT ', ' + CASE
                                             WHEN LOWER(pm2.PaymentMode) = 'credit' THEN
                                                 pm2.PaymentMode + '/' + ISNULL(spm2.Customer, '')
                                             ELSE
                                                 pm2.PaymentMode
                                         END
                           FROM dbo.RO_SalesPaymentMode spm2
                               INNER JOIN dbo.RO_PaymentModes pm2
                                   ON pm2.PaymentModeID = spm2.PaymentModeID
                           WHERE spm2.salesMasterId = cbpl.SalesMasterId
                           FOR XML PATH('')
                       ),
                       1,
                       2,
                       ''
                            )
                   ELSE
                       cbpl.buyer_name
               END AS buyer_name,
               cbpl.invoice_number,
               cbpl.invoice_date,
               cbpl.total_sales,
               cbpl.taxable_sales_vat,
               cbpl.vat,
               cbpl.excisable_amount,
               cbpl.excise,
               cbpl.taxable_sales_hst,
               cbpl.hst,
               cbpl.amount_for_esf,
               cbpl.esf,
               cbpl.export_sales,
               cbpl.tax_exempted_sales,
               cbpl.isrealtime,
               cbpl.datetimeClient,
               cbpl.BillPostDateTime,
               cbpl.StatusCode,
               cbpl.StatusDetails,
               cbpl.SalesMasterId,
               cbpl.EnglishInvDate,
               cbpl.SalesType,
               ISNULL([dbo].[ufn_getsalesbillquantity](cbpl.SalesMasterId), 0) AS Qty
        FROM CBMS_BillPostLog cbpl
        WHERE cbpl.invoice_date
        BETWEEN @FromDot AND @ToDot
        UNION ALL

        /* -------- Part B: not-yet-CBMS cake/retail/wholesale -------- */
        SELECT 0 AS LogID,
               ci.PAN AS seller_pan,
               sm.PAN AS buyer_pan,
               fy.fyName AS fiscal_year,
               sm.CustomerName AS buyer_name,
               ci.Code + fy.fyName + '-' + CAST(sm.InvoiceNo - fy.FirstSalesMasterID AS VARCHAR(20)) AS invoice_number,
               sm.NepaliInvoiceDate AS invoice_date,
               sm.BasicAmount AS total_sales,
               sm.BasicAmount AS taxable_sales_vat,
               ISNULL(vat.Amount, 0) AS vat,
               0 AS excisable_amount,
               0 AS excise,
               0 AS taxable_sales_hst,
               0 AS hst,
               0 AS amount_for_esf,
               0 AS esf,
               0 AS export_sales,
               0 AS tax_exempted_sales,
               0 AS isrealtime,
               sm.AddedOn AS datetimeClient,
               sm.BillDate AS BillPostDateTime,
               CASE
                   WHEN sm.IsArchived = 1 THEN
                       'VOID'
                   ELSE
                       'LOCAL'
               END AS StatusCode,
               CASE
                   WHEN sm.IsArchived = 1 THEN
                       'VOID - CANCELLED (local)'
                   ELSE
                       'LOCAL - NOT IRD SUBMITTED'
               END AS StatusDetails,
               sm.SalesMasterId,
               CONVERT(VARCHAR(19), sm.BillDate, 120) AS EnglishInvDate,
               sm.SalesType,
               ISNULL(qty.Qty, 0) AS Qty
        FROM dbo.RO_CakeSalesMaster sm
            INNER JOIN dbo.RO_fiscalYear fy
                ON fy.fyId = sm.FiscalYearID
            CROSS JOIN
            (SELECT TOP (1) Code, PAN FROM dbo.RO_CompanyInfo) ci
            LEFT JOIN dbo.RO_CAKE_BillingAmount vat
                ON vat.SalesMasterID = sm.SalesMasterId
                   AND vat.BilingID = 54
                   AND LOWER(ISNULL(vat.SalesType, '')) = LOWER(ISNULL(sm.SalesType, ''))
            OUTER APPLY
        (
            SELECT SUM(sd.Quantity) AS Qty
            FROM dbo.RO_CakeSalesDetail sd
            WHERE sd.SalesMasterId = sm.SalesMasterId
                  AND LOWER(ISNULL(sd.SalesType, '')) = LOWER(ISNULL(sm.SalesType, ''))
        ) qty
        WHERE sm.IsUpdated = 1
              AND LOWER(ISNULL(sm.SalesType, '')) IN ( 'cake', 'retail', 'wholesale' )
              AND sm.NepaliInvoiceDate
              BETWEEN @FromDot AND @ToDot
              AND NOT EXISTS
        (
            SELECT 1
            FROM dbo.CBMS_BillPostLog posted
            WHERE posted.SalesMasterId = sm.SalesMasterId
                  AND LOWER(ISNULL(posted.SalesType, '')) = LOWER(ISNULL(sm.SalesType, ''))
        )
    ) x
    ORDER BY x.invoice_date,
             CAST(RIGHT(x.invoice_number, LEN(x.invoice_number) - CHARINDEX('-', x.invoice_number)) AS INT);
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[USP_cbms_getCbmsData]';
GO

ALTER PROCEDURE [dbo].[USP_cbms_getCbmsData]
AS
BEGIN
    DECLARE @totalSales INT,
            @SyncedSalesBill INT,
            @UnSyncedSalesBill INT,
            @SyncedReturnedSalesBill INT,
            @UnSyncedReturnedSalesBill INT;

    SELECT @totalSales = COUNT(*)
    FROM dbo.RO_SalesMaster;

    SELECT @SyncedSalesBill = ISNULL(SUM(   CASE
                                                WHEN bp.StatusCode = '200' THEN
                                                    1
                                            END
                                        ),
                                     0
                                    ),
           @UnSyncedSalesBill = ISNULL(SUM(   CASE
                                                  WHEN bp.StatusCode != '200' THEN
                                                      1
                                              END
                                          ),
                                       0
                                      )
    FROM dbo.CBMS_BillPostLog bp;

    SELECT @SyncedReturnedSalesBill = ISNULL(SUM(   CASE
                                                        WHEN brp.StatusCode = '200' THEN
                                                            1
                                                    END
                                                ),
                                             0
                                            ),
           @UnSyncedReturnedSalesBill = ISNULL(SUM(   CASE
                                                          WHEN brp.StatusCode != '200' THEN
                                                              1
                                                      END
                                                  ),
                                               0
                                              )
    FROM dbo.CBMS_BillReturnPostLog brp
    WHERE ISNULL(brp.SalesType, '') = '';

    SELECT ISNULL(@totalSales, 0) AS TotalSales,
           @SyncedSalesBill AS SyncedSalesBill,
           @UnSyncedSalesBill AS UnSyncedSalesBill,
           @SyncedReturnedSalesBill AS SyncedReturnedSalesBill,
           @UnSyncedReturnedSalesBill AS UnSyncedReturnedSalesBill;
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[usp_GetUnitOfItemByID]';
GO
ALTER PROCEDURE [dbo].[usp_GetUnitOfItemByID] @ids INT
AS
SELECT DISTINCT
       ir.ItemID,
       ISNULL(u1.UnitDescription, 'N/A') AS UnitDescription,
       ISNULL(u1.Symbol, 'N/A') AS Symbol,
       id.IsExpirable,
       ir.LargeUnit
FROM ROI_ItemRate ir
    LEFT JOIN ROI_Unit1 u1
        ON u1.Unit1Id = ir.LargeUnit
    LEFT JOIN ROI_ItemDetails id
        ON id.ITId = ir.ItemID
WHERE ir.ItemID = @ids;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[USP_cbms_getReturnErrorBillPostLog]';
GO

ALTER PROCEDURE [dbo].[USP_cbms_getReturnErrorBillPostLog]
AS
BEGIN
    SELECT rbp.ReturnLogID,
           rbp.seller_pan,
           rbp.buyer_pan,
           rbp.fiscal_year,
           rbp.buyer_name,
           rbp.ref_invoice_number,
           rbp.credit_note_number,
           rbp.credit_note_date,
           rbp.reason_for_return,
           rbp.total_sales,
           rbp.taxable_sales_vat,
           rbp.vat,
           rbp.excisable_amount,
           rbp.excise,
           rbp.taxable_sales_hst,
           rbp.hst,
           rbp.amount_for_esf,
           rbp.esf,
           rbp.export_sales,
           rbp.tax_exempted_sales,
           rbp.SalesMasterId
    FROM dbo.CBMS_BillReturnPostLog rbp
    WHERE rbp.StatusCode != '200'
          AND ISNULL(rbp.SalesType, '') = '';
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[usp_ro_getBillBody]';
GO

ALTER PROCEDURE [dbo].[usp_ro_getBillBody] @SalesMasterID INT
AS
BEGIN
    SELECT fy.fyName,
           rr.restroRoom,
           rt.restrotableTitle,
           im.ITName,
           im.HsCode,         -- pos 5
           cc.CostCenterName, -- pos 6
           cc.coDiscount,     -- pos 7
           sm.*,              -- pos 8+
           sm.BillDate AS [Date],
           sd.*,
           sd.qty AS Quantity,
           sm.CusName
    FROM dbo.RO_SalesMaster sm
        JOIN dbo.RO_SalesDetail sd
            ON sd.salesMasterId = sm.salesMasterId
        JOIN dbo.RO_fiscalYear fy
            ON sm.FiscalYearID = fy.fyId
        LEFT JOIN dbo.RO_restroTable rt
            ON rt.restrotableId = sm.TableId
        LEFT JOIN dbo.RO_RestroRoom rr
            ON rr.restroRoomId = rt.restroRoomId
        JOIN dbo.ROI_ITEMMain im
            ON im.ITId = sd.ItemId
        JOIN dbo.CostCenterInfo cc
            ON cc.CostCenterId = sd.CostCenterId
    WHERE sm.salesMasterId = @SalesMasterID
    UNION
    SELECT fy.fyName,
           rr.restroRoom,
           rt.restrotableTitle,
           'Room: ' + rt.restrotableTitle AS ITName,
           sd.HsCode,         -- pos 5  ← aligned to im.HsCode
           cc.CostCenterName, -- pos 6
           cc.coDiscount,     -- pos 7
           sm.*,              -- pos 8+
           sm.BillDate AS [Date],
           sd.*,
           sd.qty AS Quantity,
           sm.CusName
    FROM dbo.RO_SalesMaster sm
        JOIN dbo.RO_SalesDetail sd
            ON sd.salesMasterId = sm.salesMasterId
               AND sd.CostCenterId = 3
        JOIN dbo.RO_fiscalYear fy
            ON sm.FiscalYearID = fy.fyId
        INNER JOIN dbo.RO_restroTable rt
            ON rt.restrotableId = sm.TableId
        JOIN dbo.RO_RestroRoom rr
            ON rr.restroRoomId = rt.restroRoomId
        LEFT JOIN dbo.CostCenterInfo cc
            ON cc.CostCenterId = sd.CostCenterId
    WHERE sm.salesMasterId = @SalesMasterID;
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Creating [dbo].[USP_RO_CAKE_CancelReason]';
GO

ALTER PROCEDURE [dbo].[USP_RO_CAKE_CancelReason]
    @salesMasterId INT,
    @SalesType VARCHAR(30),
    @Reasons NVARCHAR(MAX),
    @userName NVARCHAR(256),
    @creditNoteDate NVARCHAR(256),
    @restoreOrder BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF LOWER(ISNULL(@SalesType, '')) NOT IN ( 'cake', 'retail', 'wholesale' )
        THROW 50001, 'Unsupported sales type for cake-family bill cancellation.', 1;

    IF @restoreOrder = 1
        THROW 50002, 'Order restoration is not supported by the cake-family sales return path.', 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @isArchived BIT;
        DECLARE @orderMasterId INT;
        DECLARE @invoiceNo INT;
        DECLARE @fiscalYearId INT;
        DECLARE @basicAmount DECIMAL(18, 2);
        DECLARE @netAmount DECIMAL(18, 2);
        DECLARE @fiscalYear NVARCHAR(256);
        DECLARE @firstSalesMasterId INT;
        DECLARE @invoiceCode NVARCHAR(256);
        DECLARE @sellerPan NVARCHAR(256);
        DECLARE @buyerPan NVARCHAR(256);
        DECLARE @buyerName NVARCHAR(256);
        DECLARE @vat DECIMAL(18, 2);
        DECLARE @creditNoteNumber NVARCHAR(256);
        DECLARE @creditNoteSequence INT;
        DECLARE @returnLogId INT;

        SELECT @isArchived = ISNULL(sm.IsArchived, 0),
               @orderMasterId = sm.OrderMasterId,
               @invoiceNo = sm.InvoiceNo,
               @fiscalYearId = sm.FiscalYearID,
               @basicAmount = ISNULL(sm.BasicAmount, 0),
               @netAmount = ISNULL(sm.NetAmount, 0),
               @buyerPan = sm.PAN,
               @buyerName = sm.CustomerName
        FROM dbo.RO_CakeSalesMaster sm WITH (UPDLOCK, HOLDLOCK)
        WHERE sm.SalesMasterId = @salesMasterId
              AND LOWER(ISNULL(sm.SalesType, '')) = LOWER(@SalesType);

        IF @orderMasterId IS NULL
            THROW 50003, 'Bill was not found for the supplied sales type.', 1;

        IF EXISTS
        (
            SELECT 1
            FROM dbo.CBMS_BillReturnPostLog WITH (UPDLOCK, HOLDLOCK)
            WHERE SalesMasterId = @salesMasterId
                  AND LOWER(ISNULL(SalesType, '')) = LOWER(@SalesType)
                  AND StatusCode = 'LOCAL'
        )
        BEGIN
            IF @isArchived = 1
            BEGIN
                COMMIT TRANSACTION;
                RETURN;
            END;

            THROW 50004, 'A local credit note already exists for an active bill; reconcile before retrying.', 1;
        END;

        IF @isArchived = 1
            THROW 50005, 'Bill is already archived but has no local credit note; reconcile before retrying.', 1;

        SELECT @fiscalYear = fy.fyName,
               @firstSalesMasterId = fy.FirstSalesMasterID
        FROM dbo.RO_fiscalYear fy
        WHERE fy.fyId = @fiscalYearId;

        SELECT TOP (1)
               @invoiceCode = ci.Code,
               @sellerPan = ci.PAN
        FROM dbo.RO_CompanyInfo ci;

        SELECT @vat = ISNULL(ba.Amount, 0)
        FROM dbo.RO_CAKE_BillingAmount ba
        WHERE ba.SalesMasterID = @salesMasterId
              AND ba.BilingID = 54
              AND LOWER(ISNULL(ba.SalesType, '')) = LOWER(@SalesType);

        IF @fiscalYear IS NULL
           OR @invoiceCode IS NULL
            THROW 50006, 'Fiscal-year or company invoice configuration is missing.', 1;

        SELECT @creditNoteSequence
            = ISNULL(
                        MAX(   CASE
                                   WHEN ISNUMERIC(SUBSTRING(
                                                               credit_note_number,
                                                               CHARINDEX('-', credit_note_number) + 1,
                                                               LEN(credit_note_number)
                                                           )
                                                 ) = 1 THEN
                                       CAST(SUBSTRING(
                                                         credit_note_number,
                                                         CHARINDEX('-', credit_note_number) + 1,
                                                         LEN(credit_note_number)
                                                     ) AS INT)
                                   ELSE
                                       0
                               END
                           ),
                        0
                    ) + 1
        FROM dbo.CBMS_BillReturnPostLog WITH (UPDLOCK, HOLDLOCK)
        WHERE fiscal_year = @fiscalYear;

        SET @creditNoteNumber = N'CN' + @fiscalYear + N'-' + CONVERT(VARCHAR(20), @creditNoteSequence);

        INSERT INTO dbo.CBMS_BillReturnPostLog
        (
            seller_pan,
            buyer_pan,
            fiscal_year,
            buyer_name,
            ref_invoice_number,
            credit_note_number,
            credit_note_date,
            reason_for_return,
            total_sales,
            taxable_sales_vat,
            vat,
            excisable_amount,
            excise,
            taxable_sales_hst,
            hst,
            amount_for_esf,
            esf,
            export_sales,
            tax_exempted_sales,
            isrealtime,
            datetimeClient,
            BillReturnDateTime,
            StatusCode,
            StatusDetails,
            SalesMasterId,
            SalesType
        )
        VALUES
        (@sellerPan, @buyerPan, @fiscalYear, @buyerName,
         @invoiceCode + @fiscalYear + '-' + CONVERT(VARCHAR(20), @invoiceNo - @firstSalesMasterId), @creditNoteNumber,
         @creditNoteDate, @Reasons, @basicAmount, @basicAmount, ISNULL(@vat, 0), 0, 0, 0, 0, 0, 0, 0, 0, 0, GETDATE(),
         GETDATE(), 'LOCAL', 'Internal credit note; not submitted to IRD.', @salesMasterId, @SalesType);

        SET @returnLogId = CONVERT(INT, SCOPE_IDENTITY());

        DECLARE @creditPayments TABLE
        (
            MembershipID INT NOT NULL,
            CreditAmount DECIMAL(18, 2) NOT NULL
        );

        INSERT INTO @creditPayments
        (
            MembershipID,
            CreditAmount
        )
        SELECT ISNULL(spm.CusID, 0),
               SUM(ISNULL(spm.PayAmount, 0))
        FROM dbo.RO_CAKE_SalesPaymentMode spm
        WHERE spm.salesMasterId = @salesMasterId
              AND spm.PaymentModeID = 4
              AND LOWER(ISNULL(spm.SalesType, '')) = LOWER(@SalesType)
        GROUP BY ISNULL(spm.CusID, 0)
        HAVING SUM(ISNULL(spm.PayAmount, 0)) <> 0;

        DECLARE @membershipId INT;
        DECLARE @creditAmount DECIMAL(18, 2);

        DECLARE credit_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT MembershipID,
               CreditAmount
        FROM @creditPayments;

        OPEN credit_cursor;
        FETCH NEXT FROM credit_cursor
        INTO @membershipId,
             @creditAmount;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE dbo.RO_LoyaltyMembership
            SET RemainingBalance = ISNULL(RemainingBalance, 0) - @creditAmount
            WHERE MembershipID = @membershipId;

            INSERT INTO dbo.RO_MemberPay
            (
                MemberID,
                RemainingAmount,
                PayAmount,
                AddedOn,
                AddedBy,
                IsActive,
                GoodReceivedMainId,
                SettlementAmount,
                ReturnAmount
            )
            VALUES
            (@membershipId, -@creditAmount, 0, GETDATE(), @userName, 1, 0, NULL, 0);

            FETCH NEXT FROM credit_cursor
            INTO @membershipId,
                 @creditAmount;
        END;

        CLOSE credit_cursor;
        DEALLOCATE credit_cursor;

        UPDATE dbo.RO_CakeSalesMaster
        SET IsArchived = 1,
            ArchivedBy = @userName,
            ArchivedOn = GETDATE(),
            Reasons = @Reasons
        WHERE SalesMasterId = @salesMasterId
              AND LOWER(ISNULL(SalesType, '')) = LOWER(@SalesType)
              AND IsArchived = 0;

        UPDATE dbo.RO_CakeOrderMaster
        SET CancelReason = @Reasons,
            StatusId =
            (
                SELECT TOP (1)
                       Id
                FROM dbo.RO_StatusMaster
                WHERE LOWER(LookUpName) = 'cancelled'
                ORDER BY Id
            )
        WHERE OrderMasterID = @orderMasterId
              AND LOWER(ISNULL(SalesType, '')) = LOWER(@SalesType);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local', 'credit_cursor') >= 0
            CLOSE credit_cursor;
        IF CURSOR_STATUS('local', 'credit_cursor') > -3
            DEALLOCATE credit_cursor;

        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[USP_RO_GetBillInfo]';
GO

ALTER PROCEDURE [dbo].[USP_RO_GetBillInfo]
    @salesMasterId INT,
    @SalesType VARCHAR(30) = NULL
AS
DECLARE @code NVARCHAR(10);

SELECT TOP (1)
       @code = Code
FROM RO_CompanyInfo;

IF (ISNULL(@SalesType, '') = '')
BEGIN
    SELECT @code + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS NVARCHAR) AS InvoiceNo,
           bp.invoice_date AS InvoiceDate,
           ISNULL(sm.IsArchived, 0) AS IsArchived,
           ISNULL(sm.BillCancelled, 0) AS IsCancelled,
           brp.credit_note_number AS CreditNoteNumber,
           brp.credit_note_date AS CreditNoteDate,
           brp.reason_for_return AS CreditNoteReason,
           (sm.NetAmount - sm.AdvancePayment) AS TotalAmount,
           sm.CusID AS CustomerID,
           sm.CusName AS CustomerName
    FROM RO_SalesMaster sm
        INNER JOIN RO_fiscalYear fy
            ON sm.FiscalYearID = fy.fyId
        LEFT JOIN CBMS_BillPostLog bp
            ON bp.SalesMasterId = sm.salesMasterId
               AND LOWER(ISNULL(bp.SalesType, '')) = ''
        LEFT JOIN CBMS_BillReturnPostLog brp
            ON brp.SalesMasterId = sm.salesMasterId
               AND LOWER(ISNULL(brp.SalesType, '')) = ''
    WHERE sm.salesMasterId = @salesMasterId;
END;
ELSE
BEGIN
    SELECT @code + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS NVARCHAR) AS InvoiceNo,
           bp.invoice_date AS InvoiceDate,
           ISNULL(sm.IsArchived, 0) AS IsArchived,
           ISNULL(sm.IsArchived, 0) AS IsCancelled, -- ◄ cake uses IsArchived
           brp.credit_note_number AS CreditNoteNumber,
           brp.credit_note_date AS CreditNoteDate,
           brp.reason_for_return AS CreditNoteReason,
           (sm.NetAmount - sm.AdvancePayment) AS TotalAmount,
           0 AS CustomerID,
           sm.CustomerName AS CustomerName
    FROM RO_CakeSalesMaster sm
        INNER JOIN RO_fiscalYear fy
            ON sm.FiscalYearID = fy.fyId
        LEFT JOIN CBMS_BillPostLog bp
            ON bp.SalesMasterId = sm.SalesMasterId
               AND LOWER(ISNULL(bp.SalesType, '')) = LOWER(ISNULL(sm.SalesType, ''))
        LEFT JOIN CBMS_BillReturnPostLog brp
            ON brp.SalesMasterId = sm.SalesMasterId
               AND LOWER(ISNULL(brp.SalesType, '')) = LOWER(ISNULL(sm.SalesType, ''))
    WHERE sm.SalesMasterId = @salesMasterId
          AND LOWER(ISNULL(sm.SalesType, '')) = LOWER(@SalesType);
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[USP_RO_ITEMSALESREPORT]';
GO
-- Stored Procedure

--sp_helptext usp_ro_itemsalesreport '2017-09-01 00:00','2017-09-16 24:00'
ALTER PROCEDURE [dbo].[USP_RO_ITEMSALESREPORT]
    @Start DATETIME,
    @End DATETIME
--@Start DATETIME = '2017-01-02', @End DATETIME  = '2017-01-31'
AS
BEGIN

    SELECT CAST(SM.BillDate AS DATE) AS BillDate,
           CCI.CostCenterName,
           Im.ITName,
           SUM(SD.qty) AS QTY,
           SD.rate,
           --,sum(sd.Amount)  Amount
           SUM(SD.qty * SD.rate) NetAmount,
           SD.IsCombo,
           ru.Symbol AS ITUnit
    FROM RO_SalesMaster SM
        INNER JOIN RO_SalesDetail SD
            ON SM.salesMasterId = SD.salesMasterId
        INNER JOIN ROI_ITEMMain Im
            ON Im.ITId = SD.ItemId
        LEFT JOIN CostCenterInfo CCI
            ON CCI.CostCenterId = SD.CostCenterId
        LEFT JOIN ROI_ItemDetails itd
            ON Im.ITId = itd.ITId
        LEFT JOIN ROI_Unit1 ru
            ON ru.Unit1Id = itd.SmallUnit
    WHERE IsCombo = 0
          AND (CAST(SM.BillDate AS DATE)
          BETWEEN @Start AND @End
              )
    --AND (SM.BillDate >= @Start AND SM.BillDate <= @End)
    GROUP BY CAST(SM.BillDate AS DATE),
             CCI.CostCenterName,
             Im.ITName,
             SD.rate,
             SD.IsCombo,
             ru.Symbol
    UNION
    SELECT CAST(SM.BillDate AS DATE) AS BillDate,
           CCI.CostCenterName,
           Im.Name,
           SUM(SD.qty) AS QTY,
           SD.rate,
           --,sum(sd.Amount)  Amount
           SUM(SD.qty * SD.rate) NetAmount,
           SD.IsCombo,
           'Pack' AS ITUnit
    FROM RO_SalesMaster SM
        INNER JOIN RO_SalesDetail SD
            ON SM.salesMasterId = SD.salesMasterId
        INNER JOIN RO_Combo Im
            ON Im.ComboID = SD.ItemId
        LEFT JOIN CostCenterInfo CCI
            ON CCI.CostCenterId = SD.CostCenterId
    WHERE IsCombo = 1
          AND (CAST(SM.BillDate AS DATE)
          BETWEEN @Start AND @End
              )
    --AND (SM.BillDate >= @Start AND SM.BillDate <= @End)
    GROUP BY CAST(SM.BillDate AS DATE),
             CCI.CostCenterName,
             Im.Name,
             SD.rate,
             SD.IsCombo;

END;


GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering [dbo].[usp_RoleNamesGetByUserName]';
GO

ALTER PROCEDURE [dbo].[usp_RoleNamesGetByUserName]
(
    @UserName NVARCHAR(256),
    @PortalID INT
)
AS
BEGIN
    DECLARE @RoleName NVARCHAR(4000);
    SELECT @RoleName = COALESCE(@RoleName + ',', '') + RoleName
    FROM dbo.vw_PortalUsers sfu
        INNER JOIN aspnet_UsersInRoles AS uir
            ON uir.UserId = sfu.UserId
        INNER JOIN aspnet_Roles AS r
            ON r.RoleId = uir.RoleId
    WHERE (
              r.RoleName = 'Super User'
              OR PortalID = @PortalID
          )
          AND UserName = @UserName
    ORDER BY CreditLimit DESC;
    SELECT @RoleName AS RoleName;
END;






GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering trigger [dbo].[CBMS_BillPostLog_UPDATE] on [dbo].[CBMS_BillPostLog]';
GO


ALTER TRIGGER [dbo].[CBMS_BillPostLog_UPDATE]
ON [dbo].[CBMS_BillPostLog]
FOR UPDATE
AS

--IF EXISTS(SELECT * FROM DELETED d WHERE LTRIM(RTRIM(d.StatusCode))='200')
--BEGIN
--ROLLBACK TRANSACTION
--RAISERROR ('Update and Deletions not allowed from this table' , 16, 1)
--END

IF
(
    SELECT COUNT(1)
    FROM INSERTED i
        INNER JOIN DELETED d
            ON i.LogID = d.LogID
               AND i.seller_pan = d.seller_pan
               AND i.buyer_pan = d.buyer_pan
               AND i.fiscal_year = d.fiscal_year
               AND i.buyer_name = d.buyer_name
               AND i.invoice_number = d.invoice_number --AND  i.invoice_date=d.invoice_date 
               AND i.total_sales = d.total_sales
               AND i.taxable_sales_vat = d.taxable_sales_vat
               AND i.vat = d.vat
               AND i.excisable_amount = d.excisable_amount
               AND i.excise = d.excise
               AND i.taxable_sales_hst = d.taxable_sales_hst
               AND i.hst = d.hst
               AND i.amount_for_esf = d.amount_for_esf
               AND i.esf = d.esf
               AND i.export_sales = d.export_sales
               AND i.tax_exempted_sales = d.tax_exempted_sales
               AND i.datetimeClient = d.datetimeClient
               AND i.SalesMasterId = d.SalesMasterId
               AND i.EnglishInvDate = d.EnglishInvDate
) = 0
BEGIN
    ROLLBACK TRANSACTION;
    RAISERROR('Update and Deletions not allowed from this table', 16, 1);
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
DISABLE TRIGGER [dbo].[CBMS_BillPostLog_UPDATE] ON [dbo].[CBMS_BillPostLog];
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
PRINT N'Altering trigger [dbo].[RO_SalesMaster_UPDATE] on [dbo].[RO_SalesMaster]';
GO

ALTER TRIGGER [dbo].[RO_SalesMaster_UPDATE]
ON [dbo].[RO_SalesMaster]
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM INSERTED AS i
            INNER JOIN DELETED AS d
                ON i.salesMasterId = d.salesMasterId
        WHERE ISNULL(i.FiscalYearID, 0) <> ISNULL(d.FiscalYearID, 0)
              OR ISNULL(i.billNo, '') <> ISNULL(d.billNo, '')
              OR ISNULL(i.BillDate, '19000101') <> ISNULL(d.BillDate, '19000101')
              OR ISNULL(i.RoomId, 0) <> ISNULL(d.RoomId, 0)
              OR ISNULL(i.TableId, 0) <> ISNULL(d.TableId, 0)
              OR ISNULL(i.BasicAmount, 0) <> ISNULL(d.BasicAmount, 0)
              OR ISNULL(i.TermAmount, 0) <> ISNULL(d.TermAmount, 0)
              OR ISNULL(i.NetAmount, 0) <> ISNULL(d.NetAmount, 0)
              OR ISNULL(i.OrderMasterId, 0) <> ISNULL(d.OrderMasterId, 0)
              OR ISNULL(i.Waiter, '') <> ISNULL(d.Waiter, '')
              OR ISNULL(i.totaldiscount, 0) <> ISNULL(d.totaldiscount, 0)
              OR ISNULL(i.sumBev, 0) <> ISNULL(d.sumBev, 0)
              OR ISNULL(i.sumKot, 0) <> ISNULL(d.sumKot, 0)
              OR ISNULL(i.disKot, 0) <> ISNULL(d.disKot, 0)
              OR ISNULL(i.disBar, 0) <> ISNULL(d.disBar, 0)
              OR ISNULL(i.AddedBy, '') <> ISNULL(d.AddedBy, '')
              OR ISNULL(i.AddedOn, '19000101') <> ISNULL(d.AddedOn, '19000101')
              OR ISNULL(i.IsSplit, 0) <> ISNULL(d.IsSplit, 0)
              OR ISNULL(i.SeatNo, 0) <> ISNULL(d.SeatNo, 0)
              OR ISNULL(i.RoomRate, 0) <> ISNULL(d.RoomRate, 0)
              OR ISNULL(i.BookedDays, 0) <> ISNULL(d.BookedDays, 0)
              OR ISNULL(i.RoomCharge, 0) <> ISNULL(d.RoomCharge, 0)
              OR ISNULL(i.AdvancePayment, 0) <> ISNULL(d.AdvancePayment, 0)
              OR ISNULL(i.NepaliInvoiceDate, '19000101') <> ISNULL(d.NepaliInvoiceDate, '19000101')
    )
    BEGIN
        ROLLBACK TRANSACTION;

        RAISERROR('Update and Deletions not allowed from this table', 16, 1);

        RETURN;
    END;
END;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
DISABLE TRIGGER [dbo].[RO_SalesMaster_UPDATE] ON [dbo].[RO_SalesMaster];
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
COMMIT TRANSACTION;
GO
IF @@ERROR <> 0
    SET NOEXEC ON;
GO
-- This statement writes to the SQL Server Log so SQL Monitor can show this deployment.
IF HAS_PERMS_BY_NAME(N'sys.xp_logevent', N'OBJECT', N'EXECUTE') = 1
BEGIN
    DECLARE @databaseName AS NVARCHAR(2048),
            @eventMessage AS NVARCHAR(2048);
    SET @databaseName = REPLACE(REPLACE(DB_NAME(), N'\', N'\\'), N'"', N'\"');
    SET @eventMessage
        = N'Redgate SQL Compare: { "deployment": { "description": "Redgate SQL Compare deployed to ' + @databaseName
          + N'", "database": "' + @databaseName + N'" }}';
    EXECUTE sys.xp_logevent 55000, @eventMessage;
END;
GO
DECLARE @Success AS BIT;
SET @Success = 1;
SET NOEXEC OFF;
IF (@Success = 1)
    PRINT 'The database update succeeded';
ELSE
BEGIN
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    PRINT 'The database update failed';
END;
GO
