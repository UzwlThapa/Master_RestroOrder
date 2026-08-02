SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SageFrameSearchProcedureDelete]
 @SageFrameSearchProcedureID INT,   
 @DeletedBy NVARCHAR(256) 
AS

BEGIN
 UPDATE [dbo].[SageFrameSearchProcedure] SET 
  [IsDeleted] = 1, 
  [DeletedOn] = GETDATE(),  
  [DeletedBy] = @DeletedBy
 WHERE
  [SageFrameSearchProcedureID] = @SageFrameSearchProcedureID
END





GO
