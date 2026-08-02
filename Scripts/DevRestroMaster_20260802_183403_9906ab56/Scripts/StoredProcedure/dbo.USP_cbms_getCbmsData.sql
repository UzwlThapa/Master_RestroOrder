SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_cbms_getCbmsData]
AS
BEGIN
	DECLARE @totalSales INT
		,@SyncedSalesBill INT
		,@UnSyncedSalesBill INT
		,@SyncedReturnedSalesBill INT
		,@UnSyncedReturnedSalesBill INT

	SET @totalSales = (
			SELECT count(*)
			FROM RO_SalesMaster sm
			)

	--inner join CBMS_BillPostLog cb on cb.SalesMasterId = sm.salesMasterId
	SELECT @SyncedSalesBill = isnull(sum(CASE 
					WHEN bp.StatusCode = '200'
						THEN 1
					END), 0)
		,@UnSyncedSalesBill = isnull(sum(CASE 
					WHEN bp.StatusCode != '200'
						THEN 1
					END), 0)
	FROM CBMS_BillPostLog bp

	SELECT @SyncedReturnedSalesBill = isnull(sum(CASE 
					WHEN brp.StatusCode = '200'
						THEN 1
					END), 0)
		,@UnSyncedReturnedSalesBill = isnull(sum(CASE 
					WHEN brp.StatusCode != '200'
						THEN 1
					END), 0)
	FROM CBMS_BillReturnPostLog brp

	SELECT isnull(@totalSales, 0) AS TotalSales
		,@SyncedSalesBill AS SyncedSalesBill
		,@UnSyncedSalesBill AS UnSyncedSalesBill
		,@SyncedReturnedSalesBill AS SyncedReturnedSalesBill
		,@UnSyncedReturnedSalesBill AS UnSyncedReturnedSalesBill
END


GO
