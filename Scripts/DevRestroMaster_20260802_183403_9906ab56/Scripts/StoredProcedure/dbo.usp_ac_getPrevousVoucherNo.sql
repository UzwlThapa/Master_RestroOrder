SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC usp_ac_getPrevousVoucherNo 11
CREATE PROCEDURE [dbo].[usp_ac_getPrevousVoucherNo] @MembershipID INT
AS
BEGIN

	DECLARE @IsCustomer BIT
		,@VoucherTypeID INT

	if(@MembershipID <> 0)
	BEGIN
		SELECT @IsCustomer = lm.IsCustomer
		FROM ro_loyaltymembership lm
		WHERE lm.MembershipID = @MembershipID

		IF (@IsCustomer = 0)
			SET @VoucherTypeID = 2
		ELSE
			SET @VoucherTypeID = 3

		SELECT tt.VoucherNo AS prevVoucherno
		FROM Ac_TempTransaction tt
		WHERE tt.VoucherNo IS NOT NULL 
		and tt.VoucherTypeID = @VoucherTypeID
		ORDER BY tt.TransactionID DESC
	END
	ELSE
	BEGIN
		SELECT tt.VoucherNo AS prevVoucherno
		FROM Ac_TempTransaction tt
		WHERE tt.VoucherNo IS NOT NULL 
		and tt.VoucherTypeID = 3
		ORDER BY tt.TransactionID DESC
	END
END

GO
