SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_ComplementarySALESREPORT] --'09/18/2019 00:00', '09/18/2019 23:59', 0, 0,'',0
@Start DateTime,
 @End DateTime,
 @tableid int,
 @roomid int,
 @itemname varchar(250)
 --@pitid int
 as
 BEGIN
 If @itemname<>''
	SET @itemname= '%'+ @itemname+'%'
SELECT 
 SM.Date
,SM.Quantity
,SM.Rate as rate
,SM.IsCombo 
,CI.Details
,sum(SM.Quantity * SM.Rate) NetAmount
,CCI.CostCenterName
,IM.ITName
,ru.Symbol as ITUnit
,rt.restrotableTitle
FROM RO_ComplementaryItems SM
inner join tblComplementaryMaster CI ON SM.CompMasterID=CI.CompMasterID
INNER JOIN ROI_ITEMMain IM ON IM.ITId = SM.ROI_ItemId
left join CostCenterInfo CCI on CCI.CostCenterId = SM.CostCenterId
left join ROI_ItemDetails itd on Im.ITId=itd.ITId
left join ROI_Unit1 ru on ru.Unit1Id=itd.SmallUnit
left join RO_restroTable rt on rt.restrotableId = CI.TableId
left join RO_RestroRoom rm on rm.restroRoomId = RoomId
WHERE SM.IsCombo = 0 
AND (SM.Date BETWEEN @Start AND @End)
AND (CI.RoomId= @roomid or @roomid=0)
AND (CI.TableId = @tableid or @tableid=0)
And (IM.ITName like @itemname OR @itemname ='')
--AND (IM.PITId = @pitid or @pitid=0)
GROUP BY SM.Date,CCI.CostCenterName ,IM.ITName,SM.Rate,SM.IsCombo,CI.Details,ru.Symbol,SM.Quantity,rt.restrotableTitle

UNION 
SELECT 
 SM.Date
,SM.Quantity
,SM.Rate as rate
,SM.IsCombo 
,CI.Details
,sum(SM.Quantity * SM.Rate) NetAmount
,CCI.CostCenterName
,CO.Name
,ru.Symbol as ITUnit
,rt.restrotableTitle
FROM RO_ComplementaryItems SM
inner join tblComplementaryMaster CI ON SM.CompMasterID=CI.CompMasterID
INNER JOIN RO_Combo CO ON CO.ComboID = SM.ROI_ItemId
left join CostCenterInfo CCI on CCI.CostCenterId = SM.CostCenterId
left join RO_ComboDetails ctd on CO.ComboID=ctd.ComboID
left join ROI_ItemDetails itd on ctd.ItemID = itd.ITId
left join ROI_Unit1 ru on ru.Unit1Id=itd.SmallUnit
left join RO_restroTable rt on rt.restrotableId = CI.TableId
left join RO_RestroRoom rm on rm.restroRoomId = RoomId
WHERE SM.IsCombo = 1
AND (SM.Date BETWEEN @Start AND @End)
AND (CI.RoomId= @roomid or @roomid=0)
AND (CI.TableId = @tableid or @tableid=0)
And (CO.Name like @itemname OR @itemname ='')
GROUP BY SM.Date,CCI.CostCenterName ,CO.Name,SM.Rate,SM.IsCombo,CI.Details,ru.Symbol,SM.Quantity,rt.restrotableTitle
END


GO
