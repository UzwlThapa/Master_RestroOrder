SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_getConsumptionReportByDate] --'2018-12-20', '2018-12-20'
 @startDate DATE
	,@endDate DATE
AS
BEGIN
DECLARE @tbl TABLE (
		ItemId INT
		,ItemQnty decimal(18,2)
		,IngredientId INT
		,IngredientName NVARCHAR(max)
		,IngredientQnty decimal(18,2)
		)

	INSERT INTO @tbl
	SELECT DISTINCT sd.ItemId
		,sum(sd.qty) AS ItemQnty
		,IM.ITId AS IngredientId
		,IM.ITName IngredientName
		,ing.Quantity AS IngredientQnty
	FROM RO_SalesDetail sd
	INNER JOIN Ro_Ingredient ing ON ing.ItemID = sd.ItemId
	INNER JOIN ROI_ITEMMain IM ON IM.ITId = ing.Ingredient
	INNER JOIN RO_SalesMaster sm ON sd.salesMasterId = sm.salesMasterId
	WHERE sm.IsArchived=0 
	and (cast(sm.BillDate as date) >= @startDate
		AND  cast(sm.BillDate as date) <= @endDate
		)
	GROUP BY sd.ItemId
		,IM.ITName
		,ing.Quantity
		,IM.ITId
		
DECLARE @tbl2 TABLE (
		
		IngredientId INT
		,IngredientName NVARCHAR(max)
		,Quantity decimal(18,2)
		,Symbol nvarchar(25)
		,ItemQnty decimal(18,2)
		,IngredientQnty decimal(18,2)
		
		)

		INSERT INTO @tbl2
		SELECT DISTINCT t.IngredientId
		,t.IngredientName
		,sum(t.IngredientQnty * t.ItemQnty) AS Qnty
		,ru.Symbol
			,t.ItemQnty 
		,t.IngredientQnty		
	FROM @tbl t
	INNER JOIN ROI_ItemDetails ID ON ID.ITId = t.IngredientId
	LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = ID.SmallUnit                                                                                                 
	GROUP BY t.IngredientId
		,t.IngredientName
		,ru.Symbol
		,t.ItemQnty 
		,t.IngredientQnty
	ORDER BY t.IngredientId

	--SELECT DISTINCT t2.IngredientId
	--	,t2.IngredientName
	--	,sum(t2.Quantity) AS Qnty
	--	,ru.Symbol
	
		
	--FROM @tbl2 t2
	--INNER JOIN ROI_ItemDetails ID ON ID.ITId = t2.IngredientId
	--LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = ID.SmallUnit                                                                                                 
	--GROUP BY t2.IngredientId
	--	,t2.IngredientName
	--	,ru.Symbol
	
	--ORDER BY t2.IngredientName
		
	IF OBJECT_ID('tempdb..#extratable') IS NOT NULL
	DROP TABLE #extratable


select ri.IngredientID,im.ITName as IngredientName,se.Quantity *  ri.Quantity as Quantity,ru.Symbol, se.Quantity as ItemQnty,  ri.Quantity as IngredientQnty
INTO #extratable
From RO_SalesDetailExtra se
		inner join RO_ExtraItem ei on se.ExtraId = ei.ExtraItemID
		inner join  RO_ExtraIngredient ri on ei.ExtraItemID = ri.ExtraItemID
		inner join ROI_ITEMMain im on im.ITId = ri.IngredientID
		INNER JOIN RO_SalesMaster sm ON se.SalesMasterId = sm.salesMasterId
		INNER JOIN ROI_ItemDetails ID ON ID.ITId = ri.IngredientID
	    LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = ID.SmallUnit        
		WHERE sm.IsArchived=0 
		and (cast(sm.BillDate as date) BETWEEN @startDate
	AND @endDate)

	--------------=============COMPLIMENTARY ITEMS======================

	DECLARE @tmpComplimentary TABLE (
		ItemId INT
		,ItemQnty decimal(18,2)
		,IngredientId INT
		,IngredientName NVARCHAR(max)
		,IngredientQnty decimal(18,2)
		)

	INSERT INTO @tmpComplimentary
	SELECT DISTINCT ci.ROI_ItemId as ItemId
		,sum(ci.Quantity) AS ItemQnty
		,IM.ITId AS IngredientId
		,IM.ITName IngredientName
		,ing.Quantity AS IngredientQnty
	FROM RO_ComplementaryItems ci
	INNER JOIN Ro_Ingredient ing ON ing.ItemID = ci.ROI_ItemId
	INNER JOIN ROI_ITEMMain IM ON IM.ITId = ing.Ingredient
	INNER JOIN tblComplementaryMaster cm ON ci.CompMasterID = cm.CompMasterID
	WHERE cm.IsCancelled = 0
	and (cast(cm.[Date] as date) >= @startDate
		AND  cast(cm.[Date] as date) <= @endDate
		)
	GROUP BY ci.ROI_ItemId
		,IM.ITName
		,ing.Quantity
		,IM.ITId

	DECLARE @tmpComplimentary2 TABLE (
		
	IngredientId INT
	,IngredientName NVARCHAR(max)
	,Quantity decimal(18,2)
	,Symbol nvarchar(25)
	,ItemQnty decimal(18,2)
	,IngredientQnty decimal(18,2)		
	)

	INSERT INTO @tmpComplimentary2
		SELECT DISTINCT t.IngredientId
		,t.IngredientName
		,sum(t.IngredientQnty * t.ItemQnty) AS Qnty
		,ru.Symbol
		,t.ItemQnty 
		,t.IngredientQnty		
	FROM @tmpComplimentary t
	INNER JOIN ROI_ItemDetails ID ON ID.ITId = t.IngredientId
	LEFT JOIN ROI_Unit1 ru ON ru.Unit1Id = ID.SmallUnit                                                                                                 
	GROUP BY t.IngredientId
		,t.IngredientName
		,ru.Symbol
		,t.ItemQnty 
		,t.IngredientQnty
	ORDER BY t.IngredientId
	----------------------------------------------------------------

SELECT IngredientId 
		,IngredientName 
		,SUM(Quantity) as Qnty
		,Symbol
		,SUM(ItemQnty) as ItemQnty
		,SUM(IngredientQnty) as IngredientQnty
		FROM
(
   SELECT * FROM #extratable
   UNION
   SELECT  * FROM @tbl2
   UNION ALL
   SELECT * FROM @tmpComplimentary2
) as a
GROUP BY IngredientId,IngredientName,Symbol 
ORDER BY IngredientName;
END

GO
