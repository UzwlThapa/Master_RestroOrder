SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateMemberBalance]
 @paidAmount decimal
 as
--declare @paidAmount decimal=10
update  RO_LoyaltyMembership set 
RemainingBalance=RemainingBalance-@paidAmount,
UptoNowPaid= UptoNowPaid+@paidAmount
select * from RO_LoyaltyMembership



GO
