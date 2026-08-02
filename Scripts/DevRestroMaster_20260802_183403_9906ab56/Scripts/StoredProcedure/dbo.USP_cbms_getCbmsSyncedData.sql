SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_cbms_getCbmsSyncedData] @days INT
AS
BEGIN
	SELECT cast(cast(bp.BillPostDateTime AS DATE) AS NVARCHAR) AS SyncedDate
		,count(*) AS NoOfBills
		,isnull(sum(bp.total_sales), 0) AS TotalSalesAmount
		,isnull(sum(bp.taxable_sales_vat), 0) AS TaxableSalesAmount
		,isnull(sum(bp.vat), 0) AS VatAmount
	FROM CBMS_BillPostLog bp
	WHERE bp.StatusCode = '200'
		AND (
			cast(bp.BillPostDateTime AS DATE) BETWEEN cast(DATEADD(day, - @days, getdate()) AS DATE)
				AND cast(GETDATE() AS DATE)
			)
	GROUP BY cast(bp.BillPostDateTime AS DATE)
END

GO
