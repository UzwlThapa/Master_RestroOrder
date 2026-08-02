SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetUnitOfItemByID]
@ids int
as
select distinct ir.ItemID,u1.UnitDescription,u1.Symbol, id.IsExpirable, ir.LargeUnit
--,p.PurchaseDetailsID 
from ROI_ItemRate ir
 join ROI_Unit1 u1 on u1.Unit1Id=ir.LargeUnit
 join ROI_ItemDetails  id on id.ITId=ir.ItemID
 --join dbo.ROI_PurchaseDetails p on p.ItemID = ir.ItemID
 where ir.ItemID=@ids



GO
