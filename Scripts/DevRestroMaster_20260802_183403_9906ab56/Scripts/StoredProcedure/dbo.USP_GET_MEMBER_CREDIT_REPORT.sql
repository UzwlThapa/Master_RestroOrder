SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GET_MEMBER_CREDIT_REPORT]
@MembershipID int
AS
BEGIN

select 
om.BillDate,
om.NetAmount,
om.Waiter,
rt.restrotableTitle,
rr.restroRoom
,om.billNo
,om.TableId
,salesMasterId
,om.OrderMasterId,
--om.CusName,
(mm.Fname + ' ' + mm.Lname) as CusName,
mm.RemainingBalance,
mm.UptoNowPaid,
om.CusID,
mm.RemainingBalance
 from dbo.RO_SalesMaster om
 left join dbo.RO_restroTable rt on rt.restrotableId = om.TableId
 left join RO_RestroRoom rr on rr.restroRoomId=om.RoomId
  left join RO_LoyaltyMembership mm on mm.MembershipID=om.CusID

 --where EXTRACT(Year FROM om.Date), EXTRACT(Month FROM om.Date)  = '2015-11'
 

where MembershipID=@MembershipID


END



GO
