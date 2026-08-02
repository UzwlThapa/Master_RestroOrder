SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_dailyItemSalesForMail] @date DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Non‑combo items (same logic as USP_RO_ITEMSALESREPORT)
    SELECT IM.ITName AS ItemName,
           CCI.CostCenterName AS Category,
           SUM(SD.qty) AS Quantity,
           SD.rate AS UnitPrice,
           0 AS Discount,     -- no discount column in RO_SalesDetail
           SUM(SD.qty * SD.rate) AS NetAmount,
           U.Symbol AS ITUnit -- from ROI_Unit1 via SmallUnit
    FROM RO_SalesMaster SM
        INNER JOIN RO_SalesDetail SD
            ON SM.salesMasterId = SD.salesMasterId
        INNER JOIN ROI_ITEMMain IM
            ON IM.ITId = SD.ItemId
        LEFT JOIN CostCenterInfo CCI
            ON CCI.CostCenterId = SD.CostCenterId
        LEFT JOIN ROI_ItemDetails ID
            ON ID.ITId = IM.ITId -- to get SmallUnit
        LEFT JOIN ROI_Unit1 U
            ON U.Unit1Id = ID.SmallUnit -- get Symbol
    WHERE SD.IsCombo = 0
          AND CAST(SM.BillDate AS DATE) = @date
    GROUP BY IM.ITName,
             CCI.CostCenterName,
             SD.rate,
             U.Symbol
    UNION ALL

    -- Combo items (same as existing)
    SELECT C.Name AS ItemName,
           CCI.CostCenterName AS Category,
           SUM(SD.qty) AS Quantity,
           SD.rate AS UnitPrice,
           0 AS Discount,
           SUM(SD.qty * SD.rate) AS NetAmount,
           'Pack' AS ITUnit
    FROM RO_SalesMaster SM
        INNER JOIN RO_SalesDetail SD
            ON SM.salesMasterId = SD.salesMasterId
        INNER JOIN RO_Combo C
            ON C.ComboID = SD.ItemId
        LEFT JOIN CostCenterInfo CCI
            ON CCI.CostCenterId = SD.CostCenterId
    WHERE SD.IsCombo = 1
          AND CAST(SM.BillDate AS DATE) = @date
    GROUP BY C.Name,
             CCI.CostCenterName,
             SD.rate
    ORDER BY Category,
             ItemName;
END;

GO
