SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Ac_MergeAcc]
	@ParentAccId INT,
	@NewAccName NVARCHAR(50),
	@MergeFirstAccId INT,
	@MergeSecondAccId INT,
	@MergeBy NVARCHAR(50)
AS
BEGIN

DECLARE @NewFinancialId INT

BEGIN TRANSACTION
BEGIN TRY
	INSERT INTO Ac_FinancialAc ([Name],PFinancialAcID,FinancialSysID,AddedBy,AddedOn)
	values (@NewAccName,@ParentAccId,2,@MergeBy,GETDATE())

	SET @NewFinancialId = @@IDENTITY

	UPDATE Ac_FinancialAc SET IsArchived=1, ArchivedBy=@MergeBy, ArchivedOn=GETDATE() WHERE FinancialAcID IN (@MergeFirstAccId,@MergeSecondAccId)

	UPDATE Ac_TempTransactionDetail set FinancialAcID=@NewFinancialId where FinancialAcID IN (@MergeFirstAccId,@MergeSecondAccId)

	UPDATE Ac_TransactionDetail set FinancialAcID=@NewFinancialId where FinancialAcID IN (@MergeFirstAccId,@MergeSecondAccId)

	INSERT INTO [dbo].[Ac_MergeDetails] ([MergeNewAccId],[MergeOneAccId],[MergeTwoAccId],[MergedOn],[MergedBy])
	VALUES (@NewFinancialId,@MergeFirstAccId,@MergeSecondAccId,GETDATE(),@MergeBy)

	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
END CATCH
	

END

GO
