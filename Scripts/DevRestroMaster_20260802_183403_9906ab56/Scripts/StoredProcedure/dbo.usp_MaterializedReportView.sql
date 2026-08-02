SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  [usp_MaterializedReportView] '2024-03-15', '2024-05-21',-1          
CREATE PROCEDURE [dbo].[usp_MaterializedReportView]
    @StartDate DATETIME,
    @EndDate DATETIME,
    @Valid INT,
	@PaymentMode NVARCHAR(20) = N''
AS
DECLARE @qEndDate DATETIME;
DECLARE @qStartDate DATETIME;
DECLARE @qValid DATETIME;

SET @qEndDate = DATEADD(DAY, 1, @EndDate);
SET @qStartDate = @StartDate;
SET @qValid = @Valid;

DECLARE @code VARCHAR(10);

SET @code =
(
    SELECT TOP (1) Code FROM RO_CompanyInfo
);

SELECT fy.fyName AS FiscalYear,
       @code + fy.fyName + '-' + CAST((SM.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS Bill_No,
       SM.salesMasterId,
       SM.CusName AS Customer_Name,
       cb.buyer_pan AS Customer_PAN,
       SM.NepaliInvoiceDate AS Bill_Date,
       SM.BasicAmount + SM.totaldiscount AS AMOUNT,
       ISNULL(SM.totaldiscount, 0) AS Discount,
       ISNULL(bA1.Amount, 0) AS ServiceCharge,
       ISNULL(SM.BasicAmount + ISNULL(bA1.Amount, 0), 0) AS TaxableAmount,
       ISNULL(bA2.Amount, 0) AS Tax_Amount,
       --,CASE 
       --	WHEN PD.PrintedBy IS NULL
       --		THEN 0
       --	ELSE 1
       --	END AS Is_Printed
       1 AS Is_Printed,
       ~ (SM.IsArchived) AS Is_Active,
       SM.PrintDate AS Printed_Time,
       SM.PrintCount AS PrintCount,
       MIN(SM.AddedBy) AS Entered_by,
       MIN(SM.AddedBy) AS Printed_by,
       --,cb.isrealtime
       1 isrealtime,
       1 AS SyncWithIRD,
       SM.Reasons,
       ufn.PaymentModes
FROM dbo.RO_SalesMaster AS SM
    CROSS APPLY [dbo].[ufn_sales_getpaymentdata](sm.salesMasterId, @PaymentMode) ufn
    INNER JOIN RO_fiscalYear fy
        ON SM.FiscalYearID = fy.fyId
    INNER JOIN CBMS_BillPostLog cb
        ON cb.SalesMasterId = SM.salesMasterId
    LEFT JOIN dbo.PrintDetail AS PD
        ON SM.salesMasterId = PD.PrintBillNo
           AND PD.PrintedNumber = 1
    LEFT JOIN dbo.RO_BillingAmount bA1
        ON bA1.SalesMasterID = SM.salesMasterId
           AND
           (
               bA1.IsVoid = 0
               OR bA1.IsVoid IS NULL
           )
           AND bA1.BilingID = 62
    LEFT JOIN dbo.RO_BillingAmount bA2
        ON bA2.SalesMasterID = SM.salesMasterId
           AND
           (
               bA2.IsVoid = 0
               OR bA2.IsVoid IS NULL
           )
           AND bA2.BilingID = 54
WHERE (SM.BillDate
      BETWEEN @qStartDate AND @qEndDate
      )
      AND
      (
          SM.IsArchived = @qValid
          OR @qValid = -1
      )
GROUP BY SM.FiscalYearID,
         fy.fyName,
         SM.salesMasterId,
         SM.InvoiceNo,
         fy.FirstSalesMasterID,
         cb.buyer_pan,
         SM.CusName,
         SM.NepaliInvoiceDate,
         SM.BasicAmount,
         SM.totaldiscount,
         bA1.Amount,
         bA2.Amount,
         SM.PrintDate,
         SM.PrintCount,
         PD.PrintedBy,
         SM.IsArchived,
         SM.Reasons,
         cb.isrealtime,
         cb.StatusCode,
         ufn.PaymentModes
ORDER BY SM.salesMasterId ASC;




GO
