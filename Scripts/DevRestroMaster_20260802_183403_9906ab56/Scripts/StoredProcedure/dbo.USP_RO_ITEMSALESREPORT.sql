SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext usp_ro_itemsalesreport '2017-09-01 00:00','2017-09-16 24:00'
CREATE PROCEDURE [dbo].[USP_RO_ITEMSALESREPORT]

@Start datetime,
@End Datetime
 --@Start DATETIME = '2017-01-02', @End DATETIME  = '2017-01-31'
AS
BEGIN

SELECT 
 CAST(SM.BillDate as date) as BillDate
,CCI.CostCenterName
,IM.ITName
,sum(sd.qty) as QTY 
,sd.rate
--,sum(sd.Amount)  Amount
,sum(sd.qty * sd.rate) NetAmount
,SD.IsCombo 
,ru.Symbol as ITUnit
FROM RO_SalesMaster SM
INNER JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
INNER JOIN ROI_ITEMMain Im ON IM.ITId = SD.ItemId 
left join CostCenterInfo CCI on CCI.CostCenterId = sd.CostCenterId
left join ROI_ItemDetails itd on Im.ITId=itd.ITId
left join ROI_Unit1 ru on ru.Unit1Id=itd.SmallUnit

WHERE IsCombo = 0 
AND (cast(SM.BillDate as Date) BETWEEN @Start AND @End)
--AND (SM.BillDate >= @Start AND SM.BillDate <= @End)
GROUP BY  CAST(SM.BillDate as date),CCI.CostCenterName ,IM.ITName,sd.rate,SD.IsCombo,ru.Symbol
 union 
 SELECT  
 CAST(SM.BillDate as date) as BillDate
,CCI.CostCenterName
 ,IM.Name
,sum(sd.qty) as QTY 
,sd.rate
--,sum(sd.Amount)  Amount
,sum(sd.qty * sd.rate) NetAmount
,SD.IsCombo 
,'Pack' as ITUnit
FROM RO_SalesMaster SM
INNER JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
INNER JOIN RO_Combo Im ON IM.ComboID = SD.ItemId 
left join CostCenterInfo CCI on CCI.CostCenterId = sd.CostCenterId
WHERE IsCombo = 1 
AND (CAST(SM.BillDate as date) BETWEEN @Start AND @End)
--AND (SM.BillDate >= @Start AND SM.BillDate <= @End)
GROUP BY CAST(SM.BillDate as date),CCI.CostCenterName , IM.Name,sd.rate,SD.IsCombo 

END



GO
