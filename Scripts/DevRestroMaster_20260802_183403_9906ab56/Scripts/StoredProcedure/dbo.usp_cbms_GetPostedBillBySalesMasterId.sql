SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_cbms_GetPostedBillBySalesMasterId] @salesMasterId INT
AS
SELECT LogID
	,seller_pan
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
FROM CBMS_BillPostLog
WHERE SalesMasterId = @salesMasterId


GO
