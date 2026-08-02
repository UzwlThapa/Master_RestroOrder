SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [usp_RO_MonthlyClosingSalesDetailStatement] '2018-08-28 0:0','2018-08-28  23:59'
-- drop PROC [dbo].[usp_RO_MonthlyClosingSalesDetailStatement]
CREATE PROCEDURE [dbo].[usp_RO_MonthlyClosingSalesDetailStatement]
    @startDate DATETIME,
    @endDate DATETIME
AS
BEGIN
    SELECT im.ITId,
           im.ITName,
           cci.CostCenterName,
           SUM(sd.qty) AS QTY,
           sd.rate AS Rate,
           u.Symbol
    FROM dbo.RO_SalesMaster sm
        INNER JOIN dbo.CBMS_BillPostLog bp
            ON bp.SalesMasterId = sm.salesMasterId
        INNER JOIN dbo.RO_SalesDetail sd
            ON sm.salesMasterId = sd.salesMasterId
        INNER JOIN dbo.ROI_ITEMMain im
            ON im.ITId = sd.ItemId
        INNER JOIN dbo.ROI_ItemDetails id
            ON im.ITId = id.ITId
        LEFT JOIN dbo.ROI_Unit1 u
            ON u.Unit1Id = id.SmallUnit
        INNER JOIN dbo.CostCenterInfo cci
            ON sd.CostCenterId = cci.CostCenterId
    WHERE (sm.BillDate
          BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
          )
          AND sd.IsCombo = 0
          AND sm.IsArchived <> 1
          AND sm.IsUpdated = 1
		  AND ISNULL(sm.BillCancelled, 0) = 0
    GROUP BY im.ITId,
             im.ITName,
             cci.CostCenterName,
             u.Symbol,
             sd.rate
    UNION
    SELECT rim.ITId,
           im.Name ITName,
           cci.CostCenterName,
           SUM(sd.qty) AS QTY,
           sd.rate AS Rate,
           'Combo' Symbol
    FROM dbo.RO_SalesMaster sm
        INNER JOIN dbo.CBMS_BillPostLog bp
            ON bp.SalesMasterId = sm.salesMasterId
        INNER JOIN dbo.RO_SalesDetail sd
            ON sm.salesMasterId = sd.salesMasterId
        INNER JOIN dbo.ROI_ITEMMain rim
            ON rim.ITId = sd.ItemId
        INNER JOIN dbo.RO_Combo im
            ON im.ComboID = sd.ItemId
        INNER JOIN dbo.CostCenterInfo cci
            ON sd.CostCenterId = cci.CostCenterId
    WHERE (sm.BillDate
          BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
          )
          AND sd.IsCombo = 1
          AND sm.IsArchived <> 1
          AND sm.IsUpdated = 1
		  AND ISNULL(sm.BillCancelled, 0) = 0
    GROUP BY rim.ITId,
             im.Name,
             cci.CostCenterName,
             sd.rate
    UNION
    SELECT rim.ITId,
           rim.ITName + ' (Comp.)',
           cci.CostCenterName CostCenterName,
           SUM(ci.Quantity) AS QTY,
           ci.Rate AS Rate,
           u.Symbol
    FROM dbo.RO_ComplementaryItems ci
        INNER JOIN dbo.ROI_ITEMMain rim
            ON rim.ITId = ci.ROI_ItemId
        INNER JOIN dbo.ROI_ItemDetails id
            ON rim.ITId = id.ITId
        INNER JOIN dbo.CostCenterInfo cci
            ON id.ItemCostCentreID = cci.CostCenterId
        LEFT JOIN dbo.ROI_Unit1 u
            ON u.Unit1Id = id.SmallUnit
    WHERE (ci.Date
          BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
          )
          AND ci.IsCombo = 0
    GROUP BY rim.ITId,
             rim.ITName,
             u.Symbol,
             ci.Rate,
             cci.CostCenterName
    ORDER BY cci.CostCenterName,
             im.ITName;

END;



GO
