SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getCustomerBalanceTransactionRecordByID] @membershipID INT
AS
IF (@membershipID IN
    (
        SELECT MembershipID FROM dbo.RO_LoyaltyMembership WHERE IsCustomer = 1
    )
   )
BEGIN
    -- ============================================================
    -- CUSTOMER BRANCH (unchanged)
    -- ============================================================
    DECLARE @code VARCHAR(10);
    SET @code =
    (
        SELECT TOP (1) Code FROM dbo.RO_CompanyInfo
    );

    SELECT mp.[MemberPayID],
           mp.[MemberID],
           0 AS CreditAmount,
           ISNULL(mp.[PayAmount], 0) AS PayAmount,
           [mp].[AddedOn],
           [mp].[AddedBy],
           0 AS [status],
           '' AS billNo,
           1 AS iscustomer,
           0 AS salesMasterId,
           0 AS RoomBookDetailsID,
           '' AS Remarks,
           ISNULL(mp.SettlementAmount, 0) AS SettlementAmount,
           0 AS IsCancelled
    FROM [dbo].[RO_MemberPay] mp
        INNER JOIN dbo.RO_MemberPaymentMode mpm
            ON mpm.MemberPayId = mp.MemberPayID
    WHERE mp.MemberID = @membershipID
          AND mp.[PayAmount] > 0
    UNION
    SELECT sm.[salesMasterId],
           spm.[CusID],
           ISNULL(MAX(   CASE
                             WHEN sm.AdvancePayment < sm.NetAmount THEN
                                 CASE
                                     WHEN spm.PaymentModeID = 4 THEN
                                         sm.AdvancePayment + spm.PayAmount
                                     ELSE
                                         sm.AdvancePayment
                                 END
                             WHEN sm.AdvancePayment >= sm.NetAmount THEN
                                 sm.NetAmount
                         END
                     ),
                  0
                 ) AS CreditAmount,
           0 AS NetAmount,
           sm.[AddedOn],
           sm.[AddedBy],
           1 AS [status],
           @code + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo,
           1 AS iscustomer,
           sm.salesMasterId,
           0 AS RoomBookDetailsID,
           spm.Remarks,
           0 AS SettlementAmount,
           spm.IsCancelled
    FROM [dbo].[RO_SalesMaster] sm
        LEFT JOIN dbo.RO_SalesPaymentMode spm
            ON spm.salesMasterId = sm.salesMasterId
        JOIN dbo.RO_fiscalYear fy
            ON sm.FiscalYearID = fy.fyId
    WHERE spm.[CusID] = @membershipID
          AND
          (
              spm.PaymentModeID = 4
              OR sm.AdvancePayment > 0
          )
    GROUP BY @code + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)),
             sm.salesMasterId,
             spm.CusID,
             sm.AddedOn,
             sm.AddedBy,
             spm.Remarks,
             spm.IsCancelled
    UNION
    SELECT rb.RoomBookDetailsID,
           rb.CustomerId,
           0 AS CreditAmount,
           ISNULL(SUM(spm.PayAmount), 0) AS NetAmount,
           om.Date AS AddedOn,
           om.UserName AS AddedBy,
           0 AS [status],
           '' AS billNo,
           1 AS iscustomer,
           0 AS salesMasterId,
           rb.RoomBookDetailsID,
           rb.Remarks,
           ISNULL(spm.SettlementAmount, 0) AS SettlementAmount,
           0 AS IsCancelled
    FROM [dbo].Ro_RoomBookings rb
        JOIN dbo.RO_AdvancePaymentMode spm
            ON spm.RoomBookDetailsId = rb.RoomBookDetailsID
        JOIN dbo.RO_OrderMasters om
            ON rb.OrderMasterId = om.OrderMasterID
    WHERE rb.CustomerId = @membershipID
    GROUP BY ISNULL(spm.SettlementAmount, 0),
             rb.RoomBookDetailsID,
             rb.CustomerId,
             om.Date,
             om.UserName,
             rb.Remarks
    UNION
    SELECT sm.[SalesMasterId],
           sm.CustomerId,
           ISNULL(MAX(   CASE
                             WHEN sm.AdvancePayment < sm.NetAmount THEN
                                 CASE
                                     WHEN spm.PaymentModeID = 4 THEN
                                         sm.AdvancePayment + spm.PayAmount
                                     ELSE
                                         sm.AdvancePayment
                                 END
                             WHEN sm.AdvancePayment >= sm.NetAmount THEN
                                 sm.NetAmount
                         END
                     ),
                  0
                 ) AS CreditAmount,
           0 AS NetAmount,
           sm.[AddedOn],
           sm.[AddedBy],
           1 AS [status],
           @code + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo,
           1 AS iscustomer,
           sm.SalesMasterId,
           0 AS RoomBookDetailsID,
           spm.Remarks,
           0 AS SettlementAmount,
           0 AS IsCancelled
    FROM dbo.RO_CakeSalesMaster sm
        LEFT JOIN dbo.RO_CAKE_SalesPaymentMode spm
            ON spm.salesMasterId = sm.SalesMasterId
        JOIN dbo.RO_fiscalYear fy
            ON sm.FiscalYearID = fy.fyId
    WHERE spm.[CusID] = @membershipID
          AND
          (
              spm.PaymentModeID = 4
              OR sm.AdvancePayment > 0
          )
    GROUP BY @code + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)),
             sm.SalesMasterId,
             sm.CustomerId,
             sm.AddedOn,
             sm.AddedBy,
             spm.Remarks
    ORDER BY AddedOn ASC;
