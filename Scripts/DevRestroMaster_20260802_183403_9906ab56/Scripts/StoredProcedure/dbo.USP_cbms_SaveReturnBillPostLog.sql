SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_cbms_SaveReturnBillPostLog] @seller_pan NVARCHAR(256)
	,@buyer_pan NVARCHAR(256)
	,@fiscal_year NVARCHAR(256)
	,@buyer_name NVARCHAR(256)
	,@ref_invoice_number NVARCHAR(256)
	,@credit_note_date NVARCHAR(256)
	,@reason_for_return NVARCHAR(256)
	,@total_sales DECIMAL(18, 2)
	,@taxable_sales_vat DECIMAL(18, 2)
	,@vat DECIMAL(18, 2)
	,@excisable_amount DECIMAL(18, 2)
	,@excise DECIMAL(18, 2)
	,@taxable_sales_hst DECIMAL(18, 2)
	,@hst DECIMAL(18, 2)
	,@amount_for_esf DECIMAL(18, 2)
	,@esf DECIMAL(18, 2)
	,@export_sales DECIMAL(18, 2)
	,@tax_exempted_sales DECIMAL(18, 2)
	,@isrealtime BIT
	,@datetimeClient DATETIME
	,@statusCode NVARCHAR(256)
	,@status NVARCHAR(256)
	,@postedDate DATETIME
	,@salesMasterID INT
AS
BEGIN
	DECLARE @max_credit_note_number NVARCHAR(256)
	DECLARE @credit_note_number NVARCHAR(256)

	SET @max_credit_note_number = (
			SELECT isnull(max(cast(SUBSTRING(credit_note_number, CHARINDEX('-', credit_note_number) + 1, LEN(credit_note_number)) as int)) + 1, 1)
			FROM CBMS_BillReturnPostLog
			WHERE fiscal_year = @fiscal_year
			);
	set @credit_note_number = 'CN'+@fiscal_year+'-'+@max_credit_note_number
	INSERT INTO CBMS_BillReturnPostLog (
		seller_pan
		,buyer_pan
		,fiscal_year
		,buyer_name
		,ref_invoice_number
		,credit_note_number
		,credit_note_date
		,reason_for_return
		,total_sales
		,taxable_sales_vat
		,vat
		,excisable_amount
		,excise
		,taxable_sales_hst
		,hst
		,amount_for_esf
		,esf
		,export_sales
		,tax_exempted_sales
		,isrealtime
		,datetimeClient
		,BillReturnDateTime
		,StatusCode
		,StatusDetails
		,SalesMasterId
		)
	VALUES (
		@seller_pan
		,@buyer_pan
		,@fiscal_year
		,@buyer_name
		,@ref_invoice_number
		,@credit_note_number
		,@credit_note_date
		,@reason_for_return
		,@total_sales
		,@taxable_sales_vat
		,@vat
		,@excisable_amount
		,@excise
		,@taxable_sales_hst
		,@hst
		,@amount_for_esf
		,@esf
		,@export_sales
		,@tax_exempted_sales
		,@isrealtime
		,@datetimeClient
		,@postedDate
		,@statusCode
		,@status
		,@salesMasterID
		)

	SELECT cast(@@IDENTITY AS INT) AS ReturnLogID
		,@credit_note_number AS credit_note_number
END


GO
