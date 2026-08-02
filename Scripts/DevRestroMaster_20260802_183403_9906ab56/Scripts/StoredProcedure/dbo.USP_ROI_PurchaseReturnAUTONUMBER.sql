SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ROI_PurchaseReturnAUTONUMBER]
AS
BEGIN
	DECLARE @prefix VARCHAR(128)='PR_'
	DECLARE @code VARCHAR(max)
	declare @val varchar(MAX)
	IF((SELECT COUNT(*) FROM Ro_PurchaseReturnMain)>0)
	BEGIN
		 SELECT @val = CAST(MAX(CAST
		 (SUBSTRING(PRNo,4,LEN(PRNo)- LEN(@Prefix)) AS INT))+1
		 AS varchar(100)) 
		 FROM dbo.Ro_PurchaseReturnMain
		SET @code=@prefix+@val
		SELECT @code AS PRNo
	END	
	ELSE
	BEGIN
		SET @code= @prefix+CAST(1 AS VARCHAR)
		SELECT @code AS PRNo
	END

END 

--SELECT * FROM dbo.RO_GoodsReceivedMain




GO
