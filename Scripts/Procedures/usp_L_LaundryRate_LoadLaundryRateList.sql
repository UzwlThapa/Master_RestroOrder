CREATE procedure [dbo].[usp_L_LaundryRate_LoadLaundryRateList]

as

select dbo.L_LaundryRate.ID,dbo.L_LaundryRate.ClothTypeID,dbo.L_LaundryRate.LaundryTypeID,dbo.L_LaundryRate.Rate,dbo.L_Cloth.Cloth as ClothType,dbo.L_LaundryType.Type as LaundryType
from dbo.L_LaundryRate
left join dbo.L_Cloth
on dbo.L_Cloth.ID=dbo.L_LaundryRate.ClothTypeID
left join dbo.L_LaundryType
on dbo.L_LaundryRate.LaundryTypeID=dbo.L_LaundryType.ID