SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[usp_ro_generateDailyFinancialReport]
    @date DATE,
    @viewOnly BIT,
    @UseCounterCashForVendor BIT = 0,         -- 1 = vendor cash reduces drawer
    @DayCloseFixedFloat DECIMAL(18, 2) = NULL -- if > 0, use as fixed opening balance
AS
BEGIN
    IF (
           CAST(@date AS DATE) = CAST(GETDATE() AS DATE)
           AND CAST(GETDATE() AS TIME) < CAST('10:00:00' AS TIME)
       )
    BEGIN
        SET @date = DATEADD(DAY, -1, @date);
    END;

    DELETE FROM DailyFinancialReport
    WHERE ISNULL(IsClosed, 0) = 0;

    DECLARE @IsClosed BIT;

    SET @IsClosed = ISNULL(
                    (
                        SELECT ISNULL(IsClosed, 0)
                        FROM DailyFinancialReport
                        WHERE Period = CAST(@date AS DATE)
                    ),
                    0
                          );

    IF (@viewOnly = 0 AND @IsClosed = 0)
    BEGIN

        DECLARE @creditPayCash DECIMAL(18, 2),
                @creditPayCard DECIMAL(18, 2),
                @creditPayFonePay DECIMAL(18, 2),
                @creditPayeSewa DECIMAL(18, 2),
                @creditPayCheque DECIMAL(18, 2),
                @vendorPayCash DECIMAL(18, 2) = 0, -- cash paid OUT to vendors
                @advancePayCash DECIMAL(18, 2),
                @advancePayFonePay DECIMAL(18, 2),
                @advancePayeSewa DECIMAL(18, 2),
                @advancePayCard DECIMAL(18, 2),
                @advancePayCheque DECIMAL(18, 2),
                @totalNetAmount DECIMAL(18, 2),
                @PreviousMaxPeriod DATE,
                @PreviousClosedTS DATETIME,
                @totalexpenses DECIMAL(18, 2) = 0,
                @creditsettlementamt DECIMAL(18, 2) = 0,
                @SurplusDeficient DECIMAL(18, 2) = 0,
                @ReturnAmtCash DECIMAL(18, 2),
                @ReturnAmtCard DECIMAL(18, 2),
                @ReturnAmtFonePay DECIMAL(18, 2),
                @ReturnAmteSewa DECIMAL(18, 2),
                @ReturnAmtCheque DECIMAL(18, 2);

        SELECT @PreviousMaxPeriod = MAX(Period),
               @PreviousClosedTS = MAX(ClosedTS)
        FROM DailyFinancialReport
        WHERE IsClosed = 1;

        IF (OBJECT_ID('tempdb..#Temp1') IS NOT NULL)
            DROP TABLE #Temp1;
        IF (OBJECT_ID('tempdb..#Temp2') IS NOT NULL)
            DROP TABLE #Temp2;
        IF (OBJECT_ID('tempdb..#Temp3') IS NOT NULL)
            DROP TABLE #Temp3;

        -- Surplus/deficit from RO sales
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
            INNER JOIN CBMS_BillPostLog bp
                ON bp.SalesMasterId = sm.salesMasterId
            LEFT JOIN RO_SalesPaymentMode spm
                ON spm.salesMasterId = sm.salesMasterId
        WHERE sm.IsArchived = 0
              AND sm.BillCancelled = 0
              AND
              (
                  sm.BillDate
              BETWEEN DATEADD(HOUR, 4, @PreviousClosedTS) AND DATEADD(HOUR, 4, GETDATE())
                  OR @PreviousClosedTS IS NULL
              )
        GROUP BY sm.salesMasterId,
                 sm.AdvancePayment,
                 sm.NetAmount,
                 sm.IsUpdated;

        -- Surplus/deficit from cake sales
        SELECT sm.SalesMasterId,
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
        INTO #Temp2
        FROM dbo.RO_CakeSalesMaster sm
            LEFT JOIN RO_CAKE_SalesPaymentMode spm
                ON spm.salesMasterId = sm.SalesMasterId
        WHERE sm.IsArchived = 0
              AND
              (
                  sm.BillDate
              BETWEEN DATEADD(HOUR, 4, @PreviousClosedTS) AND DATEADD(HOUR, 4, GETDATE())
                  OR @PreviousClosedTS IS NULL
              )
        GROUP BY sm.SalesMasterId,
                 sm.AdvancePayment,
                 sm.NetAmount,
                 sm.IsUpdated;

        SELECT @SurplusDeficient = SUM(SurplusDeficit)
        FROM #Temp1;
        SELECT @SurplusDeficient = @SurplusDeficient + SUM(SurplusDeficit)
        FROM #Temp2;

        SELECT @creditsettlementamt = SUM(ISNULL(mpm.SettlementAmount, 0))
        FROM RO_MemberPay mp
            LEFT JOIN RO_MemberPaymentMode mpm
                ON mpm.MemberPayId = mp.MemberPayID
        WHERE (
                  mp.AddedOn
              BETWEEN @PreviousClosedTS AND GETDATE()
                  OR @PreviousClosedTS IS NULL
              );

        -- =====================================================================
        -- CHANGED: @creditPayCash now only includes CUSTOMERS (IsCustomer = 1)
        -- Cash received INTO drawer from customers settling their credit
        -- =====================================================================
        SET @creditPayCash = ISNULL(
                             (
                                 SELECT SUM(ISNULL(mp.PayAmount, 0))
                                 FROM RO_MemberPay mp
                                     LEFT JOIN RO_MemberPaymentMode mpm
                                         ON mpm.MemberPayId = mp.MemberPayID
                                     LEFT JOIN RO_LoyaltyMembership lm
                                         ON lm.MembershipID = mp.MemberID
                                 WHERE (
                                           mp.AddedOn
                                       BETWEEN @PreviousClosedTS AND GETDATE()
                                           OR @PreviousClosedTS IS NULL
                                       )
                                       AND mpm.PaymentModeID = 1
                                       AND mp.PayAmount > 0
                                       AND lm.IsCustomer = 1
                             ),
                             0
                                   );

        -- =====================================================================
        -- NEW: @vendorPayCash = cash paid OUT of drawer to vendors
        -- Only populated when UseCounterCashForVendor = 1
        -- =====================================================================
        IF (@UseCounterCashForVendor = 1)
        BEGIN
            SET @vendorPayCash = ISNULL(
                                 (
                                     SELECT SUM(ISNULL(mp.PayAmount, 0))
                                     FROM RO_MemberPay mp
                                         LEFT JOIN RO_MemberPaymentMode mpm
                                             ON mpm.MemberPayId = mp.MemberPayID
                                         LEFT JOIN RO_LoyaltyMembership lm
                                             ON lm.MembershipID = mp.MemberID
                                     WHERE (
                                               mp.AddedOn
                                           BETWEEN @PreviousClosedTS AND GETDATE()
                                               OR @PreviousClosedTS IS NULL
                                           )
                                           AND mpm.PaymentModeID = 1
                                           AND mp.PayAmount > 0
                                           AND lm.IsCustomer = 0
                                 ),
                                 0
                                       );
        END;

        -- eSewa credit collections (customers only)
        SET @creditPayeSewa = ISNULL(
                              (
                                  SELECT SUM(ISNULL(mp.PayAmount, 0))
                                  FROM RO_MemberPay mp
                                      LEFT JOIN RO_MemberPaymentMode mpm
                                          ON mpm.MemberPayId = mp.MemberPayID
                                      LEFT JOIN RO_LoyaltyMembership lm
                                          ON lm.MembershipID = mp.MemberID
                                  WHERE (
                                            mp.AddedOn
                                        BETWEEN @PreviousClosedTS AND GETDATE()
                                            OR @PreviousClosedTS IS NULL
                                        )
                                        AND mpm.PaymentModeID = 5
                                        AND mp.PayAmount > 0
                                        AND lm.IsCustomer = 1
                              ),
                              0
                                    );

        -- FonePay credit collections (customers only)
        SET @creditPayFonePay = ISNULL(
                                (
                                    SELECT SUM(ISNULL(mp.PayAmount, 0))
                                    FROM RO_MemberPay mp
                                        LEFT JOIN RO_MemberPaymentMode mpm
                                            ON mpm.MemberPayId = mp.MemberPayID
                                        LEFT JOIN RO_LoyaltyMembership lm
                                            ON lm.MembershipID = mp.MemberID
                                    WHERE (
                                              mp.AddedOn
                                          BETWEEN @PreviousClosedTS AND GETDATE()
                                              OR @PreviousClosedTS IS NULL
                                          )
                                          AND mpm.PaymentModeID = 6
                                          AND mp.PayAmount > 0
                                          AND lm.IsCustomer = 1
                                ),
                                0
                                      );

        -- Card credit collections (customers only)
        SET @creditPayCard = ISNULL(
                             (
                                 SELECT SUM(mp.PayAmount)
                                 FROM RO_MemberPay mp
                                     LEFT JOIN RO_MemberPaymentMode mpm
                                         ON mpm.MemberPayId = mp.MemberPayID
                                     LEFT JOIN RO_LoyaltyMembership lm
                                         ON lm.MembershipID = mp.MemberID
                                 WHERE (
                                           mp.AddedOn
                                       BETWEEN @PreviousClosedTS AND GETDATE()
                                           OR @PreviousClosedTS IS NULL
                                       )
                                       AND mpm.PaymentModeID = 3
                                       AND mp.PayAmount > 0
                                       AND lm.IsCustomer = 1
                             ),
                             0
                                   );

        -- Cheque credit collections (customers only)
        SET @creditPayCheque = ISNULL(
                               (
                                   SELECT SUM(mp.PayAmount)
                                   FROM RO_MemberPay mp
                                       LEFT JOIN RO_MemberPaymentMode mpm
                                           ON mpm.MemberPayId = mp.MemberPayID
                                       LEFT JOIN RO_LoyaltyMembership lm
                                           ON lm.MembershipID = mp.MemberID
                                   WHERE (
                                             mp.AddedOn
                                         BETWEEN @PreviousClosedTS AND GETDATE()
                                             OR @PreviousClosedTS IS NULL
                                         )
                                         AND mpm.PaymentModeID = 2
                                         AND mp.PayAmount > 0
                                         AND lm.IsCustomer = 1
                               ),
                               0
                                     );

        -- Advance payments (room bookings) – same as before
        SET @advancePayCash = ISNULL(
                              (
                                  SELECT SUM(apm.PayAmount)
                                  FROM Ro_RoomBookings rb
                                      INNER JOIN RO_OrderMasters om
                                          ON rb.OrderMasterId = om.OrderMasterID
                                      LEFT JOIN RO_AdvancePaymentMode apm
                                          ON apm.RoomBookDetailsId = rb.RoomBookDetailsID
                                  WHERE (
                                            om.Date
                                        BETWEEN @PreviousClosedTS AND GETDATE()
                                            OR @PreviousClosedTS IS NULL
                                        )
                                        AND apm.PaymentModeID = 1
                              ),
                              0
                                    );

        SET @advancePayeSewa = ISNULL(
                               (
                                   SELECT SUM(apm.PayAmount)
                                   FROM Ro_RoomBookings rb
                                       INNER JOIN RO_OrderMasters om
                                           ON rb.OrderMasterId = om.OrderMasterID
                                       LEFT JOIN RO_AdvancePaymentMode apm
                                           ON apm.RoomBookDetailsId = rb.RoomBookDetailsID
                                   WHERE (
                                             om.Date
                                         BETWEEN @PreviousClosedTS AND GETDATE()
                                             OR @PreviousClosedTS IS NULL
                                         )
                                         AND apm.PaymentModeID = 5
                               ),
                               0
                                     );

        SET @advancePayFonePay = ISNULL(
                                 (
                                     SELECT SUM(apm.PayAmount)
                                     FROM Ro_RoomBookings rb
                                         INNER JOIN RO_OrderMasters om
                                             ON rb.OrderMasterId = om.OrderMasterID
                                         LEFT JOIN RO_AdvancePaymentMode apm
                                             ON apm.RoomBookDetailsId = rb.RoomBookDetailsID
                                     WHERE (
                                               om.Date
                                           BETWEEN @PreviousClosedTS AND GETDATE()
                                               OR @PreviousClosedTS IS NULL
                                           )
                                           AND apm.PaymentModeID = 6
                                 ),
                                 0
                                       );

        SET @advancePayCard = ISNULL(
                              (
                                  SELECT SUM(apm.PayAmount)
                                  FROM Ro_RoomBookings rb
                                      INNER JOIN RO_OrderMasters om
                                          ON rb.OrderMasterId = om.OrderMasterID
                                      LEFT JOIN RO_AdvancePaymentMode apm
                                          ON apm.RoomBookDetailsId = rb.RoomBookDetailsID
                                  WHERE (
                                            om.Date
                                        BETWEEN @PreviousClosedTS AND GETDATE()
                                            OR @PreviousClosedTS IS NULL
                                        )
                                        AND apm.PaymentModeID = 3
                              ),
                              0
                                    );

        SET @advancePayCheque = ISNULL(
                                (
                                    SELECT SUM(apm.PayAmount)
                                    FROM Ro_RoomBookings rb
                                        INNER JOIN RO_OrderMasters om
                                            ON rb.OrderMasterId = om.OrderMasterID
                                        LEFT JOIN RO_AdvancePaymentMode apm
                                            ON apm.RoomBookDetailsId = rb.RoomBookDetailsID
                                    WHERE (
                                              om.Date
                                          BETWEEN @PreviousClosedTS AND GETDATE()
                                              OR @PreviousClosedTS IS NULL
                                          )
                                          AND apm.PaymentModeID = 2
                                ),
                                0
                                      );

        -- Return amounts – unchanged
        SET @ReturnAmtCash = ISNULL(
                             (
                                 SELECT SUM(ISNULL(mp.ReturnAmount, 0))
                                 FROM RO_MemberPay mp
                                     LEFT JOIN RO_MemberPaymentMode mpm
                                         ON mpm.MemberPayId = mp.MemberPayID
                                 WHERE (
                                           mp.AddedOn
                                       BETWEEN @PreviousClosedTS AND GETDATE()
                                           OR @PreviousClosedTS IS NULL
                                       )
                                       AND mpm.PaymentModeID = 1
                                       AND ISNULL(mp.ReturnAmount, 0) > 0
                             ),
                             0
                                   );

        SET @ReturnAmteSewa = ISNULL(
                              (
                                  SELECT SUM(ISNULL(mp.ReturnAmount, 0))
                                  FROM RO_MemberPay mp
                                      LEFT JOIN RO_MemberPaymentMode mpm
                                          ON mpm.MemberPayId = mp.MemberPayID
                                  WHERE (
                                            mp.AddedOn
                                        BETWEEN @PreviousClosedTS AND GETDATE()
                                            OR @PreviousClosedTS IS NULL
                                        )
                                        AND mpm.PaymentModeID = 5
                                        AND ISNULL(mp.ReturnAmount, 0) > 0
                              ),
                              0
                                    );

        SET @ReturnAmtFonePay = ISNULL(
                                (
                                    SELECT SUM(ISNULL(mp.ReturnAmount, 0))
                                    FROM RO_MemberPay mp
                                        LEFT JOIN RO_MemberPaymentMode mpm
                                            ON mpm.MemberPayId = mp.MemberPayID
                                    WHERE (
                                              mp.AddedOn
                                          BETWEEN @PreviousClosedTS AND GETDATE()
                                              OR @PreviousClosedTS IS NULL
                                          )
                                          AND mpm.PaymentModeID = 6
                                          AND ISNULL(mp.ReturnAmount, 0) > 0
                                ),
                                0
                                      );

        SET @ReturnAmtCard = ISNULL(
                             (
                                 SELECT SUM(ISNULL(mp.ReturnAmount, 0))
                                 FROM RO_MemberPay mp
                                     LEFT JOIN RO_MemberPaymentMode mpm
                                         ON mpm.MemberPayId = mp.MemberPayID
                                 WHERE (
                                           mp.AddedOn
                                       BETWEEN @PreviousClosedTS AND GETDATE()
                                           OR @PreviousClosedTS IS NULL
                                       )
                                       AND mpm.PaymentModeID = 3
                                       AND ISNULL(mp.ReturnAmount, 0) > 0
                             ),
                             0
                                   );

        SET @ReturnAmtCheque = ISNULL(
                               (
                                   SELECT SUM(ISNULL(mp.ReturnAmount, 0))
                                   FROM RO_MemberPay mp
                                       LEFT JOIN RO_MemberPaymentMode mpm
                                           ON mpm.MemberPayId = mp.MemberPayID
                                   WHERE (
                                             mp.AddedOn
                                         BETWEEN @PreviousClosedTS AND GETDATE()
                                             OR @PreviousClosedTS IS NULL
                                         )
                                         AND mpm.PaymentModeID = 2
                                         AND ISNULL(mp.ReturnAmount, 0) > 0
                               ),
                               0
                                     );

        -- Total net sales
        SET @totalNetAmount =
        (
            SELECT SUM(NetAmount)
            FROM
            (
                SELECT SUM(sm1.NetAmount) [NetAmount]
                FROM RO_SalesMaster sm1
                    INNER JOIN CBMS_BillPostLog cb
                        ON cb.SalesMasterId = sm1.salesMasterId
                WHERE sm1.IsArchived = 0
                      AND sm1.IsUpdated = 1
                      AND sm1.BillCancelled = 0
                      AND
                      (
                          sm1.BillDate
                      BETWEEN @PreviousClosedTS AND GETDATE()
                          OR @PreviousClosedTS IS NULL
                      )
                UNION
                SELECT SUM(sm.NetAmount) [NetAmount]
                FROM RO_CakeSalesMaster sm
                WHERE sm.IsArchived = 0
                      AND sm.IsUpdated = 1
                      AND
                      (
                          sm.BillDate
                      BETWEEN @PreviousClosedTS AND GETDATE()
                          OR @PreviousClosedTS IS NULL
                      )
            ) AS t
        );

        -- =====================================================================
        -- CHANGED: @OpeningB overridden if @DayCloseFixedFloat > 0
        -- =====================================================================
        DECLARE @OpeningB DECIMAL(15, 2) = CASE
                                               WHEN @DayCloseFixedFloat IS NOT NULL
                                                    AND @DayCloseFixedFloat > 0 THEN
                                                   @DayCloseFixedFloat
                                               ELSE
                                           (
                                               SELECT TOP (1)
                                                      ISNULL(df.ClosingBalance, 0)
                                               FROM DailyFinancialReport df
                                               WHERE df.IsClosed = 1
                                               ORDER BY df.FinancialID DESC
                                           )
                                           END;

        DECLARE @ROCashSales DECIMAL(15, 2) =
                (
                    SELECT SUM(spm.PayAmount)
                    FROM RO_SalesMaster sm
                        INNER JOIN RO_SalesPaymentMode spm
                            ON sm.salesMasterId = spm.salesMasterId
                    WHERE spm.PaymentModeID = 1
                          AND sm.IsArchived = 0
                          AND sm.IsUpdated = 1
                          AND sm.BillCancelled = 0
                          AND
                          (
                              sm.BillDate
                          BETWEEN @PreviousClosedTS AND GETDATE()
                              OR @PreviousClosedTS IS NULL
                          )
                );

        DECLARE @CakeCashSales DECIMAL(15, 2) =
                (
                    SELECT SUM(spm.PayAmount)
                    FROM RO_CakeSalesMaster sm
                        INNER JOIN RO_CAKE_SalesPaymentMode spm
                            ON sm.SalesMasterId = spm.salesMasterId
                    WHERE spm.PaymentModeID = 1
                          AND sm.IsArchived = 0
                          AND sm.IsUpdated = 1
                          AND
                          (
                              sm.BillDate
                          BETWEEN @PreviousClosedTS AND GETDATE()
                              OR @PreviousClosedTS IS NULL
                          )
                );

        -- =====================================================================
        -- #Temp3: note @vendorPayCash subtracted in BOTH UNION halves
        -- =====================================================================
        SELECT *
        INTO #Temp3
        FROM
        (
            -- RO Sales half
            SELECT CAST(@date AS DATE) AS Period,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 1 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) Cash,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 2 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) Cheque,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 3 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) Card,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 4 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) Credit,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 5 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) eSewa,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 6 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) FonePay,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 1 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) + @creditPayCash + @advancePayCash - @vendorPayCash AS TotalCashReceived,
                   @SurplusDeficient SurplusDeficit,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 1 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) + @creditPayCash + @advancePayCash - @vendorPayCash AS CashInCounter,
                   0 AS CashSettlement,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 1 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) + @creditPayCash + @advancePayCash - @vendorPayCash AS ClosingBalance,
                   0 AS IsClosed,
                   GETDATE() AS ClosedTS,
                   @creditPayCard AS CreditCollectedInCard,
                   @creditPayeSewa AS CreditCollectedIneSewa,
                   @creditPayFonePay AS CreditCollectedInFonePay,
                   @creditPayCheque AS CreditCollectedInCheque,
                   @advancePayCash AS AdvancePayInCash,
                   @advancePayCard AS AdvanceCollectedInCard,
                   @advancePayeSewa AS AdvanceCollectedIneSewa,
                   @advancePayFonePay AS AdvanceCollectedInFonePay,
                   @advancePayCheque AS AdvanceCollectedInCheque,
                   @totalexpenses AS TotalExpenses,
                   @creditsettlementamt AS CreditSettlement,
                   ISNULL(@ReturnAmtCash, 0) AS ReturnAmtCash,
                   ISNULL(@ReturnAmtCard, 0) AS ReturnAmtCard,
                   ISNULL(@ReturnAmteSewa, 0) AS ReturnAmteSewa,
                   ISNULL(@ReturnAmtFonePay, 0) AS ReturnAmtFonePay,
                   ISNULL(@ReturnAmtCheque, 0) AS ReturnAmtCheque
            FROM RO_SalesMaster sm
                INNER JOIN CBMS_BillPostLog cb
                    ON cb.SalesMasterId = sm.salesMasterId
                LEFT JOIN RO_SalesPaymentMode spm
                    ON sm.salesMasterId = spm.salesMasterId
                LEFT JOIN DailyFinancialReport df
                    ON df.Period = @PreviousMaxPeriod
            WHERE sm.IsArchived = 0
                  AND sm.IsUpdated = 1
                  AND sm.BillCancelled = 0
                  AND
                  (
                      sm.BillDate
                  BETWEEN @PreviousClosedTS AND GETDATE()
                      OR @PreviousClosedTS IS NULL
                  )
            GROUP BY df.ClosingBalance
            UNION

            -- Cake Sales half
            SELECT CAST(@date AS DATE) AS Period,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 1 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) Cash,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 2 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) Cheque,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 3 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) Card,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 4 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) Credit,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 5 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) eSewa,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 6 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) FonePay,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 1 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) + @creditPayCash + @advancePayCash - @vendorPayCash AS TotalCashReceived,
                   @SurplusDeficient SurplusDeficit,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 1 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) + @creditPayCash + @advancePayCash - @vendorPayCash AS CashInCounter,
                   0 AS CashSettlement,
                   ISNULL(SUM(   CASE
                                     WHEN spm.PaymentModeID = 1 THEN
                                         spm.PayAmount
                                 END
                             ),
                          0
                         ) + @creditPayCash + @advancePayCash - @vendorPayCash AS ClosingBalance,
                   0 AS IsClosed,
                   GETDATE() AS ClosedTS,
                   @creditPayCard AS CreditCollectedInCard,
                   @creditPayeSewa AS CreditCollectedIneSewa,
                   @creditPayFonePay AS CreditCollectedInFonePay,
                   @creditPayCheque AS CreditCollectedInCheque,
                   @advancePayCash AS AdvancePayInCash,
                   @advancePayCard AS AdvanceCollectedInCard,
                   @advancePayeSewa AS AdvanceCollectedIneSewa,
                   @advancePayFonePay AS AdvanceCollectedInFonePay,
                   @advancePayCheque AS AdvanceCollectedInCheque,
                   @totalexpenses AS TotalExpenses,
                   @creditsettlementamt AS CreditSettlement,
                   ISNULL(@ReturnAmtCash, 0) AS ReturnAmtCash,
                   ISNULL(@ReturnAmtCard, 0) AS ReturnAmtCard,
                   ISNULL(@ReturnAmteSewa, 0) AS ReturnAmteSewa,
                   ISNULL(@ReturnAmtFonePay, 0) AS ReturnAmtFonePay,
                   ISNULL(@ReturnAmtCheque, 0) AS ReturnAmtCheque
            FROM RO_CakeSalesMaster sm
                LEFT JOIN RO_CAKE_SalesPaymentMode spm
                    ON sm.SalesMasterId = spm.salesMasterId
                LEFT JOIN DailyFinancialReport df
                    ON df.Period = @PreviousMaxPeriod
            WHERE sm.IsArchived = 0
                  AND sm.IsUpdated = 1
                  AND
                  (
                      sm.BillDate
                  BETWEEN @PreviousClosedTS AND GETDATE()
                      OR @PreviousClosedTS IS NULL
                  )
            GROUP BY df.ClosingBalance
        ) AS Temp2;

        -- =====================================================================
        -- Final INSERT: @vendorPayCash subtracted from TotalCashReceived,
        -- CashInCounter and ClosingBalance
        -- =====================================================================
        INSERT INTO DailyFinancialReport
        (
            Period,
            OpeningBalance,
            Cash,
            Cheque,
            Card,
            Credit,
            eSewa,
            FonePay,
            TotalCashReceived,
            SurplusDeficit,
            CreditCollectedInCash,
            CashInCounter,
            CashSettlement,
            ClosingBalance,
            IsClosed,
            ClosedTS,
            CreditCollectedInCard,
            CreditCollectedIneSewa,
            CreditCollectedInFonePay,
            CreditCollectedInCheque,
            AdvanceCollectedInCash,
            AdvanceCollectedInCard,
            AdvanceCollectedIneSewa,
            AdvanceCollectedInFonePay,
            AdvanceCollectedInCheque,
            TotalSales,
            TotalExpenses,
            CreditSettlement,
            ReturnAmtCash,
            ReturnAmtCard,
            ReturnAmteSewa,
            ReturnAmtFonePay,
            ReturnAmtCheque
        )
        SELECT Period,
               ISNULL(@OpeningB, 0),
               ISNULL(SUM(Cash), 0),
               ISNULL(SUM(Cheque), 0),
               ISNULL(SUM(Card), 0),
               ISNULL(SUM(Credit), 0),
               ISNULL(SUM(eSewa), 0),
               ISNULL(SUM(FonePay), 0),
               ISNULL(@creditPayCash, 0) + ISNULL(@CakeCashSales, 0) + ISNULL(@ROCashSales, 0)
               - ISNULL(@vendorPayCash, 0),
               ISNULL(SUM(SurplusDeficit), 0),
               ISNULL(@creditPayCash, 0) AS CreditCollectedInCash,
               ISNULL(@creditPayCash, 0) + ISNULL(@CakeCashSales, 0) + ISNULL(@ROCashSales, 0) + ISNULL(@OpeningB, 0)
               - ISNULL(@vendorPayCash, 0),
               ISNULL(SUM(CashSettlement), 0),
               ISNULL(@creditPayCash, 0) + ISNULL(@CakeCashSales, 0) + ISNULL(@ROCashSales, 0) + ISNULL(@OpeningB, 0)
               - ISNULL(@vendorPayCash, 0),
               IsClosed,
               ClosedTS,
               @creditPayCard,
               @creditPayeSewa,
               @creditPayFonePay,
               @creditPayCheque,
               @advancePayCash,
               @advancePayCard,
               @advancePayeSewa,
               @advancePayFonePay,
               @advancePayCheque,
               @totalNetAmount,
               @totalexpenses,
               @creditsettlementamt,
               ISNULL(@ReturnAmtCash, 0),
               ISNULL(@ReturnAmtCard, 0),
               ISNULL(@ReturnAmteSewa, 0),
               ISNULL(@ReturnAmtFonePay, 0),
               ISNULL(@ReturnAmtCheque, 0)
        FROM #Temp3
        GROUP BY Period,
                 IsClosed,
                 ClosedTS;

    END;

    -- Final SELECT
    SELECT df.FinancialID,
           df.Period,
           df.OpeningBalance,
           df.TotalSales,
           df.Cash,
           df.Cheque,
           df.Card,
           df.Credit,
           df.eSewa,
           df.FonePay,
           df.TotalCashReceived,
           df.SurplusDeficit,
           df.CreditCollectedInCash,
           df.CreditCollectedInCard,
           df.CreditCollectedIneSewa,
           df.CreditCollectedInFonePay,
           df.CreditCollectedInCheque,
           df.AdvanceCollectedInCash,
           df.AdvanceCollectedInCard,
           df.AdvanceCollectedIneSewa,
           df.AdvanceCollectedInFonePay,
           df.AdvanceCollectedInCheque,
           df.CashInCounter,
           df.CashSettlement,
           df.ClosingBalance,
           ISNULL(df.IsClosed, 0) AS IsClosed,
           df.TotalExpenses,
           ISNULL(df.CreditSettlement, 0) AS CreditSettlement,
           ISNULL(df.ReturnAmtCash, 0) AS ReturnAmtCash,
           ISNULL(df.ReturnAmtCard, 0) AS ReturnAmtCard,
           ISNULL(df.ReturnAmteSewa, 0) AS ReturnAmteSewa,
           ISNULL(df.ReturnAmtFonePay, 0) AS ReturnAmtFonePay,
           ISNULL(df.ReturnAmtCheque, 0) AS ReturnAmtCheque
    FROM DailyFinancialReport df
    WHERE df.Period = CAST(@date AS DATE);
END;

GO
