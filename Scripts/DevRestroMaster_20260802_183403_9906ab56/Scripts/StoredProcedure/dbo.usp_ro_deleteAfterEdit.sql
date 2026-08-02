SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_ro_deleteAfterEdit '78','40'
CREATE PROCEDURE [dbo].[usp_ro_deleteAfterEdit] @PurchaseDetailsID INT
	,@PurchaseMainID INT
AS
DECLARE @value INT

SELECT @value = count(PurchaseMainID)
FROM ROI_PurchaseDetails
WHERE PurchaseMainID = @PurchaseMainID

IF (@value > 0)
BEGIN
	DELETE
	FROM ROI_PurchaseDetails
	WHERE PurchaseDetailsID = @PurchaseDetailsID

	DELETE
	FROM ROI_PurchaseLotNo
	WHERE PurchaseDetailsID = @PurchaseDetailsID
END
ELSE IF (@value < 1)
BEGIN
	DELETE
	FROM ROI_PurchaseMain
	WHERE PurchaseMainID = @PurchaseMainID

	DELETE
	FROM ROI_PurchaseDetails
	WHERE PurchaseDetailsID = @PurchaseDetailsID

	DELETE
	FROM ROI_PurchaseLotNo
	WHERE PurchaseDetailsID = @PurchaseDetailsID
END

SELECT *
FROM ROI_PurchaseMain

SELECT *
FROM ROI_PurchaseDetails

SELECT *
FROM ROI_PurchaseLotNo




GO
