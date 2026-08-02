SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- USP_RO_getCreditPayReportByDates '1/01/2018','9/24/2019', null,0  
--DROP procedure [dbo].[USP_RO_getCreditPayReportByDates]   
CREATE PROCEDURE [dbo].[USP_RO_getCreditPayReportByDates]   
@sdate date,  
@edate date,  
@Customer nvarchar(250) = null,  
@IsCustomer bit=null  
as  
	SELECT mp.[MemberPayID]  
		,0 as RoomBookDetailsID
		,mp.[MemberID]  
		,lm.Fname + ' ' + lm.Lname as CustName  
		,mpm.[PayAmount]  
		,case when mpm.PaymentModeID=1 THEN 'CASH'  
			WHEN mpm.PaymentModeID=2 THEN 'CHEQUE'  
			WHEN mpm.PaymentModeID=3 THEN 'CARD'  
			END as PaymentMode  
		,mp.[AddedOn]  
		,mp.[AddedBy]  
		,CASE WHEN lm.IsCustomer < 1 THEN 'Vendor' ELSE 'Customer' END AS CustType  
		,isnull(mp.SettlementAmount,0) as SettlementAmount
	  FROM [dbo].[RO_MemberPay] mp  
	  inner join RO_MemberPaymentMode mpm on mp.MemberPayID=mpm.MemberPayId  
	  inner join RO_LoyaltyMembership lm  
	  on lm.MembershipID=mp.MemberID  
		   where (cast(dateadd(hour,-4,mp.AddedOn) as date) between @sdate and @edate) and mpm.[PayAmount] != 0.00  
		   AND ( lm.IsCustomer=@IsCustomer or  @IsCustomer IS NULL or  @IsCustomer='')  
		   AND (lm.Fname + ' ' + lm.Lname = @Customer or @Customer IS NULL)  
		   AND mpm.[PayAmount] > 0
		order by CustName ASC  
  --UNION 

		--select 
		--0 as [MemberPayID]  
		--,rm.RoomBookDetailsID
		--,rm.CustomerId
		--,lm.Fname + ' ' + lm.Lname as CustName  
		--,rpm.[PayAmount]  
		--,case when rpm.PaymentModeID=1 THEN 'CASH'  
		--	   WHEN rpm.PaymentModeID=2 THEN 'CHEQUE'  
		--	   WHEN rpm.PaymentModeID=3 THEN 'CARD'  
		--	  END as PaymentMode  
		--,om.Date
		--,om.UserName
		--,CASE WHEN lm.IsCustomer < 1 THEN 'Vendor' ELSE 'Customer' END AS CustType  
	 --  ,isnull(rpm.SettlementAmount,0) as SettlementAmount
		--from Ro_RoomBookings rm 
		--inner join RO_OrderMasters om on om.OrderMasterID = rm.OrderMasterId
		--inner join RO_AdvancePaymentMode rpm on rm.RoomBookDetailsID = rpm.RoomBookDetailsId 
		--inner join RO_LoyaltyMembership lm on lm.MembershipID =  rm.CustomerId
		--where (cast(dateadd(hour,-4,om.Date) as date) between @sdate and @edate)
		--   AND ( lm.IsCustomer=@IsCustomer or  @IsCustomer IS NULL or  @IsCustomer='')  
		--   AND (lm.Fname + ' ' + lm.Lname = @Customer or @Customer IS NULL)  
		--   AND rm.AdvancePayment > 0
		--   order by CustName ASC  
  

GO
