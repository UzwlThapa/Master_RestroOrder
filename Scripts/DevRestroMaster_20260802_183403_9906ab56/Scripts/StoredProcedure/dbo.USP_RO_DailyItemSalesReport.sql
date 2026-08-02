SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_DailyItemSalesReport]
    @startDate DATETIME,
    @endDate DATETIME,
    @costCenterID INT,
    @PITId INT,
    @Username NVARCHAR(25) = ''
AS
BEGIN
    -- Use consistent date handling to match with summary report
    -- No time shifting or manipulation
    DECLARE @StartDateTime DATETIME = @startDate;
    DECLARE @EndDateTime DATETIME = @endDate;
    
    IF @PITId = 0
    BEGIN
        -- Regular sales
        SELECT   
            CAST(SM.BillDate AS DATE) AS BillDate,
            SUM(CASE 
                    WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN ISNULL(SD.qty, 0) - ISNULL(t.SalesReturnQty, 0)
                    ELSE 0  -- If cancelled, don't count
                END) AS Quantity,
            SD.rate AS Rate,
            rim.ITId,
            rim.ITName,
            ru.Symbol AS ITUnit,
            cci.CostCenterName,
            SM.Waiter
        FROM dbo.RO_SalesMaster SM
        INNER JOIN dbo.CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
        INNER JOIN dbo.RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
        INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
        LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
        LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
        LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
        LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
        OUTER APPLY (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView 
            WHERE SalesDetailId = SD.salesDetailId
        ) t
        WHERE 
            SD.IsCombo = 0
            AND (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
            AND (CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE))
            AND ISNULL(SM.IsArchived, 0) = 0
            AND (SM.Waiter = @Username OR @Username = '')
        GROUP BY 
            CAST(SM.BillDate AS DATE),
            SD.rate,
            rim.ITName,
            ru.Symbol,
            cci.CostCenterName,
            rim.ITId,
            SM.Waiter
        
        UNION
        
        -- Cake sales
        SELECT   
            CAST(SM.BillDate AS DATE) AS BillDate,
            SUM(CASE 
                    WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN ISNULL(SD.Quantity, 0) - ISNULL(t.SalesReturnQty, 0)
                    ELSE 0  -- If cancelled, don't count
                END) AS Quantity,
            SD.Rate AS Rate,
            rim.ITId,
            rim.ITName,
            ru.Symbol AS ITUnit,
            cci.CostCenterName,
            SM.AddedBy AS Waiter
        FROM dbo.RO_CakeSalesMaster SM
        INNER JOIN dbo.RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
        INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
        LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
        LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
        LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
        LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
        OUTER APPLY (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView 
            WHERE SalesDetailId = SD.SalesDetailId
        ) t
        WHERE 
            (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
            AND (CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE))
            AND ISNULL(SM.IsArchived, 0) = 0
            AND (SM.AddedBy = @Username OR @Username = '')
        GROUP BY 
            CAST(SM.BillDate AS DATE),
            SD.Rate,
            rim.ITName,
            ru.Symbol,
            cci.CostCenterName,
            rim.ITId,
            SM.AddedBy
        ORDER BY rim.ITName;
    END
    ELSE
    BEGIN
        -- Create recursive CTE to get all items under parent item
        ;WITH CTE (ITid, PITId, ITName)
        AS (
            SELECT 
                ITId,
                PITId,
                ITName
            FROM dbo.ROI_ITEMMain i
            WHERE i.ITId = @PITId
            
            UNION ALL
            
            SELECT 
                m.ITId,
                m.PITId,
                m.ITName
            FROM dbo.ROI_ITEMMain m
            INNER JOIN CTE c ON m.PITId = c.ITid
        )
        SELECT 
            CTE.ITid,
            CTE.PITId,
            CTE.ITName
        INTO #Items
        FROM CTE;

        -- Regular sales with filtered items
        SELECT   
            CAST(SM.BillDate AS DATE) AS BillDate,
            SUM(CASE 
                    WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN ISNULL(SD.qty, 0) - ISNULL(t.SalesReturnQty, 0)
                    ELSE 0  -- If cancelled, don't count
                END) AS Quantity,
            SD.rate AS Rate,
            rim.ITId,
            rim.ITName,
            ru.Symbol AS ITUnit,
            cci.CostCenterName,
            SM.Waiter
        FROM dbo.RO_SalesMaster SM
        INNER JOIN dbo.CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
        INNER JOIN dbo.RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
        INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
        INNER JOIN #Items i ON rim.ITId = i.ITid
        LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
        LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
        LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
        LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
        OUTER APPLY (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView 
            WHERE SalesDetailId = SD.salesDetailId
        ) t
        WHERE 
            SD.IsCombo = 0
            AND (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
            AND (CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE))
            AND ISNULL(SM.IsArchived, 0) = 0
            AND (SM.Waiter = @Username OR @Username = '')
        GROUP BY 
            CAST(SM.BillDate AS DATE),
            SD.rate,
            rim.ITName,
            ru.Symbol,
            cci.CostCenterName,
            rim.ITId,
            SM.Waiter
        
        UNION
        
        -- Cake sales with filtered items
        SELECT   
            CAST(SM.BillDate AS DATE) AS BillDate,
            SUM(CASE 
                    WHEN ISNULL(OM.IsCancelled, 0) = 0 THEN ISNULL(SD.Quantity, 0) - ISNULL(t.SalesReturnQty, 0)
                    ELSE 0  -- If cancelled, don't count
                END) AS Quantity,
            SD.Rate AS Rate,
            rim.ITId,
            rim.ITName,
            ru.Symbol AS ITUnit,
            cci.CostCenterName,
            SM.AddedBy AS Waiter
        FROM dbo.RO_CakeSalesMaster SM
        INNER JOIN dbo.RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
        INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
        INNER JOIN #Items i ON rim.ITId = i.ITid
        LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
        LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
        LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
        LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
        OUTER APPLY (
            SELECT SUM(SalesReturnQty) AS SalesReturnQty
            FROM dbo.vw_ROI_StockReportView 
            WHERE SalesDetailId = SD.SalesDetailId
        ) t
        WHERE 
            (SD.CostCenterId = @costCenterID OR @costCenterID = 0)
            AND (CAST(SM.BillDate AS DATE) BETWEEN CAST(@StartDateTime AS DATE) AND CAST(@EndDateTime AS DATE))
            AND ISNULL(SM.IsArchived, 0) = 0
            AND (SM.AddedBy = @Username OR @Username = '')
        GROUP BY 
            CAST(SM.BillDate AS DATE),
            SD.Rate,
            rim.ITName,
            ru.Symbol,
            cci.CostCenterName,
            rim.ITId,
            SM.AddedBy
        ORDER BY rim.ITName;
        
        -- Clean up
        DROP TABLE #Items;
    END;
END;
GO
