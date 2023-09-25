create procedure [dbo].[usp_L_MaterialType_UpdateMaterialType]
@id int,
@type nvarchar(max)
as

update dbo.L_MaterialType set dbo.L_MaterialType.Type=@type where dbo.L_MaterialType.ID=@id 

