SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[usp_roi_viewItemByID] 4707
CREATE PROCEDURE [dbo].[usp_roi_viewItemByID]
@ids int
as
select ir.SRate,ir.ValidFrom,ir.PostedBy,ir.PostedOn from ROI_ItemRate ir
where ir.ItemID=@ids



GO
