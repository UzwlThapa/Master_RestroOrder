SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--drop PROCEDURE [dbo].[USP_GetCompDataFromCostCenterID] 
CREATE PROCEDURE [dbo].[USP_GetCompDataFromCostCenterID] 
@CostCenterId INT
AS
SELECT DISTINCT it.ITId
	,
	-- ROI_ItemId as ItemId,  
	itd.ImagePath
	,od.CompId
	,(od.Note + 'Extra : ' + stuff( (SELECT ','+ p2.ExtraItem + '('+CAST(p2.Quantity as varchar(10))  +')' 
               FROM Comp_ExtraItem p2
               WHERE p2.CompMasterID = od.CompMasterID
               ORDER BY CompMasterID
               FOR XML PATH(''), TYPE).value('.', 'varchar(max)')
            ,1,1,'')) as Note

	,iis.ItemStatus
	,iis.StatusID
	,it.ITName
	,od.Quantity
	,om.BillPaid
	,od.IsCancelled
	,rr.restroRoom
	,rt.restrotableTitle
	,od.IsRunningOrder
	,od.DATE
	,CAST(LEFT(CONVERT(TIME(0), od.DATE), 5) AS VARCHAR(128)) AS billtime
	,om.CompMasterID
	,IsCombo = 0
FROM ROI_ITEMMain it
JOIN RO_ComplementaryItems od ON it.ITId = od.ROI_ItemId
INNER JOIN ROI_ItemDetails itd ON it.ITId = itd.ITId
LEFT JOIN ROI_ItemRate ir ON it.ITId = ir.ItemID
JOIN tblComplementaryMaster om ON om.CompMasterID = od.CompMasterID
JOIN CompItemStatus os ON os.CompId = od.CompId
JOIN dbo.RO_ItemStatus iis ON iis.StatusID = os.StatusID
LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
WHERE itd.ItemCostCentreID = @CostCenterId
	--AND om.BillPaid = 0
	AND CONVERT(DATE, od.DATE) = CONVERT(DATE, getdate())
	--AND iis.StatusID != 3
	AND IsCombo = 0

UNION

SELECT DISTINCT
	--it.ITId,
	cm.ComboID
	,
	cm.ImagePath
	,od.CompId
	,od.Note
	,iis.ItemStatus
	,iis.StatusID
	,
	--it.ITName,
	cm.NAME
	,od.Quantity
	,om.BillPaid
	,od.IsCancelled
	,rr.restroRoom
	,rt.restrotableTitle
	,od.IsRunningOrder
	,od.DATE
	,CAST(LEFT(CONVERT(TIME(0), om.DATE), 5) AS VARCHAR(128)) AS billtime
	,om.CompMasterID
	,IsCombo = 1
FROM
	--ROI_ITEMMain it join
	RO_ComplementaryItems od
--ON it.ITId = od.ROI_ItemId
JOIN RO_Combo cm ON cm.ComboID = od.ROI_ItemId
--Inner Join ROI_ItemDetails itd ON it.ITId = itd.ITId
--left JOIN ROI_ItemRate ir ON it.ITId = ir.ItemID
JOIN tblComplementaryMaster om ON om.CompMasterID = od.CompMasterID
JOIN CompItemStatus os ON os.CompId = od.CompId
JOIN dbo.RO_ItemStatus iis ON iis.StatusID = os.StatusID
LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = om.TableId
LEFT JOIN dbo.RO_RestroRoom rr ON rr.restroRoomId = om.RoomId
--WHERE itd.ItemCostCentreID=@CostCenterId AND om.BillPaid = 0 
WHERE cm.CostCenterID = @CostCenterId
	--AND om.BillPaid = 0
	AND CONVERT(DATE, od.DATE) = CONVERT(DATE, getdate())
	--AND iis.StatusID != 3
	AND IsCombo = 1
ORDER BY od.DATE DESC



GO
