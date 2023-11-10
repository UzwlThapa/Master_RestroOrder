SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date:  11/10/2023
====================================

EXEC dbo.USP_RO_SummaryItemSalesReport @startDate = '11/10/2023 23:59' , -- datetime
                                  @endDate = '11/10/2023 23:59' ,   -- datetime
                                  @costCenterID = 1 ,                  -- int
                                  @PITId = 118 -- int

*/
ALTER PROCEDURE [dbo].USP_RO_SummaryItemSalesReport
    @startDate DATETIME ,
    @endDate DATETIME ,
    @costCenterID INT ,
    @PITId INT
AS
    BEGIN
        IF @PITId = 0
            BEGIN

                SELECT   SUM (CASE WHEN OM.IsCancelled = 1 THEN ISNULL (SD.qty, 0) - ISNULL (t.SalesReturnQty, 0)
                                   ELSE SD.qty
                              END) AS Quantity ,
                         SD.rate AS Rate ,
                         rim.ITId ,
                         rim.ITName ,
                         ru.Symbol AS ITUnit ,
                         cci.CostCenterName
                FROM     dbo.RO_SalesMaster SM
                         INNER JOIN dbo.CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
                         INNER JOIN dbo.RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
                         INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                         LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
                         LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                         LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
                         --INNER JOIN dbo.vw_ROI_StockReportView t ON t.SalesDetailId = SD.salesDetailId
                         CROSS APPLY ( SELECT DISTINCT t.SalesReturnQty
                                       FROM   dbo.vw_ROI_StockReportView t
                                       WHERE  t.SalesDetailId = SD.salesDetailId ) t
                         LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
                WHERE    SD.IsCombo = 0
                AND      ( SD.CostCenterId = @costCenterID
                        OR @costCenterID = 0 )
                AND      ( CAST(SM.BillDate AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
                AND      ISNULL (SM.IsArchived, 0) = 0
                GROUP BY rim.ITName ,
                         ru.Symbol ,
                         cci.CostCenterName ,
                         SD.rate ,
                         rim.ITId ,
                         t.SalesReturnQty
                UNION
                SELECT   SUM (CASE WHEN OM.IsCancelled = 1 THEN ISNULL (SD.Quantity, 0) - ISNULL (t.SalesReturnQty, 0)
                                   ELSE SD.Quantity
                              END) AS Quantity ,
                         SD.Rate AS Rate ,
                         rim.ITId ,
                         rim.ITName ,
                         ru.Symbol AS ITUnit ,
                         cci.CostCenterName
                FROM     dbo.RO_CakeSalesMaster SM
                         INNER JOIN dbo.RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
                         INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                         LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
                         LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                         LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
                         --INNER JOIN dbo.vw_ROI_StockReportView t ON t.SalesDetailId = SD.SalesDetailId
                         CROSS APPLY ( SELECT DISTINCT t.SalesReturnQty
                                       FROM   dbo.vw_ROI_StockReportView t
                                       WHERE  t.SalesDetailId = SD.SalesDetailId ) t
                         LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
                WHERE    ( SD.CostCenterId = @costCenterID
                        OR @costCenterID = 0 )
                AND      ( CAST(SM.BillDate AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
                AND      ISNULL (SM.IsArchived, 0) = 0
                GROUP BY rim.ITName ,
                         ru.Symbol ,
                         cci.CostCenterName ,
                         SD.Rate ,
                         rim.ITId ,
                         t.SalesReturnQty
                ORDER BY rim.ITName;

            END;
        ELSE
            BEGIN

                ;WITH CTE ( ITid, PITId, ITName )
                 AS ( SELECT ITId ,
                             PITId ,
                             ITName
                      FROM   dbo.ROI_ITEMMain i
                      WHERE  ( i.ITId = @PITId
                            OR @PITId = 0 )
                      UNION ALL
                      SELECT m.ITId ,
                             m.PITId ,
                             m.ITName
                      FROM   dbo.ROI_ITEMMain m
                             INNER JOIN CTE c ON m.PITId = c.ITid )
                SELECT CTE.ITid ,
                       CTE.PITId ,
                       CTE.ITName
                INTO   #Items
                FROM   CTE;
                WITH CT ( Quantity, Rate, ITId, ITName, ITUnit, CostCenterName )
                AS ( SELECT   SUM (CASE WHEN OM.IsCancelled = 1 THEN ISNULL (SD.qty, 0) - ISNULL (t.SalesReturnQty, 0)
                                        ELSE SD.qty
                                   END) AS Quantity ,
                              SD.rate AS Rate ,
                              rim.ITId ,
                              rim.ITName ,
                              ru.Symbol AS ITUnit ,
                              cci.CostCenterName
                     FROM     dbo.RO_SalesMaster SM
                              INNER JOIN dbo.CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
                              INNER JOIN dbo.RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
                              INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                              INNER JOIN #Items i ON rim.ITId = i.ITid
                              LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
                              LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                              LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
                              --INNER JOIN dbo.vw_ROI_StockReportView t ON t.SalesDetailId = SD.salesDetailId
                              CROSS APPLY ( SELECT DISTINCT t.SalesReturnQty
                                            FROM   dbo.vw_ROI_StockReportView t
                                            WHERE  t.SalesDetailId = SD.salesDetailId ) t
                              LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
                     WHERE    SD.IsCombo = 0
                     AND      ( SD.CostCenterId = @costCenterID
                             OR @costCenterID = 0 )
                     AND      ( CAST(SM.BillDate AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
                     AND      ISNULL (SM.IsArchived, 0) = 0
                     GROUP BY rim.ITName ,
                              ru.Symbol ,
                              cci.CostCenterName ,
                              SD.rate ,
                              rim.ITId ,
                              t.SalesReturnQty
                     UNION
                     SELECT   SUM (
                                  CASE WHEN OM.IsCancelled = 1 THEN
                                           ISNULL (SD.Quantity, 0) - ISNULL (t.SalesReturnQty, 0)
                                       ELSE SD.Quantity
                                  END) AS Quantity ,
                              SD.Rate AS Rate ,
                              rim.ITId ,
                              rim.ITName ,
                              ru.Symbol AS ITUnit ,
                              cci.CostCenterName
                     FROM     dbo.RO_CakeSalesMaster SM
                              INNER JOIN dbo.RO_SalesMaster SMM ON SMM.salesMasterId = SM.SalesMasterId
                              INNER JOIN dbo.RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
                              INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                              INNER JOIN #Items i ON rim.ITId = i.ITid
                              LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
                              LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                              LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
                              LEFT JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterId
                              --LEFT JOIN dbo.vw_ROI_StockReportView t ON t.SalesReturnDetailId = SD.SalesDetailId
                              CROSS APPLY ( SELECT DISTINCT t.SalesReturnQty
                                            FROM   dbo.vw_ROI_StockReportView t
                                            WHERE  t.SalesDetailId = SD.SalesDetailId ) t
                     WHERE    ( SD.CostCenterId = @costCenterID
                             OR @costCenterID = 0 )
                     AND      ( CAST(SM.BillDate AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
                     AND      ISNULL (SM.IsArchived, 0) = 0
                     GROUP BY rim.ITName ,
                              ru.Symbol ,
                              cci.CostCenterName ,
                              SD.Rate ,
                              rim.ITId ,
                              t.SalesReturnQty )
                SELECT CT.Quantity ,
                       CT.Rate ,
                       CT.ITId ,
                       CT.ITName ,
                       CT.ITUnit ,
                       CT.CostCenterName
                INTO   #temp1
                FROM   CT;

                SELECT   Quantity ,
                         Rate ,
                         ITId ,
                         ITName ,
                         ITUnit ,
                         CostCenterName
                FROM     #temp1
                ORDER BY Quantity DESC;

                DROP TABLE #temp1;
            END;
    END;
GO

