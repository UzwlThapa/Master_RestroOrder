SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GET_ROUNIT] 

@ITId int

AS
BEGIN

select u3.UnitId, u1.UnitDescription,  u3.FUnit, u3.SUnit, id.MUnitId   from ROI_ItemDetails id
join  dbo.FGetUnitTB() u3   on u3.UnitId=id.MUnitId
join dbo.ROI_Unit1 u1 on u1.Unit1Id = u3.FUnit
--join dbo.ROI_Unit2 u2 on u2.Unit2ID = u3.SUnit
 where id.ITId=@ITId

END





GO
