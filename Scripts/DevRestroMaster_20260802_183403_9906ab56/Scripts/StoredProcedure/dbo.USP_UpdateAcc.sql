SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--   USP_SALES_REPORT '2023-02-14 0:0' , '2023-05-11 23:59','',-1, 0, ''
CREATE PROCEDURE [dbo].[USP_UpdateAcc]
AS
BEGIN

	SELECT Salesmasterid, OrderMasterId INTo #Temp1 FROM RO_SalesMaster where billNo='1234'

	ALTER TABLE RO_SalesDetail DISABLE TRIGGER [RO_SalesDetail_Delete]
		DELETE FROM RO_SalesDetail where salesMasterId IN (SELECT Salesmasterid from #Temp1)
	ALTER TABLE RO_SalesDetail ENABLE TRIGGER [RO_SalesDetail_Delete]


		DELETE FROM RO_OrderMasters where OrderMasterID IN (SELECT OrderMasterId from #Temp1)

		DELETE FROM RO_Order_Detail where OrderMasterId IN (SELECT OrderMasterId from #Temp1)

		DELETE FROM RO_BillingAmount where salesMasterId IN (SELECT salesMasterId from #Temp1)

		ALTER TABLE RO_SalesMaster DISABLE TRIGGER [RO_SalesMaster_Delete]
		DELETE FROM RO_SalesMaster where salesMasterId IN (SELECT salesMasterId from #Temp1)
		ALTER TABLE RO_SalesMaster ENABLE TRIGGER [RO_SalesMaster_Delete]

		ALTER TABLE RO_SalesPaymentMode DISABLE TRIGGER [RO_SalesPaymentMode_Delete]
		DELETE FROM RO_SalesPaymentMode where salesMasterId IN (SELECT salesMasterId from #Temp1)
		ALTER TABLE RO_SalesPaymentMode ENABLE TRIGGER [RO_SalesPaymentMode_Delete]

		DROP TABLE #Temp1

		
END



GO
