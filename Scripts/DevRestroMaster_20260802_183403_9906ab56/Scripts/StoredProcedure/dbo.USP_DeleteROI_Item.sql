SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_DeleteROI_Item]
CREATE PROCEDURE [dbo].[USP_DeleteROI_Item]
@Itemid int,
@ArchivedBy nvarchar(256)
as
begin
--delete from dbo.ROI_ITEMMain where ITId=@Itemid
--delete from dbo.ROI_ItemDetails where  ITId=@Itemid
update dbo.ROI_ITEMMain
set isArchived=1
,ArchivedBy=@ArchivedBy
,ArchivedOn=GETDATE()
 where ITId=@Itemid

 update dbo.ROI_ItemDetails
set isArchived=1
,ArchivedBy=@ArchivedBy
,ArchivedOn=GETDATE()
 where ITId=@Itemid

 update dbo.ROI_ITEMMain
set isArchived=1
,ArchivedBy=@ArchivedBy
,ArchivedOn=GETDATE()
 where PITID=@Itemid

 UPDATE ROI_ItemDetails
SET ROI_ItemDetails.isArchived=1
,ROI_ItemDetails.ArchivedBy=@ArchivedBy
,ROI_ItemDetails.ArchivedOn=GETDATE()
FROM ROI_ITEMMain T1, ROI_ItemDetails T2
WHERE T1.ITId = t2.ITId
and T1.PITId = @Itemid

 delete from StoreItemMinimumStock where ItemId=@Itemid
end

GO
