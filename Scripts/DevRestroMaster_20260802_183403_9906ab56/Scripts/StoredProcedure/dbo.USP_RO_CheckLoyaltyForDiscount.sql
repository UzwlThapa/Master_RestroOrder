SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_RO_CheckLoyaltyForDiscount
--[dbo].[USP_RO_CheckLoyaltyForDiscount] '','12345'
CREATE PROCEDURE [dbo].[USP_RO_CheckLoyaltyForDiscount] @MembershipID NVARCHAR(256)
	,@TelMobile NVARCHAR(max)
AS
SELECT *
FROM dbo.RO_LoyaltyMembership
WHERE (
		CardNumber = @MembershipID
		AND CardNumber <> ''
		OR (
			(
				TelMobile = @TelMobile
				AND TelMobile <> ''
				)
			--OR (
			--	COALESCE(NULLIF(TelHome, ''), '0') = @TelMobile
			--	AND TelHome <> ''
			--	)
			--OR (
			--	COALESCE(NULLIF(TelWork, ''), '0') = @TelMobile
			--	AND TelWork <> ''
			--	)
			)
		)
	AND iscustomer = 1



GO
