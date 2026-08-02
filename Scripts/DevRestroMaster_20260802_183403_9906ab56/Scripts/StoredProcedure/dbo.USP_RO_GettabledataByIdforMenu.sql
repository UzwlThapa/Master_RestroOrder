SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[USP_RO_GettabledataByIdforMenu] 9  
CREATE PROCEDURE [dbo].[USP_RO_GettabledataByIdforMenu]
    @TableId INT
AS
    BEGIN
        DECLARE @val VARCHAR (90);

        SET @val = dbo.fn_getMaxMasterId (@TableId);
        SELECT   *
        FROM     ( SELECT --od.OrderDetailsID
                            od.OrderMasterId ,
                            SUM (od.Quantity) AS Quantity ,
                            od.Rate ,
                            SUM (od.Amount) AS Amount ,
                            od.SeatNo ,
                            om.OrderNo ,
                            od.CostCenterId ,
                            it.ITId AS ItemId ,
                            it.ITName ,
                            ir.SRate ,
                            rt.restrotableId ,
                            rt.restrotableTitle ,
                            om.IsSplit ,
                            0 AS isCombo ,
                            ISNULL (om.GuestNo, 1) AS GuestNo ,
                            ( SELECT STUFF (( SELECT '/' + restrotableTitle
                                              FROM   RO_restroTable mrt
                                                     INNER JOIN RO_MergeTable mtm ON mrt.restrotableId = mtm.TableID
                                              WHERE  mtm.MergeTableList = rt.restrotableId
                                            FOR XML PATH (''), TYPE ).value ('.', 'NVARCHAR(MAX)') ,
                                            1 ,
                                            1 ,
                                            '')) AS Note
                   FROM     dbo.RO_Order_Detail od
                            INNER JOIN dbo.ROI_ITEMMain it ON it.ITId = od.ROI_ItemId
                            LEFT JOIN dbo.ROI_ItemRate ir ON ir.ItemID = od.ROI_ItemId
                            INNER JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = @val
                            INNER JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
                            LEFT JOIN dbo.RO_MergeTable mt ON mt.TableID = rt.restrotableId
                   --LEFT JOIN DBO.RO_COMBO C ON C.ComboID = OD.ItemId  
                   WHERE    om.TableId = @TableId
                   AND      om.BillPaid = 0
                   AND      om.IsCancelled = 0
                   AND      od.Quantity != 0
                   AND      od.IsCancelled = 0
                   AND      od.OrderMasterId = @val
                   AND      ISNULL (od.BillPaid, 0) = 0
                   AND      od.IsCombo = 0
                   GROUP BY ISNULL (om.GuestNo, 1) ,
                            od.OrderMasterId ,
                            od.Rate ,
                            od.SeatNo ,
                            om.OrderNo ,
                            od.CostCenterId ,
                            it.ITId ,
                            it.ITName ,
                            ir.SRate ,
                            rt.restrotableId ,
                            rt.restrotableTitle ,
                            om.IsSplit
                   UNION
                   SELECT --od.OrderDetailsID
                            od.OrderMasterId ,
                            SUM (od.Quantity) AS Quantity ,
                            od.Rate ,
                            SUM (od.Amount) AS Amount ,
                            od.SeatNo ,
                            om.OrderNo ,
                            od.CostCenterId ,
                            it.ComboID AS ItemId ,
                            it.Name AS ITName ,
                            it.SalesPrice AS SRate ,
                            rt.restrotableId ,
                            rt.restrotableTitle ,
                            om.IsSplit ,
                            1 AS isCombo ,
                            ISNULL (om.GuestNo, 1) AS GuestNo ,
                            ( SELECT STUFF (( SELECT '/' + restrotableTitle
                                              FROM   RO_restroTable mrt
                                                     INNER JOIN RO_MergeTable mtm ON mrt.restrotableId = mtm.TableID
                                              WHERE  mtm.MergeTableList = rt.restrotableId
                                            FOR XML PATH (''), TYPE ).value ('.', 'NVARCHAR(MAX)') ,
                                            1 ,
                                            1 ,
                                            '')) AS Note
                   FROM     dbo.RO_Order_Detail od
                            INNER JOIN dbo.RO_Combo it ON it.ComboID = od.ROI_ItemId
                            INNER JOIN dbo.RO_OrderMasters om ON om.OrderMasterID = @val
                            INNER JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
                            LEFT JOIN dbo.RO_MergeTable mt ON mt.TableID = rt.restrotableId
                   --LEFT JOIN DBO.RO_COMBO C ON C.ComboID = OD.ItemId  
                   WHERE    om.TableId = @TableId
                   AND      om.BillPaid = 0
                   AND      om.IsCancelled = 0
                   AND      od.Quantity != 0
                   AND      od.IsCancelled = 0
                   AND      od.OrderMasterId = @val
                   AND      ISNULL (od.BillPaid, 0) = 0
                   AND      od.IsCombo = 1
                   GROUP BY ISNULL (om.GuestNo, 1) ,
                            od.OrderMasterId ,
                            od.Rate ,
                            od.SeatNo ,
                            om.OrderNo ,
                            od.CostCenterId ,
                            it.ComboID ,
                            it.Name ,
                            it.SalesPrice ,
                            rt.restrotableId ,
                            rt.restrotableTitle ,
                            om.IsSplit ) x
        ORDER BY x.ITName ASC;

    END;

GO
