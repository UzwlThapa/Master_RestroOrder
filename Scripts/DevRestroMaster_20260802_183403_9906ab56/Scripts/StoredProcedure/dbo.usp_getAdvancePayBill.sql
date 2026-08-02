SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAdvancePayBill] 
  @RoomBookDetailsID int
  AS
SELECT rb.RoomBookDetailsID as MemberPayId
      ,rb.CustomerId as MemberID
   ,lm.Fname + ' ' + lm.Lname as CustomerName  
      ,apm.[PayAmount]  
   ,case when apm.PaymentModeID=1 THEN 'CASH'  
   WHEN apm.PaymentModeID=2 THEN 'CHEQUE'  
   WHEN apm.PaymentModeID=3 THEN 'CARD'  
  END as PaymentMode  
       ,om.Date as AddedOn
      ,om.UserName as AddedBy
   , CASE WHEN lm.IsCustomer < 1 THEN 'Vendor' ELSE 'Customer' END AS CustType  
   ,apm.SettlementAmount
   ,apm.TransactionNo
   ,cp.ProviderName
   ,PaymentModeID
  ,lm.RemainingBalance
   FROM [dbo].Ro_RoomBookings rb
  JOIN RO_AdvancePaymentMode apm ON apm.RoomBookDetailsId = rb.RoomBookDetailsID
 JOIN RO_OrderMasters om ON rb.OrderMasterId= om.OrderMasterID
  inner join RO_LoyaltyMembership lm on lm.MembershipID=rb.CustomerId  
  left join RO_CardProvider cp on cp.ProviderID = apm.ProviderID
	where rb.RoomBookDetailsID = @RoomBookDetailsID
   order by CustomerName   ASC  
  

GO
