SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleManagerGetPageModules] (
 @PageID INT
 ,@PortalID INT
 ,@IsHandheld BIT
 )
AS
BEGIN
 DECLARE @IsAdmin BIT

 SELECT @IsAdmin = IsAdmin
 FROM [dbo].[PageMenu]
 WHERE PageID = @PageID;

 SELECT DISTINCT pm.pageid
  ,um.usermoduleid
  ,um.usermoduletitle
  ,um.seoname
  ,pm.pagemoduleid
  ,pm.panename
  ,pm.moduleorder
  ,pm.isactive
  ,um.allpages
  ,um.showinpages
  ,um.ModuleDefID
  ,(
   SELECT COUNT(ModuleControlID)
   FROM ModuleControls mc
   WHERE mc.ModuleDefID = um.ModuleDefID and  IsDeleted<>1
   ) AS ControlsCount
 FROM pages p
 INNER JOIN pagemodules pm ON p.pageid = pm.pageid
 INNER JOIN usermodules um ON pm.usermoduleid = um.usermoduleid
 INNER JOIN pagemenu pmenu ON p.pageid = pmenu.pageid
 WHERE (
   pm.portalid = @PortalID
   
   AND (
    ISNULL(um.IsHandheld, 0) = @IsHandheld
    AND (ISNULL(um.isdeleted, 0) = 0)
    )
   AND (
    (
     pmenu.isadmin = @IsAdmin
     AND um.allpages = 1
     OR @PageID IN (
      SELECT Rtrim(Ltrim(items))
      FROM Split(um.showinpages, ',')
      WHERE (isnull(um.isdeleted, 0) = 0)
      )
     )
    )
   OR (pm.pageid = @PageID)
   )
  AND ISNULL(pm.isdeleted, 0) = 0
  AND um.IsHandheld = @IsHandheld
 ORDER BY pm.moduleorder
END





GO
