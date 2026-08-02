SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_ITEMSAVE]
(
@ItemID int,
@ItemName varchar(128),
@ItemDescription varchar(128),
@PhotoPath varchar(128),
@Price decimal(18,2),
@ItemCode varchar(128),
@UnitID int,
@CategoriesID int,
@CostCenterID int
)
AS

if(@ItemID = 0)
BEGIN
INSERT INTO dbo.RO_Items
        ( ItemName ,
          ItemDescription ,
          PhotoPath ,
          Price ,
          ItemCode ,
          UnitID ,
          CategoryID,
		  CostCenterID
        )
VALUES  ( @ItemName , -- ItemName - varchar(128)
          @ItemDescription , -- ItemDescription - varchar(128)
          @PhotoPath , -- PhotoPath - varchar(128)
          @Price, -- Price - decimal
          @ItemCode , -- ItemCode - varchar(128)
          @UnitID , -- UnitId - int
          @CategoriesID,  -- CategoryId - int
	      @CostCenterID
		)
END
else
begin
Update dbo.RO_Items Set

ItemName = @ItemName,ItemDescription=@ItemDescription,PhotoPath=@PhotoPath, ItemCode= @ItemCode, Price = @Price, UnitID= @UnitID, CategoryID=@CategoriesID, CostCenterID=@CostCenterID
WHERE ItemID=@ItemID

 end






GO
