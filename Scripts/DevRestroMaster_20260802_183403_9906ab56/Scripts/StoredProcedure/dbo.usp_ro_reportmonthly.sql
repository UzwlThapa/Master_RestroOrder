SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_ro_reportmonthly 2016,1
CREATE PROCEDURE [dbo].[usp_ro_reportmonthly] --2016,1
 @year VARCHAR(128),
 @month VARCHAR(128)
AS
BEGIN
SELECT CAST(sm.BillDate AS DATE) AS BillDate,
SUM(sm.sumKot) AS sumKot,
SUM(sm.sumBev) AS sumBev
,SUM(sm.sumKot+sm.sumBev) AS sumKotBev
 FROM dbo.RO_SalesMaster sm 
 where CAST(DATEPART(YEAR,sm.BillDate) AS VARCHAR(128))+' '+CAST(DATEPART(MONTH,BillDate)AS VARCHAR(128)) = @year+' '+@month
GROUP BY CAST(sm.BillDate AS DATE)
END	






GO
