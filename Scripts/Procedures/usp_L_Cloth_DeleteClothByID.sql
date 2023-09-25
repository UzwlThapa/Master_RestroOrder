

create procedure [dbo].[usp_L_Cloth_DeleteClothByID]
@id int
as

delete from dbo.L_Cloth where dbo.L_Cloth.ID=@id
