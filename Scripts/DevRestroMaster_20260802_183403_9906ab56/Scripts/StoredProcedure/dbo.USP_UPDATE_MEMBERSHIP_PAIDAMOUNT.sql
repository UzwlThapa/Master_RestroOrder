SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UPDATE_MEMBERSHIP_PAIDAMOUNT]
(
    @MembershipID int,
	@UptoNowPaid VARCHAR(256)
	
	
)
AS

BEGIN
Update  RO_LoyaltyMembership set 
	UptoNowPaid = CAST( (CAST(@UptoNowPaid AS DECIMAL(18, 2)) + CAST((select UptoNowPaid from RO_LoyaltyMembership where MembershipID=@MembershipID)AS DECIMAL(18, 2))) as nvarchar(200))
	where MembershipID=@MembershipID
	
	
END

GO
