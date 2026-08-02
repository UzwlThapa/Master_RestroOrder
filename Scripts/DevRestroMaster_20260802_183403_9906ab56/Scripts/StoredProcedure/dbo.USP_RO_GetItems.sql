SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- drop PROCEDURE [USP_RO_GetItemByCategoryID]
CREATE PROCEDURE [dbo].[USP_RO_GetItems]
AS
BEGIN

    --select * from RO_Items where CategoryID = @CategoriesID
    SELECT m.ITId AS ItemId,
           m.ITName AS ItemName,
           m.PITId AS PItemId,
           d.ROrderLevel AS LEVEL,
           d.ImagePath,
           ir.SRate,
           m.IsCategory,
           d.IsOutOfStock,
           (ITName) AS LanguageMenuText
    FROM ROI_ITEMMain m
        INNER JOIN ROI_ItemDetails d
            ON d.ITId = m.ITId
        INNER JOIN ROI_ItemRate ir
            ON ir.ItemID = m.ITId
    WHERE m.IsArchived = 0
          AND m.IsMenu = 1
          AND m.IsActive = 1
    ORDER BY ItemName ASC;


END;

GO
