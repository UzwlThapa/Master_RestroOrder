SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC  dbo.USP_RO_GetOccupiedTables 1
CREATE PROCEDURE [dbo].[USP_RO_GetOccupiedTables]
    @isTable BIT
AS
    IF OBJECT_ID ('tempdb..#MaxOrderMaster1') IS NOT NULL
        DROP TABLE #MaxOrderMaster1;


    SELECT   TableId ,
             MAX (OrderMasterID) AS OrderMasterId
    INTO     #MaxOrderMaster1
    FROM     dbo.RO_OrderMasters
    WHERE    BillPaid <> 1
    AND      IsCancelled <> 1
    GROUP BY TableId;


    IF OBJECT_ID ('tempdb..#OMAmount') IS NOT NULL
        DROP TABLE #OMAmount;

    SELECT   od.OrderMasterId ,
             SUM (od.Quantity * od.Rate) AS Amount
    INTO     #OMAmount
    FROM     dbo.RO_Order_Detail od
             INNER JOIN #MaxOrderMaster1 omMax ON od.OrderMasterId = omMax.OrderMasterId
    WHERE    ( od.BillPaid = 0
            OR od.BillPaid IS NULL )
    AND      od.IsCancelled = 0
    GROUP BY od.OrderMasterId;


    SELECT DISTINCT rr.restrotableId ,
                    rr.restrotableTitle ,
                    rr.restroRoomId ,
                    rr.restrotablesStatusID ,
                    rr.Seatcap ,
                    rr.IsTable ,
                    rr.Rate ,
                    r.restroRoom ,
                    CONVERT (CHAR (5), om.[Date], 108) AS tabletime ,
                    om.[Date] AS tableDate ,
                    mt.MergeID ,
                    mt.TableID ,
                    ( SELECT STUFF (( SELECT '/' + restrotableTitle
                                      FROM   dbo.RO_restroTable mrt
                                             INNER JOIN RO_MergeTable mtm ON mrt.restrotableId = mtm.TableID
                                      WHERE  mtm.MergeTableList = rr.restrotableId
                                    FOR XML PATH (''), TYPE ).value ('.', 'NVARCHAR(MAX)') ,
                                    1 ,
                                    1 ,
                                    '')) AS MergeTableName ,
                    om.OrderMasterID AS OrderMasterId ,
                    ISNULL (om.GuestNo, 1) AS GuestNo ,
                    Amount ,
                    ISNULL (mt.MergeTableList, 0) AS MergeTableList ,
                    ot.TokenNo
    INTO   #temp
    FROM   dbo.RO_restroTable rr
           INNER JOIN dbo.RO_RestroRoom r ON r.restroRoomId = rr.restroRoomId
           LEFT JOIN ( SELECT m.*
                       FROM   dbo.RO_OrderMasters m
                              INNER JOIN #MaxOrderMaster1 mom ON  mom.TableId = m.TableId
                                                              AND mom.OrderMasterId = m.OrderMasterID ) om ON om.TableId = rr.restrotableId
           INNER JOIN #OMAmount oma ON oma.OrderMasterId = om.OrderMasterID
           LEFT JOIN dbo.RO_MergeTable mt ON mt.TableID = rr.restrotableId
           LEFT JOIN dbo.RO_OrderToken ot ON om.OrderMasterID = ot.OrderMasterID
    WHERE  om.BillPaid = 0
    AND    rr.restrotableId <> 0
    AND    om.IsCancelled = 0
    AND    rr.IsTable = @isTable;

    SELECT   restrotableId ,
             CASE WHEN MergeTableList = 0 THEN restrotableTitle
                  ELSE MergeTableName
             END AS restrotableTitle ,
             restroRoomId ,
             restrotablesStatusID ,
             Seatcap ,
             IsTable ,
             Rate ,
             restroRoom ,
             tabletime ,
             tableDate ,
             MergeID ,
             TableID ,
             MergeTableName ,
             OrderMasterId ,
             GuestNo ,
             Amount ,
             MergeTableList
    FROM     #temp
    ORDER BY tableDate DESC;

    DROP TABLE #temp;

GO
