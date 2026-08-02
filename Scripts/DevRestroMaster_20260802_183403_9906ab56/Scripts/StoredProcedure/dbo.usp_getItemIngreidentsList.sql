SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getItemIngreidentsList] 
   @costCenter INT
	,@ItemId INT
	,@Category INT
AS
BEGIN
IF (OBJECT_ID('tempdb..#TempIngrediants') is not null)
begin 
	drop table #TempIngrediants
end
SELECT im.ITId ,im.ITName, id.SmallUnit , u.Symbol
, isnull(gd.Rate,0)/ISNULL(dbo.[fn_GetConversion](pd.UsedUnitID,id.SmallUnit),1) as SmallUnitRate 
INTO #TempIngrediants
FROM ROI_ITEMMain im
inner join ROI_ItemDetails id on id.ITId=im.ITId and im.IsCategory=0 and im.IsMenu=0 and im.IsArchived = 0
LEFT JOIN (
	select pd.ItemID, MAX(gd.GDId) AS [MAXGDId] from RO_GoodsReceivedDetls gd
	inner join ROI_PurchaseDetails pd on pd.PurchaseDetailsID = gd.PDId
	where gd.Rate is not null 
	group by ItemID
) x ON x.ItemID=im.ITId
left join RO_GoodsReceivedDetls gd on x.MAXGDId=gd.GDId
left join  ROI_PurchaseDetails pd on pd.PurchaseDetailsID = gd.PDId
inner join ROI_Unit1 u on u.Unit1Id=id.SmallUnit
where  im.IsArchived = 0

SELECT m.ITId AS ItemID
		,m.ITName AS ItemName
		,r.SRate AS MRP
		,ri.Ingredient as Ingredient 
		,isnull(ri.Quantity, 0) AS Quantity
		,isnull((i.ITName + ', ' + i.Symbol + ' / ' + u1.Symbol), '-, ') AS IngredientName
		,isnull( i.SmallUnitRate,0)  AS Amount
		,d.ImagePath
		,d.Details
	FROM ROI_ITEMMain m
	INNER JOIN ROI_ItemDetails d ON m.ITId = d.ITId
	INNER JOIN ROI_ItemRate r ON m.ITId = r.ItemID
	LEFT JOIN ROI_Unit1 u1 ON u1.Unit1Id = d.SmallUnit
	LEFT JOIN Ro_Ingredient ri ON ri.ItemID = m.ITId
	LEFT JOIN #TempIngrediants i on ri.Ingredient=i.ITId
	WHERE m.IsActive = 1
		AND m.IsArchived = 0
		AND d.IsProdMaterial = 0
	    AND m.IsCategory = 0 
		AND m.IsMenu=1
		AND ( d.ItemCostCentreID = @costCenter OR @costCenter = 0 )
		AND ( m.ITId = @ItemId OR @ItemId = 0 )
	  and (m.PITId =@Category   OR @Category =0)
	  order by m.ITName
	  END

GO
