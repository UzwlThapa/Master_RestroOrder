
create procedure [dbo].[usp_L_LaundryType_GetLaundryTypeByID]
@id int
as

select * from dbo.L_LaundryType where dbo.L_LaundryType.ID=@id
