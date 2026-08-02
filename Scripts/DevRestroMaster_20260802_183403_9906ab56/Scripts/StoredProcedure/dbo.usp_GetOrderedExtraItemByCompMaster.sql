SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetOrderedExtraItemByCompMaster] @CompMasterID INT
AS
BEGIN
	SELECT oe.CompMasterID
		,oe.ItemID
		,oe.ExtraItemID
		,oe.ExtraItem
		,sum(oe.Quantity) AS Quantity
		,oe.ExtraPrice
	FROM Comp_ExtraItem oe
	JOIN RO_ComplementaryItems od ON od.CompId = oe.CompId
	JOIN CompItemStatus ois ON od.CompId = ois.CompId
	WHERE oe.CompMasterID= @CompMasterID
		AND od.IsCancelled = 0
		AND ois.StatusID = 1
	GROUP BY oe.CompMasterID
		,oe.ItemID
		,oe.ExtraItemID
		,oe.ExtraItem
		,oe.ExtraPrice
END


GO
