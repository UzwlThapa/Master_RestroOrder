SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_PO_DELETEMEMBERSHIP]
CREATE PROCEDURE [dbo].[USP_PO_DELETEMEMBERSHIP]
@MembershipID INT,
@ArchivedBy nvarchar(250)

AS
BEGIN
DECLARE @RemainingBalance decimal 
select @RemainingBalance=RemainingBalance  from RO_LoyaltyMembership where MembershipID=@MembershipID

if(@RemainingBalance = 0 )
BEGIN
	Update RO_LoyaltyMembership set IsArchived=1, ArchivedBy=@ArchivedBy, ArchivedOn=getdate() where MembershipID=@MembershipID
		SELECT 200
		END
	else
		SELECT 100
END




GO
