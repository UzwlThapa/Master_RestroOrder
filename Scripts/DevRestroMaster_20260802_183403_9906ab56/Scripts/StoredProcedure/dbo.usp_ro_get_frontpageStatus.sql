SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_get_frontpageStatus]
AS
DECLARE @totalSales DECIMAL(18, 2),
        @totalTables INT,
        @occupiedTables INT;

SELECT @totalSales = SUM(NetAmount - totaldiscount)
FROM RO_SalesMaster sm
WHERE IsArchived = 0
      AND IsUpdated = 1
      AND CAST(DATEADD(HOUR, -4, BillDate) AS DATE) = CAST(GETDATE() AS DATE);


SELECT @totalTables = COUNT(*)
FROM RO_restroTable
WHERE IsTable = 1;

SELECT @occupiedTables = COUNT(*)
FROM RO_restroTable
WHERE IsTable = 1
      AND restrotablesStatusID <> 6;

SELECT ISNULL(@totalSales, 0.00) TotalSales,
       ISNULL(@totalTables, 0) TotalTables,
       ISNULL(@occupiedTables, 0) OccupiedTables;

GO
