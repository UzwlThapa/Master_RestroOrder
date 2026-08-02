SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETINVITEM_OrderLevel] 
@ParentId int
AS
BEGIN
select m.PITId, m.ITId, m.ITName, d.ROrderLevel
 from ROI_ITEMMain m  Inner Join ROI_ItemDetails d on m.ITId = d.ITId
 where m.ITId = @ParentId
end





GO
