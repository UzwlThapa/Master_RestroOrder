
GO
/****** Object:  StoredProcedure [dbo].[USP_RO_SummaryItemSalesReport]    Script Date: 15/10/2023 2:43:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 10/09/2023
====================================

EXEC dbo.USP_RO_SummaryItemSalesReport @startDate = '09/01/2023' , -- datetime
                                  @endDate = '10/08/2023' ,   -- datetime
                                  @costCenterID = 2 ,                  -- int
                                  @PITId = 256 -- int

*/
ALTER PROCEDURE [dbo].[USP_RO_SummaryItemSalesReport]
    @startDate DATETIME ,
    @endDate DATETIME ,
    @costCenterID INT ,
    @PITId INT
AS
    BEGIN
        --declare @PITId int=9
        IF @PITId = 0
            BEGIN

                SELECT  SUM (CASE WHEN OM.IsCancelled = 1
                                     THEN isnull(SD.qty,0) - ISNULL(t.SalesReturnQty,0)
                                   ELSE SD.qty
                              END) AS Quantity ,
                         SD.rate AS rate ,
                         rim.ITId ,
                         rim.ITName ,
                         ru.Symbol AS ITUnit ,
                         cci.CostCenterName
                FROM     RO_SalesMaster SM
                         INNER JOIN CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
                         INNER JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
                         INNER JOIN ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                         LEFT JOIN ROI_ItemDetails rid ON rid.ITId = rim.ITId
                         LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                         LEFT JOIN CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
                              INNER JOIN vw_ROI_StockReportView t ON t.SalesDetailId = SD.salesDetailId 
							  left JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterID   
                WHERE    SD.IsCombo = 0
                AND      ( SD.CostCenterId = @costCenterID
                        OR @costCenterID = 0 )
                AND      ( CAST (SM.BillDate AS DATE) BETWEEN CAST (@startDate AS DATE) AND CAST (@endDate AS DATE))
                AND      ISNULL (SM.IsArchived, 0) = 0
                GROUP BY rim.ITName ,
                         ru.Symbol ,
                         cci.CostCenterName ,
                         SD.rate ,
                         rim.ITId,
						 t.SalesReturnQty
                UNION
                SELECT    SUM (CASE WHEN OM.IsCancelled = 1
                                     THEN isnull(SD.Quantity,0) - ISNULL(t.SalesReturnQty,0)
                                   ELSE SD.Quantity
                              END) AS Quantity ,
                         SD.Rate AS rate ,
                         rim.ITId ,
                         rim.ITName ,
                         ru.Symbol AS ITUnit ,
                         cci.CostCenterName
                FROM     RO_CakeSalesMaster SM
                         INNER JOIN RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
                         INNER JOIN ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                         LEFT JOIN ROI_ItemDetails rid ON rid.ITId = rim.ITId
                         LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                         LEFT JOIN CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
                              INNER JOIN vw_ROI_StockReportView t ON t.SalesDetailId = SD.salesDetailId 
							  left JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterID     
                WHERE    ( SD.CostCenterId = @costCenterID
                        OR @costCenterID = 0 )
                AND      ( CAST (SM.BillDate AS DATE) BETWEEN CAST (@startDate AS DATE) AND CAST (@endDate AS DATE))
                AND      ISNULL (SM.IsArchived, 0) = 0
                GROUP BY rim.ITName ,
                         ru.Symbol ,
                         cci.CostCenterName ,
                         SD.Rate ,
                         rim.ITId 
						 ,t.SalesReturnQty
                ORDER BY rim.ITName;

            END;
        ELSE
            BEGIN
                ;WITH CTE ( ITid, PITId, ITName )
                 AS ( SELECT ITId ,
                             PITId ,
                             ITName
                      FROM   ROI_ITEMMain i
                      WHERE  ( i.ITId = @PITId
                            OR @PITId = 0 )
                      UNION ALL
                      SELECT m.ITId ,
                             m.PITId ,
                             m.ITName
                      FROM   ROI_ITEMMain m
                             INNER JOIN CTE c ON m.PITId = c.ITid )
                SELECT *
                INTO   #Items
                FROM   CTE;
                WITH CT ( Quantity, rate, ITId, ITName, ITUnit, CostCenterName )
                AS ( SELECT   SUM (CASE WHEN OM.IsCancelled = 1
								   THEN isnull(T.SalesQty,0) - ISNULL(t.SalesReturnQty,0)
                                   ELSE T.SalesQty
                              END) AS Quantity ,
                              SD.rate AS rate ,
                              rim.ITId ,
                              rim.ITName ,
                              ru.Symbol AS ITUnit ,
                              cci.CostCenterName
                     FROM     RO_SalesMaster SM
                              INNER JOIN CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
                              INNER JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
                              INNER JOIN ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                              INNER JOIN #Items i ON rim.ITId = i.ITid
                              LEFT JOIN ROI_ItemDetails rid ON rid.ITId = rim.ITId
                              LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                              LEFT JOIN CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
                              INNER JOIN vw_ROI_StockReportView t ON t.SalesDetailId = SD.salesDetailId 
							  left JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterID         
                     WHERE    SD.IsCombo = 0
                     AND      ( SD.CostCenterId = @costCenterID
                             OR @costCenterID = 0 )
                     AND      ( CAST (SM.BillDate AS DATE) BETWEEN CAST (@startDate AS DATE) AND CAST (@endDate AS DATE))
                     AND      ISNULL (SM.IsArchived, 0) = 0
                     GROUP BY rim.ITName ,
                              ru.Symbol ,
                              cci.CostCenterName ,
                              SD.rate ,
                              rim.ITId,
							  t.SalesReturnQty
                     UNION
                     SELECT    SUM (CASE WHEN OM.IsCancelled = 1
								   THEN isnull(sd.Quantity,0) - ISNULL(t.SalesReturnQty,0)
                                   ELSE sd.Quantity
                              END) AS Quantity ,
                              SD.Rate AS rate ,
                              rim.ITId ,
                              rim.ITName ,
                              ru.Symbol AS ITUnit ,
                              cci.CostCenterName
                     FROM     RO_CakeSalesMaster SM
                              INNER JOIN RO_SalesMaster SMM ON SMM.salesMasterId = SM.SalesMasterId
                              INNER JOIN RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
                              INNER JOIN ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                              INNER JOIN #Items i ON rim.ITId = i.ITid
                              LEFT JOIN ROI_ItemDetails rid ON rid.ITId = rim.ITId
                              LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                              LEFT JOIN CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
							  left JOIN dbo.RO_OrderMasters OM ON OM.OrderMasterID = SM.OrderMasterID 
                              LEFT JOIN vw_ROI_StockReportView t ON t.SalesReturnDetailId = SD.SalesDetailId
                     WHERE    ( SD.CostCenterId = @costCenterID
                             OR @costCenterID = 0 )
                     AND      ( CAST (SM.BillDate AS DATE) BETWEEN CAST (@startDate AS DATE) AND CAST (@endDate AS DATE))
                     AND      ISNULL (SM.IsArchived, 0) = 0
                     GROUP BY rim.ITName ,
                              ru.Symbol ,
                              cci.CostCenterName ,
                              SD.Rate ,
                              rim.ITId ,
                              t.SalesReturnQty )
                SELECT *
                INTO   #temp1
                FROM   CT;


                SELECT   *
                FROM     #temp1
                ORDER BY Quantity DESC;

                DROP TABLE #temp1;


            END;
    END;
