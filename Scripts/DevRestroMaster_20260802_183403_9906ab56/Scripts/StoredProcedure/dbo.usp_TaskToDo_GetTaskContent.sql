SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TaskToDo_GetTaskContent]
@CultureCode nvarchar(50),
@PortalID int,
@UserModuleId  int,
@Id int
AS
SELECT TaskId,Note,Date FROM TaskToDo WHERE
 TaskId=@Id and CultureField=@CultureCode and ModuleID=@UserModuleId And portalId=@PortalID





GO
