SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_cbms_getErrorBillPostLog]
AS
BEGIN
	SELECT bp.LogID
		,bp.seller_pan
		,bp.buyer_pan
		,bp.fiscal_year
		,bp.buyer_name
		,bp.invoice_number
		,bp.invoice_date
		,bp.total_sales
		,bp.taxable_sales_vat
		,bp.vat
		,bp.excisable_amount
		,bp.excise
		,bp.taxable_sales_hst
		,bp.hst
		,bp.amount_for_esf
		,bp.esf
		,bp.export_sales
		,bp.tax_exempted_sales
		,bp.SalesMasterId
	FROM CBMS_BillPostLog bp
	WHERE bp.StatusCode != '200'
END

GO
