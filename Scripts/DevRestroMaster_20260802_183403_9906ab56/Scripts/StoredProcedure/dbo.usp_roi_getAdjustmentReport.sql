SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 -- [dbo].[usp_roi_getAdjustmentReport] '2017-01-03 0:0' , '2017-03-31 23:59'
CREATE PROCEDURE [dbo].[usp_roi_getAdjustmentReport] @startdate DATETIME
	,@enddate DATETIME
AS
BEGIN
	SELECT DISTINCT am.AMId
		,am.AMNo
		,fy.fyName
		,st.StName
		,am.PostedOn
		,am.PostedBy
		,im.ITName
		,ad.Qnty
		,u1.UnitDescription AS UnitName
		,at.AdjustmentTypeName
	FROM ROI_AdjustmentMain am
	JOIN ROI_AdjustmentDetls ad ON ad.AMId = am.AMId
	LEFT JOIN Ro_AdjustmentType at ON at.AdjustmentTypeID = ad.AdType
	LEFT JOIN RO_fiscalYear fy ON fy.fyId = am.FYId
	LEFT JOIN ROI_Store st ON st.STId = am.STId
	LEFT JOIN ROI_ITEMMain im ON im.ITId = ad.ITId
	LEFT JOIN ROI_Unit1 u1 ON u1.Unit1Id = ad.UsedUnitId
	WHERE
		--Year(am.PostedOn) = @year,
		(
			am.PostedOn BETWEEN @startDate
				AND @endDate
			)
	ORDER BY am.AMId DESC
END




GO
