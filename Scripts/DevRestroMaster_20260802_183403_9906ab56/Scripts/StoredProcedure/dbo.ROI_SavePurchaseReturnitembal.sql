SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ROI_SAVEPURCHASEitembal 168, 0, 112, 0, 30  

CREATE PROCEDURE [dbo].[ROI_SavePurchaseReturnitembal] 
	@ItemID INT
	,@STId INT
	,@OPBal INT
	,@CLBal decimal(18,2)
AS
BEGIN
	DECLARE @CheckITemID INT =0

	SELECT @CheckITemID = count(1)
	FROM dbo.ROI_ITEMBal where ITId = @ItemID  and STId = @STId
	if (@CheckITemID is null) set @CheckITemID=0
	IF (@CheckITemID>= 1)
	BEGIN
		DECLARE @TotalCBl bigint =0
		SELECT @TotalCBl = CLBal
		FROM dbo.ROI_ITEMBal where ITId = @ItemID  and STId = @STId
		set @TotalCBl = @TotalCBl - @CLBal
		UPDATE ROI_ITEMBal
		SET CLBal = @TotalCBl
		WHERE ITId = @ItemID and STId = @STId
	END
	ELSE
	BEGIN
		INSERT INTO dbo.ROI_ITEMBal (
			ITId
			,PDId
			,STId
			,OPBal
			,CLBal
			,PostedDate
			)
		VALUES (
			@ItemID
			,0
			,@STId
			,@OPBal
			,-@CLBal
			,GETDATE()
			)
	END
END
	--SELECT * FROM DBO.ROI_ITEMBal  



GO
