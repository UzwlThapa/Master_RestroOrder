SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleMessageGetModules]
AS
BEGIN
  SELECT 
  [ModuleID],
  [FriendlyName]     
  FROM 
  [dbo].[Modules]
  WHERE 
   ( 
     IsDeleted=0 
    OR IsDeleted IS NULL 
   )
  AND 
   IsAdmin=1
END





GO
