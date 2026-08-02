SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ROI_GET_ITEM_RATE]

AS

BEGIN
	DECLARE @temp TABLE (
	unitId int,
	funitId int,
	sunitid int,
	convertsion int,
	particulars varchar(max),
	symbol varchar(128)
	)

	INSERT INTO @temp
	    SELECT * FROM dbo.FGetUnitTB()

	select *,im.ITName,t.particulars from ROI_ItemRate ir
	join ROI_ITEMMain im on im.ITId=ir.ItemID
	join @temp t on t.unitId=ir.UnitId
end

--select * from ROI_ItemRate  select* from ROI_ITEMMain




GO
