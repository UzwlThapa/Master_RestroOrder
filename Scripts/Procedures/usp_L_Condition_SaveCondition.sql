
create procedure [dbo].[usp_L_Condition_SaveCondition]
@condition nvarchar(max)

as

insert into dbo.L_Condition(Condition) values(@condition)
