SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- FIX 1: USP_RO_getItemForApi
-- Casts integer flags to BIT to prevent Invalid Cast Exception on Tablet
CREATE PROCEDURE [dbo].[USP_RO_getItemForApi]
AS
BEGIN
    ;WITH MenuItem (ItemId, ItemName, PItemId, Details, ItemCode, ImagePath, CostCenterID, CostCenterName, MUnitId,
                    DSUnitId, DPUnitId, IsExpirable, IsProdMaterial, [LEVEL], IsUnitWiseRate, SRate, Currency, IsCombo,
                    IsCategory, IsOutOfStock
                   )
     AS (SELECT m.ITId AS ItemId,
                m.ITName AS ItemName,
                m.PITId AS PItemId,
                d.Details,
                d.ITCode AS ItemCode,
                d.ImagePath,
                d.ItemCostCentreID AS CostCenterID,
                cc.CostCenterName AS CostCenterName,
                d.MUnitId,
                d.DSUnitId,
                d.DPUnitId,
                CAST(d.IsExpirable AS BIT) AS IsExpirable,       -- FIXED: Cast to BIT
                CAST(d.IsProdMaterial AS BIT) AS IsProdMaterial, -- FIXED: Cast to BIT
                1 AS LEVEL,
                CAST(d.IsUnitWiseRate AS BIT) AS IsUnitWiseRate, -- FIXED: Cast to BIT
                r.SRate AS SRate,
                'NRS' AS Currency,
                CAST(0 AS BIT) AS IsCombo,                       -- FIXED: Cast to BIT
                CAST(m.IsCategory AS BIT) AS IsCategory,         -- FIXED: Cast to BIT
                CAST(d.IsOutOfStock AS BIT) AS IsOutOfStock      -- FIXED: Cast to BIT
         FROM ROI_ITEMMain m
             INNER JOIN ROI_ItemDetails d
                 ON d.ITId = m.ITId
             INNER JOIN ROI_ItemRate r
                 ON r.ItemID = m.ITId
             INNER JOIN CostCenterInfo cc
                 ON cc.CostCenterId = d.ItemCostCentreID
         WHERE m.IsArchived = 0
               AND m.IsMenu = 1
               AND ISNULL(m.IsActive, 1) = 1
               AND
               (
                   ISNULL(m.PITId, 0) = 0
                   OR m.PITId = 0
               )
         UNION ALL
         SELECT m.ITId AS ItemId,
                m.ITName AS ItemName,
                m.PITId AS PItemId,
                d.Details,
                d.ITCode AS ItemCode,
                d.ImagePath,
                d.ItemCostCentreID AS CostCenterID,
                cc.CostCenterName AS CostCenterName,
                d.MUnitId,
                d.DSUnitId,
                d.DPUnitId,
                CAST(d.IsExpirable AS BIT) AS IsExpirable,       -- FIXED
                CAST(d.IsProdMaterial AS BIT) AS IsProdMaterial, -- FIXED
                mi.[LEVEL] + 1 AS LEVEL,
                CAST(d.IsUnitWiseRate AS BIT) AS IsUnitWiseRate, -- FIXED
                r.SRate AS SRate,
                'NRS' AS Currency,
                CAST(0 AS BIT) AS IsCombo,                       -- FIXED
                CAST(m.IsCategory AS BIT) AS IsCategory,         -- FIXED
                CAST(d.IsOutOfStock AS BIT) AS IsOutOfStock      -- FIXED
         FROM ROI_ITEMMain m
             INNER JOIN MenuItem mi
                 ON mi.ItemId = m.PITId
             INNER JOIN ROI_ItemDetails d
                 ON d.ITId = m.ITId
             INNER JOIN ROI_ItemRate r
                 ON r.ItemID = m.ITId
             INNER JOIN CostCenterInfo cc
                 ON cc.CostCenterId = d.ItemCostCentreID
         WHERE m.IsArchived = 0
               AND m.IsMenu = 1
               AND ISNULL(m.IsActive, 1) = 1)
    SELECT *
    FROM MenuItem
    UNION ALL
    SELECT m.ComboID AS ItemId,
           m.Name AS ItemName,
           0 AS PItemId,
           m.[Description] AS Details,
           m.ComboCode AS ItemCode,
           m.ImagePath AS ImagePath,
           m.CostCenterID,
           cc.CostCenterName,
           0 AS MUnitId,
           0 AS DSUnitId,
           0 AS DPUnitId,
           CAST(0 AS BIT) AS IsExpirable,    -- FIXED
           CAST(0 AS BIT) AS IsProdMaterial, -- FIXED
           1 AS LEVEL,
           CAST(0 AS BIT) AS IsUnitWiseRate, -- FIXED
           m.SalesPrice AS SRate,
           'NRS' AS Currency,
           CAST(1 AS BIT) AS IsCombo,        -- FIXED
           CAST(0 AS BIT),                   -- FIXED
           CAST(0 AS BIT) AS IsOutOfStock    -- FIXED
    FROM RO_Combo m
        INNER JOIN CostCenterInfo cc
            ON cc.CostCenterId = m.CostCenterID
    WHERE m.IsActive = 1
          AND m.IsDeleted = 0
          AND GETDATE()
          BETWEEN m.StartDate AND m.EndDate
    ORDER BY ItemName;
END;

GO
