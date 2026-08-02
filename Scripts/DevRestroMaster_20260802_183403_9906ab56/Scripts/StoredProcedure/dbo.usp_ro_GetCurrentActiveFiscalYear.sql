SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_GetCurrentActiveFiscalYear]
AS
SELECT *,(SELECT MAX(BillNo) FROM dbo.RO_OrderMasters) AS LatestBillNo FROM dbo.RO_fiscalYear WHERE isActive = 1 AND IsDeleted != 1

--SELECT MAX(BillNo)  FROM dbo.RO_OrderMasters
--SELECT *  FROM dbo.RO_OrderMasters




GO
