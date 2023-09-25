
create procedure [dbo].[usp_L_MaterialType_SaveMaterialType]
@type nvarchar(max)
as

insert into dbo.L_MaterialType(Type) values(@type)

