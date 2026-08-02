SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROC [dbo].[usp_ro_GetUnpaidBills]
CREATE PROCEDURE [dbo].[usp_ro_GetUnpaidBills]
AS
BEGIN
	DECLARE @code VARCHAR(10)

	SET @code = (
			SELECT TOP (1) Code
			FROM RO_CompanyInfo
			)

	SELECT sm.salesMasterId
		,(@code + fy.fyName + '-' + convert(VARCHAR(max), (sm.InvoiceNo - fy.FirstSalesMasterID))) AS BillNo
		,(sm.NetAmount - isnull(sm.AdvancePayment, 0)) AS BillAmount
		,sm.RoomId
		,sm.SPMID
		,rr.restroRoom AS RoomName
		,sm.TableId
		,rt.restrotableTitle AS TableName
		,sm.CusName AS Customer
		,sm.CusID AS CusID
		,isnull(om.OrderTypeID,0) as OrderTypeID
		,isnull(om.OrderNo,0) as OrderNo
		,sm.DeliveredBy
		,sm.BillDate
	FROM RO_SalesMaster sm
	Inner join RO_OrderMasters om ON sm.OrderMasterId = om.OrderMasterID
	INNER JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID
	LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = sm.RoomId
	LEFT JOIN RO_restroTable rt ON rt.restrotableId = sm.TableId
	WHERE IsUpdated = 0
		AND IsArchived = 0
		AND BillCancelled = 0
END



GO
