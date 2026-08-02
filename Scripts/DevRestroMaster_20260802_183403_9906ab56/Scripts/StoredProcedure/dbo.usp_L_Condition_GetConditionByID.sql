SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_Condition_GetConditionByID]
@id int

as

select * from dbo.L_Condition where dbo.L_Condition.ID=@id



GO
