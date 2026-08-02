SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleManagerGetSearchModules]
 @SearchText VARCHAR(20),
 @PortalID INT,
 @IsAdmin BIT
AS
BEGIN
 SELECT 
  m.FriendlyName,
  m.ModuleID,
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
   (m.IsAdmin=@IsAdmin)
  AND (
     m.IsDeleted IS NULL 
    OR m.IsDeleted=0
   )
  AND 
   pm.PortalID=@PortalID
  AND 
  pm.IsActive=1
  AND 
   m.FriendlyName LIKE '%'+ @SearchText +  '%'
 ORDER BY 
  m.FriendlyName ASC
END





GO
