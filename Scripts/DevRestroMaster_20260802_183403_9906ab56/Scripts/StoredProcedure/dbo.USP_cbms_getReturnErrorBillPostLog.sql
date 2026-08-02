SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_cbms_getReturnErrorBillPostLog]
AS
BEGIN
	SELECT rbp.ReturnLogID
		,rbp.seller_pan
		,rbp.buyer_pan
		,rbp.fiscal_year
		,rbp.buyer_name
		,rbp.ref_invoice_number
		,rbp.credit_note_number
		,rbp.credit_note_date
		,rbp.reason_for_return
		,rbp.total_sales
		,rbp.taxable_sales_vat
		,rbp.vat
		,rbp.excisable_amount
		,rbp.excise
		,rbp.taxable_sales_hst
		,rbp.hst
		,rbp.amount_for_esf
		,rbp.esf
		,rbp.export_sales
		,rbp.tax_exempted_sales
		,rbp.SalesMasterId
	FROM CBMS_BillReturnPostLog rbp
	WHERE rbp.StatusCode != '200'
END


GO
