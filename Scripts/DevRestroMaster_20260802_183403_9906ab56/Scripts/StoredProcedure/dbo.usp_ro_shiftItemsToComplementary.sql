SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- usp_ro_shiftItems 23,1,2,1,'superuser',13,1,false
CREATE PROCEDURE [dbo].[usp_ro_shiftItemsToComplementary]
    @CompId INT ,
    @fromTable INT ,
    @fromSplitNo INT ,
    @shiftedBy NVARCHAR (MAX) ,
    @ItemId INT ,
    @Quantity FLOAT ,
    @IsCombo BIT
AS
    BEGIN
        DECLARE @orderdetail INT ,
                @qnty INT ,
                @QntyToShift INT ,
                @oldOrderMasterId INT ,
                @Rate DECIMAL (18, 2);
        DECLARE @continue BIT = 0;

        SELECT @QntyToShift = @Quantity;

        SET @oldOrderMasterId = ( SELECT MAX (OrderMasterID)
                                  FROM   dbo.RO_OrderMasters
                                  WHERE   TableId = @fromTable
                                  AND    ISNULL (BillPaid, 0) = 0
                                  AND    ISNULL (IsCancelled, 0) = 0 );

        INSERT INTO dbo.RO_ItemShiftLog ( FromTable ,
                                      FromSplitNo ,
                                      ToTable ,
                                      ToSplitNo ,
                                      ShiftedBy ,
                                      ItemId ,
                                      Quantity ,
                                      IsCombo ,
                                      ShiftedOn ,
                                      OrderMasterId )
        VALUES ( @fromTable, @fromSplitNo, 0, 0, @shiftedBy, @ItemId, @Quantity, @IsCombo, GETDATE () ,
                 @oldOrderMasterId );

        WHILE ( @continue = 0 )
            BEGIN

                SELECT   TOP ( 1 ) @orderdetail = OrderDetailsID ,
                                   @qnty = Quantity ,
                                   @Rate = Rate
                FROM     dbo.RO_Order_Detail od
                WHERE    od.ROI_ItemId = @ItemId
                AND      od.IsCombo = @IsCombo
                AND      od.IsCancelled = 0
                AND      od.SeatNo = @fromSplitNo
                AND      od.OrderMasterId = @oldOrderMasterId
                ORDER BY OrderDetailsID DESC;

                IF ( @qnty < @Quantity
                  OR @qnty = @Quantity )
                    BEGIN
                        UPDATE dbo.RO_Order_Detail
                        SET    IsCancelled = 1
                        WHERE  OrderDetailsID = @orderdetail;

                        SET @Quantity = ( @Quantity - @qnty );

                        IF ( @Quantity > 0 )
                            SET @continue = 0;
                        ELSE
                            SET @continue = 1;
                    END;
                ELSE
                    BEGIN
                        UPDATE dbo.RO_Order_Detail
                        SET    Quantity = ( Quantity - @Quantity )
                        WHERE  OrderDetailsID = @orderdetail
                        AND    SeatNo = @fromSplitNo;

                        SET @continue = 1;
                    END;
            END;

        IF OBJECT_ID ('tempdb..#Cancelled1') IS NOT NULL
            DROP TABLE #Cancelled1;

        IF OBJECT_ID ('tempdb..#BillPaid1') IS NOT NULL
            DROP TABLE #BillPaid1;

        SELECT ISNULL (od.IsCancelled, 0) AS IsCancelled
        INTO   #Cancelled1
        FROM   dbo.RO_OrderMasters om
               INNER JOIN dbo.RO_Order_Detail od ON om.OrderMasterID = od.OrderMasterId
        WHERE  om.OrderMasterID = @oldOrderMasterId
        AND    od.SeatNo = @fromSplitNo;

        SELECT ISNULL (od.BillPaid, 0) AS BillPaid
        INTO   #BillPaid1
        FROM   dbo.RO_OrderMasters om
               INNER JOIN dbo.RO_Order_Detail od ON om.OrderMasterID = od.OrderMasterId
        WHERE  om.OrderMasterID = @oldOrderMasterId
        AND    od.SeatNo = @fromSplitNo;

        --select * from #Cancelled1

        IF NOT EXISTS ( SELECT *
                        FROM   #Cancelled1
                        WHERE  IsCancelled = 0 )
            BEGIN
                UPDATE dbo.RO_OrderMasters
                SET    IsCancelled = 1
                WHERE  OrderMasterID = @oldOrderMasterId;
            END;
        ELSE IF EXISTS ( SELECT *
                         FROM   #BillPaid1
                         WHERE  BillPaid = 1 )
                 BEGIN
                     UPDATE dbo.RO_OrderMasters
                     SET    BillPaid = 1
                     WHERE  OrderMasterID = @oldOrderMasterId;
                 END;


        EXEC dbo.[USP_SAVECOMPLEMENTARYDETAIL] @CompId ,
                                           @ItemId ,
                                           @Rate ,
                                           0 ,
                                           @QntyToShift ,
                                           0 ,
                                           '' ,
                                           0 ,
                                           0 ,
                                           0 ,
                                           1 ,
                                           '' ,
                                           0 ,
                                           @IsCombo;
        EXEC dbo.[usp_ro_solveTableIssues];
    END;

GO
