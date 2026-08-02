SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP proc USP_RO_GetOrderDeliveryList
CREATE PROCEDURE [dbo].[USP_RO_GetOrderDeliveryList]
as
select om.[OrderMasterID] as OrderMasterId
	, om.[Date] as tableDate
	,om.GuestNo
,isnull(om.OrderNo,0) OrderNo
, isnull(ot.TokenNo,0) TokenNo
,isnull(ot.CustomerID,0) CustomerID
,ot.CustomerName
,ot.Phone
,isnull(lm.discount,0) discount
from RO_OrderMasters om
left join RO_OrderToken ot on om.OrderMasterID = ot.OrderMasterID
left join RO_LoyaltyMembership lm on lm.MembershipID = ot.CustomerID
where isnull(om.TableId,0)=0 
and ISNULL(om.BillPaid,0)=0 
and ISNULL(om.IsCancelled,0)=0
and ISNULL(om.OrderTypeID,0) = 4

GO
