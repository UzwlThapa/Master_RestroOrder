SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_ROI_IssueAUTONUMBER]
AS
BEGIN
	DECLARE @prefix VARCHAR(128)='IS_'
	DECLARE @code VARCHAR(max)
	declare @val varchar(MAX)
	IF((SELECT COUNT(*) FROM dbo.ROI_IssueMain)>0)
	BEGIN
		 SELECT @val = CAST(MAX(CAST
		 (SUBSTRING(ISNo,4,LEN(ISNo)- LEN(@Prefix)) AS INT))+1
		 AS varchar(100)) 
		 FROM dbo.ROI_IssueMain
		SET @code=@prefix+@val
		SELECT @code AS ISNo
	END	
	ELSE
	BEGIN
		SET @code= @prefix+CAST(1 AS VARCHAR)
		SELECT @code AS ISNo
	END

END 

--SELECT * FROM dbo.RO_GoodsReceivedMain
--SELECT * FROM dbo.ROI_IssueMain




GO
