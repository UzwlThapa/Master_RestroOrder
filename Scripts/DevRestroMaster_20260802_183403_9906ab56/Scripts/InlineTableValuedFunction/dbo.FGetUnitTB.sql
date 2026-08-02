SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Function [dbo].[FGetUnitTB]()
returns
table
as
return
(
SELECT     dbo.ROI_Unit3.UnitId, dbo.ROI_Unit3.FUnit, ISNULL(dbo.ROI_Unit2.SecondUnit, dbo.ROI_Unit3.FUnit) AS SUnit, ISNULL(dbo.ROI_Unit2.Conversion, 1) AS Conversion, 
                      dbo.ROI_Unit3.Particulars, UnitA.Symbol
FROM         dbo.ROI_Unit3 INNER JOIN
                      dbo.ROI_Unit1 UnitA ON dbo.ROI_Unit3.FUnit = UnitA.Unit1Id LEFT OUTER JOIN
                      dbo.ROI_Unit1 UnitB ON dbo.ROI_Unit3.UnitId = UnitB.Unit1Id LEFT OUTER JOIN
                      dbo.ROI_Unit2 ON dbo.ROI_Unit3.UnitId = dbo.ROI_Unit2.Unit2ID
)






GO
