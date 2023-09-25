
create procedure [dbo].[usp_L_MaterialType_DeleteMaterialTypeByID]
@id int
as

delete from dbo.L_MaterialType where dbo.L_MaterialType.ID=@id

