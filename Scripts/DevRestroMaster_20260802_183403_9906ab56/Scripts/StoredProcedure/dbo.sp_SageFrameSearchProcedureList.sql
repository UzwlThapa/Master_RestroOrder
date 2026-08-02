SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SageFrameSearchProcedureList]
(
 @PortalID INT
)

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
  [IsDeleted] = 0 
 AND [IsActive] = 1 
 AND [PortalID] = @PortalID
END





GO
