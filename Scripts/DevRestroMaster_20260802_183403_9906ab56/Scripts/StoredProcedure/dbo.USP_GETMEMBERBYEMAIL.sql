SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETMEMBERBYEMAIL] 
@MembershipID int
AS
BEGIN

select Fname+ ' ' + Lname as Name,
[Address],
TelMobile,
Email,
MembershipID,
PAN
from RO_LoyaltyMembership 
where MembershipID=@MembershipID
END

GO
