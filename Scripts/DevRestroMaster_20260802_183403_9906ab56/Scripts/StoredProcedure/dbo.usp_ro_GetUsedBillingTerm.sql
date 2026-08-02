SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_ro_GetUsedBillingTerm 49
CREATE PROCEDURE [dbo].[usp_ro_GetUsedBillingTerm] @salesMasterId INT
AS
SELECT ubt.*,bt.*
FROM RO_BillingAmount ubt
JOIN RO_SalesMaster sm ON sm.salesMasterId = ubt.SalesMasterId
left join RO_BillTerm bt on bt.BilingID=ubt.BilingID
WHERE sm.salesMasterId = @salesMasterId





GO
