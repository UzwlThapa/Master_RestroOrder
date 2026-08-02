SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_ro_reportDaily] '12/5/2016'
CREATE PROCEDURE [dbo].[usp_ro_reportDaily]
@date DATETIME
AS
BEGIN
SELECT 
ISNULL(SUM(sm.sumKot),0) AS sumKot,
ISNULL(SUM(sm.sumBev),0) AS sumBev
,SUM(sm.sumKot+sm.sumBev) AS sumKotBev
 FROM dbo.RO_SalesMaster sm WHERE CAST(BillDate AS DATE)=CAST(@date AS DATE)
END	
--select * FROM dbo.RO_SalesMaster





GO
