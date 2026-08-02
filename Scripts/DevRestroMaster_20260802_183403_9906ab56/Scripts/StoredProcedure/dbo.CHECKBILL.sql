SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CHECKBILL]
    @OrderMasterId INT ,
    @SeatNo INT ,
    @TableId INT
AS
    DECLARE @IsCancelled BIT ,
            @BillPaid INT;

    IF OBJECT_ID ('tempdb..#BillPaid1') IS NOT NULL
        DROP TABLE #BillPaid1;

    SELECT ISNULL (BillPaid, 0) AS BillPaid
    INTO   #BillPaid1
    FROM   dbo.RO_Order_Detail od
    WHERE  od.OrderMasterId = @OrderMasterId
    AND    ( od.SeatNo = @SeatNo
          OR @SeatNo = 0 );

    IF EXISTS ( SELECT 1
                FROM   #BillPaid1 )
        IF EXISTS ( SELECT 1
                    FROM   #BillPaid1
                    WHERE  BillPaid = 0 )
            SET @BillPaid = 0;
        ELSE
            SET @BillPaid = 1;
    ELSE
        SET @BillPaid = 0;

    SELECT DISTINCT @IsCancelled = od.IsCancelled
    FROM   dbo.RO_OrderMasters om
           INNER JOIN dbo.RO_Order_Detail od ON om.OrderMasterID = od.OrderMasterId
    WHERE  om.OrderMasterID = @OrderMasterId
    AND    ( od.SeatNo = @SeatNo
          OR @SeatNo = 0 )
    AND    ( om.TableId = @TableId
          OR @TableId = 0 );

    IF OBJECT_ID ('tempdb..#Cancelled1') IS NOT NULL
        DROP TABLE #Cancelled1;

    SELECT od.IsCancelled
    INTO   #Cancelled1
    FROM   dbo.RO_OrderMasters om
           INNER JOIN dbo.RO_Order_Detail od ON om.OrderMasterID = od.OrderMasterId
    WHERE  om.OrderMasterID = @OrderMasterId
    AND    ( od.SeatNo = @SeatNo
          OR @SeatNo = 0 )
    AND    ( om.TableId = @TableId
          OR @TableId = 0 );
    --SELECT * FROM  #Cancelled

    IF EXISTS ( SELECT *
                FROM   #Cancelled1 )
        IF EXISTS ( SELECT *
                    FROM   #Cancelled1
                    WHERE  IsCancelled = 0 )
            SET @IsCancelled = 0;
        ELSE
            SET @IsCancelled = 1;
    ELSE
        SET @IsCancelled = 0;

    IF ( @TableId = 0 )
        BEGIN
            SELECT 'Your Ready to GenerateBill' AS ErrorMessage ,
                   200 AS ErrorNumber;
        END;
    ELSE IF EXISTS ( SELECT 1
                     FROM   dbo.RO_OrderMasters om
                            INNER JOIN dbo.RO_Order_Detail od ON om.OrderMasterID = od.OrderMasterId
                            INNER JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
                     WHERE  om.OrderMasterID = @OrderMasterId
                     AND    ( od.SeatNo = @SeatNo
                           OR @SeatNo = 0 )
                     AND    ( om.TableId = @TableId
                           OR @TableId = 0 )
                     AND    rt.IsTable = 1 )
             BEGIN
                 IF ( @IsCancelled = 0 )
                     BEGIN
                         IF NOT EXISTS ( SELECT 1
                                         FROM   dbo.RO_SalesMaster sm
                                         WHERE  sm.OrderMasterId = @OrderMasterId )
                             SELECT 'Your Ready to GenerateBill' AS ErrorMessage ,
                                    200 AS ErrorNumber;
                         ELSE IF ( @BillPaid = 1 )
                             SELECT 'Your Bill is already Generated' AS ErrorMessage ,
                                    100 AS ErrorNumber;
                         ELSE
                             SELECT 'Your Ready to GenerateBill' AS ErrorMessage ,
                                    200 AS ErrorNumber;
                     END;
                 ELSE
                     SELECT 'Your Order is already cancelled' AS ErrorMessage ,
                            100 AS ErrorNumber;
             END;
    ELSE IF EXISTS ( SELECT 1
                     FROM   dbo.Ro_RoomBookings rm
                            INNER JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = rm.OrderMasterId
                     WHERE  om.OrderMasterID = @OrderMasterId
                     AND    rm.IsCancelled = 0
                     AND    om.BillPaid = 0 )
             BEGIN
                 SELECT 'Your Ready to GenerateBill' AS ErrorMessage ,
                        200 AS ErrorNumber;

             END;
    ELSE
        SELECT 'This table is not available to do this action' AS ErrorMessage ,
               100 AS ErrorNumber;

GO
