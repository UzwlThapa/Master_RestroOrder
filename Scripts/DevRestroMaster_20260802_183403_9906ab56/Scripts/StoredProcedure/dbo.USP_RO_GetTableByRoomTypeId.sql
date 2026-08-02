SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec sp_rename USP_RO_GetTableByRoomTypeId 3,'USP_RO_GetTableByRoomTypeId_backup2'
-- drop PROCEDURE [dbo].[USP_RO_GetTableByRoomTypeId] 3
CREATE PROCEDURE [dbo].[USP_RO_GetTableByRoomTypeId]
    @RoomTypeId INT
AS
    IF OBJECT_ID ('tempdb..#MaxOrderMaster') IS NOT NULL
        DROP TABLE #MaxOrderMaster;

    IF OBJECT_ID ('tempdb..#RoomBooking') > 0
        DROP TABLE #RoomBooking;


    SELECT   om.TableId ,
             MAX (om.OrderMasterID) AS OrderMasterId
    INTO     #MaxOrderMaster
    FROM     dbo.RO_OrderMasters om
    WHERE    ISNULL (BillPaid, 0) = 0
    AND      ISNULL (IsCancelled, 0) = 0
    GROUP BY TableId;

    SELECT rb.TableId ,
           rb.OrderMasterId ,
           rb.BookedFrom ,
           rb.BookedTo
    INTO   #RoomBooking
    FROM   Ro_RoomBookings rb
           INNER JOIN ( SELECT   rb.TableId ,
                                 MAX (rb.OrderMasterId) AS OrderMasterId
                        FROM     Ro_RoomBookings rb
                                 INNER JOIN RO_OrderMasters om ON om.OrderMasterID = rb.OrderMasterId
                        WHERE    rb.BookedFrom <= GETDATE ()
                        AND      rb.BookedTo >= GETDATE ()
                        AND      om.BillPaid != 1
                        AND      om.IsCancelled != 1
                        GROUP BY rb.TableId ) AS mrb ON  rb.TableId = mrb.TableId
                                                     AND rb.OrderMasterId = mrb.OrderMasterId;



    SELECT rt.restrotableId ,
           rt.restrotableTitle ,
           rt.restroRoomId ,
           --CASE WHEN om.OrderCount >0 THEN 7 ELSE rt.restrotablesStatusID END restrotablesStatusID, 
           rt.restrotablesStatusID ,
           rt.Seatcap ,
           rt.IsTable ,
           rt.Rate ,
           CONVERT (CHAR (5), COALESCE (om.[Date], rb.BookedFrom), 108) AS TableTime ,
           COALESCE (om.[Date], rb.BookedFrom) AS TableDate ,
           ( CASE WHEN ( rt.restrotablesStatusID = 7
                     AND om.BillPaid IS NULL
                     AND rt.IsTable = 1 ) THEN 1
                  WHEN ( rt.restrotablesStatusID = 7
                     AND ( GETDATE () BETWEEN rb.BookedFrom AND rb.BookedTo )) THEN 0
                  ELSE ISNULL (om.BillPaid, 0)
             END ) AS BillPaid ,
           om.IsCancelled ,
           rr.restroRoom ,
           mt.MergeID ,
           mt.TableID ,
           rt.IsTable ,
           ISNULL (mt.MergeTableList, 0) AS MergeTableList ,
           ( SELECT STUFF (( SELECT '/' + restrotableTitle
                             FROM   RO_restroTable mrt
                                    INNER JOIN RO_MergeTable mtm ON mrt.restrotableId = mtm.TableID
                             WHERE  mtm.MergeTableList = mt.TableID
                           FOR XML PATH (''), TYPE ).value ('.', 'NVARCHAR(MAX)') ,
                           1 ,
                           1 ,
                           '')) AS MergeTableName ,
           ISNULL (rb.OrderMasterId, omm.OrderMasterId) AS OrderMasterId ,
           om.GuestNo
    FROM   dbo.RO_restroTable rt
           INNER JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId = rt.restroRoomId
           LEFT JOIN dbo.RO_MergeTable mt ON mt.TableID = rt.restrotableId
           LEFT JOIN ( SELECT   m.OrderMasterID ,
                                m.TableId ,
                                m.BillPaid ,
                                m.[Date] ,
                                m.IsCancelled ,
                                COUNT (d.OrderDetailsID) AS OrderCount ,
                                m.GuestNo
                       FROM     dbo.RO_OrderMasters m
                                INNER JOIN #MaxOrderMaster mom ON mom.TableId = m.TableId
                                INNER JOIN RO_Order_Detail d ON  d.OrderMasterId = mom.OrderMasterId
                                                             AND d.IsCancelled = 0
                                                             AND mom.OrderMasterId = m.OrderMasterID
                       GROUP BY m.OrderMasterID ,
                                m.TableId ,
                                m.BillPaid ,
                                m.[Date] ,
                                m.IsCancelled ,
                                m.GuestNo ) om ON om.TableId = rt.restrotableId
           LEFT JOIN #RoomBooking rb ON rt.restrotableId = rb.TableId
           LEFT JOIN #MaxOrderMaster omm ON omm.TableId = rt.restrotableId
           LEFT JOIN dbo.RO_restroTable mrt ON mrt.restrotableId = mt.MergeTableList
    WHERE  rt.restroRoomId = @RoomTypeId;
--Order By rt.restrotableTitle


GO
