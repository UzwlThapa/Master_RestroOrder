SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_RO_ArchivePaymentMethod]
    @salesMasterId INT,
	@NewCustomerName NVARCHAR(50)

AS
BEGIN

	-- Updating Previous Payment Method
	BEGIN

		ALTER TABLE RO_SalesPaymentMode DISABLE TRIGGER RO_SalesPaymentMode_Delete

		update RO_SalesPaymentMode set PaymentModeID=-1,Remarks=('SalesReturnAmt:' + CAST(PayAmount AS VARCHAR) + 'New Customer Name:' + @NewCustomerName + 'Date: ' + CAST(GETDATE() AS varchar)),PayAmount=0,CusID=-1,Customer='' WHERE salesMasterId = @salesMasterId;

		ALTER TABLE RO_SalesPaymentMode ENABLE TRIGGER RO_SalesPaymentMode_Delete

	END

END;

GO
