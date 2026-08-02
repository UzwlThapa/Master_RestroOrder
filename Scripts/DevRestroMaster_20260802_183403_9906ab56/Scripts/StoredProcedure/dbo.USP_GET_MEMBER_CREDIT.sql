SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GET_MEMBER_CREDIT]

AS
BEGIN

select Fname+ ' ' + Lname as Name,

Address,
TelMobile,
CardNumber,
CC.RemainingBalance,
cc.MembershipID
 from RO_LoyaltyMembership lm

INNER JOIN tbl_cus_credit CC ON CC.MembershipID = lm.MembershipID


END

--select * from RO_LoyaltyMembership





GO
