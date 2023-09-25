
create procedure [dbo].[usp_L_LaundryRate_DeleteLaundryRate]
@id int
as

delete from dbo.L_LaundryRate
where dbo.L_LaundryRate.ID = @id
