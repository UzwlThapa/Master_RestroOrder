SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SageFrameSearchProcedureAddUpdate]
 @SageFrameSearchProcedureID INT,
 @SageFrameSearchTitle NVARCHAR(100),
 @SageFrameSearchProcedureName NVARCHAR(256),
 @SageFrameSearchProcedureExecuteAs NVARCHAR(50),
 @IsActive BIT, 
 @AddedOn DATETIME, 
 @PortalID INT,
 @AddedBy NVARCHAR(256) 
AS
BEGIN
 IF @SageFrameSearchProcedureID = 0
  BEGIN
   INSERT INTO [dbo].[SageFrameSearchProcedure] (
    [SageFrameSearchTitle],
    [SageFrameSearchProcedureName],
    [SageFrameSearchProcedureExecuteAs],
    [IsActive],
    [IsDeleted],
    [IsModified],
    [AddedOn],
    [UpdatedOn],   
    [PortalID],
    [AddedBy]   
   ) VALUES (
    @SageFrameSearchTitle,
    @SageFrameSearchProcedureName,
    @SageFrameSearchProcedureExecuteAs,
    @IsActive,
    0,
    0,
    GETDATE(),
    GETDATE(),   
    @PortalID,
    @AddedBy   
   )
  END
 ELSE
  BEGIN
   UPDATE [dbo].[SageFrameSearchProcedure] SET
    [SageFrameSearchTitle] = @SageFrameSearchTitle,
    [SageFrameSearchProcedureName] = @SageFrameSearchProcedureName,
    [SageFrameSearchProcedureExecuteAs] = @SageFrameSearchProcedureExecuteAs,
    [IsActive] = @IsActive,  
    [IsModified] = 1,  
    [UpdatedOn] = GETDATE(),  
    [PortalID] = @PortalID,  
    [UpdatedBy] = @AddedBy  
   WHERE
    [SageFrameSearchProcedureID] = @SageFrameSearchProcedureID
  END
END





GO
