SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_GetAllItems]
CREATE PROCEDURE [dbo].[USP_GetAllItems]
AS
    BEGIN
        ;WITH CTE ( [Level], ITId, [path], ITName, PITId, IsActive, IsMenu, IsCategory, HsCode, AddedBy, AddedOn ,
                    UpdatedOn , UpdatedBy, IsUpdated, IsArchived, ArchivedBy, ArchivedOn, ParentItem, ItemOrder, x )
         AS ( SELECT 0 AS [Level] ,
                     ITId ,
                     CAST(ROW_NUMBER () OVER ( PARTITION BY PITId
                                               ORDER BY ITName ) AS VARCHAR (MAX)) AS [path] ,
                     ITName ,
                     PITId ,
                     IsActive ,
                     IsMenu ,
                     IsCategory ,
                     HSCode ,
                     AddedBy ,
                     AddedOn ,
                     UpdatedOn ,
                     UpdatedBy ,
                     IsUpdated ,
                     IsArchived ,
                     ArchivedBy ,
                     ArchivedOn ,
                     CAST('' AS VARCHAR (250)) AS ParentItem ,
                     CAST(ITId AS VARCHAR (50)) AS ItemOrder ,
                     ROW_NUMBER () OVER ( PARTITION BY PITId
                                          ORDER BY ITName ) / POWER (10000.0, 0) AS x
              FROM   dbo.ROI_ITEMMain
              WHERE  ( PITId = 0
                    OR PITId IS NULL )
              AND    IsArchived = 0
              AND    IsMenu = 1
              UNION ALL
              SELECT ( CTE.[Level] + 1 ) AS [Level] ,
                     im.ITId ,
                     CTE.[path] + '-' + CAST(ROW_NUMBER () OVER ( PARTITION BY im.PITId
                                                                  ORDER BY im.ITName ) AS VARCHAR (MAX)) ,
                     im.ITName ,
                     im.PITId ,
                     im.IsActive ,
                     im.IsMenu ,
                     im.IsCategory ,
                     im.HSCode ,
                     im.AddedBy ,
                     im.AddedOn ,
                     im.UpdatedOn ,
                     im.UpdatedBy ,
                     im.IsUpdated ,
                     im.IsArchived ,
                     im.ArchivedBy ,
                     im.ArchivedOn ,
                     CTE.ITName AS ParentItem ,
                     CAST(CTE.ItemOrder + '.' + CAST(im.ITId AS VARCHAR (10)) AS VARCHAR (50)) AS ItemOrder ,
                     x + ROW_NUMBER () OVER ( PARTITION BY im.PITId
                                              ORDER BY im.ITName ) / POWER (10000.0, Level + 1)
              FROM   dbo.ROI_ITEMMain AS im
                     INNER JOIN CTE ON im.PITId = CTE.ITId
              WHERE  im.IsArchived = 0
              AND    im.IsMenu = 1 )
        SELECT   CTE.ItemOrder ,
                 CTE.ITId ,
                 CTE.PITId ,
                 dbo.fn_LevelPrefix (CONVERT (INT, ISNULL ([CTE].[Level], 0)), '----') + CTE.ITName AS ItemName ,
                 CTE.ITName ,
                 id.ITCode ,
                 CTE.HsCode ,
                 id.ImagePath ,
                 id.IsExpirable ,
                 id.IsProdMaterial ,
                 id.ItemCostCentreID ,
                 id.Details ,
                 id.SmallUnit ,
                 ir.LargeUnit ,
                 ir.Conversion ,
                 ir.IsDefaultPurchaseUnit ,
                 ir.IsDefaultSalesUnit ,
                 ISNULL (ir.SRate, 0) AS SRate ,
                 CONVERT (VARCHAR (MAX), ir.ValidFrom, 110) AS ValidFrom ,
                 id.IsExtra ,
                 cci.CostCenterName ,
                 ( SELECT DISTINCT rir.ItemID
                   FROM   dbo.ROI_ItemRate AS rir
                   WHERE  ItemID = CTE.ITId ) AS ItemRateID ,
                 u.Symbol AS MunitParticulars ,
                 u.UnitDescription AS dsunitparticular ,
                 CTE.[path] ,
                 CTE.IsActive ,
                 CTE.IsMenu ,
                 CTE.IsCategory ,
                 CTE.HsCode ,
                 CTE.AddedBy ,
                 CTE.AddedOn ,
                 CTE.UpdatedOn ,
                 CTE.UpdatedBy ,
                 CTE.IsUpdated ,
                 CTE.IsArchived ,
                 CTE.ArchivedBy ,
                 CTE.ArchivedOn ,
                 CTE.ParentItem
        FROM     CTE
                 LEFT JOIN dbo.ROI_ItemDetails id ON id.ITId = CTE.ITId
                 LEFT JOIN dbo.ROI_ItemRate ir ON ir.ItemID = CTE.ITId
                 LEFT JOIN dbo.RO_ExtraItem ex ON ex.ItemID = id.ITId
                 LEFT JOIN dbo.ROI_Unit1 u ON u.Unit1Id = id.SmallUnit
                 LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = id.ItemCostCentreID
        WHERE    CTE.IsArchived = 0
        ORDER BY CTE.x;

    END;



GO
