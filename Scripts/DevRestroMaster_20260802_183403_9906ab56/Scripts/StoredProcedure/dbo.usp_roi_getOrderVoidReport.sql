SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_roi_getOrderVoidReport]  
@startDate DATETIME,        
@endDate DATETIME
as
--declare @startDate datetime='2017-01-03 0:0' , @endDate datetime= '2017-03-31 23:59'
		SELECT cast(CONVERT(VARCHAR(16), rom.DATE, 20) AS VARCHAR(120)) AS BillDate
			,rom.NetAmount
			,rom.UserName AS Waiter
			,rt.restrotableTitle
			,rr.restroRoom
			--,rom.billNo
			--,'RO' + fy.fyName + '-' + cast((om.salesMasterId - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo
			,rom.TableId
			--,rom.salesMasterId
			,rom.OrderMasterId
			,rom.CancelReason
			,rom.CancelDate
			,rom.CancelBy
		--,RBA.BilingID
		--,rbt.Name
		--,RBA.Amount
		FROM dbo.RO_OrderMasters rom
		LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = rom.TableId
		LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = rom.RoomId
		--INNER JOIN RO_fiscalYear fy ON fy.fyId = om.FiscalYearID
		--LEFT JOIN RO_BillingAmount RBA ON RBA.SalesMasterID = rom.salesMasterId
		--LEFT JOIN dbo.RO_BillTerm rbt ON rbt.BilingID = RBA.BilingID
		WHERE 
		--Year(rom.DATE) = @year
		(rom.[date] BETWEEN @startDate AND @endDate)
			AND rom.IsCancelled = 1
		ORDER BY rom.[date] DESC

		




GO
