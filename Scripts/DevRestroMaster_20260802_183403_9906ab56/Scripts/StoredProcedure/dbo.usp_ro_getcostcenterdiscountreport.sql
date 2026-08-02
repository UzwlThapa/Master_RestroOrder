SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[usp_ro_getcostcenterdiscountreport] '2023-07-17 ','2023-08-17'
CREATE PROCEDURE [dbo].[usp_ro_getcostcenterdiscountreport]
    -- Add the parameters for the stored procedure here
    @StartDate NVARCHAR(50) = N'2025-05-20',
    @EndDate NVARCHAR(50) = N'2025-05-20'
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here

    DECLARE @tempSales AS TABLE
    (
        salesMasterId INT,
        CustomerName VARCHAR(200)
    );
    INSERT INTO @tempSales
    SELECT sm.salesMasterId,
           CASE
               WHEN ISNULL(spm.Customer, '') = '' THEN
                   sm.CusName
               ELSE
                   spm.Customer
           END AS cutomerName
    FROM RO_SalesMaster sm
        LEFT JOIN RO_SalesPaymentMode spm
            ON sm.salesMasterId = spm.salesMasterId
    GROUP BY sm.salesMasterId,
             CASE
                 WHEN ISNULL(spm.Customer, '') = '' THEN
                     sm.CusName
                 ELSE
                     spm.Customer
             END;


    SELECT sm.OrderMasterId,
                   sm.salesMasterId,
           CAST(CONVERT(VARCHAR(16), sm.BillDate, 20) AS VARCHAR(120)) AS BillDate,
           (
               SELECT TOP (1) Code FROM RO_CompanyInfo
           ) + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR(20)) AS billNo,
           sm.Waiter,
           --,isnull(rt.restrotableTitle, 'Take Away') AS restrotableTitle

           --,isnull(rr.restroRoom, 'Take Away') AS restroRoom
           sm.BasicAmount + sm.totaldiscount AS SubTotal,
           ufn.BarDiscount,
           ufn.KOTDiscount,
           ufn.BakeryDiscount,
           ufn.PizzaDiscount,
		   ufn.LoyaltyDiscount,
           sm.BasicAmount AS BasicAmount,
           ISNULL(b1.Amount, 0) AS ServiceCharge,
           ISNULL(b2.Amount, 0) AS Vat,
           sm.NetAmount,
           (
               SELECT ISNULL(STUFF(
                                      (
                                          SELECT ' & ' + CASE
                                                             WHEN LOWER(pms.PaymentMode) = 'credit' THEN
                                                                 pms.PaymentMode + '/' + spm.Customer
                                                             ELSE
                                                                 pms.PaymentMode
                                                         END
                                          FROM RO_SalesPaymentMode spm
                                              INNER JOIN RO_PaymentModes pms
                                                  ON spm.PaymentModeID = pms.PaymentModeID
                                          WHERE spm.salesMasterId = sm.salesMasterId --and spm.PaymentModeID = 4
                                          FOR XML PATH(''), TYPE
                                      ).value('.', 'NVARCHAR(MAX)'),
                                      1,
                                      3,
                                      ''
                                  ),
                             ''
                            )
           ) AS PaymentModes,
           ts.CustomerName AS CustomerName
    FROM dbo.RO_SalesMaster sm
        INNER JOIN @tempSales ts
            ON ts.salesMasterId = sm.salesMasterId
        INNER JOIN RO_OrderMasters om
            ON sm.OrderMasterId = om.OrderMasterID
        INNER JOIN CBMS_BillPostLog bp
            ON bp.SalesMasterId = sm.salesMasterId
        INNER JOIN RO_fiscalYear fy
            ON fy.fyId = sm.FiscalYearID
        --LEFT JOIN RO_SalesPaymentMode spm
        --    ON spm.salesMasterId = sm.salesMasterId
        LEFT JOIN RO_BillingAmount b1
            ON b1.SalesMasterID = sm.salesMasterId
               AND b1.BilingID = 62
        LEFT JOIN RO_BillingAmount b2
            ON b2.SalesMasterID = sm.salesMasterId
               AND b2.BilingID = 54
        LEFT JOIN dbo.RO_restroTable rt
            ON rt.restrotableId = sm.TableId
        LEFT JOIN RO_RestroRoom rr
            ON rr.restroRoomId = rt.restroRoomId
        CROSS APPLY dbo.ufn_ro_getcostcenterdiscount(sm.salesMasterId) ufn
    --LEFT JOIN @tempSales ts ON ts.salesMasterId = sm.salesMasterId
    WHERE sm.BillDate
	BETWEEN dateadd(hour,4, @StartDate)
				AND dateadd(hour,28, @EndDate)
          AND (sm.IsArchived = 0)
    ORDER BY sm.BillDate ASC;
END;

GO
