SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETGLOBALIZEDMENU]
@LanguageID int
AS
BEGIN
	SELECT m.ITID AS ItemId
		,m.ITName AS ItemName
		,m.PITId AS PItemId
		,m.LookupName
		,d.ROrderLevel AS LEVEL
		,d.ImagePath
		,d.IsProdMaterial
		,d.IsOutOfStock
		,coalesce(gm.[Text],m.ITName) AS LanguageMenuText
	FROM ROI_ITEMMain m
	--inner join ROI_ITEMMain cat on m.PITId=cat.ITId
	LEFT JOIN ROI_ItemDetails d ON d.ITId = m.ITId
	LEFT JOIN RO_GlobalizedMenu gm on m.ITId = gm.ItemID and LanguageID=@LanguageID
	WHERE ROrderLevel = 1
		AND m.IsArchived = 0
		AND m.IsMenu = 1
		AND m.IsActive=1
		--AND isnull(d.IsOutOfStock,0) = 0
 --and cat.IsArchived=0
 --and cat.IsActive=1 and cat.IsMenu=1
	ORDER BY ItemName ASC
	END
	

GO
