SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from ROI_Unit1
--select * from ROI_Unit2
CREATE PROCEDURE [dbo].[usp_LargeUnitBySmallUnit]
@smallUnit int
as
select Unit1Id as UnitId,UnitDescription as Particulars, Symbol from ROI_Unit1 u1 where u1.Unit1Id in (select u2.FirstUnit from ROI_Unit2 u2 where u2.SecondUnit=@smallUnit)



GO
