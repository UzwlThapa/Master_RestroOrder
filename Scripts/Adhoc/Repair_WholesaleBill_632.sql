SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[USP_cbms_getCbmsData]
AS
BEGIN
	DECLARE @totalSales INT,
			@SyncedSalesBill INT,
			@UnSyncedSalesBill INT,
			@SyncedReturnedSalesBill INT,
			@UnSyncedReturnedSalesBill INT;

	SELECT @totalSales = COUNT(*) FROM dbo.RO_SalesMaster;

	SELECT @SyncedSalesBill = ISNULL(SUM(CASE WHEN bp.StatusCode = '200' THEN 1 END), 0),
		   @UnSyncedSalesBill = ISNULL(SUM(CASE WHEN bp.StatusCode != '200' THEN 1 END), 0)
	FROM dbo.CBMS_BillPostLog bp;

	SELECT @SyncedReturnedSalesBill = ISNULL(SUM(CASE WHEN brp.StatusCode = '200' THEN 1 END), 0),
		   @UnSyncedReturnedSalesBill = ISNULL(SUM(CASE WHEN brp.StatusCode != '200' THEN 1 END), 0)
	FROM dbo.CBMS_BillReturnPostLog brp
	WHERE ISNULL(brp.SalesType, '') = '';

	SELECT ISNULL(@totalSales, 0) AS TotalSales,
		   @SyncedSalesBill AS SyncedSalesBill,
		   @UnSyncedSalesBill AS UnSyncedSalesBill,
		   @SyncedReturnedSalesBill AS SyncedReturnedSalesBill,
		   @UnSyncedReturnedSalesBill AS UnSyncedReturnedSalesBill;
END;
GO

ALTER PROCEDURE [dbo].[USP_cbms_getReturnErrorBillPostLog]
AS
BEGIN
	SELECT rbp.ReturnLogID,
		   rbp.seller_pan,
		   rbp.buyer_pan,
		   rbp.fiscal_year,
		   rbp.buyer_name,
		   rbp.ref_invoice_number,
		   rbp.credit_note_number,
		   rbp.credit_note_date,
		   rbp.reason_for_return,
		   rbp.total_sales,
		   rbp.taxable_sales_vat,
		   rbp.vat,
		   rbp.excisable_amount,
		   rbp.excise,
		   rbp.taxable_sales_hst,
		   rbp.hst,
		   rbp.amount_for_esf,
		   rbp.esf,
		   rbp.export_sales,
		   rbp.tax_exempted_sales,
		   rbp.SalesMasterId
	FROM dbo.CBMS_BillReturnPostLog rbp
	WHERE rbp.StatusCode != '200'
	  AND ISNULL(rbp.SalesType, '') = '';
END;
GO

SET XACT_ABORT ON;
BEGIN TRY
	BEGIN TRANSACTION;

	DECLARE @salesMasterId INT = 4016;
	DECLARE @salesType VARCHAR(30) = 'wholesale';
	DECLARE @detailAmount DECIMAL(18, 2);
	DECLARE @discount DECIMAL(18, 2);
	DECLARE @vat DECIMAL(18, 2);
	DECLARE @basicAmount DECIMAL(18, 2);
	DECLARE @netAmount DECIMAL(18, 2);
	DECLARE @isArchived BIT;

	SELECT @detailAmount = SUM(sd.Amount)
	FROM dbo.RO_CakeSalesDetail sd
	WHERE sd.SalesMasterId = @salesMasterId
	  AND LOWER(ISNULL(sd.SalesType, '')) = LOWER(@salesType);

	SELECT @discount = ISNULL(d.TotalDiscount, 0),
		   @basicAmount = d.BasicAmount
	FROM dbo.RO_Discount d
	WHERE d.SalesMasterId = @salesMasterId
	  AND LOWER(ISNULL(d.SalesType, '')) = LOWER(@salesType);

	SELECT @vat = ISNULL(ba.Amount, 0)
	FROM dbo.RO_CAKE_BillingAmount ba
	WHERE ba.SalesMasterID = @salesMasterId
	  AND ba.BilingID = 54
	  AND LOWER(ISNULL(ba.SalesType, '')) = LOWER(@salesType);

	SELECT @basicAmount = ISNULL(sm.BasicAmount, 0),
		   @netAmount = ISNULL(sm.NetAmount, 0),
		   @isArchived = ISNULL(sm.IsArchived, 0)
	FROM dbo.RO_CakeSalesMaster sm
	WHERE sm.SalesMasterId = @salesMasterId
	  AND LOWER(ISNULL(sm.SalesType, '')) = LOWER(@salesType);

	IF @detailAmount IS NULL OR @discount IS NULL OR @vat IS NULL OR @netAmount IS NULL
		THROW 50101, 'Bill 632 reconciliation data is incomplete; no repair was applied.', 1;

	IF @detailAmount <> 4420.35 OR @discount <> 0 OR @vat <> 574.65 OR @netAmount <> 4995.00
		THROW 50102, 'Bill 632 no longer matches the verified reconciliation values; review before applying.', 1;

	IF @isArchived = 0
	BEGIN
		IF @basicAmount = 4995.00
		BEGIN
			UPDATE dbo.RO_CakeSalesMaster
			SET BasicAmount = @detailAmount - @discount
			WHERE SalesMasterId = @salesMasterId
			  AND LOWER(ISNULL(SalesType, '')) = LOWER(@salesType)
			  AND IsArchived = 0;

			UPDATE dbo.RO_Discount
			SET BasicAmount = @detailAmount - @discount
			WHERE SalesMasterId = @salesMasterId
			  AND LOWER(ISNULL(SalesType, '')) = LOWER(@salesType)
			  AND BasicAmount = 4995.00;
		END
		ELSE IF @basicAmount <> @detailAmount - @discount
			THROW 50103, 'Bill 632 base amount is not the expected old or corrected value; review before applying.', 1;

		EXEC dbo.USP_RO_CAKE_CancelReason
			@salesMasterId = @salesMasterId,
			@SalesType = @salesType,
			@Reasons = N'Customer return; wholesale bill corrected and voided after failed sales-return workflow.',
			@userName = N'Authorized repair batch',
			@creditNoteDate = N'2083.06.23',
			@restoreOrder = 0;
	END
	ELSE IF NOT EXISTS
	(
		SELECT 1
		FROM dbo.CBMS_BillReturnPostLog
		WHERE SalesMasterId = @salesMasterId
		  AND LOWER(ISNULL(SalesType, '')) = LOWER(@salesType)
		  AND StatusCode = 'LOCAL'
	)
		THROW 50104, 'Bill 632 is archived without its local credit note; reconcile manually.', 1;

	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
	THROW;
END CATCH;
GO