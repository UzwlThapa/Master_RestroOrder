SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[usp_ro_getBillBody]
    @SalesMasterID INT
AS
BEGIN
    SELECT fy.fyName,
           rr.restroRoom,
           rt.restrotableTitle,
           im.ITName,
           im.HsCode,                       -- pos 5
           cc.CostCenterName,               -- pos 6
           cc.coDiscount,                   -- pos 7
           sm.*,                            -- pos 8+
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
           sd.HsCode,                       -- pos 5  ← aligned to im.HsCode
           cc.CostCenterName,               -- pos 6
           cc.coDiscount,                   -- pos 7
           sm.*,                            -- pos 8+
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
END
GO