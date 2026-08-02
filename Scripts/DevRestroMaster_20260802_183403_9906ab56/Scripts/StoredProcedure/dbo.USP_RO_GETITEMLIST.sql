SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETITEMLIST]
AS
BEGIN
select *
from dbo.RO_Menus inner join dbo.RO_Categories ON dbo.RO_Menus.MenuID = RO_Categories.MenuID
 
 join dbo.RO_Items ON RO_Items.CategoryID = RO_Categories.CategoriesID
 
 join dbo.RO_Units ON RO_Units.UnitID = RO_Items.UnitId

end





GO
