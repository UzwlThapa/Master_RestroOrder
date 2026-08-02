SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create FUNCTION [dbo].[fn_A]
(
 @Level int
)
RETURNS bit
AS
BEGIN
 DECLARE @ReturnValue bit
 IF(Exists(Select * From dbo.PageModules Where dbo.PageModules.UserModuleID In (Select top 1 ModuleDefID from dbo.ModuleDefinitions Where dbo.ModuleDefinitions.ModuleID = @Level)))
  Begin
   set @ReturnValue = 1
  End
 Else
   Begin
    set @ReturnValue = 0
   End
 RETURN @ReturnValue

END





GO
