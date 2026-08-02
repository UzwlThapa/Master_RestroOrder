SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_L_Condition_SaveCondition]
@condition nvarchar(max)

as

insert into dbo.L_Condition(Condition) values(@condition)



GO
