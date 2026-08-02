SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GETCATEGORIES]
AS
BEGIN
select dbo.RO_Categories.CategoriesID, dbo.RO_Categories.PhotoPath, dbo.RO_Categories.CategoriesName, dbo.RO_Menus.MenuName, dbo.RO_Menus.MenuID FROM  dbo.RO_Categories join dbo.RO_Menus ON dbo.RO_Categories.MenuID = dbo.RO_Menus.MenuID
end





GO
