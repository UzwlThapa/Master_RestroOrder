SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 11/10/2023
====================================

 EXEC dbo.USP_SALES_REPORT @startDate = '2023-09-06' , -- datetime
                           @endDate = '2023-09-06' ,   -- datetime
                           @PaymentMode = N'' ,                 -- nvarchar(20)
                           @Status = -1 ,                        -- int
                           @OrdertypeID = 0 ,                   -- int
                           @CustName = ''                       -- varchar(50)
 

*/
ALTER PROCEDURE [dbo].USP_SALES_REPORT
    --DECLARE 
    @startDate DATETIME = '2022-09-17' ,
    @endDate DATETIME = '2022-09-17' ,
    @PaymentMode NVARCHAR (20) = N'' ,
    @Status INT = -1 ,
    @OrdertypeID INT = 0 ,
    @CustName VARCHAR (50) = ''
AS
    BEGIN

        DECLARE @StartDateTime DATETIME;
        DECLARE @EndDateTime DATETIME;
        SELECT @StartDateTime = DATEADD (HOUR, 4, @startDate);
        --SELECT @EndDateTime = DATEADD (MINUTE, -1, DATEADD (HOUR, 28, @endDate));
        SELECT @EndDateTime = DATEADD (HOUR, 4, @endDate);

        DECLARE @code VARCHAR (10);

        SET @code = ( SELECT TOP ( 1 ) Code
                      FROM   RO_CompanyInfo );

        DECLARE @tempSales AS TABLE
        (   salesMasterId INT ,
            CustomerName VARCHAR (200));
        INSERT INTO @tempSales
                    SELECT   sm.salesMasterId ,
                             CASE WHEN ISNULL (spm.Customer, '') = '' THEN sm.CusName
                                  ELSE spm.Customer
                             END AS cutomerName
                    FROM     RO_SalesMaster sm
                             LEFT JOIN RO_SalesPaymentMode spm ON sm.salesMasterId = spm.salesMasterId
                    WHERE    ( sm.BillDate BETWEEN @StartDateTime AND @EndDateTime )
                    AND      ( spm.PaymentModeID > 0
                            OR spm.PaymentModeID IS NULL )
                    GROUP BY sm.salesMasterId ,
                             CASE WHEN ISNULL (spm.Customer, '') = '' THEN sm.CusName
                                  ELSE spm.Customer
                             END;


        SELECT salesMasterId
        INTO   #temp
        FROM   dbo.RO_SalesMaster sm
        WHERE  sm.BillDate BETWEEN @StartDateTime AND @EndDateTime
        AND    ( @Status = -1
              OR sm.IsUpdated = @Status );


        SELECT   sm.OrderMasterId ,
                 sm.salesMasterId ,
                 CAST(CONVERT (VARCHAR (16), sm.BillDate, 20) AS VARCHAR (120)) AS BillDate ,
                 @code + fy.fyName + '-' + CAST(( sm.InvoiceNo - fy.FirstSalesMasterID ) AS VARCHAR (20)) AS billNo ,
                 sm.Waiter ,
                 sm.TableId ,
                 CASE WHEN om.OrderTypeID = 4 THEN 'Food Delivery'
                      WHEN om.OrderTypeID = 3 THEN 'Food Court'
                 END AS restrotableTitle ,
                 CASE WHEN om.OrderTypeID = 4 THEN 'Food Delivery'
                      WHEN om.OrderTypeID = 3 THEN 'Food Court'
                 END AS restroRoom ,
                 sm.BasicAmount + sm.totaldiscount AS SubTotal ,
                 sm.totaldiscount ,
                 sm.BasicAmount AS BasicAmount ,
                 sm.NetAmount ,
                 ISNULL (sm.PrintCount, 0) AS PrintCount ,
                 sm.IsUpdated AS [Status] ,
                 ( CASE WHEN ISNULL (sm.IsUpdated, 0) = 1
                        AND  ISNULL (sm.AdvancePayment, 0) < sm.NetAmount THEN
                 ( ISNULL (SUM (spm.PayAmount), 0) + ISNULL (sm.AdvancePayment, 0) - sm.NetAmount
                   - ISNULL (SUM (spm.ReturnPayment), 0))
                        WHEN ISNULL (sm.IsUpdated, 0) = 1
                        AND  ISNULL (sm.AdvancePayment, 0) > sm.NetAmount THEN 0
                        ELSE 0
                   END ) AS SurplusDeficit ,
                 ISNULL (spm.ReturnPayment, 0) AS ReturnPayment ,
                 '' AS SalesType ,
                 ts.CustomerName AS CustomerName ,
                 om.GuestNo ,
                 sm.BillCancelled ,
                 sm.IsArchived
        INTO     #temp2
        FROM     #temp tmp
                 INNER JOIN dbo.RO_SalesMaster sm ON sm.salesMasterId = tmp.salesMasterId
                 INNER JOIN @tempSales ts ON ts.salesMasterId = sm.salesMasterId
                 INNER JOIN RO_OrderMasters om ON sm.OrderMasterId = om.OrderMasterID
                 INNER JOIN CBMS_BillPostLog bp ON bp.SalesMasterId = sm.salesMasterId
                 INNER JOIN RO_fiscalYear fy ON fy.fyId = sm.FiscalYearID
                 LEFT JOIN RO_SalesPaymentMode spm ON spm.salesMasterId = sm.salesMasterId
        WHERE    ( ISNULL (om.OrderTypeID, 1) = @OrdertypeID
                OR @OrdertypeID = 0 )
        GROUP BY sm.OrderMasterId ,
                 sm.salesMasterId ,
                 sm.Waiter ,
                 sm.TableId ,
                 fy.fyName ,
                 sm.InvoiceNo ,
                 fy.FirstSalesMasterID ,
                 sm.totaldiscount ,
                 sm.BasicAmount ,
                 sm.BillDate ,
                 sm.AdvancePayment ,
                 sm.NetAmount ,
                 sm.PrintCount ,
                 sm.IsUpdated ,
                 om.OrderTypeID ,
                 spm.ReturnPayment ,
                 ts.CustomerName ,
                 om.GuestNo ,
                 sm.BillCancelled ,
                 sm.IsArchived;


        SELECT OrderMasterId ,
               sm.salesMasterId ,
               BillDate ,
               billNo ,
               Waiter ,
               TableId ,
               CASE WHEN rt.restrotableTitle IS NULL THEN ISNULL (sm.restrotableTitle, 'Take Away')
                    ELSE ''
               END AS restrotableTitle ,
               ISNULL (sm.restroRoom, rt.restrotableTitle) AS restroRoom ,
               SubTotal ,
               totaldiscount ,
               BasicAmount ,
               ISNULL (b1.Amount, 0) AS ServiceCharge ,
               ISNULL (b2.Amount, 0) AS Vat ,
               NetAmount ,
               PrintCount ,
               ufn.PaymentModes ,
               Status ,
               ufn.PaidAmount AS ReceivedAmount ,
               SurplusDeficit ,
               ReturnPayment ,
               SalesType ,
               CustomerName ,
               GuestNo ,
               sm.BillCancelled ,
               sm.IsArchived
        INTO #temp3
        FROM   #temp2 sm
               CROSS APPLY [dbo].[ufn_sales_getpaymentdata] (sm.salesMasterId, @PaymentMode) ufn
               LEFT JOIN RO_BillingAmount b1 ON  b1.SalesMasterID = sm.salesMasterId
                                             AND b1.BilingID = 62
               LEFT JOIN RO_BillingAmount b2 ON  b2.SalesMasterID = sm.salesMasterId
                                             AND b2.BilingID = 54
               LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = sm.TableId
               LEFT JOIN RO_RestroRoom rr ON rr.restroRoomId = rt.restroRoomId
        UNION
        SELECT t2.OrderMasterId ,
               t2.SalesMasterId ,
               t2.BillDate ,
               t2.billNo ,
               t2.Waiter ,
               t2.TableId ,
               t2.restrotableTitle ,
               t2.restroRoom ,
               t2.SubTotal ,
               t2.TotalDiscount ,
               t2.BasicAmount ,
               t2.ServiceCharge ,
               t2.Vat ,
               t2.NetAmount ,
               t2.PrintCount ,
               t2.PaymentModes ,
               t2.Status ,
               t2.ReceivedAmount ,
               t2.SurplusDeficit ,
               t2.ReturnPayment ,
               t2.SalesType ,
               t2.CustomerName ,
               t2.GuestNo ,
               0 ,
               t2.IsArchived
        FROM   [dbo].[vw_CakeSalesReport] t2
        WHERE  t2.BillDate BETWEEN @StartDateTime AND @EndDateTime
        AND    ( ( t2.SalesType = CASE @OrdertypeID
                                       WHEN 6 THEN 'cake'
                                       WHEN 7 THEN 'wholesale'
                                       WHEN 8 THEN 'retail'
                                  END )
              OR @OrdertypeID = 0 );

        DECLARE @CDate DATETIME = ISNULL (( SELECT   TOP ( 1 ) ClosedTS
                                            FROM     [dbo].[DailyFinancialReport]
                                            WHERE    IsClosed = 1
                                            ORDER BY FinancialID DESC ) ,
                                          GETDATE () - 100);

        SELECT   * ,
                 ( CASE WHEN ( CAST(t.BillDate AS DATETIME) >= CAST(@CDate AS DATETIME)) THEN 1
                        ELSE 0
                   END ) AS EditBill
        FROM     #temp3 t
        WHERE    t.CustomerName LIKE '%' + @CustName + '%'
        AND      ( @PaymentMode = ''
                OR t.PaymentModes LIKE '%' + @PaymentMode + '%' )
        ORDER BY t.BillDate ASC;

        DROP TABLE #temp;
        DROP TABLE #temp2;
        DROP TABLE #temp3;
    END;


GO

