SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_Condition_UpdateCondition]
@id int,
@condition nvarchar(max)

as

update dbo.L_Condition set dbo.L_Condition.Condition=@condition where dbo.L_Condition.ID=@id



GO
