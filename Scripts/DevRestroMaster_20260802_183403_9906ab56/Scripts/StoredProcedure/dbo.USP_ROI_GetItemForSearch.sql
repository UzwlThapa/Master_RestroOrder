SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_ROI_GetItemForSearch] 1
CREATE PROCEDURE [dbo].[USP_ROI_GetItemForSearch]
--@LanguageID INT
AS
    BEGIN
        SELECT rim.ITId ,
               rim.ITName ,
               ir.LargeUnit ,
               u1.UnitDescription ,
               u1.Symbol ,
               rim.IsCategory
        --,coalesce(gm.[Text],ITName) AS LanguageMenuText
        FROM   dbo.ROI_ITEMMain rim
               INNER JOIN ROI_ITEMMain cat ON rim.PITId = cat.ITId
               JOIN dbo.ROI_ItemDetails id ON id.ITId = rim.ITId
               JOIN ROI_ItemRate ir ON ir.ItemID = rim.ITId
               LEFT JOIN ROI_Unit1 u1 ON u1.Unit1Id = ir.LargeUnit
        --LEFT JOIN RO_GlobalizedMenu gm on rim.ITId = gm.ItemID 
        --and LanguageID=@LanguageID
        WHERE  rim.PITId != 0
        AND    rim.IsArchived = 0
        --and id.IsProdMaterial=0 
        AND    rim.IsActive = 1
        AND    rim.IsMenu = 1
        AND    cat.IsArchived = 0
        --and id.IsProdMaterial=0 
        AND    cat.IsActive = 1
        AND    cat.IsMenu = 1;
    --and rim.IsCategory is not null and rim.IsCategory=0
    END;



GO
