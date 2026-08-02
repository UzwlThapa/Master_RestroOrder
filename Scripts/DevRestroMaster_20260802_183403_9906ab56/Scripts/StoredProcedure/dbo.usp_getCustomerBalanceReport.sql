SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getCustomerBalanceReport]
@startDate datetime,  
@endDate datetime,  
@CustomerName int 
AS
BEGIN
--declare @startDate datetime='2017/01/01'
--declare @endDate datetime ='2017/01/31'
--declare @CustomerName int =6
if(@CustomerName=0)
begin
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
om.CusID
 from dbo.RO_SalesMaster om
 left join dbo.RO_restroTable rt on rt.restrotableId = om.TableId
 left join RO_RestroRoom rr on rr.restroRoomId=om.RoomId
  left join RO_LoyaltyMembership mm on mm.MembershipID=om.CusID
  --select * from RO_LoyaltyMembership
 --where EXTRACT(Year FROM om.Date), EXTRACT(Month FROM om.Date)  = '2015-11'
 where 
 --(om.BillDate between @startDate and @endDate) 
 (CONVERT(date, om.BillDate)>=@startDate and CONVERT(date, om.BillDate)<=@endDate)
and cusid !=0
 -- and  mm.MembershipID =@CustomerName
 --Year(om.BillDate)=@year and Month(om.BillDate)=@month
 end
 else
 begin
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
om.CusID
 from dbo.RO_SalesMaster om
 left join dbo.RO_restroTable rt on rt.restrotableId = om.TableId
 left join RO_RestroRoom rr on rr.restroRoomId=om.RoomId
  left join RO_LoyaltyMembership mm on mm.MembershipID=om.CusID
 where 
 --(om.BillDate between @startDate and @endDate)  and 
 (CONVERT(date, om.BillDate)>=@startDate and CONVERT(date, om.BillDate)<=@endDate)  and 
 mm.MembershipID =@CustomerName and cusid !=0
 end
END



GO
