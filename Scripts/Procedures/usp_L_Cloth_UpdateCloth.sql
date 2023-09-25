CREATE procedure [dbo].[usp_L_Cloth_UpdateCloth]
@id int,
@cloth nvarchar(max),
@gender nvarchar(max)

as

update dbo.L_Cloth set dbo.L_Cloth.Cloth=@cloth,dbo.L_Cloth.Gender=@gender where dbo.L_Cloth.ID=@id
