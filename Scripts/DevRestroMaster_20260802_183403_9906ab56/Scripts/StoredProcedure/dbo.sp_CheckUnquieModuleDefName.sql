SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Milson Munakami
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[sp_CheckUnquieModuleDefName] 
 @ModuleDefID int,
 @ModuleDefName nvarchar(50), 
 @Count int output
AS
Begin
 --Initilization of output parameter
 Set @Count = 0
  Begin
   Select @Count = IsNull(Count(ModuleDefID),0) From dbo.ModuleDefinitions Where FriendlyName = @ModuleDefName and ModuleDefID <> @ModuleDefID
  End
Print @Count
End





GO
