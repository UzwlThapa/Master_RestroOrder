SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetViewBill] 
 @BillNo nvarchar(128)
AS
BEGIN
	SELECT ISNULL(SD.qty,0) Quantity
		,ISNULL(SD.rate,0) Rate
		,CASE 
			WHEN sd.CostCenterId = 1
				OR sd.CostCenterId = 95
				OR sd.CostCenterId = 97
				THEN SD.qty * SD.rate
			ELSE 0
			END AS Amount
		,CASE 
			WHEN sd.CostCenterId = 2
				THEN SD.qty * SD.rate
			ELSE 0
			END AS Bevrage
		,SM.OrderMasterId
		,'' Note
		,0 ExtraCharge
		,it.ITName
		,SM.BillDate DATE
		,SM.BasicAmount
		,rt.restrotableTitle
		,sm.totaldiscount
		,
		--(select max(PrintedNumber) from PrintDetail where PrintBillNo=sm.salesMasterId) as PrintCount,
		isnull(sm.PrintCount, 0) AS PrintCount
		,(sm.InvoiceNo - fy.FirstSalesMasterID) AS BillNo
		,(fy.fyName) AS fiscalYear
		,SM.CusID
		,SM.CusName
		,SM.PAN
		,SM.Address
		,SM.salesMasterId
		,SM.AddedBy AS Cashier
		,isnull(SM.RoomRate, 0) AS RoomRate
		,isnull(SM.RoomCharge, 0) AS RoomCharge
		,isnull(SM.BookedDays, 0) AS BookedDays
		,isnull(SM.AdvancePayment, 0) AS AdvancePayment
		,rt.IsTable
	FROM RO_SalesMaster SM
	LEFT JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
	LEFT JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID
	LEFT JOIN RO_restroTable rt ON rt.restrotableId = sm.TableId
	LEFT JOIN ROI_ITEMMain it ON it.ITId = sd.ItemId
	WHERE SM.billNo = BillNo
		AND (SD.IsCombo = 0 OR SD.IsCombo IS NULL)
	
	UNION
	
	SELECT ISNULL(SD.qty,0) Quantity
		,ISNULL(SD.rate,0) Rate
		,CASE 
			WHEN sd.CostCenterId = 1
				OR sd.CostCenterId = 95
				OR sd.CostCenterId = 97
				THEN SD.qty * SD.rate
			ELSE 0
			END AS Amount
		,CASE 
			WHEN sd.CostCenterId = 2
				THEN SD.qty * SD.rate
			ELSE 0
			END AS Bevrage
		,SM.OrderMasterId
		,'' Note
		,0 ExtraCharge
		,it.NAME ITName
		,SM.BillDate DATE
		,SM.BasicAmount
		,rt.restrotableTitle
		,sm.totaldiscount
		,isnull(sm.PrintCount, 0) AS PrintCount
		,(sm.InvoiceNo - fy.FirstSalesMasterID) AS BillNo
		,(fy.fyName) AS fiscalYear
		,SM.CusID
		,SM.CusName
		,SM.PAN
		,SM.Address
		,SM.salesMasterId
		,SM.AddedBy AS Cashier
		,isnull(SM.RoomRate, 0) AS RoomRate
		,isnull(SM.RoomCharge, 0) AS RoomCharge
		,isnull(SM.BookedDays, 0) AS BookedDays
		,isnull(SM.AdvancePayment, 0) AS AdvancePayment
		,rt.IsTable
	FROM RO_SalesMaster SM
	LEFT JOIN RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
	LEFT JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID
	LEFT JOIN RO_restroTable rt ON rt.restrotableId = sm.TableId
	LEFT JOIN RO_Combo it ON it.ComboID = sd.ItemId
	WHERE SM.billNo = BillNo
		AND (SD.IsCombo = 1 OR SD.IsCombo IS NULL)
END;
	--select * from CostCenterInfo



GO
