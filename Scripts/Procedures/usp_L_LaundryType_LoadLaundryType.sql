CREATE procedure [dbo].[usp_L_LaundryType_LoadLaundryType]
@clothid int=0
as

select * from dbo.L_LaundryType
Left join L_LaundryRate
on L_LaundryType.ID=L_LaundryRate.LaundryTypeID and (L_LaundryRate.ClothTypeID=@clothid OR @clothid=0)
