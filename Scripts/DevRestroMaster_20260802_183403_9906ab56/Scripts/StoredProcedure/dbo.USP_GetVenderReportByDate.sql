SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USP_GetVenderReportByDate '03/01/2020','09/27/2022',2158
CREATE PROCEDURE [dbo].[USP_GetVenderReportByDate] 
@DateFrom datetime,
@DateTo datetime,
@VenderId int
as

if(@VenderId = 0)
begin

select 
pm.PurchaseMainID,PM.PuNo,PM.PbDate,PM.IvNo,PM.Vid,lm.Fname,PD.ItemID,itm.ITName,PD.UsedUnitID,PD.Quentity as PurchaseQuantity,PD.UnitRate
,gr.PDId,isnull(sum(gr.Qnty),0) GoodReceivedQuantity,isnull((PD.Quentity-sum(isnull(gr.Qnty,0))),0) as Remaining,ru.Symbol as Description
from ROI_PurchaseMain pm
inner join ROI_PurchaseDetails PD on PM.PurchaseMainID = PD.PurchaseMainID
inner join ROI_ITEMMain itm on itm.ITId = pd.ItemID
inner join RO_LoyaltyMembership lm on lm.MembershipID=pm.Vid
left join RO_GoodsReceivedDetls gr on PD.PurchaseDetailsID = gr.PDId
left join ROI_ItemDetails itd on itm.ITId=itd.ITId
--left join ROI_Unit1 ru on ru.Unit1Id=itd.SmallUnit
left join ROI_Unit1 ru on ru.Unit1Id=PD.UsedUnitID
where (cast(pm.PbDate AS DATE) >= @DateFrom OR @DateFrom=0 OR @DateFrom IS NULL OR @DateFrom='')
and (cast(pm.PbDate AS DATE) <= @DateTo OR @DateTo=0 OR @DateTo IS NULL OR @DateTo='')
group by pm.PurchaseMainID,PM.PuNo,PM.PbDate,PM.IvNo,PM.Vid,lm.Fname,PD.ItemID,itm.ITName,PD.UsedUnitID,PD.Quentity,PD.UnitRate
,gr.PDId,ru.Symbol
end
else
begin 
select 
pm.PurchaseMainID,PM.PuNo,PM.PbDate,PM.IvNo,PM.Vid,lm.Fname,PD.ItemID,itm.ITName,PD.UsedUnitID,PD.Quentity as PurchaseQuantity,PD.UnitRate
,gr.PDId,sum(gr.Qnty) GoodReceivedQuantity,PD.Quentity-sum(gr.Qnty) Remaining,ru.Symbol as Description
from ROI_PurchaseMain pm
inner join ROI_PurchaseDetails PD on PM.PurchaseMainID = PD.PurchaseMainID
inner join ROI_ITEMMain itm on itm.ITId = pd.ItemID
inner join RO_LoyaltyMembership lm on lm.MembershipID=pm.Vid
left join RO_GoodsReceivedDetls gr on PD.PurchaseDetailsID = gr.PDId
left join ROI_ItemDetails itd on itm.ITId=itd.ITId
--left join ROI_Unit1 ru on ru.Unit1Id=itd.SmallUnit
left join ROI_Unit1 ru on ru.Unit1Id=PD.UsedUnitID
where (cast(pm.PbDate AS DATE) >= @DateFrom OR @DateFrom=0 OR @DateFrom IS NULL OR @DateFrom='')
and (cast(pm.PbDate AS DATE) <= @DateTo OR @DateTo=0 OR @DateTo IS NULL OR @DateTo='')
and (pm.Vid=@VenderId or @VenderId=0)
group by pm.PurchaseMainID,PM.PuNo,PM.PbDate,PM.IvNo,PM.Vid,lm.Fname,PD.ItemID,itm.ITName,PD.UsedUnitID,PD.Quentity,PD.UnitRate
,gr.PDId,ru.Symbol
end

GO
