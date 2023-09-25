create procedure [dbo].[usp_L_Cloth_GetClothByID]
@id int
as

select * from dbo.L_Cloth where dbo.L_Cloth.ID=@id
