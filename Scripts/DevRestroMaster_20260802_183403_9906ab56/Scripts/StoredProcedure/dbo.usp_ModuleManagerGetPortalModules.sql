SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleManagerGetPortalModules]
(
@PortalID INT
)
AS
BEGIN
 SELECT 
  m.FriendlyName,
  md.ModuleDefID 
 FROM 
  Modules m 
 INNER JOIN 
  ModuleDefinitions md 
 ON 
  m.ModuleID=md.ModuleID
 INNER JOIN 
  PortalModules pm 
 ON 
  md.ModuleID=pm.ModuleID
 WHERE 
   (
     m.IsAdmin=0 
    OR m.IsAdmin IS NULL
   )
  AND 
   (
     m.IsDeleted IS NULL 
    OR m.IsDeleted=0
   )
 AND 
  pm.PortalID=@PortalID
 AND 
  pm.IsActive=1
END





GO
