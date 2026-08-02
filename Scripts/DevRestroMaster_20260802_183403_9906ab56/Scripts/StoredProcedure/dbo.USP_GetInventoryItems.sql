SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetInventoryItems]
AS
BEGIN

    SELECT DISTINCT
           im.ITId,
           im.PITId,
           im.ITName,
           id.ITCode,
           id.ImagePath,
           im.IsMenu,
           im.IsCategory,
           id.IsExpirable,
           id.IsProdMaterial,
           id.ItemCostCentreID,
           id.Details,
           im.IsActive,
           id.SmallUnit,
           ir.LargeUnit,
           ir.Conversion,
           ir.IsDefaultPurchaseUnit,
           ir.IsDefaultSalesUnit,
           ISNULL(ir.SRate, 0) AS SRate,
           ir.ValidFrom,
           id.IsExtra,
		   im.HsCode,
           --,ex.ExtraItemID
           --,ex.ExtraItem,ex.ExtraPrice,ex.IsActive
           cci.CostCenterName,
           (
               SELECT DISTINCT ItemID FROM ROI_ItemRate WHERE ItemID = im.ITId
           ) AS ItemRateID,
           (
               SELECT ITName FROM ROI_ITEMMain WHERE ITId = im.PITId
           ) AS ParentItem,
           u.Symbol AS MunitParticulars,
           u.UnitDescription AS dsunitparticular,
           ISNULL(rpd.UnitRate, 0) AS LastPurchaseRate,
           ROW_NUMBER() OVER (PARTITION BY im.ITId ORDER BY rpd.PurchaseDetailsID DESC) AS RowNum
    INTO #temp
    FROM ROI_ITEMMain im
        LEFT JOIN ROI_ItemDetails id
            ON id.ITId = im.ITId
        --left join Roi_ItemWithUnit iwu on iwu.ItemID=id.ITId
        LEFT JOIN ROI_ItemRate ir
            ON ir.ItemID = im.ITId
        LEFT JOIN RO_ExtraItem ex
            ON ex.ItemID = id.ITId
        LEFT JOIN ROI_Unit1 u
            ON u.Unit1Id = id.SmallUnit
        LEFT JOIN CostCenterInfo cci
            ON cci.CostCenterId = id.ItemCostCentreID
        LEFT JOIN ROI_PurchaseDetails rpd
            ON rpd.ItemID = id.ITId
    WHERE ISNULL(im.IsArchived, 0) = 0
          --and id.IsProdMaterial=0 
          AND im.IsCategory = 0
          AND im.IsMenu = 0
          AND id.IsArchived = 0
    ORDER BY im.ITName ASC;

    SELECT *
    FROM #temp
    WHERE RowNum = 1 --and ITName like '%carl%'
    ORDER BY ITName;

    DROP TABLE #temp;
END;




GO
