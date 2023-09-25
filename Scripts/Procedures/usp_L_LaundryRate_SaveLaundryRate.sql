create procedure [dbo].[usp_L_LaundryRate_SaveLaundryRate]
@clothid int,
@laundryTypeId int,
@rate decimal(18,0)
as

insert into dbo.L_LaundryRate(ClothTypeID,LaundryTypeID,Rate) values(@clothid,@laundryTypeId,@rate)
