SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_GetSalesPayMode] @salesMasterId INT
AS
SELECT SPMID
	,billNo AS BillNo
	,IsUpdated AS BillPaid
	,salesMasterId
	,NetAmount AS BillAmount
	,CusName AS Customer
	,Address
	,PAN
FROM RO_SalesMaster
WHERE salesMasterId = @salesMasterId




GO
