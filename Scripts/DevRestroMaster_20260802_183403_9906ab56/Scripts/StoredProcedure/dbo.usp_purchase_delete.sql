SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_purchase_delete] @PurchaseMainID INT
	,@PurchaseDetailsID INT
AS

--DECLARE @memID INT
--	,@remAmnt DECIMAL(10, 2)
--	,@mempayId INT

--SET @memID = (
--		SELECT Vid
--		FROM ROI_PurchaseMain
--		WHERE PurchaseMainID = @PurchaseMainID
--		)

--IF (isnull(@memID, 0) > 0)
--BEGIN
--	SELECT @remAmnt = RemainingAmount
--		,@mempayId = MemberPayID
--	FROM RO_MemberPay
--	WHERE MemberID = @memID
--		AND PurchaseMainId = @PurchaseMainID

--	UPDATE RO_LoyaltyMembership
--	SET RemainingBalance = RemainingBalance - (RemainingBalance - isnull(@remAmnt, 0))
--	WHERE MembershipID = @memID

--	DELETE
--	FROM RO_MemberPay
--	WHERE MemberPayID = ISNULL(@mempayId, 0)
--END
DELETE
FROM ROI_PurchaseMain
WHERE PurchaseMainID = @PurchaseMainID

DELETE
FROM ROI_PurchaseDetails
WHERE PurchaseMainID = @PurchaseMainID

DELETE
FROM ROI_PurchaseLotNo
WHERE PurchaseDetailsID = @PurchaseDetailsID

GO
