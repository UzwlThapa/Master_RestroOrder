SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SageFrameSearchProcedureGet]
 @SageFrameSearchProcedureID INT
 
AS
BEGIN
 SELECT
 [SageFrameSearchProcedureID],
 [SageFrameSearchTitle],
 [SageFrameSearchProcedureName],
 [SageFrameSearchProcedureExecuteAs],
 [IsActive],
 [IsDeleted],
 [IsModified],
 [AddedOn],
 [UpdatedOn],
 [DeletedOn],
 [PortalID],
 [AddedBy],
 [UpdatedBy],
 [DeletedBy]
FROM 
 [dbo].[SageFrameSearchProcedure]
WHERE
 [SageFrameSearchProcedureID] = @SageFrameSearchProcedureID
END





GO
