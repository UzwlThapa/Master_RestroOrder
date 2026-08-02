SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_getPurchaseDetailsbyID 6
CREATE PROCEDURE [dbo].[usp_getPurchaseDetailsbyID] @PurchaseMainID INT
	--,@PurchaseDetailsID int
AS
SELECT pd.PurchaseDetailsID AS PurchaseDetailsID
	,pd.PurchaseMainID AS PurchaseMainID
	,pd.Quentity AS Quentity
	,pd.UnitRate AS Rate
	,pd.UsedUnitID AS UnitId
	,pd.Total AS Total
	,im.ITName AS ITName
	,im.ITId AS ITId
	,u1.UnitDescription AS UnitName
	--,u1.Unit1Id as Unit1Id
	,pl.LotNo AS LotNo
	,pl.BatchNo AS BatchNo
	,pl.ExpDate AS ExpDate
--,pl.LotNo,pl.BatchNo,pl.ExpDate
--from ROI_PurchaseLotNo pl
FROM ROI_PurchaseDetails pd
JOIN ROI_ITEMMain im ON pd.ItemID = im.ITId
JOIN ROI_Unit1 u1 ON u1.Unit1Id = pd.UsedUnitID
JOIN ROI_PurchaseLotNo pl ON pl.PurchaseDetailsID = pd.PurchaseDetailsID
--on pd.PurchaseMainID= pl.PurchaseDetailsID
--inner join ROI_PurchaseMain pm
--on pl.PurchaseDetailsID = pm.PurchaseMainID
WHERE pd.PurchaseMainID = @PurchaseMainID
	--select * from ROI_PurchaseMain
	--select * from ROI_PurchaseDetails
	--select * from ROI_PurchaseLotNo




GO
