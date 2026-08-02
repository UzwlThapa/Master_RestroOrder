SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETITEM]
AS
BEGIN
select RO_Items.ItemID, RO_Items.ItemName, RO_Items.ItemDescription, dbo.RO_Items.PhotoPath, dbo.RO_Items.Price, RO_Items.ItemCode, RO_Items.UnitID, RO_Items.CategoryID as CategoriesID, RO_Items.CostCenterID,    RO_Units.UnitName, dbo.RO_Categories.CategoriesName, CostCenterInfo.CostCenterName FROM dbo.RO_Items join RO_Units ON RO_Items.UnitID = RO_Units.UnitID  JOIN dbo.RO_Categories ON dbo.RO_Categories.CategoriesID = RO_Items.CategoryID
 JOIN dbo.CostCenterInfo ON dbo.CostCenterInfo.CostCenterId = RO_Items.CostCenterID

end





GO
