SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_SavePurchaseReturnMain]

@PRNo varchar(200),
@PostedBy varchar(200),
@PostedOn Datetime,
@vendorId int,
@NepaliInvoiceDate nvarchar(250) = null,
@FyId int = null
as
BEGIN
DECLARE @prefix VARCHAR(128)='PR_'
	declare @val varchar(MAX)
	IF((SELECT COUNT(*) FROM Ro_PurchaseReturnMain)>0)
	BEGIN
		 SELECT @val = CAST(MAX(CAST
		 (SUBSTRING(PRNo,4,LEN(PRNo)- LEN(@Prefix)) AS INT))+1
		 AS varchar(100)) 
		 FROM dbo.Ro_PurchaseReturnMain
		SET @PRNo=@prefix+@val

	END	
	ELSE
	BEGIN
		SET @PRNo= @prefix+CAST(1 AS VARCHAR)

	END

	DECLARE @fiscal_year nvarchar(250),
	@max_debit_note_number nvarchar(250)

	  select @FyId=fyId, @fiscal_year=fyName from RO_fiscalYear where IsDeleted=0 and GETDATE() between StartDate and EndDate

		SET @max_debit_note_number = (
			SELECT isnull(max(cast(SUBSTRING(PRNote, CHARINDEX('-', PRNote) + 1, LEN(PRNote)) as int)) + 1, 1)
			FROM RO_PurchaseReturnMain
			WHERE FyId = @FyId
			);
	set @max_debit_note_number = 'PR'+@fiscal_year+'-'+@max_debit_note_number

	select @NepaliInvoiceDate= [dbo].[ConvertDateToNepali] (getdate());

		INSERT into Ro_PurchaseReturnMain
		( PRNo, PostedBy, PostedOn, vendorId, NepaliInvoiceDate,FyId,PRNote)
		Values
		(@PRNo, @PostedBy, @PostedOn, @vendorId, @NepaliInvoiceDate,@FyId,@max_debit_note_number)
		SELECT cast(@@IDENTITY as int)
		END

GO
