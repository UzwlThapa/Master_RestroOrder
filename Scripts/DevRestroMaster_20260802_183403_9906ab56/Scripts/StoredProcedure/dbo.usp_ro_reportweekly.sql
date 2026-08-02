SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_ro_reportweekly '2016-12-12'
CREATE PROCEDURE [dbo].[usp_ro_reportweekly]
 @date DATETIME
AS
BEGIN
SELECT CAST(sm.BillDate AS DATE) AS BillDate,
SUM(sm.sumKot) AS sumKot,
SUM(sm.sumBev) AS sumBev
,SUM(sm.sumKot+sm.sumBev) AS sumKotBev
 FROM dbo.RO_SalesMaster sm WHERE CAST(BillDate AS DATE) BETWEEN CONVERT(varchar(10),DateAdd(DD,-7, @date),102) AND CONVERT(varchar(10),@date,102)
GROUP BY CAST(sm.BillDate AS DATE)
END	






GO
