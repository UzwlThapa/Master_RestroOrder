
create procedure [dbo].[usp_L_LaundryType_UpdateLaundryType]
@id int,
@type nvarchar(max)
as

update dbo.L_LaundryType set dbo.L_LaundryType.Type=@type where dbo.L_LaundryType.ID=@id
