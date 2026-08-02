SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Ac_AddACOpeningBalance]
	@AcId INT,
	@OpeningDate DATETIME,
	@OpeningAmt DECIMAL(15,2),
	@AddedBy VARCHAR(50),
	@IsDebit BIT
AS
BEGIN

	INSERT INTO Ac_Transaction
	(TransactionDate,VoucherTypeID,VoucherNo,Descriptions,PostedBy,PostedOn,VerifiedOn)
	VALUES
	( CAST(@OpeningDate as DATE),
	57,'Opening','Opening Balance',ISNULL(@AddedBy,''),GETDATE(),GETDATE()
	)

	DECLARE @TranId INT = @@Identity

	INSERT INTO Ac_TransactionDetail
	(TransactionID,FinancialAcID,Particulars,Debit,Credit)
	VALUES
	(@TranId,@AcId,'Opening Balance',
	CASE 
		WHEN @IsDebit = 1
			THEN @OpeningAmt
		ELSE 0.00
	END,
	CASE
		WHEN @IsDebit = 0
			THEN @OpeningAmt
		ELSE 0.00
	END
	)

	INSERT INTO [dbo].[Ac_OpeningBalanceDetail]
	(TranId,[TranDate],[IsDebit],[AddedOn],[AddedBy],OpeningAmt)
	VALUES
	(@TranId,@OpeningDate,@IsDebit,GETDATE(),@AddedBy,@OpeningAmt)

END

GO
