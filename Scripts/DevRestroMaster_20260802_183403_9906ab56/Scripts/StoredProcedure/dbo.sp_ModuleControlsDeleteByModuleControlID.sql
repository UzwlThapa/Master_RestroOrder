SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_ModuleControlsDeleteByModuleControlID]
 @ModuleControlID INT,
 @DeletedBy NVARCHAR(256)
AS
BEGIN
 UPDATE dbo.ModuleControls SET
 IsDeleted=1,
 DeletedOn=GETDATE(),
 DeletedBy=@DeletedBy
WHERE
 [ModuleControlID] = @ModuleControlID 

END





GO
