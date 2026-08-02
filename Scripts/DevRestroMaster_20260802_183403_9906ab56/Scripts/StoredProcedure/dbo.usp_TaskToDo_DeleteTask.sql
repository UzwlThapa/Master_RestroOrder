SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TaskToDo_DeleteTask] 
 -- Add the parameters for the stored procedure here
 @CultureCode nvarchar(50),
    @PortalID int,
    @UserModuleId  int,
 @Id INT,
 @UserName nvarchar(200)
AS
BEGIN

 SET NOCOUNT ON;
 UPDATE TaskToDo  SET IsDeleted='TRUE',DeletedBy=@UserName,DeletedOn=GETDATE() WHERE TaskID=@Id
  and CultureField=@CultureCode and ModuleID=@UserModuleId And portalId=@PortalID
END





GO
