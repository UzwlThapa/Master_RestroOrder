SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ROI_Adjustment]
AS
BEGIN
	DECLARE @prefix VARCHAR(128)='AM_'
	DECLARE @code VARCHAR(max)
	declare @val varchar(MAX)
	IF((SELECT COUNT(*) FROM dbo.ROI_AdjustmentMain)>0)
	BEGIN
		 SELECT @val = CAST(MAX(CAST
		 (SUBSTRING(AMNo,LEN(1)+3,LEN(AMNo)- LEN(@Prefix)) AS INT))+1 
		 AS varchar(100)) 
		 FROM dbo.ROI_AdjustmentMain
		SET @code=@prefix+@val
		SELECT @code AS AMNo
	END	
	ELSE
	BEGIN
		SET @code= @prefix+CAST(1 AS VARCHAR)
		SELECT @code AS AMNo
	END

END 


--select * from ROI_AdjustmentMain




GO
