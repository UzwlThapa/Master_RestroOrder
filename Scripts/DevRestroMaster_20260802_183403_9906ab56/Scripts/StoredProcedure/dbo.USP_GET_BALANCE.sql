SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GET_BALANCE]
as
begin
	--select distinct ib.ItemBalID,ib.ITId,ib.OPBal,im.ITName,ib.STId,S.StName,id.SmallUnit,u1.UnitDescription,u1.Symbol, ib.CLBal
	--,ISNULL(ib.OPRate,0) OPRate, ISNULL(ib.CLRate,0) CLRate, (ISNULL(ib.OPBal,0) * ISNULL(ib.OPRate,0)) as TotalValue
	--from ROI_ITEMBal ib
	--INNER JOIN ROI_ITEMMain im on ib.ITId = im.ITId
	--INNER JOIN ROI_Store S on S.STId = IB.STId
	--join ROI_ItemDetails id on id.ITId=im.ITId
	--left join ROI_Unit1 u1 on u1.Unit1Id=id.SmallUnit

	SELECT OST.OpeningTranId [ItemBalID], OST.ItemId [ITId],ID.ITCode [ITName],OST.StoreId [STId], S.StName [StName], U.UnitDescription, U.Symbol, OST.OpeningQty [OPBal] ,OST.OpeningRate [OPRate], OST.OpeningAmt [TotalValue] FROM [dbo].[ROI_OpeningStockTransaction] OST
	INNER JOIN ROI_ItemDetails ID ON OST.ItemId = ID.ITId
	INNER JOIN ROI_Store S ON OST.StoreId = S.STId
	INNER JOIN ROI_Unit1 U ON U.Unit1Id = OST.OpeningUnit
	
end

GO
