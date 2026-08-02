SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getAdvanceReturnBill] 
  @MemberPayID int
  AS
SELECT mp.[MemberPayID]  as  MemberPayId
      ,mp.[MemberID]  
   ,lm.Fname + ' ' + lm.Lname as  CustomerName
      ,isnull(mp.ReturnAmount,0) as [PayAmount]  
   ,case when mpm.PaymentModeID=1 THEN 'CASH'  
   WHEN mpm.PaymentModeID=2 THEN 'CHEQUE'  
   WHEN mpm.PaymentModeID=3 THEN 'CARD'  
  END as PaymentMode  
      ,mp.[AddedOn]  
      ,mp.[AddedBy]  
   , CASE WHEN lm.IsCustomer < 1 THEN 'Vendor' ELSE 'Customer' END AS CustType  
      ,mpm.SettlementAmount
   ,mpm.TransactionNo
   ,cp.ProviderName
   ,PaymentModeID
  ,lm.RemainingBalance
  FROM [dbo].[RO_MemberPay] mp  
  inner join RO_MemberPaymentMode mpm on mp.MemberPayID=mpm.MemberPayId  
  inner join RO_LoyaltyMembership lm  
  on lm.MembershipID=mp.MemberID  
    left join RO_CardProvider cp on cp.ProviderID = mpm.ProviderID
   where mp.MemberPayID = @MemberPayID and isnull(mpm.ReturnAmount,0) > 0
  

GO
