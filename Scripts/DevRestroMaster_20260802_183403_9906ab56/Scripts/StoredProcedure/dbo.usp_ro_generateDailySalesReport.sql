SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC [dbo].[usp_ro_generateDailySalesReport] '2023-08-02',0
CREATE PROCEDURE [dbo].[usp_ro_generateDailySalesReport] @date DATE
	,@viewOnly BIT
AS
BEGIN
	IF (@viewOnly = 0)
	BEGIN
		DECLARE @code VARCHAR(10)

		SET @code = (SELECT TOP (1) ISNULL(Code,'')	FROM RO_CompanyInfo)

		DECLARE @PreviousClosedTS DATETIME,@CurrentClosedTS DATETIME

		SET @PreviousClosedTS = (SELECT max(ClosedTS)	FROM DailyFinancialReport		WHERE Period < @date)
		SET @CurrentClosedTS = (SELECT ClosedTS			FROM DailyFinancialReport		WHERE Period = @date)

		DELETE
		FROM DailySalesReport
		WHERE Period = cast(@date AS DATE)

		INSERT INTO DailySalesReport(Period,BillNo,BillTime,BasicAmount,TotalDiscount,ServiceCharge,
		VAT,NetAmount,TenderAmount,ReturnAmount,ReceivedAmount,PaymentMode
		,ChequeAmount,CardAmount,CreditAmount,Customer)
		SELECT * FROM (
SELECT  cast(@date AS DATE) AS Period
			,@code + fy.fyName + '-' + cast(sm.InvoiceNo AS NVARCHAR) AS BillNo
			,cast(sm.BillDate AS TIME(0)) AS BillTime
			,sm.BasicAmount 
			,sm.totaldiscount as TotalDiscount
			,isnull(ba2.Amount, 0) AS ServiceCharge
			,isnull(ba.Amount, 0) AS VAT
			,sm.NetAmount-sm.totaldiscount [NetAmount]
			,isnull(sm.TenderAmount, 0) AS TenderAmount
			,isnull(sm.ReturnAmount, 0) AS ReturnAmount
			,ISNULL(sum(CASE 
						WHEN spm.PaymentModeID = 1
							THEN spm.PayAmount
						END), 0) AS ReceivedAmount
			,(
				SELECT isnull(stuff((
								SELECT ' & ' + pms.PaymentMode
								FROM RO_SalesPaymentMode spm
								INNER JOIN RO_PaymentModes pms ON spm.PaymentModeID = pms.PaymentModeID
								WHERE spm.salesMasterId = sm.salesMasterId --and spm.PaymentModeID = 4
								FOR XML PATH('')
									,TYPE
								).value('.', 'NVARCHAR(MAX)'), 1, 3, ''), 'Unpaid')
				) AS PaymentMode
			,ISNULL(sum(CASE 
						WHEN spm.PaymentModeID = 2
							THEN spm.PayAmount
						END), 0) AS ChequeAmount
			,ISNULL(sum(CASE 
						WHEN spm.PaymentModeID = 3
							THEN spm.PayAmount
						END), 0) AS CardAmount
			,ISNULL(sum(CASE 
						WHEN spm.PaymentModeID = 4
							THEN spm.PayAmount
						END), 0) AS CreditAmount
			,sm.CusName AS Customer
		FROM RO_SalesMaster sm
		inner join CBMS_BillPostLog cb on cb.SalesMasterId = sm.salesMasterId
		LEFT JOIN RO_SalesPaymentMode spm ON spm.SalesMasterID = sm.salesMasterId
		INNER JOIN RO_fiscalYear fy ON sm.FiscalYearID = fy.fyId
		LEFT JOIN RO_BillingAmount ba ON ba.SalesMasterID = sm.salesMasterId
			AND ba.BilingID = 54
		LEFT JOIN RO_BillingAmount ba2 ON ba2.SalesMasterID = sm.salesMasterId
			AND ba2.BilingID = 62
		WHERE sm.IsArchived = 0
			AND sm.IsUpdated = 1
			AND (
				sm.BillDate BETWEEN @PreviousClosedTS
					AND @CurrentClosedTS

				OR @PreviousClosedTS is null
				)
		GROUP BY fy.fyName
			,sm.InvoiceNo
			,sm.BillDate
			,sm.BasicAmount
			,sm.totaldiscount
			,ba.Amount
			,ba2.Amount
			,sm.NetAmount
			,sm.TenderAmount
			,sm.ReturnAmount
			,sm.salesMasterId
			,sm.CusName

		union

		SELECT  cast(@date AS DATE) AS Period
			,@code + fy.fyName + '-' + cast(sm.InvoiceNo AS NVARCHAR) AS BillNo
			,cast(sm.BillDate AS TIME(0)) AS BillTime
			,sm.BasicAmount 
			,0 as TotalDiscount
			,isnull(ba2.Amount, 0) AS ServiceCharge
			,isnull(ba.Amount, 0) AS VAT
			,sm.NetAmount [NetAmount]
			,isnull(sm.TenderAmount, 0) AS TenderAmount
			,isnull(sm.ReturnAmount, 0) AS ReturnAmount
			,ISNULL(sum(CASE 
						WHEN spm.PaymentModeID = 1
							THEN spm.PayAmount
						END), 0) AS ReceivedAmount
			,(
				SELECT isnull(stuff((
								SELECT ' & ' + pms.PaymentMode
								FROM RO_CAKE_SalesPaymentMode spm
								INNER JOIN RO_PaymentModes pms ON spm.PaymentModeID = pms.PaymentModeID
								WHERE spm.salesMasterId = sm.salesMasterId --and spm.PaymentModeID = 4
								FOR XML PATH('')
									,TYPE
								).value('.', 'NVARCHAR(MAX)'), 1, 3, ''), 'Unpaid')
				) AS PaymentMode
			,ISNULL(sum(CASE 
						WHEN spm.PaymentModeID = 2
							THEN spm.PayAmount
						END), 0) AS ChequeAmount
			,ISNULL(sum(CASE 
						WHEN spm.PaymentModeID = 3
							THEN spm.PayAmount
						END), 0) AS CardAmount
			,ISNULL(sum(CASE 
						WHEN spm.PaymentModeID = 4
							THEN spm.PayAmount
						END), 0) AS CreditAmount
			,sm.CustomerName AS Customer
		FROM RO_CakeSalesMaster sm
		LEFT JOIN RO_CAKE_SalesPaymentMode spm ON spm.SalesMasterID = sm.salesMasterId
		INNER JOIN RO_fiscalYear fy ON sm.FiscalYearID = fy.fyId
		LEFT JOIN RO_CAKE_BillingAmount ba ON ba.SalesMasterID = sm.salesMasterId
			AND ba.BilingID = 54
		LEFT JOIN RO_CAKE_BillingAmount ba2 ON ba2.SalesMasterID = sm.salesMasterId
			AND ba2.BilingID = 62
		WHERE sm.IsArchived = 0
			AND sm.IsUpdated = 1
			AND (
				sm.BillDate BETWEEN @PreviousClosedTS
					AND @CurrentClosedTS

				OR @PreviousClosedTS is null
				)
		GROUP BY fy.fyName
			,sm.InvoiceNo
			,sm.BillDate
			,sm.BasicAmount
			,ba.Amount
			,ba2.Amount
			,sm.NetAmount
			,sm.TenderAmount
			,sm.ReturnAmount
			,sm.salesMasterId
			,sm.CustomerName
		
	) as t
	END

	SELECT CAST(BillNo AS VARCHAR) BillNo
		,CAST(BillTime AS VARCHAR) BillTime
		,BasicAmount
		,TotalDiscount
		,BasicAmount + TotalDiscount as SubTotal
		,ServiceCharge
		,VAT
		,NetAmount
		,TenderAmount
		,ReturnAmount
		,ReceivedAmount
		,ChequeAmount
		,CardAmount
		,CreditAmount
		,CAST(PaymentMode AS VARCHAR) PaymentMode
		,Customer
	FROM DailySalesReport
	WHERE Period = cast(@date AS DATE)

END



GO
