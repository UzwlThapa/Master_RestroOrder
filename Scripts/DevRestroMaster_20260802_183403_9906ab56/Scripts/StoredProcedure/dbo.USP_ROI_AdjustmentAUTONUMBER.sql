SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ROI_AdjustmentAUTONUMBER]
AS
BEGIN
	DECLARE @prefix VARCHAR(128)='AM_'
	DECLARE @code VARCHAR(max)
	declare @val varchar(MAX)
	IF((SELECT COUNT(*) FROM dbo.ROI_AdjustmentMain)>0)
	BEGIN
		 SELECT @val = CAST(MAX(CAST
		 (SUBSTRING(AMNo,4,LEN(AMNo)- LEN(@Prefix)) AS INT))+1
		 AS varchar(100)) 
		 FROM dbo.ROI_AdjustmentMain
		SET @code=@prefix+@val
		SELECT @code AS GMNo
	END	
	ELSE
	BEGIN
		SET @code= @prefix+CAST(1 AS VARCHAR)
		SELECT @code AS GMNo
	END

END 





GO
