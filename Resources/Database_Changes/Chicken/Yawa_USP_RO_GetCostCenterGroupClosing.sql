
GO
/****** Object:  StoredProcedure [dbo].[USP_RO_GetCostCenterGroupClosing]    Script Date: 10/10/2023 10:40:03 AM ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 10/10/2023
====================================

EXEC dbo.USP_RO_GetCostCenterGroupClosing '2023-01-01','2023-01-27'

*/
ALTER PROCEDURE [dbo].USP_RO_GetCostCenterGroupClosing
    @startDate DATETIME ,
    @endDate DATETIME
AS
    BEGIN
        SELECT   ccg.GroupId ,
                 ccg.GroupName ,
                 CAST(SUM (sd.qty * sd.rate) AS DECIMAL (18, 2) ) AS [TotalAmt]
        FROM     dbo.RO_CostCenterGroup ccg
                 INNER JOIN dbo.CostCenterInfo cc ON ccg.GroupId = cc.GroupId
                 INNER JOIN dbo.RO_SalesDetail sd ON cc.CostCenterId = sd.CostCenterId
        WHERE    EXISTS ( SELECT 1
                          FROM   dbo.RO_SalesMaster sm
                          WHERE  ISNULL (sm.IsArchived, 0) = 0
                          AND    ISNULL (sm.BillCancelled, 0) = 0
                          AND    sd.salesMasterId = sm.salesMasterId
                          AND    ( sm.BillDate IS NOT NULL
                               AND CAST (sm.BillDate AS DATETIME) BETWEEN dateadd(hour,4, @startDate) AND dateadd(hour,4, @endDate)))
        GROUP BY ccg.GroupId ,
                 ccg.GroupName;
    END;
