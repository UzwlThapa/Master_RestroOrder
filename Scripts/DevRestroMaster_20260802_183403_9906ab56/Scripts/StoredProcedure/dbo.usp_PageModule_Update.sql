SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PageModule_Update]
(
@UserModuleID INT,
@PaneName NVARCHAR(200),
@ModuleOrder INT
)
as
BEGIN
SET NOCOUNT ON;
UPDATE [dbo].[PageModules]
SET PaneName=@PaneName,
 ModuleOrder=@ModuleOrder
WHERE UserModuleID=@UserModuleID
END





GO
