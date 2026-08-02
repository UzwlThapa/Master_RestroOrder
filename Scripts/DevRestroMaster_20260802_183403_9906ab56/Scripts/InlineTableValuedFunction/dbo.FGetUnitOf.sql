SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Function [dbo].[FGetUnitOf](@UnitId int)
returns table
as 
return
( 
	SELECT     dbo.ROI_Unit3.UnitId, dbo.ROI_Unit3.UnitName, dbo.ROI_Unit3.Conversion, dbo.ROI_Unit1.Symbol, dbo.ROI_Unit3.FUnit, dbo.ROI_Unit3.SUnit, @UnitId AS CurrentUnit
	FROM         dbo.ROI_Unit1 INNER JOIN
						  dbo.ROI_Unit3 ON dbo.ROI_Unit1.Unit1Id = dbo.ROI_Unit3.SUnit
	WHERE     (dbo.ROI_Unit3.SUnit =
							  (SELECT     sunit
								FROM          ROI_Unit3
								WHERE      ROI_Unit3.UnitId = @UnitId)) AND (dbo.ROI_Unit3.Conversion = 1)

	union all
	SELECT dbo.ROI_Unit3.UnitId, dbo.ROI_Unit3.UnitName, dbo.ROI_Unit3.Conversion, dbo.ROI_Unit1.Symbol, FUnit, SUnit,  @UnitId as CurrentUnit
	FROM         dbo.ROI_Unit1 
					INNER JOIN dbo.ROI_Unit2 ON dbo.ROI_Unit1.Unit1Id = dbo.ROI_Unit2.FirstUnit 
					INNER JOIN dbo.ROI_Unit3 ON dbo.ROI_Unit2.Unit2ID = dbo.ROI_Unit3.UnitId 
					where ROI_Unit3.UnitId in ( select inunitid from ROI_Unit4 where UnitId = @Unitid)
	                 
	union all
	SELECT dbo.ROI_Unit3.UnitId, dbo.ROI_Unit3.UnitName, dbo.ROI_Unit3.Conversion, dbo.ROI_Unit1.Symbol, FUnit, SUnit,  @UnitId as CurrentUnit
	FROM         dbo.ROI_Unit1 
					INNER JOIN dbo.ROI_Unit2 ON dbo.ROI_Unit1.Unit1Id = dbo.ROI_Unit2.FirstUnit 
					INNER JOIN dbo.ROI_Unit3 ON dbo.ROI_Unit2.Unit2ID = dbo.ROI_Unit3.UnitId 
					where ROI_Unit3.UnitId in ( select SecondUnit from ROI_Unit2 where Unit2Id = @Unitid)
	                   
	union all
	SELECT dbo.ROI_Unit3.UnitId, dbo.ROI_Unit3.UnitName, dbo.ROI_Unit3.Conversion, dbo.ROI_Unit1.Symbol, FUnit, SUnit,  @UnitId as CurrentUnit
	FROM         dbo.ROI_Unit1 INNER JOIN
						  dbo.ROI_Unit2 ON dbo.ROI_Unit1.Unit1Id = dbo.ROI_Unit2.FirstUnit INNER JOIN
						  dbo.ROI_Unit3 ON dbo.ROI_Unit2.Unit2ID = dbo.ROI_Unit3.UnitId 
						  where  funit in (select InUnitId from ROI_Unit4 where unitid = @UnitId) and ROI_Unit3.Funit <> @UnitId  and ROI_Unit3.conversion > 1
					   and   ROI_Unit2.Unit2Id = @unitid
	               
                  
)






GO
