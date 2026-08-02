SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_RO_GetCategoriesBymenuID] 477
CREATE PROCEDURE [dbo].[USP_RO_GetCategoriesBymenuID] @MenuId INT
,@LanguageID INT
AS
--select * from RO_Categories where MenuID = @MenuId  
SELECT m.ITID AS ItemId
	,m.ITName AS ItemName
	,m.PITId AS PItemId
	,d.ROrderLevel AS LEVEL
	,d.ImagePath
	,m.IsCategory
	,ir.SRate
	,d.IsOutOfStock
	,coalesce(gm.[Text],ITName) AS LanguageMenuText
FROM ROI_ITEMMain m
INNER JOIN ROI_ItemDetails d ON d.ITId = m.ITId
--left join ROI_ITEMMain m1 on m.ITId = m1.PITId
INNER JOIN ROI_ItemRate ir ON ir.ItemID = m.ITId
LEFT JOIN RO_GlobalizedMenu gm on m.ITId = gm.ItemID and LanguageID=@LanguageID
WHERE m.PITId = @MenuId
	AND m.IsArchived = 0
	AND m.IsMenu = 1
	AND m.IsActive = 1
order by ItemName asc

GO
