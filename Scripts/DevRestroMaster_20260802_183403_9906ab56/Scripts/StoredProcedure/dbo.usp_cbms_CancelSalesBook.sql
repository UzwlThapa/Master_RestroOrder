SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_cbms_CancelSalesBook] @salesMasterId INT

AS
BEGIN

	
	ALTER TABLE [dbo].[CBMS_BillPostLog] DISABLE TRIGGER [CBMS_BillPostLog_UPDATE]

	UPDATE CBMS_BillPostLog
	SET buyer_pan = ''
		,buyer_name = '(Cancellation)'
		,total_sales = 0
		,taxable_sales_vat = 0
		,vat = 0
	WHERE SalesMasterId = @salesMasterID

	ALTER TABLE [dbo].[CBMS_BillPostLog] ENABLE TRIGGER [CBMS_BillPostLog_UPDATE]
END


GO
