SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
====================================
	Author: Unknown
    Creadted Date: Unknown
	Last Modified By: Yawahang
	Last Modified Date: 12/12/2023
====================================

	EXEC dbo.USP_RO_BillCancelReason

*/
CREATE PROCEDURE [dbo].[USP_RO_BillCancelReason]
    @salesMasterId INT ,
    @Reasons NVARCHAR (MAX) ,
    @userName NVARCHAR (256)
AS
    BEGIN

        ALTER TABLE RO_SalesMaster DISABLE TRIGGER [RO_SalesMaster_UPDATE];

        UPDATE RO_SalesMaster
        SET    BillCancelled = 1 ,
               ArchivedBy = @userName ,
               CusName = '(Cancellation)' ,
               CusID = -1 ,
               ArchivedOn = GETDATE () ,
               Reasons = @Reasons ,
               BasicAmount = 0 ,
               TermAmount = 0 ,
               NetAmount = 0 ,
               totaldiscount = 0 ,
               RoomRate = 0 ,
               RoomCharge = 0 ,
               AdvancePayment = 0 ,
               TenderAmount = 0 ,
               ReturnAmount = 0
        WHERE  salesMasterId = @salesMasterId;

        ALTER TABLE RO_SalesMaster ENABLE TRIGGER [RO_SalesMaster_UPDATE];

        UPDATE RO_BillingAmount
        SET    Amount = 0
        WHERE  SalesMasterID = @salesMasterId;


        UPDATE RO_Order_Detail
        SET    IsCancelled = 1
        WHERE  OrderMasterId = ( SELECT OrderMasterId
                                 FROM   RO_SalesMaster
                                 WHERE  salesMasterId = @salesMasterId )
        AND    SeatNo = ( SELECT SeatNo
                          FROM   RO_SalesMaster
                          WHERE  salesMasterId = @salesMasterId );


        -- reset sales quantity while bill is cancelled
		
        ALTER TABLE RO_SalesDetail DISABLE TRIGGER [RO_SalesDetail_Delete];
        UPDATE rsd
        SET    rsd.qty = 0
        FROM   dbo.RO_SalesDetail AS rsd
        WHERE  rsd.salesMasterId = @salesMasterId;
		
        ALTER TABLE RO_SalesDetail ENABLE TRIGGER [RO_SalesDetail_Delete];

        UPDATE rsd
        SET    rsd.Quantity = 0
        FROM   dbo.RO_CakeSalesDetail AS rsd
        WHERE  rsd.SalesMasterId = @salesMasterId;

        EXEC usp_ro_solveTableIssues;
    END;

GO
