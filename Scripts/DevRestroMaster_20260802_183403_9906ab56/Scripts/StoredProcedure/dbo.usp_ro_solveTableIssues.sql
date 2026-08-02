SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_solveTableIssues]
AS
    BEGIN
        DECLARE @tableId INT ,
                @isTable BIT;

        DECLARE @BookingDetail TABLE
        (   tableId INT ,
            OrderMasterID INT ,
            SalesMasterID INT ,
            minBookedDate DATETIME ,
            maxBookedDate DATETIME );

        DECLARE @cursor CURSOR;
        SET @cursor = CURSOR FOR
        SELECT restrotableId ,
               IsTable
        FROM   RO_restroTable;
        

        OPEN @cursor;

        FETCH NEXT FROM @cursor
        INTO @tableId ,
             @isTable;

        WHILE @@FETCH_STATUS = 0
            BEGIN
                DECLARE @ordermasterid INT;
                DECLARE @salesmasterid INT;
                DECLARE @minBookingDate DATETIME;
                DECLARE @maxBookingDate DATETIME;

                SET @ordermasterid = ( SELECT MAX (om.OrderMasterID)
                                       FROM   RO_OrderMasters om
                                              INNER JOIN RO_Order_Detail od ON od.OrderMasterId = om.OrderMasterID
                                       WHERE  om.TableId = @tableId
                                       AND    ISNULL (om.BillPaid, 0) = 0
                                       AND    ISNULL (om.IsCancelled, 0) = 0 );

                SET @salesmasterid = ( SELECT MAX (salesMasterId)
                                       FROM   RO_SalesMaster
                                       WHERE  TableId = @tableId
                                       AND    ISNULL (IsUpdated, 0) = 0
                                       AND    ISNULL (IsArchived, 0) = 0 );

                IF ( @isTable = 0 )
                    BEGIN
                        SELECT @minBookingDate = MAX (rb.BookedFrom) ,
                               @maxBookingDate = MAX (rb.BookedTo)
                        FROM   Ro_RoomBookings rb
                        WHERE  rb.TableId = @tableId;

                        INSERT INTO @BookingDetail
                        VALUES ( @tableId, @ordermasterid, @salesmasterid, @minBookingDate, @maxBookingDate );
                    END;

                IF ( @isTable = 1 )
                    BEGIN
                        IF ( ISNULL (@ordermasterid, 0) <> 0 )
                            BEGIN
                                UPDATE om
                                SET    om.BillPaid = 1
                                FROM   RO_SalesMaster sm
                                       INNER JOIN RO_OrderMasters om ON sm.OrderMasterId = om.OrderMasterID
                                WHERE  sm.OrderMasterId = @ordermasterid
                                AND    sm.IsUpdated = 1
                                AND    ISNULL (sm.IsArchived, 0) = 0;

                                UPDATE rt
                                SET    rt.restrotablesStatusID = 6
                                FROM   RO_SalesMaster sm
                                       INNER JOIN RO_restroTable rt ON  sm.TableId = rt.restrotableId
                                                                    AND rt.restrotableId = @tableId
                                WHERE  sm.OrderMasterId = @ordermasterid
                                AND    sm.IsUpdated = 1
                                AND    ISNULL (sm.IsArchived, 0) = 0;
                            END;
                        ELSE
                            BEGIN
                                UPDATE RO_restroTable
                                SET    restrotablesStatusID = ( CASE WHEN ISNULL (@ordermasterid, 0) = 0
                                                                     AND  ISNULL (@salesmasterid, 0) = 0 THEN 6
                                                                     ELSE 7
                                                                END )
                                WHERE  restrotableId = @tableId;
                            END;
                    END;
                ELSE
                    BEGIN

                        IF ( EXISTS ( SELECT 1
                                      FROM   Ro_RoomBookings rb
                                             INNER JOIN RO_OrderMasters om ON rb.OrderMasterId = om.OrderMasterID
                                             LEFT JOIN RO_SalesMaster sm ON  om.OrderMasterID = sm.OrderMasterId
                                                                         AND sm.IsUpdated = 0
                                      WHERE  rb.TableId = @tableId
                                      AND    om.BillPaid = 0
                                      AND    rb.IsCancelled = 0
                                      AND    ( GETDATE () BETWEEN rb.BookedFrom AND rb.BookedTo )))
                            BEGIN
                                UPDATE RO_restroTable
                                SET    restrotablesStatusID = 7
                                WHERE  restrotableId = @tableId;
                            END;
                        ELSE
                            BEGIN
                                UPDATE RO_restroTable
                                SET    restrotablesStatusID = 6
                                WHERE  restrotableId = @tableId;
                            END;

                    END;

                FETCH NEXT FROM @cursor
                INTO @tableId ,
                     @isTable;
            END;

        CLOSE @cursor;
        DEALLOCATE @cursor;
 
        UPDATE om
        SET    om.IsCancelled = 1
        FROM   RO_OrderMasters om
               INNER JOIN RO_restroTable rt ON om.TableId = rt.restrotableId
               LEFT JOIN RO_Order_Detail od ON od.OrderMasterId = om.OrderMasterID
        WHERE  rt.IsTable = 1
        AND    od.OrderDetailsID IS NULL;
    END;

GO
