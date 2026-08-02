SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 10/09/2023
====================================

EXEC dbo.usp_ro_get_frontpageheaderStatus
  
*/
CREATE PROCEDURE [dbo].[usp_ro_get_frontpageheaderStatus]
AS
    DECLARE @TotalSales DECIMAL (18, 2) ,
            @OutstandingSales DECIMAL (18, 2) ,
            @BillIssued INT ,
            @TotalOrders INT ,
            @TotalCancelled INT ,
            @StartDate DATETIME = DATEADD (HOUR, 4, DATEDIFF (d, 0, GETDATE ())) ,
            @EndDate DATETIME = DATEADD (HOUR, 4, DATEDIFF (d, 0, GETDATE () + 1));

    SET @TotalSales = ISNULL (( SELECT SUM (NetAmount)
                                FROM   RO_SalesMaster
                                WHERE  IsUpdated = 1
                                AND    IsArchived = 0
                                AND    BillCancelled = 0
                                AND    BillDate BETWEEN @StartDate AND @EndDate ) ,
                              0);

    SET @OutstandingSales = ISNULL (( SELECT SUM (om.BasicAmount)
                                      FROM   RO_OrderMasters om
                                             --LEFT JOIN RO_SalesMaster sm ON om.OrderMasterID = sm.OrderMasterId
											  WHERE 
											   ISNULL (om.BillPaid, 0) = 0
                                      AND    ISNULL (om.IsCancelled, 0) = 0
            --  (sm.IsUpdated is not null and   ISNULL (sm.IsUpdated, 0) = 0)
									   --AND (sm.IsArchived is not null and   ISNULL (sm.IsArchived, 0) = 0)
									   -- AND (sm.BillCancelled is not null and   ISNULL (sm.BillCancelled, 0) = 0)
                                      AND    om.Date BETWEEN @StartDate AND @EndDate ) ,
                                    0);

    SET @BillIssued = ISNULL (( SELECT COUNT (*)
                                FROM   RO_SalesMaster
                                WHERE  IsUpdated = 1
                                AND    IsArchived = 0
                                AND    BillCancelled = 0
                                AND    BillDate BETWEEN @StartDate AND @EndDate ) ,
                              0);

    SET @TotalOrders = ISNULL (( SELECT SUM (Quantity)
                                 FROM   RO_Order_Detail
                                 WHERE  Date BETWEEN @StartDate AND @EndDate ) ,
                               0);

    SET @TotalCancelled = ISNULL (( SELECT SUM (Quantity)
                                    FROM   RO_Order_Detail
                                    WHERE  IsCancelled = 1
                                    AND    Date BETWEEN @StartDate AND @EndDate ) ,
                                  0);

    SELECT @TotalSales [TotalSales] ,
           @OutstandingSales [OutstandingSales] ,
           @BillIssued [BillIssued] ,
           @TotalOrders [TotalOrders] ,
           @TotalCancelled [TotalCancelled];

GO
