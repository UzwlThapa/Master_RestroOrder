SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_LaundryRate_GetLaundryRateByID]
@id int
as

select dbo.L_LaundryRate.ID,dbo.L_LaundryRate.ClothTypeID,dbo.L_LaundryRate.LaundryTypeID,dbo.L_LaundryRate.Rate,dbo.L_Cloth.Cloth as Cloth,dbo.L_LaundryType.Type as LaundryType
from dbo.L_LaundryRate
inner join dbo.L_Cloth
on dbo.L_Cloth.ID=dbo.L_LaundryRate.ClothTypeID
inner join dbo.L_LaundryType
on dbo.L_LaundryType.ID=dbo.L_LaundryRate.LaundryTypeID
where dbo.L_LaundryRate.ID = @id



GO
