SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Saroj Kumar Chaudhary>  
-- Create date: <02-Mar-2021>  
-- Description: View to get service charge details 
-- EXECUTE: SELECT * FROM [dbo].[vw_CakeServiceCharge] ORDER BY SalesMasterID 
-- ============================================= 

CREATE VIEW [dbo].[vw_CakeServiceCharge]
AS
SELECT
BA.SalesMasterID, BT.Name AS 'TaxType', BT.Rate AS 'TaxPercent', BA.Amount, BA.SalesType
FROM 
	RO_CAKE_BillingAmount BA
INNER JOIN
	RO_BillTerm BT
ON 
	BT.BilingID = BA.BilingID 
WHERE
	BT.BilingID = 62


GO