END;
ELSE
BEGIN
    -- ============================================================
    -- VENDOR BRANCH
    -- ============================================================
    SELECT mp.[MemberPayID],
           mp.[MemberID],
           0 AS CreditAmount,
           ISNULL(mp.[PayAmount], 0) AS PayAmount,
           [mp].[AddedOn],
           [mp].[AddedBy],
           0 AS [status],
           '' AS billNo,
           0 AS iscustomer,
           0 AS salesMasterId,
           ISNULL(mp.SettlementAmount, 0) AS SettlementAmount,
           0 AS IsCancelled
    FROM [dbo].[RO_MemberPay] mp
        INNER JOIN dbo.RO_MemberPaymentMode mpm
            ON mpm.MemberPayId = mp.MemberPayID
    WHERE mp.MemberID = @membershipID
          AND mp.[PayAmount] > 0
    UNION
    SELECT sm.GMId,
           sm.vendorId,
           ISNULL(   ppm.PayAmount,
                     CASE
                         WHEN lm.IsVat = 0 THEN
                             SUM(rd.Total)
                         ELSE
                             SUM(rd.Total * 1.13)
                     END
                 ) AS CreditAmount,
           0 AS PayAmount,
           sm.PostedOn AS AddedOn,
           sm.PostedBy,
           1 AS [status],
           sm.GMNo AS billNo,
           0 AS iscustomer,
           sm.GMId AS salesMasterId,
           0 AS SettlementAmount,
           0 AS IsCancelled
    FROM dbo.RO_GoodsReceivedMain sm
        JOIN dbo.RO_GoodsReceivedDetls rd
            ON rd.GMId = sm.GMId
        JOIN dbo.RO_LoyaltyMembership lm
            ON lm.MembershipID = sm.vendorId
        LEFT JOIN dbo.RO_PurchasePaymentMode ppm
            ON ppm.GMId = sm.GMId
    WHERE sm.vendorId = @membershipID
          AND rd.Total IS NOT NULL
          AND ISNULL(ppm.paymentModeID, sm.paymentMode) = 4
    GROUP BY sm.vendorId,
             sm.GMId,
             sm.PostedOn,
             sm.PostedBy,
             sm.GMNo,
             lm.IsVat,
             ppm.PayAmount
    UNION
    -- ✅ FAST: pre‑aggregate only the vendor's returns
    SELECT PR.PurchaseReturnId,
           PR.vendorId,
           -ISNULL(PRD.ReturnTotal, 0) AS CreditAmount,
           0 AS PayAmount,
           PR.PostedOn AS AddedOn,
           PR.PostedBy,
           1 AS [status],
           PR.PRNo AS billNo,
           0 AS iscustomer,
           PR.PurchaseReturnId AS salesMasterId,
           0 AS SettlementAmount,
           0 AS IsCancelled
    FROM dbo.RO_PurchaseReturnMain PR
        LEFT JOIN
        (
            SELECT PD.PurchaseReturnId,
                   SUM(   CASE
                              WHEN lm.IsVat = 1 THEN
                                  PD.Total * 1.13
                              ELSE
                                  PD.Total
                          END
                      ) AS ReturnTotal
            FROM dbo.RO_PurchaseReturnDetails PD
                JOIN dbo.RO_PurchaseReturnMain PRM2
                    ON PRM2.PurchaseReturnId = PD.PurchaseReturnId
                JOIN dbo.RO_LoyaltyMembership lm
                    ON lm.MembershipID = PRM2.vendorId
            WHERE PRM2.vendorId = @membershipID
            GROUP BY PD.PurchaseReturnId
        ) PRD
            ON PR.PurchaseReturnId = PRD.PurchaseReturnId
    WHERE PR.vendorId = @membershipID
          AND
          (
              NOT EXISTS
    (
        SELECT 1
        FROM dbo.RO_PurchaseReturnPaymentMode ppm
        WHERE ppm.PurchaseReturnId = PR.PurchaseReturnId
    )
              OR EXISTS
    (
        SELECT 1
        FROM dbo.RO_PurchaseReturnPaymentMode ppm
        WHERE ppm.PurchaseReturnId = PR.PurchaseReturnId
              AND ppm.paymentModeID = 4
    )
          )
    ORDER BY AddedOn ASC;
END;

GO
