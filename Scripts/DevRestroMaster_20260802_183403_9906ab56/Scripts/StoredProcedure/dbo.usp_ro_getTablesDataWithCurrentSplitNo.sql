SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_getTablesDataWithCurrentSplitNo]
AS
    SELECT rt.restrotableId ,
           rt.restrotableTitle ,
           rt.restroRoomId ,
           rt.restrotablesStatusID ,
           rt.Seatcap ,
           rt.IsTable ,
           rt.Rate ,
           ISNULL (om.GuestNo, 0) AS GuestNo
    FROM   dbo.RO_restroTable rt
           LEFT JOIN dbo.RO_OrderMasters om ON  om.TableId = rt.restrotableId
                                            AND om.OrderMasterID = ( SELECT MAX (om2.OrderMasterID)
                                                                     FROM   dbo.RO_OrderMasters om2
                                                                     WHERE  om2.TableId = rt.restrotableId
                                                                     AND    ISNULL (om2.BillPaid, 0) = 0
                                                                     AND    ISNULL (om2.IsCancelled, 0) = 0 )
           LEFT JOIN dbo.RO_MergeTable mt ON rt.restrotableId = mt.TableID
    WHERE  ( ( rt.restrotablesStatusID = 7
           AND ISNULL (om.BillPaid, 0) = 0 )
          OR rt.restrotablesStatusID = 6 )
    AND    ( rt.restrotableId = mt.MergeTableList
          OR mt.MergeTableList = 0
          OR mt.MergeTableList IS NULL );

GO
