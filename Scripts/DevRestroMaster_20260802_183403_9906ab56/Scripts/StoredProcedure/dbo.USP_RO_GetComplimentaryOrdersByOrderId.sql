SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[USP_RO_GetComplimentaryOrdersByOrderId] 
@OrderMasterId int

AS

select  cm.CompMasterID as OrderMasterId, rr.restroRoom, rt.restrotableTitle, cm.BasicAmount as Amount
,cm.[Date] as tableDate, cm.GuestNo
,ci.ROI_ItemId as itemId, it.ITName as itemName, ci.Quantity, ci.Rate, ci.CostCenterId, ci.ExtraItem, ci.ExtraCharge,cm.Details
 from tblComplementaryMaster cm
inner join RO_restroTable rt on cm.TableId = rt.restrotableId
inner join RO_RestroRoom rr on rt.restroRoomId = rr.restroRoomId 
inner join RO_ComplementaryItems ci on ci.CompMasterID = cm.CompMasterID
inner join ROI_ITEMMain it on it.ITId = ci.ROI_ItemId
where cm.CompMasterID = @OrderMasterId

GO
