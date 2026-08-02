SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ROI_PURCHASEAUTONUMBER]
AS
BEGIN
	DECLARE @prefix VARCHAR(128)='PO_'
	DECLARE @code VARCHAR(max)
	declare @val varchar(MAX)
	IF((SELECT COUNT(*) FROM dbo.ROI_PurchaseMain)>0)
	BEGIN
		 SELECT @val = CAST(MAX(CAST
		 (SUBSTRING(PuNo,LEN(1)+3,LEN(PuNo)- LEN(@Prefix)) AS INT))+1 
		 AS varchar(100)) 
		 FROM dbo.ROI_PurchaseMain
		SET @code=@prefix+@val
		SELECT @code AS PuNo
	END	
	ELSE
	BEGIN
		SET @code= @prefix+CAST(1 AS VARCHAR)
		SELECT @code AS PuNo
	END

END 






GO
