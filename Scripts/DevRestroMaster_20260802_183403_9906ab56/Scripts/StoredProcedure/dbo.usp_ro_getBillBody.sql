SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getBillBody] @SalesMasterID INT
AS
--declare @SalesMasterID INT=187
SELECT fy.fyName,
       rr.restroRoom,
       rt.restrotableTitle,
       im.ITName,
	   im.HsCode,
       cc.CostCenterName,
       cc.coDiscount,
       sm.*,
       sm.BillDate AS [Date],
       sd.*,
       sd.qty AS Quantity,
       --,sd.CCDiscount
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
--WHERE sm.salesMasterId = 114

WHERE sm.salesMasterId = @SalesMasterID
--order by cc.CostCenterId asc
--select * from CostCenterInfo

UNION

--declare @SalesMasterID INT=187
SELECT fy.fyName,
       rr.restroRoom,
       rt.restrotableTitle,
       'Room: ' + rt.restrotableTitle AS ITName,
       cc.CostCenterName,
       cc.coDiscount,
       sm.*,
       sm.BillDate AS [Date],
       sd.*,
       sd.qty AS Quantity,
	   sd.HsCode,
       --,sd.CCDiscount
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
    --JOIN ROI_ITEMMain im ON im.ITId = sd.ItemId
    LEFT JOIN dbo.CostCenterInfo cc
        ON cc.CostCenterId = sd.CostCenterId
--WHERE sm.salesMasterId = 114

WHERE sm.salesMasterId = @SalesMasterID;
--order by cc.CostCenterId asc


GO
