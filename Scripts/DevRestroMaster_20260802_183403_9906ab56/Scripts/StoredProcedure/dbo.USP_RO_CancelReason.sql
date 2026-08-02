SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_CancelReason]
    @salesMasterId INT ,
    @Reasons NVARCHAR (MAX) ,
    @userName NVARCHAR (256)
AS
    BEGIN
        UPDATE dbo.RO_SalesMaster
        SET    BillCancelled = 1 ,
               ArchivedBy = @userName ,
               ArchivedOn = GETDATE () ,
               Reasons = @Reasons
        WHERE  salesMasterId = @salesMasterId;

        UPDATE dbo.RO_Order_Detail
        SET    IsCancelled = 1
        WHERE  OrderMasterId = ( SELECT OrderMasterId
                                 FROM   dbo.RO_SalesMaster
                                 WHERE  salesMasterId = @salesMasterId )
        AND    SeatNo = ( SELECT SeatNo
                          FROM   dbo.RO_SalesMaster
                          WHERE  salesMasterId = @salesMasterId );

        INSERT INTO dbo.ROI_SalesReturnStockTransaction ( SalesDetailId ,
                                                          StoreId ,
                                                          ItemId ,
                                                          SalesReturnQty ,
                                                          Unit ,
                                                          SalesReturnRate ,
                                                          SalesReturnAmt ,
                                                          TransactionDate )
                    SELECT st.SalesDetailId ,
                           st.StoreId ,
                           st.ItemId ,
                           st.SalesQty AS SalesReturnQty ,
                           st.SalesUnit AS Unit ,
                           st.SalesRate AS SalesReturnRate ,
                           -- You may need to calculate SalesReturnAmt based on the return quantity and return rate
                           st.SalesAmt AS SalesReturnAmt ,
                           GETDATE () AS TransactionDate
                    FROM   dbo.RO_SalesMaster sm
                           INNER JOIN dbo.ROI_SalesStockTransaction st ON sm.salesMasterId = st.SalesDetailId
                    WHERE  sm.IsArchived = 1
                    AND    sm.salesMasterId = @salesMasterId;


        EXEC [dbo].[usp_SaveTransactionForSalesReturn] @SalesMasterID = @salesMasterId;

        EXEC dbo.usp_ro_solveTableIssues;
    END;


GO
