SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_MENUSAVE]
(
@MenuID int,
@MenuName nvarchar(200),
@PhotoPath nvarchar(128)
)
AS

if(@MenuID = 0)
BEGIN
INSERT INTO RO_Menus(MenuName, PhotoPath) values(@MenuName, @PhotoPath)
END
else
begin
Update dbo.RO_Menus Set

MenuName = @MenuName,
PhotoPath = @PhotoPath
WHERE MenuID=@MenuID

 end









GO
