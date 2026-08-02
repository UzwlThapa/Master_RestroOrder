SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_SAVEBILLINGTERM] (
	@billtermId INT
	,@Name NVARCHAR(200)
	,@IsAdd BIT
	,@Rate DECIMAL(18, 2)
	,@Description NVARCHAR(200)
	,@SequenceOrder INT
	--,@IsAlwaysActive BIT
	)
AS
IF (@billtermId = 0)
BEGIN
	DECLARE @VAL INT

	SELECT @VAL = MAX(RO_BillTerm.BilingID)
	FROM RO_BillTerm

	INSERT INTO RO_BillTerm (
		NAME
		,IsAdd
		,Rate
		,Description
		,SequenceOrder
		--,IsAlwaysActive
		)
	VALUES (
		@Name
		,@IsAdd
		,@Rate
		,@Description
		,(@SequenceOrder)
		--,@IsAlwaysActive
		)

	--SELECT * FROM dbo.RO_BillTerm 
	DECLARE @maxsequence INT

	SELECT @maxsequence = MAX(SequenceOrder)
	FROM dbo.RO_BillTerm

	IF @SequenceOrder = @maxsequence
	BEGIN
		UPDATE dbo.RO_BillTerm
		SET SequenceOrder = (@maxsequence + 1)
		WHERE NAME = 'VAT'
	END

	SELECT cast(@@IDENTITY AS INT)
END
ELSE
BEGIN
	UPDATE dbo.RO_BillTerm
	SET NAME = @Name
		,IsAdd = @IsAdd
		,Rate = @Rate
		,Description = @Description
		,SequenceOrder = @SequenceOrder
		--,IsAlwaysActive = @IsAlwaysActive
	WHERE BilingID = @billtermId

	DECLARE @maxsequences INT

	SELECT @maxsequences = MAX(SequenceOrder)
	FROM dbo.RO_BillTerm

	IF @SequenceOrder = @maxsequences
	BEGIN
		UPDATE dbo.RO_BillTerm
		SET SequenceOrder = (@maxsequences + 1)
		WHERE NAME = 'VAT'
	END

	SELECT cast(@billtermId AS INT)
END




GO
