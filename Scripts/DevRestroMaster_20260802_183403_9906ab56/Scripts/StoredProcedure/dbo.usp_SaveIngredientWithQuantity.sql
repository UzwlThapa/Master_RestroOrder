SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_SaveIngredientWithQuantity]
@ItemID int,
@Ingredient int,
@Quantity decimal(10,2)
as
if(@Ingredient not in (select Ingredient from [Ro_Ingredient] where ItemID=@ItemID))
INSERT INTO [dbo].[Ro_Ingredient]
           ([ItemID]
		   ,[ingredient]
           ,[Quantity])
     VALUES
           (@ItemID,
		   @Ingredient,
           @Quantity)
else
	update [Ro_Ingredient] set Quantity=@Quantity where ItemID=@ItemID and Ingredient=@Ingredient

;
insert into ROI_ITEMBal(ITId,STId)
select @Ingredient, cc.StoreId  from ROI_ItemDetails d
inner join CostCenterInfo cc on d.ItemCostCentreID=cc.CostCenterId
where d.ITId=@ItemID
except
select ITId,STId from ROI_ITEMBal


GO
