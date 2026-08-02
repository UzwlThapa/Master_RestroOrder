SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_GetComplimentaryOccupiedTables]
    @isTable BIT = 0
AS
    SELECT   cm.CompMasterID AS OrderMasterId ,
             rr.restroRoom ,
             rt.restrotableTitle ,
             cm.BasicAmount AS Amount ,
             cm.[Date] AS tableDate ,
             cm.GuestNo ,
             1 AS IsTable ,
             rt.restrotableId ,
             cm.Details
    FROM     dbo.tblComplementaryMaster cm
             INNER JOIN dbo.RO_restroTable rt ON cm.TableId = rt.restrotableId
             INNER JOIN dbo.RO_RestroRoom rr ON rt.restroRoomId = rr.restroRoomId
    WHERE    CAST(cm.[Date] AS DATE) >= DATEADD (DAY, -1, CAST(GETDATE () AS DATE)) ----showing only for today and yesterday records
    ORDER BY cm.[Date] DESC;


GO
