SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC [dbo].[usp_RO_MonthlyClosingTotalSalesStatement] '2023-04-06 0:0','2023-04-06 23:59'
CREATE PROCEDURE [dbo].[usp_RO_MonthlyClosingTotalSalesStatement]
    @startDate DATETIME,
    @endDate DATETIME
AS
BEGIN
    --DECLARE @startDate DATETIME = '2018-09-27 0:0',@endDate DATETIME = '2019-11-29 23:59'
    DECLARE @kot DECIMAL(18, 2),
            @bar DECIMAL(18, 2),
            @bakery DECIMAL(18, 2),
            @pizza DECIMAL(18, 2),
            @roomCharge DECIMAL(18, 2),
            @netAmount DECIMAL(18, 2),
            @totalBills DECIMAL(18, 2),
            @servChrg DECIMAL(18, 2),
            @vat DECIMAL(18, 2),
            @disc DECIMAL(18, 2),
            @deliveryChrg DECIMAL(18, 2),
            @SurplusDeficient DECIMAL(18, 2) = 0,
            @Complementry DECIMAL(15, 2);

    SELECT @Complementry =
    (
        SELECT SUM(Amount) AS Complementry
        FROM dbo.RO_ComplementaryItems
        WHERE Date
        BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
    );

    SELECT @servChrg = SUM(   CASE
                                  WHEN ba.BilingID = 62 THEN
                                      ISNULL(ba.Amount, 0)
                              END
                          ),
           @vat = SUM(   CASE
                             WHEN ba.BilingID = 54 THEN
                                 ISNULL(ba.Amount, 0)
                         END
                     )
    FROM dbo.RO_BillingAmount ba
        INNER JOIN dbo.RO_SalesMaster sm
            ON ba.SalesMasterID = sm.salesMasterId
        INNER JOIN dbo.CBMS_BillPostLog bp
            ON bp.SalesMasterId = sm.salesMasterId
    WHERE (sm.BillDate
          BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
          )
          AND ISNULL(sm.IsArchived, 0) = 0
          AND ISNULL(sm.IsUpdated, 0) = 1
          AND ISNULL(sm.BillCancelled, 0) = 0;

    IF (OBJECT_ID('tempdb..#Temp1') IS NOT NULL)
        DROP TABLE #Temp1;

    SELECT sm.salesMasterId,
           (CASE
                WHEN ISNULL(sm.IsUpdated, 0) = 1
                     AND ISNULL(sm.AdvancePayment, 0) < sm.NetAmount THEN
           (ISNULL(SUM(spm.PayAmount), 0) + ISNULL(sm.AdvancePayment, 0) - sm.NetAmount
            - ISNULL(SUM(spm.ReturnPayment), 0)
           )
                WHEN ISNULL(sm.IsUpdated, 0) = 1
                     AND ISNULL(sm.AdvancePayment, 0) > sm.NetAmount THEN
                    0
                ELSE
                    0
            END
           ) AS SurplusDeficit
    INTO #Temp1
    FROM dbo.RO_SalesMaster sm
        INNER JOIN dbo.CBMS_BillPostLog bp
            ON bp.SalesMasterId = sm.salesMasterId
        LEFT JOIN dbo.RO_SalesPaymentMode spm
            ON spm.salesMasterId = sm.salesMasterId
    WHERE (sm.IsArchived = 0)
          AND (sm.BillDate
          BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
              )
    GROUP BY sm.salesMasterId,
             sm.AdvancePayment,
             sm.NetAmount,
             sm.IsUpdated;


    SELECT @SurplusDeficient = SUM(SurplusDeficit)
    FROM #Temp1;


    SELECT @kot = SUM(ISNULL(sm.sumKot, 0)),
           @bar = SUM(ISNULL(sm.sumBev, 0)),
           @bakery = SUM(ISNULL(sm.sumBakery, 0)),
           @pizza = SUM(ISNULL(sm.sumPizza, 0)),
           @roomCharge = SUM(ISNULL(sm.RoomCharge, 0)),
           @netAmount = SUM(ISNULL(sm.NetAmount, 0)),
           @disc = SUM(ISNULL(sm.totaldiscount, 0)),
           @totalBills = SUM(1),
           @deliveryChrg = SUM(ISNULL(sm.DeliveryCharge, 0))
    FROM dbo.RO_SalesMaster sm
        INNER JOIN dbo.CBMS_BillPostLog bp
            ON bp.SalesMasterId = sm.salesMasterId
    WHERE (sm.BillDate
          BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
          )
          AND ISNULL(sm.IsArchived, 0) = 0
          AND ISNULL(sm.IsUpdated, 0) = 1
          AND ISNULL(sm.BillCancelled, 0) = 0;

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
           END RoomDiscount,
           CASE
               WHEN dis.isLoyalty = 1 THEN
                   CAST(sm.totaldiscount AS DECIMAL(18, 2))
               ELSE
                   0
           END LoyalityDiscount
    INTO #temp
    FROM dbo.RO_SalesMaster sm
        LEFT JOIN dbo.ro_flatandPerDiscount dis
            ON dis.SalesMasterId = sm.salesMasterId
    WHERE (sm.BillDate
          BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
          )
          AND sm.IsArchived <> 1
          AND sm.IsUpdated = 1;

    --select * from  #temp 

    IF OBJECT_ID('tempdb..#salestemp') IS NOT NULL
        DROP TABLE #salestemp;

    SELECT CONVERT(VARCHAR(11), @startDate) + ' / ' + CONVERT(VARCHAR(10), DAY(@endDate)) AS [date],
           sm.salesMasterId,
           SUM(ISNULL(   (CASE
                              WHEN spm.PaymentModeID = 1 THEN
                                  spm.PayAmount
                          END
                         ),
                         0
                     )
              ) CashReceived,
           SUM(ISNULL(   (CASE
                              WHEN spm.PaymentModeID = 2 THEN
                                  spm.PayAmount
                          END
                         ),
                         0
                     )
              ) ChequeReceived,
           SUM(ISNULL(   (CASE
                              WHEN spm.PaymentModeID = 3 THEN
                                  spm.PayAmount
                          END
                         ),
                         0
                     )
              ) CardReceived,
           SUM(ISNULL(   (CASE
                              WHEN spm.PaymentModeID = 4 THEN
                                  spm.PayAmount
                          END
                         ),
                         0
                     )
              ) CreditReceived,
           SUM(ISNULL(   (CASE
                              WHEN spm.PaymentModeID = 5 THEN
                                  spm.PayAmount
                          END
                         ),
                         0
                     )
              ) eSewaReceived,
           SUM(ISNULL(   (CASE
                              WHEN spm.PaymentModeID = 6 THEN
                                  spm.PayAmount
                          END
                         ),
                         0
                     )
              ) FonePayReceived,
           SUM(ISNULL((spm.PayAmount), 0)) AS PayAmount
    INTO #salestemp
    FROM dbo.RO_SalesMaster sm
        INNER JOIN dbo.CBMS_BillPostLog bp
            ON bp.SalesMasterId = sm.salesMasterId
        JOIN dbo.RO_SalesPaymentMode spm
            ON sm.salesMasterId = spm.salesMasterId
    WHERE (sm.BillDate
          BETWEEN DATEADD(HOUR, 4, @startDate) AND DATEADD(HOUR, 4, @endDate)
          )
          AND ISNULL(sm.IsArchived, 0) = 0
          AND ISNULL(sm.IsUpdated, 0) = 1
          AND ISNULL(sm.BillCancelled, 0) = 0
    GROUP BY sm.salesMasterId;

    --select * from #salestemp

    SELECT CONVERT(VARCHAR(11), @startDate) + ' / ' + CONVERT(VARCHAR(10), DAY(@endDate)) AS [date],
           ISNULL(@totalBills, 0) AS [BillNo],
           ISNULL(@kot + @bar + @bakery + @pizza + @roomCharge - @disc, 0) AS [TotalAll],
           ISNULL(@bar, 0) AS BEV,
           ISNULL(@kot, 0) AS KOT,
           ISNULL(@bakery, 0) AS Bakery,
           ISNULL(@pizza, 0) AS Pizza,
           ISNULL(@roomCharge, 0) AS RoomCharge,
           ISNULL(SUM(tp.KOTDiscount), 0) AS KotDiscount,
           ISNULL(SUM(tp.BarDiscount), 0) AS BarDiscount,
           ISNULL(SUM(tp.BakeryDiscount), 0) AS BakeryDiscount,
           ISNULL(SUM(tp.PizzaDiscount), 0) AS PizzaDiscount,
           ISNULL(SUM(tp.RoomDiscount), 0) AS RoomDiscount,
           ISNULL(SUM(tp.LoyalityDiscount), 0) AS LoyalityDiscount,
           ISNULL(@disc, 0) AS [DISCOUNT],
           ISNULL(@kot + @bar + @bakery + @pizza + @roomCharge, 0) AS Total,
           ISNULL(@servChrg, 0) AS ServiceCharge,
           ISNULL(@vat, 0) AS TaxCharge,
           ISNULL(@deliveryChrg, 0) AS DeliveryCharge,
           ISNULL(@netAmount, 0) AS NetAmount,
           ISNULL(@netAmount / @totalBills, 0) AS [SalesPerBill],
           ISNULL(SUM(st.CashReceived), 0) AS CashReceived,
           ISNULL(SUM(st.ChequeReceived), 0) AS ChequeReceived,
           ISNULL(SUM(st.CardReceived), 0) AS CardReceived,
           ISNULL(SUM(st.CreditReceived), 0) AS CreditReceived,
           ISNULL(SUM(st.eSewaReceived), 0) AS eSewaReceived,
           ISNULL(SUM(st.FonePayReceived), 0) AS FonePayReceived,
           --,isnull(sum(st.PayAmount),0)-isnull(@netAmount, 0)  as SurplusDeficit
           ISNULL(@SurplusDeficient, 0) AS SurplusDeficit,
           ISNULL(@Complementry, 0) AS Complementry
    FROM #salestemp st
        LEFT JOIN #temp tp
            ON tp.salesMasterId = st.salesMasterId;
END;


GO
