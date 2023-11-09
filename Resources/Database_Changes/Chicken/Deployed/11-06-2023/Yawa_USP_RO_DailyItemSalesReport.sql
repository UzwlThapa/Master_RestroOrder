SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 11/10/2023
====================================

	EXEC dbo.USP_RO_DailyItemSalesReport '2023-01-01','2023-11-06'

*/
ALTER PROCEDURE [dbo].USP_RO_DailyItemSalesReport
    @startDate DATETIME ,
    @endDate DATETIME ,
    @costCenterID INT ,
    @PITId INT ,
    @Username NVARCHAR (25) = ''
AS
    BEGIN
        IF @PITId = 0
            BEGIN
                SELECT   CAST(SM.BillDate AS DATE) AS BillDate ,
                         SUM (SD.qty) AS Quantity ,
                         SD.rate AS rate ,
                         rim.ITId ,
                         rim.ITName ,
                         ru.Symbol AS ITUnit ,
                         cci.CostCenterName ,
                         SM.Waiter
                FROM     dbo.RO_SalesMaster SM
                         INNER JOIN dbo.CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
                         INNER JOIN dbo.RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
                         INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                         LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
                         LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                         LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
                WHERE    SD.IsCombo = 0
                AND      ( SD.CostCenterId = @costCenterID
                        OR @costCenterID = 0 )
                AND      ( CAST(SM.BillDate AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
                AND      ISNULL (SM.IsArchived, 0) = 0
                AND      ( SM.Waiter = @Username
                        OR @Username = '' )
                GROUP BY CAST(SM.BillDate AS DATE) ,
                         SD.rate ,
                         rim.ITName ,
                         ru.Symbol ,
                         cci.CostCenterName ,
                         rim.ITId ,
                         SM.Waiter
                UNION
                SELECT   CAST(SM.BillDate AS DATE) AS BillDate ,
                         SUM (SD.Quantity) AS Quantity ,
                         SD.Rate AS rate ,
                         rim.ITId ,
                         rim.ITName ,
                         ru.Symbol AS ITUnit ,
                         cci.CostCenterName ,
                         SM.AddedBy AS Waiter
                FROM     dbo.RO_CakeSalesMaster SM
                         --INNER JOIN CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId  
                         INNER JOIN dbo.RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
                         INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                         LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
                         LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                         LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
                WHERE --SD.IsCombo = 0  
                         ( SD.CostCenterId = @costCenterID
                        OR @costCenterID = 0 )
                AND      ( CAST(SM.BillDate AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
                AND      ISNULL (SM.IsArchived, 0) = 0
                AND      ( SM.AddedBy = @Username
                        OR @Username = '' )
                GROUP BY CAST(SM.BillDate AS DATE) ,
                         SD.Rate ,
                         rim.ITName ,
                         ru.Symbol ,
                         cci.CostCenterName ,
                         rim.ITId ,
                         SM.AddedBy
                ORDER BY rim.ITName;
            END;
        ELSE
            BEGIN
                ;WITH CTE ( ITid, PITId, ITName )
                 AS ( SELECT ITId ,
                             PITId ,
                             ITName
                      FROM   dbo.ROI_ITEMMain i
                      WHERE  i.ITId = @PITId
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

                SELECT   CAST(SM.BillDate AS DATE) AS BillDate ,
                         SUM (SD.qty) AS Quantity ,
                         SD.rate AS rate ,
                         rim.ITId ,
                         rim.ITName ,
                         ru.Symbol AS ITUnit ,
                         cci.CostCenterName ,
                         SM.Waiter
                FROM     dbo.RO_SalesMaster SM
                         INNER JOIN dbo.CBMS_BillPostLog bp ON bp.SalesMasterId = SM.salesMasterId
                         INNER JOIN dbo.RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
                         INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                         INNER JOIN #Items i ON rim.ITId = i.ITid
                         LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
                         LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                         LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
                WHERE    SD.IsCombo = 0
                AND      ( SD.CostCenterId = @costCenterID
                        OR @costCenterID = 0 )
                AND      ( CAST(SM.BillDate AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
                AND      ISNULL (SM.IsArchived, 0) = 0
                AND      ( SM.Waiter = @Username
                        OR @Username = '' )
                GROUP BY CAST(SM.BillDate AS DATE) ,
                         SD.rate ,
                         rim.ITName ,
                         ru.Symbol ,
                         cci.CostCenterName ,
                         rim.ITId ,
                         SM.Waiter
                UNION
                SELECT   CAST(SM.BillDate AS DATE) AS BillDate ,
                         SUM (SD.Quantity) AS Quantity ,
                         SD.Rate AS rate ,
                         rim.ITId ,
                         rim.ITName ,
                         ru.Symbol AS ITUnit ,
                         cci.CostCenterName ,
                         SM.AddedBy AS Waiter
                FROM     dbo.RO_CakeSalesMaster SM
                         INNER JOIN dbo.RO_CakeSalesDetail SD ON SM.SalesMasterId = SD.SalesMasterId
                         INNER JOIN dbo.ROI_ITEMMain rim ON rim.ITId = SD.ItemId
                         INNER JOIN #Items i ON rim.ITId = i.ITid
                         LEFT JOIN dbo.ROI_ItemDetails rid ON rid.ITId = rim.ITId
                         LEFT JOIN dbo.ROI_Unit1 ru ON ru.Unit1Id = rid.SmallUnit
                         LEFT JOIN dbo.CostCenterInfo cci ON cci.CostCenterId = SD.CostCenterId
                WHERE    ( SD.CostCenterId = @costCenterID
                        OR @costCenterID = 0 )
                AND      ( CAST(SM.BillDate AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
                AND      ISNULL (SM.IsArchived, 0) = 0
                AND      ( SM.AddedBy = @Username
                        OR @Username = '' )
                GROUP BY CAST(SM.BillDate AS DATE) ,
                         SD.Rate ,
                         rim.ITName ,
                         ru.Symbol ,
                         cci.CostCenterName ,
                         rim.ITId ,
                         SM.AddedBy
                ORDER BY rim.ITName;
            END;
    END;
GO

