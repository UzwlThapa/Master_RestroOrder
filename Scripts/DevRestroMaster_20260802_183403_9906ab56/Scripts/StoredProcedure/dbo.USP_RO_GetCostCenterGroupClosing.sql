SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_GetCostCenterGroupClosing]
	 @startDate DATETIME,
    @endDate DATETIME
AS
BEGIN
	select ccg.GroupId, ccg.GroupName, SUM(sd.qty * sd.rate) [TotalAmt] from RO_CostCenterGroup ccg 
	INNER JOIN 
	CostCenterInfo cc on ccg.GroupId= cc.GroupId
	INNER JOIN RO_SalesDetail sd on CC.CostCenterId = sd.CostCenterId  
	WHERE sd.salesMasterId IN (select salesMasterId from RO_SalesMaster sm WHERE sm.IsArchived = 0 and sm.BillCancelled=0 and sm.BillDate BETWEEN @startDate AND @endDate)
	GROUP BY ccg.GroupId, ccg.GroupName
END

GO
