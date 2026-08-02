SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----DROP PROC usp_RO_MonthlyClosingSalesStatement '2018-09-01','2019-09-28'
CREATE PROCEDURE [dbo].[usp_RO_MonthlyClosingSalesStatement]
    @startDate DATETIME,
    @endDate DATETIME
AS
BEGIN

    --declare @startDate datetime='2018-09-01 0:0', @endDate datetime='2018-09-28 23:59'
    DECLARE @code VARCHAR(10);

    SET @code =
    (
        SELECT TOP (1) Code FROM dbo.RO_CompanyInfo
    );

    IF OBJECT_ID('tempdb..#tempBillDetail') IS NOT NULL
        DROP TABLE #tempBillDetail;

    SELECT MAX(Code) Code,
           MIN(invoiceno) MinInvoiceNo,
           MAX(invoiceno) MaxInvoiceNo,
           [DATE]
    INTO #tempBillDetail
    FROM
    (
        SELECT @code + fy.fyName + '-' AS Code,
               CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS INT) AS invoiceno,
               bp.invoice_number,
               CAST(sm.BillDate AS DATE) AS [DATE]
        FROM dbo.RO_SalesMaster sm
            INNER JOIN dbo.RO_fiscalYear fy
                ON fy.fyId = sm.FiscalYearID
            INNER JOIN dbo.CBMS_BillPostLog bp
                ON bp.SalesMasterId = sm.salesMasterId
        WHERE (sm.BillDate
              BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
              )
              AND sm.IsArchived <> 1
              AND sm.IsUpdated = 1
              AND ISNULL(sm.BillCancelled, 0) = 0
    ) AS b
    GROUP BY b.[DATE];

    IF OBJECT_ID('tempdb..#temp') IS NOT NULL
        DROP TABLE #temp;

    SELECT sm.salesMasterId,
           CASE
               WHEN dis.isflatdis = 1 THEN
                   CAST(dis.kotdis AS DECIMAL(18, 2))
               ELSE
                   CAST(dis.kotdis AS DECIMAL(18, 2)) / 100 * sm.sumKot
           END KOTDiscount,
           CASE
               WHEN dis.isflatdis = 1 THEN
                   CAST(dis.bardis AS DECIMAL(18, 2))
               ELSE
                   CAST(dis.bardis AS DECIMAL(18, 2)) / 100 * sm.sumBev
           END BarDiscount,
           CASE
               WHEN dis.isflatdis = 1 THEN
                   CAST(dis.bakerydis AS DECIMAL(18, 2))
               ELSE
                   CAST(dis.bakerydis AS DECIMAL(18, 2)) / 100 * sm.sumBakery
           END BakeryDiscount,
           CASE
               WHEN dis.isflatdis = 1 THEN
                   CAST(dis.pizzadis AS DECIMAL(18, 2))
               ELSE
                   CAST(dis.pizzadis AS DECIMAL(18, 2)) / 100 * sm.sumPizza
           END PizzaDiscount,
           CASE
               WHEN dis.isflatdis = 1 THEN
                   CAST(dis.roomdis AS DECIMAL(18, 2))
               ELSE
                   CAST(dis.roomdis AS DECIMAL(18, 2)) / 100 * sm.RoomCharge
           END RoomDiscount
    INTO #temp
    FROM dbo.RO_SalesMaster sm
        LEFT JOIN dbo.ro_flatandPerDiscount dis
            ON dis.SalesMasterId = sm.salesMasterId
    WHERE (sm.BillDate
          BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
          )
          AND sm.IsArchived <> 1
          AND sm.IsUpdated = 1
          AND ISNULL(sm.BillCancelled, 0) = 0;


    SELECT CAST(sm.BillDate AS DATE) AS [DATE],
           bd.Code + CAST(bd.MinInvoiceNo AS VARCHAR) + ' - ' + bd.Code + CAST(bd.MaxInvoiceNo AS VARCHAR) AS [BillNo],
           SUM(sm.BasicAmount + sm.RoomCharge) AS [TotalAll],
           SUM(sm.sumBev) AS BEV,
           SUM(sm.sumKot) AS KOT,
           SUM(sm.sumBakery) AS Bakery,
           SUM(sm.sumPizza) AS Pizza,
           SUM(sm.RoomCharge) AS RoomCharge,
           SUM(sm.totaldiscount) AS [DISCOUNT],
           SUM(ISNULL(tp.KOTDiscount, 0)) AS KotDiscount,
           SUM(ISNULL(tp.BarDiscount, 0)) AS BarDiscount,
           SUM(ISNULL(tp.BakeryDiscount, 0)) AS BakeryDiscount,
           ISNULL(SUM(tp.PizzaDiscount), 0) AS PizzaDiscount,
           ISNULL(SUM(tp.RoomDiscount), 0) AS RoomDiscount,
           SUM(sm.sumBev + sm.sumKot + sm.RoomCharge + sm.sumBakery + sm.sumPizza) AS Total,
           SUM(ISNULL(b1.Amount, 0)) AS ServiceCharge,
           SUM(ISNULL(b2.Amount, 0)) AS TaxCharge,
           SUM(sm.NetAmount) AS NetAmount,
           SUM(sm.NetAmount) / SUM(1) AS [SalesPerBill]
    FROM dbo.RO_SalesMaster sm
        INNER JOIN #temp tp
            ON sm.salesMasterId = tp.salesMasterId
        INNER JOIN #tempBillDetail bd
            ON CAST(sm.BillDate AS DATE) = bd.DATE
        INNER JOIN dbo.CBMS_BillPostLog bp
            ON bp.SalesMasterId = sm.salesMasterId
        LEFT JOIN dbo.RO_BillingAmount b1
            ON b1.SalesMasterID = sm.salesMasterId
               AND b1.BilingID = 62
        LEFT JOIN dbo.RO_BillingAmount b2
            ON b2.SalesMasterID = sm.salesMasterId
               AND b2.BilingID = 54
        LEFT JOIN dbo.ro_flatandPerDiscount dis
            ON dis.SalesMasterId = sm.salesMasterId
    WHERE
        --cast(sm.BillDate as DATE) = CAST(@DATE as date) 
        (sm.BillDate
        BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
        )
        AND sm.IsArchived <> 1
        AND sm.IsUpdated = 1
        AND ISNULL(sm.BillCancelled, 0) = 0
    GROUP BY CAST(sm.BillDate AS DATE),
             bd.Code,
             bd.MinInvoiceNo,
             bd.MaxInvoiceNo
    --,SM.sumKot
    --,dis.kotdis
    --,dis.isflatdis
    --,sm.sumBev
    --,dis.bardis
    --,SM.sumPizza
    --,dis.pizzadis
    --,SM.RoomCharge
    --,dis.roomdis
    --,SM.sumBakery
    --,dis.bakerydis
    ORDER BY [DATE] ASC;
END;


GO
