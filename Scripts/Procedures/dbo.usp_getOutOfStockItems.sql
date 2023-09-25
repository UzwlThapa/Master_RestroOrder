CREATE PROC dbo.usp_getOutOfStockItems
AS
SELECT ib.ITId
	,im.ITName
	,CLBal
	,ib.STId
	,st.StName
	,un.Symbol
FROM ROI_ITEMBal ib
INNER JOIN ROI_Store st ON st.STId = ib.STId
INNER JOIN ROI_ITEMMain im ON im.ITId = ib.ITId
LEFT JOIN ROI_ItemDetails id ON id.ITId = ib.ITId
LEFT JOIN ROI_Unit1 un ON un.Unit1Id = id.SmallUnit
WHERE CLBal < 30
	AND st.IsDeleted <> 1
