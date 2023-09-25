CREATE procedure [dbo].[usp_L_Cloth_SaveCloth]
@cloth nvarchar(max),
@gender nvarchar(max)

as

insert into dbo.L_Cloth(Cloth,Gender) values(@cloth,@gender)
