SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_CATEGORIESSAVE]

(
@CategoriesID INT, 
@MenuID int,
@CategoriesName varchar(128),
@PhotoPath varchar(128)
)
AS

if(@CategoriesID = 0)
BEGIN
INSERT INTO dbo.RO_Categories
        ( MenuID, CategoriesName, PhotoPath )
VALUES  ( @MenuID, -- ItemID - int
          @CategoriesName,  -- CategoriesName - varchar(128)
          @PhotoPath
		  )
END
else
begin
Update dbo.RO_Categories SET

CategoriesName = @CategoriesName, MenuID =@MenuID, PhotoPath = @PhotoPath WHERE CategoriesID=@CategoriesID

 end






GO
