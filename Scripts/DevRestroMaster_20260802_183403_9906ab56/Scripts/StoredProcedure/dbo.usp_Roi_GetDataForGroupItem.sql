SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Roi_GetDataForGroupItem]
as
select 
--distinct im.ITId,
distinct ig.GroupID,
ig.GroupName,
 --gwi.ItemID,
 ig.GroupID
 ,ig.GroupName
 ,ig.GroupCode
--,im.ITName
from Roi_ItemGroup ig
join Roi_GroupWithItem gwi on ig.GroupID=gwi.GroupID
left join ROI_ITEMMain im on im.ITId=gwi.ItemID  where gwi.IsArchived=0



GO
