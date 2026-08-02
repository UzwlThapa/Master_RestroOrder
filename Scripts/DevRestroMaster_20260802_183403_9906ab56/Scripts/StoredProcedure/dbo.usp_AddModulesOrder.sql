SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_AddModulesOrder]
@ModuleOrder NVARCHAR(100),
@PortelID INT,
@ModuleID NVARCHAR(100),
@ModuleName NVARCHAR(100),
@PaneName NVARCHAR(100),
@UserModuleID int,
@NewModuleID INT OUTPUT
AS
BEGIN
IF @UserModuleID=0
BEGIN
INSERT INTO [dbo].[LayOutMgr](ModuleOrder,PortelID,ModuleID,ModuleName,PaneName)VALUES(@ModuleOrder,@PortelID,@ModuleID,@ModuleName,@PaneName)
SELECT @NewModuleID = SCOPE_IDENTITY()
END
ELSE
BEGIN
UPDATE LayoutMgr
set ModuleOrder=@ModuleOrder,PortelID=@PortelID,PaneName=@PaneName,ModuleName=@ModuleName
where ID=@UserModuleID
SELECT @NewModuleID = @UserModuleID
END
END





GO
