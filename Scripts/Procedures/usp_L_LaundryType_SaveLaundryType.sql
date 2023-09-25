
create procedure [dbo].[usp_L_LaundryType_SaveLaundryType]
@type nvarchar(max)
as

insert into dbo.L_LaundryType(Type) values(@type)
