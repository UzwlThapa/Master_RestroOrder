SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_Condition_DeleteConditionByID]
@id int

as

delete from dbo.L_Condition where dbo.L_Condition.ID=@id



GO
