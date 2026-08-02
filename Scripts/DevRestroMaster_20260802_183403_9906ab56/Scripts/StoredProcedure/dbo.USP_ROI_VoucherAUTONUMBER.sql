SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[USP_ROI_VoucherAUTONUMBER]
AS
BEGIN
	DECLARE @prefix VARCHAR(128)='VO_'
	DECLARE @code VARCHAR(max)
	declare @val varchar(MAX)
	IF((SELECT COUNT(*) FROM dbo.Ac_TempTransaction)>0)
	BEGIN
		 SELECT @val = CAST(MAX(CAST
		 (SUBSTRING(VoucherNo,LEN(1)+3,LEN(VoucherNo)- LEN(@Prefix)) AS INT))+1 
		 AS varchar(100)) 
		 FROM dbo.Ac_TempTransaction
		SET @code=@prefix+@val
		SELECT @code AS VoucherNo
	END	
	ELSE
	BEGIN
		SET @code= @prefix+CAST(1 AS VARCHAR)
		SELECT @code AS VoucherNo
	END

END 



GO
