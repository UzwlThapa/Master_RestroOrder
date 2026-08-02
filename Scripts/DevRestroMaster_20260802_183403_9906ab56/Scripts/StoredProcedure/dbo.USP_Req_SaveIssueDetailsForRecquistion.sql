SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Req_SaveIssueDetailsForRecquistion] @RecqId INT
	,@IssueNo INT
	,@RecqDetailId INT
	,@IssueQuantity DECIMAL(18, 2)
	,@IssuedBy NVARCHAR(256)
AS
BEGIN
	DECLARE @Conversion INT
		,@ItemId INT
		,@Unit INT
		,@ISNos NVARCHAR(50)
		,@IssuedToSTId INT
		,@IssuedFrSTId INT
		,@itemSmallUnitId int

	SELECT @ItemId = ItemId
		,@Unit = Unit
	FROM Req_RecquistionDetails
	WHERE RecqId = @RecqId
		AND RecqDetailId = @RecqDetailId


		select @itemSmallUnitId = SmallUnit from ROI_ItemDetails where ITId =@ItemId

	SELECT @Conversion = isnull(Conversion, 1)
	FROM ROI_Unit2
	WHERE FirstUnit = @Unit
	and SecondUnit=@itemSmallUnitId
	and IsArchived=0

	SELECT @IssuedFrSTId = ParentStore
		,@IssuedToSTId = StoreId
	FROM Req_Recquistion
	WHERE RecqId = @RecqId

	DECLARE @ItemCount INT = 0

	BEGIN
		SELECT @ItemCount = count(1)
		FROM ROI_ITEMBal
		WHERE ITId = @ItemId
			AND STId = @IssuedFrSTId

		SET @ItemCount = isnull(@ItemCount, 0)

		IF @ItemCount >= 1
		BEGIN
			UPDATE ROI_ITEMBal
			SET CLBal = isnull(CLBal, 0) - (@IssueQuantity * isnull(@Conversion,1))
			WHERE ITId = @ItemId
				AND STId = @IssuedFrSTId
		END
		ELSE
		BEGIN
			INSERT INTO ROI_ITEMBal (
				ITId
				,PDId
				,STId
				,CLBal
				,OPBal
				)
			VALUES (
				@ItemId
				,'0'
				,@IssuedFrSTId
				,- (@IssueQuantity * isnull(@Conversion,1))
				,0
				)
		END
	END

	BEGIN
		SET @ItemCount = 0

		SELECT @ItemCount = count(1)
		FROM ROI_ITEMBal
		WHERE ITId = @ItemId
			AND STId = @IssuedToSTId

		SET @ItemCount = isnull(@ItemCount, 0)

		IF @ItemCount >= 1
		BEGIN
			UPDATE ROI_ITEMBal
			SET CLBal = CLBal + (@IssueQuantity * isnull(@Conversion,1))
			WHERE ITId = @ItemId
				AND STId = @IssuedToSTId
		END
		ELSE
		BEGIN
			INSERT INTO ROI_ITEMBal (
				ITId
				,PDId
				,STId
				,CLBal
				,OPBal
				)
			VALUES (
				@ItemId
				,'0'
				,@IssuedToSTId
				,(@IssueQuantity * isnull(@Conversion,1))
				,0
				)
		END
	END

	
	INSERT INTO dbo.ROI_IssueDetails (
		IMId
		,ITID
		,UsedUnitId
		,Qnty
		,QntyInText
		,ReceivedBy
		,ReceivedOn
		)
	VALUES (
		@IssueNo
		,@ItemId
		,@Unit
		,@IssueQuantity
		,''
		,@IssuedBy
		,GETDATE()
		)

	INSERT INTO Req_IssueLog (
		RecqDetailId
		,IssueMainId
		,IssuedQuantity
		,IssuedOn
		,IssuedBy
		)
	VALUES (
		@RecqDetailId
		,@IssueNo
		,@IssueQuantity
		,GETDATE()
		,@IssuedBy
		)

	DECLARE @totalIssued INT

	SET @totalIssued = (
			SELECT sum(IssuedQuantity)
			FROM Req_IssueLog
			WHERE RecqDetailId = @RecqDetailId
			)

	UPDATE Req_RecquistionDetails
	SET StatusId = (
			CASE 
				WHEN @totalIssued >= Quantity
					THEN 4
				ELSE 2
				END
			)
	WHERE RecqDetailId = @RecqDetailId

	DECLARE @inpCount INT
		,@reqCount INT

	SET @reqCount = (
			SELECT count(*)
			FROM Req_RecquistionDetails
			WHERE StatusId = 8
				AND RecqId = @RecqId
			)
	SET @inpCount = (
			SELECT count(*)
			FROM Req_RecquistionDetails
			WHERE StatusId = 2
				AND RecqId = @RecqId
			)

	UPDATE Req_Recquistion
	SET StatusId = (
			CASE 
				WHEN @reqCount = 0
					AND @inpCount = 0
					THEN 4
				ELSE 2
				END
			)
	WHERE RecqId = @RecqId
END


GO
