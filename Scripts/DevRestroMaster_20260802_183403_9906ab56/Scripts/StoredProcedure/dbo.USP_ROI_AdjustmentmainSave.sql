SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_AdjustmentmainSave]
@AMNo nvarchar(50),
@STId int,
@Remarks varchar(max),
@FYId varchar(200),
@PostedOn datetime,
@PostedBy varchar(200)
as
begin
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
		END	
		ELSE
		BEGIN
			SET @code= @prefix+CAST(1 AS VARCHAR)
		
		END

	INSERT INTO ROI_AdjustmentMain (
	AMNo,
	STId,
	Remarks,
	FYId,
	PostedOn,
	PostedBy
	) 
	VALUES (
	
	@code,
	@STId,
	@Remarks,
	@FYId,
	@PostedOn,
	@PostedBy
	)
	SELECT @@IDENTITY
END





GO
