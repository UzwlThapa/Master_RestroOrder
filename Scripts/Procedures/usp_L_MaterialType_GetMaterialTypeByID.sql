
create procedure [dbo].[usp_L_MaterialType_GetMaterialTypeByID]
@id int
as

select * from dbo.L_MaterialType where dbo.L_MaterialType.ID=@id

