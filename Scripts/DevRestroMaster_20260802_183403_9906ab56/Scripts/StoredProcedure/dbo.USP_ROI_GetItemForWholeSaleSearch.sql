SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_GetItemForWholeSaleSearch]
--@LanguageID INT
	@LookUpName VARCHAR(10) = NULL

AS
BEGIN

SELECT rim.ITId,rim.ITName,ir.LargeUnit,u1.UnitDescription,u1.Symbol, rim.IsCategory
	FROM dbo.ROI_ITEMMain rim
	INNER JOIN ROI_ITEMMain cat ON rim.PITId = cat.ITId
	JOIN dbo.ROI_ItemDetails id ON id.ITId = rim.ITId
	JOIN ROI_ItemRate ir ON ir.ItemID = rim.ITId
	LEFT JOIN ROI_Unit1 u1 ON u1.Unit1Id = ir.LargeUnit
	WHERE rim.PITId!=0 AND rim.IsArchived = 0
	AND rim.IsActive=1 AND rim.IsMenu = 1
	AND cat.IsArchived=0
	AND cat.IsActive=1 AND cat.IsMenu=1
	AND cat.LookupName = @LookUpName
END

GO
