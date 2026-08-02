SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_cbms_SaveBillPostLog] @seller_pan NVARCHAR(256)
	,@buyer_pan NVARCHAR(256)
	,@fiscal_year NVARCHAR(256)
	,@buyer_name NVARCHAR(256)
	,@invoice_number NVARCHAR(256)
	,@invoice_date NVARCHAR(256)
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
	,@EnglishInvDate NVARCHAR(256)
AS
BEGIN
	INSERT INTO CBMS_BillPostLog (
		seller_pan
		,buyer_pan
		,fiscal_year
		,buyer_name
		,invoice_number
		,invoice_date
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
		,BillPostDateTime
		,StatusCode
		,StatusDetails
		,SalesMasterId
		,EnglishInvDate
		)
	VALUES (
		@seller_pan
		,@buyer_pan
		,@fiscal_year
		,@buyer_name
		,@invoice_number
		,@invoice_date
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
		,@EnglishInvDate
		)

	SELECT @@IDENTITY
END


GO
