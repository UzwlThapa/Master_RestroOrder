SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ROI_GoodsReceiveAUTONUMBER]
AS
BEGIN
	DECLARE @prefix VARCHAR(128)='GM_'
	DECLARE @code VARCHAR(max)
	declare @val varchar(MAX)
	IF((SELECT COUNT(*) FROM dbo.RO_GoodsReceivedMain)>0)
	BEGIN
		 SELECT @val = CAST(MAX(CAST
		 (SUBSTRING(GMNo,4,LEN(GMNo)- LEN(@Prefix)) AS INT))+1
		 AS varchar(100)) 
		 FROM dbo.RO_GoodsReceivedMain
		SET @code=@prefix+@val
		SELECT @code AS GMNo
	END	
	ELSE
	BEGIN
		SET @code= @prefix+CAST(1 AS VARCHAR)
		SELECT @code AS GMNo
	END

END 

--SELECT * FROM dbo.RO_GoodsReceivedMain




GO
