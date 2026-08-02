SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETORDERDELIVEREDTIME]
as
BEGIN
	DECLARE @code VARCHAR(10)

	SET @code = (
			SELECT TOP (1) Code
			FROM RO_CompanyInfo
			)

	SELECT sm.OrderMasterId
		,sm.salesMasterId
		--,CAST(CONVERT(VARCHAR(16), sm.BillDate, 20) AS VARCHAR(120)) AS BillDate
		,sm.BillDate
		,@code + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo
		,sm.Waiter
		,CASE when om.OrderTypeID=4 Then 'Food Delivery' when om.OrderTypeID=3 Then 'Food Court' else  isnull(rt.restrotableTitle, 'Take Away') END restrotableTitle
		,CASE when om.OrderTypeID=4 Then 'Food Delivery' when om.OrderTypeID=3 Then 'Food Court' else  isnull(rr.restroRoom, 'Take Away') END restroRoom
		,sm.BasicAmount + sm.totaldiscount AS SubTotal
		,sm.totaldiscount
		,sm.BasicAmount AS BasicAmount
		,isnull(b1.Amount, 0) AS ServiceCharge
		,isnull(b2.Amount, 0) AS Vat
		,sm.NetAmount
		,(
			SELECT isnull(stuff((
							SELECT ' & ' + pms.PaymentMode
							FROM RO_SalesPaymentMode spm
							INNER JOIN RO_PaymentModes pms ON spm.PaymentModeID = pms.PaymentModeID
							WHERE spm.salesMasterId = sm.salesMasterId --and spm.PaymentModeID = 4
							FOR XML PATH('')
								,TYPE
							).value('.', 'NVARCHAR(MAX)'), 1, 3, ''), '')
			) AS PaymentModes
		,sm.IsUpdated AS [Status]
		,isnull(sum(CASE 
					WHEN spm.PaymentModeID = 1
						THEN spm.PayAmount
					END), 0) AS ReceivedAmount
		,(case when isnull(sm.IsUpdated,0) = 1 then  (isnull(sum(spm.PayAmount), 0) + isnull(sm.AdvancePayment, 0) - sm.netamount) 
		else 0 end) as SurplusDeficit
		--,isnull(sm.UpdatedOn,getdate()) as DeliveryTime
		,sm.UpdatedOn as DeliveryTime
		,sm.DeliveredBy
		,om.[date] as Date
	FROM dbo.RO_SalesMaster sm
	INNER JOIN RO_OrderMasters om ON sm.OrderMasterId = om.OrderMasterID
	INNER JOIN CBMS_BillPostLog bp on bp.SalesMasterId = sm.salesMasterId
	INNER JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID
	LEFT JOIN RO_SalesPaymentMode spm ON spm.salesMasterId = sm.salesMasterId
	LEFT JOIN RO_BillingAmount b1 ON B1.SalesMasterID = sm.salesMasterId
		AND b1.BilingID = 62
	LEFT JOIN RO_BillingAmount b2 ON B2.SalesMasterID = sm.salesMasterId
		AND b2.BilingID = 54
	LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = sm.TableId
	LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = rt.restroRoomId
	WHERE  (sm.IsArchived = 0) and om.OrderTypeID=4 and sm.IsUpdated=1 and cast(sm.UpdatedOn as date) = cast(getdate() as date)
	GROUP BY sm.OrderMasterId
		,sm.salesMasterId
		,sm.Waiter
		,rt.restrotableTitle
		,rr.restroRoom
		,fy.fyName
		,sm.InvoiceNo
		,fy.FirstSalesMasterID
		,sm.totaldiscount
		,sm.BasicAmount
		,sm.BillDate
		,b1.Amount
		,b2.Amount
		,sm.AdvancePayment
		,sm.NetAmount
		,sm.PrintCount
		,sm.IsUpdated
		,om.OrderTypeID
	    ,sm.UpdatedOn 
		,sm.DeliveredBy
		,om.[date]
	ORDER BY InvoiceNo DESC


	END

GO
