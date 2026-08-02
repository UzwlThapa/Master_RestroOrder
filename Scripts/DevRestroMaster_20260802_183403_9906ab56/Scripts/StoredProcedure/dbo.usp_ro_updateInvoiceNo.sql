SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_updateInvoiceNo] @salesMasterId INT
AS
BEGIN
	DECLARE @prevBillsCount INT
		,@newInvNo INT

	SELECT @prevBillsCount = count(salesMasterId)
	FROM RO_SalesMaster
	WHERE InvoiceNo = (
			SELECT InvoiceNo
			FROM RO_SalesMaster
			WHERE salesMasterId = @salesMasterId
			)
		AND salesMasterId < @salesMasterId

	IF (@prevBillsCount > 0)
	BEGIN
		SELECT cast(1 as bit);

		UPDATE RO_SalesMaster
		SET InvoiceNo = isnull((
					SELECT MAX(InvoiceNo)
					FROM RO_SalesMaster
					), 0) + 1
		WHERE salesMasterId = @salesMasterId

	END
	ELSE
	BEGIN
		SELECT cast(0 as bit);
	END
END

GO
