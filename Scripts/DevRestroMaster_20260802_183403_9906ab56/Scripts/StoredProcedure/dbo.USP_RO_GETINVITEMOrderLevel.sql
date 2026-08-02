SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETINVITEMOrderLevel]
@ParentId int
AS
BEGIN
select m.PITId as parentId,m.ITId as ItemId, m.ITName as ItemName , d.ROrderLevel as OrderLevel
 from ROI_ITEMMain m  Inner Join ROI_ItemDetails d on m.ITId = d.ITId
 where m.ITId = @ParentId
end




GO
