
CREATE procedure [dbo].[usp_L_LaundryRate_LoadClothList]

as

select dbo.L_Cloth.ID as ClothTypeID,dbo.L_Cloth.Cloth as ClothType
from dbo.L_Cloth