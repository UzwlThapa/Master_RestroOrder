SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleManagerGetAdminModules]
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
  m.IsAdmin=1
 AND (
    m.IsDeleted IS NULL 
   OR m.IsDeleted=0
  )
 AND pm.PortalID=@PortalID
END





GO
