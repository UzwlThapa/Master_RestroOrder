create procedure [dbo].[usp_L_Condition_UpdateCondition]
@id int,
@condition nvarchar(max)

as

update dbo.L_Condition set dbo.L_Condition.Condition=@condition where dbo.L_Condition.ID=@id

