SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_RO_GETMENU] 
CREATE PROCEDURE [dbo].[USP_RO_GETMENU]
AS
BEGIN
	SELECT m.ITID AS ItemId
		,m.ITName AS ItemName
		,m.PITId AS PItemId
		,d.ROrderLevel AS LEVEL
		,d.ImagePath
		,d.IsProdMaterial
		,d.IsOutOfStock
	FROM ROI_ITEMMain m
	LEFT JOIN ROI_ItemDetails d ON d.ITId = m.ITId
	WHERE ROrderLevel = 1
		AND m.IsArchived = 0
		AND m.IsMenu = 1
		--AND isnull(d.IsOutOfStock,0) = 0
	ORDER BY ItemName ASC
END

GO
