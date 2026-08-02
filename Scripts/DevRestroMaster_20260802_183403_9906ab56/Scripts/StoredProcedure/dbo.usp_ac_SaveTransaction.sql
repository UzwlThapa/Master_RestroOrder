SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ac_SaveTransaction] @TransactionID INT
	,@TransactionDate DATETIME
	,@VoucherTypeID INT
	--,@VoucherNo NVARCHAR(256)
	,@Descriptions NVARCHAR(256)
	,@PostedBy NVARCHAR(256)
AS
IF (@TransactionID = 0)
BEGIN
	INSERT INTO Ac_TempTransaction (
		[TransactionDate]
		,[VoucherTypeID]
		--,[VoucherNo]
		,[Descriptions]
		,[PostedBy]
		,[PostedOn]
		)
	VALUES (
		@TransactionDate
		,@VoucherTypeID
		--,@VoucherNo
		,@Descriptions
		,@PostedBy
		,getdate()
		)

	SELECT cast(@@IDENTITY AS INT)
END
ELSE
BEGIN
	UPDATE Ac_TempTransaction
	SET [TransactionDate] = @TransactionDate
		,[VoucherTypeID] = @VoucherTypeID
		--,[VoucherNo] = @VoucherNo
		,[Descriptions] = @Descriptions
		,[UpdatedBy] = @PostedBy
		,[PostedOn] = GETDATE()
		,IsUpdated = 1
	WHERE TransactionID = @transactionID
	SELECT cast(@TransactionID AS INT)
END





  




GO
