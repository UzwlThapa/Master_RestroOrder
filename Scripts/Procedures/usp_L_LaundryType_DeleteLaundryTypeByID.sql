
create procedure [dbo].[usp_L_LaundryType_DeleteLaundryTypeByID]
@id int
as

delete from dbo.L_LaundryType where dbo.L_LaundryType.ID=@id
