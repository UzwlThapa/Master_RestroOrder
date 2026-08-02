SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Ac_saveBankInfo]
	--@BankAccountID INT
	@FinancialAcID INT
	,@PhoneNo nvarchar(10)
	,@Branch NVARCHAR(256)
	,@ContactPerson NVARCHAR(256)
	,@IsFixed BIT
	,@InterestRate DECIMAL(18, 2)
	,@OpenDate DATETIME
	,@MatureDate DATETIME
	,@MinimumBalance DECIMAL(18, 2)
AS
--declare @FinancialAcname nvarchar(256),@PFinancialAcID int,@FinancialSysID int
--IF (@FinancialAcID != (select FinancialAcID from Ac_BankInfo))
IF not EXISTS (
		SELECT *
		FROM Ac_BankInfo
		WHERE [FinancialAcID] = @FinancialAcID
		)
BEGIN
	INSERT INTO dbo.Ac_BankInfo (
		[FinancialAcID]
		,[PhoneNo]
		,[Branch]
		,[ContactPerson]
		,[IsFixed]
		,[InterestRate]
		,[OpenDate]
		,[MatureDate]
		,[MinimumBalance]
		)
	VALUES (
		@FinancialAcID
		,@PhoneNo
		,@Branch
		,@ContactPerson
		,@IsFixed
		,@InterestRate
		,@OpenDate
		,@MatureDate
		,@MinimumBalance
		)
END
ELSE
BEGIN
	UPDATE dbo.Ac_BankInfo
	SET [FinancialAcID] = @FinancialAcID
		,[PhoneNo] = @PhoneNo
		,[Branch] = @Branch
		,[ContactPerson] = @ContactPerson
		,[IsFixed] = @IsFixed
		,[InterestRate] = @InterestRate
		,[OpenDate] = @OpenDate
		,[MatureDate] = @MatureDate
		,[MinimumBalance] = @MinimumBalance
	WHERE [FinancialAcID] = @FinancialAcID
		--[BankAccountID] = @BankAccountID
END
		--select * from Ac_FinancialAc
		--UPDATE dbo.Ac_FinancialAc SET IsArchived = 0
		--select * from 	dbo.Ac_FinancialAc 

		SELECT *
		FROM Ac_BankInfo
		WHERE [FinancialAcID] = 12

--***************sp_8*************************



GO
