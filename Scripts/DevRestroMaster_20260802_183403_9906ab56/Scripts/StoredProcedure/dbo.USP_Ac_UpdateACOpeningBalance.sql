SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Ac_UpdateACOpeningBalance]
@OpeningId INT,
@TranDate DATETIME,
@OpeningAmt DECIMAL(15,2),
@AddedBy VARCHAR(50),
@IsDebit BIT
AS
BEGIN
	DECLARE @fcid INT = ISNULL((SELECT TOP(1) TranId from [dbo].[Ac_OpeningBalanceDetail] where [AcOpeningId]=@OpeningId),0)

	UPDATE [dbo].[Ac_OpeningBalanceDetail] SET TranDate=@TranDate,UpdatedOn=GETDATE(), OpeningAmt = @OpeningAmt,IsDebit = @IsDebit WHERE [AcOpeningId]=@OpeningId;

	UPDATE Ac_Transaction SET TransactionDate=@TranDate where TransactionID=@fcid;

	IF(@IsDebit = 1)
	BEGIN
		UPDATE Ac_TransactionDetail SET Debit=@OpeningAmt,Credit=0 where TransactionID=@fcid
	END
	ELSE
	BEGIN
		UPDATE Ac_TransactionDetail SET Debit=0,Credit=@OpeningAmt where TransactionID=@fcid
	END
END

GO
