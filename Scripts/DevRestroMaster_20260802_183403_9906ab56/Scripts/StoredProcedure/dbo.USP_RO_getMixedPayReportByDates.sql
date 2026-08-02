SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP procedure USP_RO_getCreditReport
CREATE PROCEDURE [dbo].[USP_RO_getMixedPayReportByDates]
    @sdate DATE,
    @edate DATE,
    @Customer NVARCHAR(250) = NULL,
    @IsCustomer BIT = NULL
AS

CREATE TABLE #temp
(
    MemberPayID INT,
    MemberID INT,
    AddedOn NVARCHAR(50),
    CustName NVARCHAR(255),
    CustType NVARCHAR(100),
    PayAmount DECIMAL(14, 4),
    CreditAmount DECIMAL(14, 4),
    SalesMasterID INT,
    BillNo NVARCHAR(100),
    TrType INT,
	iscustomer BIT
);

IF (@IsCustomer = 1)
BEGIN

    DECLARE @code VARCHAR(10);

    SET @code =
    (
        SELECT TOP (1) Code FROM RO_CompanyInfo
    );


    INSERT INTO #temp
    (
        MemberPayID,
        MemberID,
        AddedOn,
        CustName,
        CustType,
        PayAmount,
        CreditAmount,
        SalesMasterID,
        BillNo,
        TrType,iscustomer
    )
    SELECT sm.[salesMasterId] AS MemberPayId,
           spm.[CusID] AS MemberID,
           sm.[AddedOn],
           lm.Fname + ' ' + lm.Lname AS CustName,
           CASE
               WHEN lm.IsCustomer < 1 THEN
                   'Vendor'
               ELSE
                   'Customer'
           END AS CustType,
           0,
           ISNULL(spm.PayAmount, 0),
           sm.salesMasterId,
           @code + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo,
           1 AS TrType,1 AS iscustomer
    FROM [dbo].[RO_SalesMaster] sm
        LEFT JOIN RO_SalesPaymentMode spm
            ON spm.salesMasterId = sm.salesMasterId
        JOIN dbo.RO_fiscalYear fy
            ON sm.FiscalYearID = fy.fyId
        INNER JOIN RO_LoyaltyMembership lm
            ON lm.MembershipID = spm.[CusID]
    WHERE
        --spm.[CusID] = @membershipID
        (CAST(DATEADD(HOUR, -4, sm.AddedOn) AS DATE)
        BETWEEN @sdate AND @edate
        )
        AND
        (
            lm.Fname + ' ' + lm.Lname = @Customer
            OR @Customer IS NULL
        )
        AND spm.PaymentModeID = 4
    ORDER BY AddedOn DESC;
END;
ELSE
    INSERT INTO #temp
    (
        MemberPayID,
        MemberID,
        AddedOn,
        CustName,
        CustType,
        PayAmount,
        CreditAmount,
        SalesMasterID,
        BillNo,
        TrType,
		iscustomer
    )
    SELECT sm.GMId AS MemberPayId,
           sm.vendorId AS MemberID,
           sm.PostedOn AS AddedOn,
           lm.Fname + ' ' + lm.Lname AS CustName,
           CASE
               WHEN lm.IsCustomer < 1 THEN
                   'Vendor'
               ELSE
                   'Customer'
           END AS CustType,
           0,
           ISNULL(   pm.PayAmount,
                     CASE
                         WHEN lm.IsVat = 0 THEN
                             SUM(Total)
                         ELSE
                             SUM(Total * 1.13)
                     END
                 ) PayAmount,
           sm.GMId AS salesMasterId,
           GMNo AS billNo,
           1 AS TrType,
		 0  iscustomer
    FROM RO_GoodsReceivedMain sm
        JOIN RO_GoodsReceivedDetls rd
            ON rd.GMId = sm.GMId
        JOIN RO_LoyaltyMembership lm
            ON lm.MembershipID = sm.vendorId
        LEFT JOIN RO_PurchasePaymentMode pm
            ON pm.GMId = sm.GMId
    WHERE
        --spm.[CusID] = @membershipID
        (CAST(DATEADD(HOUR, -4, sm.PostedOn) AS DATE)
        BETWEEN @sdate AND @edate
        )
        AND
        (
            lm.Fname + ' ' + lm.Lname = @Customer
            OR @Customer IS NULL
        )
        AND rd.Total IS NOT NULL
        --AND isnull(sm.paymentMode, 0) = 4
        AND ISNULL(pm.paymentModeID, sm.paymentMode) = 4
    GROUP BY sm.vendorId,
             sm.GMId,
             sm.PostedOn,
             sm.PostedBy,
             GMNo,
             lm.IsVat,
             lm.Fname,
             lm.Lname,
             lm.IsCustomer,
             pm.paymentModeID,
             pm.PayAmount
    ORDER BY AddedOn DESC;


INSERT INTO #temp
(
    MemberPayID,
    MemberID,
    AddedOn,
    CustName,
    CustType,
    PayAmount,
    CreditAmount,
    SalesMasterID,
    BillNo,
    TrType,iscustomer
)
SELECT mp.[MemberPayID],
       mp.[MemberID],
       mp.[AddedOn],
       lm.Fname + ' ' + lm.Lname AS CustName,
       CASE
           WHEN lm.IsCustomer < 1 THEN
               'Vendor'
           ELSE
               'Customer'
       END AS CustType,
       mpm.[PayAmount],
       0,
       0,
       '',
       2 AS TrType,
	   0
FROM [dbo].[RO_MemberPay] mp
    INNER JOIN RO_MemberPaymentMode mpm
        ON mp.MemberPayID = mpm.MemberPayId
    INNER JOIN RO_LoyaltyMembership lm
        ON lm.MembershipID = mp.MemberID
WHERE (CAST(DATEADD(HOUR, -4, mp.AddedOn) AS DATE)
      BETWEEN @sdate AND @edate
      )
      AND mpm.[PayAmount] != 0.00
      AND
      (
          lm.IsCustomer = @IsCustomer
          OR @IsCustomer IS NULL
          OR @IsCustomer = ''
      )
      AND
      (
          lm.Fname + ' ' + lm.Lname = @Customer
          OR @Customer IS NULL
      )
      AND mpm.[PayAmount] > 0
ORDER BY CustName ASC;

SELECT *
FROM #temp
ORDER BY AddedOn;

DROP TABLE #temp;




GO
