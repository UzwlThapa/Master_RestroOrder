SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETINVITEM]
@costCenter int
AS
BEGIN
	SELECT m.ITId
		,m.ITName
		,m.IsCategory
		,r.SRate
		,d.ItemCostCentreID
	FROM ROI_ITEMMain m
	INNER JOIN ROI_ItemDetails d ON m.ITId = d.ITId
	INNER JOIN ROI_ItemRate r ON m.ITId = r.ItemID
	WHERE m.IsActive = 1
		AND m.IsArchived = 0
		--AND d.IsMenu = 1
		AND d.IsProdMaterial = 0
		AND m.IsCategory = 0
		AND (
			d.ItemCostCentreID = @costCenter
			OR @costCenter = 0
			)
			order by m.ITName
END

GO
