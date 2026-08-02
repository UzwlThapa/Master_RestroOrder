SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- drop PROCEDURE [USP_RO_GetItemByCategoryID]
CREATE PROCEDURE [dbo].[USP_RO_GetItemByCategoryID] @CategoriesID INT
,@LanguageID INT
AS
--select * from RO_Items where CategoryID = @CategoriesID
SELECT m.ITID AS ItemId
	,m.ITName AS ItemName
	,m.PITId AS PItemId
	,d.ROrderLevel AS LEVEL
	,d.ImagePath
	,ir.SRate
	,m.IsCategory
	,d.IsOutOfStock
	,coalesce(gm.[Text],ITName) AS LanguageMenuText
FROM ROI_ITEMMain m
INNER JOIN ROI_ItemDetails d ON d.ITId = m.ITId
INNER JOIN ROI_ItemRate ir ON ir.ItemID = m.ITId
LEFT JOIN RO_GlobalizedMenu gm on m.ITId = gm.ItemID and LanguageID=@LanguageID
WHERE m.PITId = @CategoriesID
	AND m.IsArchived = 0
	AND m.IsMenu = 1
	AND m.IsActive = 1
order by ItemName asc


GO
