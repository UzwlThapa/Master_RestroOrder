SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--***********************sp_5********************
CREATE PROCEDURE [dbo].[usp_Ac_saveFinancialAc] @FinancialAcID INT
	,@FinancialAcname NVARCHAR(256)
	,@PFinancialAcID INT
	,@FinancialSysID INT
	,@AddedBy NVARCHAR(256)
	,@OpeningBalance DECIMAL(18, 2) = NULL
	,@AccEntryType INT
	,@IsDebit BIT
AS

DECLARE @InsertData INT
DECLARE @DebitEntry BIT
DECLARE @EntryType INT

IF (@FinancialAcID = 0)
BEGIN
	IF(@PFinancialAcID=0)
	BEGIN
		INSERT INTO dbo.Ac_FinancialAc (
			NAME
			,PFinancialAcID
			,FinancialSysID
			,AddedBy
			,AddedOn
			,OpeningBalance
			,[AccEntryType]
			,[IsDebit]
			)
		VALUES (
			@FinancialAcname
			,@PFinancialAcID
			,@FinancialSysID
			,@AddedBy
			,GETDATE()
			,@OpeningBalance
			,@AccEntryType
			,@IsDebit
			)
		Set @InsertData = CAST(@@IDENTITY AS INT)
	END
	ELSE
	BEGIN
		INSERT INTO dbo.Ac_FinancialAc (
			NAME
			,PFinancialAcID
			,FinancialSysID
			,AddedBy
			,AddedOn
			,OpeningBalance
			)
		VALUES (
			@FinancialAcname
			,@PFinancialAcID
			,@FinancialSysID
			,@AddedBy
			,GETDATE()
			,@OpeningBalance
			)
		Set @InsertData = CAST(@@IDENTITY AS INT)

		--Getting the Top Parent of the Hierarchy to insert Entry Type and Debit Credit Column
		;WITH cte_hierarchy AS (
		  SELECT FinancialAcID,Name,PFinancialAcID,IsArchived,AccEntryType,IsDebit FROM Ac_FinancialAc
		  WHERE FinancialAcID = @InsertData 

		  UNION ALL

		  SELECT t.FinancialAcID,t.Name,t.PFinancialAcID,t.IsArchived,t.AccEntryType,t.IsDebit
		  FROM Ac_FinancialAc t
		  INNER JOIN cte_hierarchy cte ON t.FinancialAcID = cte.PFinancialAcID
		)
		SELECT @AccEntryType = Ct.AccEntryType,
		@IsDebit = ct.IsDebit
		FROM cte_hierarchy ct
		WHERE PFinancialAcID=0;

		UPDATE Ac_FinancialAc SET AccEntryType=@AccEntryType, IsDebit=@IsDebit WHERE FinancialAcID=@InsertData

	END
END
ELSE
BEGIN
	UPDATE dbo.Ac_FinancialAc
	SET NAME = @FinancialAcname
		,PFinancialAcID = @PFinancialAcID
		,FinancialSysID = @FinancialSysID
		,IsUpdated = 1
		,UpdatedBy = @AddedBy
		,UpdatedOn = GETDATE()
		,OpeningBalance = @OpeningBalance
		,AccEntryType = @AccEntryType
		,IsDebit = @IsDebit
	WHERE FinancialAcID = @FinancialAcID

	SET @InsertData = cast(@FinancialAcID AS INT)
END


SELECT @InsertData



GO
