SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- FIX 2: USP_ROI_GetItemExtraListByItemID
-- Casts IsActive to BIT
CREATE PROCEDURE [dbo].[USP_ROI_GetItemExtraListByItemID] @ItemId INT
AS
BEGIN
    SELECT ei.ItemID,
           ext.ExtraItemID,
           ext.ExtraItem,
           ext.ExtraPrice,
           CAST(ext.IsActive AS BIT) AS IsActive, -- FIXED: Cast to BIT
           CAST(1 AS BIT) AS IsExtra              -- FIXED: Cast to BIT
    FROM Roi_ExtraItemForItem ei
        LEFT JOIN RO_ExtraItem ext
            ON ei.ExtraItemID = ext.ExtraItemID
    WHERE ei.ItemID = @ItemId
          AND ext.IsActive = 1;
END;

GO
