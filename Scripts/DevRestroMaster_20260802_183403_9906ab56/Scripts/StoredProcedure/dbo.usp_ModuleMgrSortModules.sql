SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleMgrSortModules]
 @flag INT,
 @isAdmin BIT,
 @PortalID INT,
 @IncludePortalModules int
AS 

--IF @IncludePortalModules=0
 BEGIN
   SELECT 
    m.FriendlyName,
    md.ModuleDefID 
   FROM 
    Modules m 
       INNER JOIN  ModuleDefinitions md  ON  m.ModuleID=md.ModuleID
       INNER JOIN  PortalModules pm ON  md.ModuleID=pm.ModuleID
   WHERE 
     (isnull(m.IsAdmin,0)=@isAdmin)
    AND (
       m.IsDeleted IS NULL 
      OR m.IsDeleted=0
     )
    AND pm.PortalID=@PortalID
    AND pm.IsActive=1
   
   ORDER BY
    CASE 
     WHEN @flag = 0 
      THEN m.FriendlyName 
     END ASC,
    CASE 
     WHEN @flag = 1 
      THEN m.FriendlyName 
     END DESC
     
 END





GO
