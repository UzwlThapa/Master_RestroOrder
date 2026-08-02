SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_MasterPageGetPageModules_Superuser 1,'Home',1,'superuser','en-us',0,'none'
CREATE PROCEDURE [dbo].[usp_MasterPageGetPageModules_Superuser] 
   @CONtrolType [INT],
   @PageSEOName [NVARCHAR](1000),
   @PortalID [INT],
   @UserName [NVARCHAR](256),
   @CultureCode [NVARCHAR](100),
   @IsPreview bit,
   @PreviewCode nvarchar(256)
WITH EXECUTE AS CALLER
AS
BEGIN
SET NOCOUNT ON;
------------------------
-- absolute method
------------------------
--DECLARE @temprole TABLE ( roleid NVARCHAR(250), username NVARCHAR(50))

-----------------------------------------------------------
--Declare All Variables Here
-----------------------------------------------------------
DECLARE @IsPageAvailable BIT,@IsPageAccessible BIT,@PageID INT

DECLARE @AllowPreview BIT
DECLARE @IsModuleEdit BIT 
  
SET @AllowPreview  = 0 

SET @IsModuleEdit  = 1

-----------------------------------------------------------
--Get PageID From PageSEOName
-----------------------------------------------------------
SELECT @PageID=PageID FROM Pages WHERE SEOName=@PageSEOName AND PortalID=@PortalID and IsActive = 1 and Isdeleted = 0

--------------------------------------------------------------------------------------
IF EXISTS(SELECT PageID FROM PagePreview WHERE PreviewCode = @PreviewCode and PageID =  @PageID) and (@IsPreview = 1)  
 SET @AllowPreview = 1
--------------------------------------------------------------------------------------
-- absolute method
------------------------
--INSERT INTO @temprole 
--SELECT  [dbo].[aspnet_UsersInRoles].roleid, [dbo].[aspnet_Users].username
--FROM         [dbo].[aspnet_UsersInRoles] INNER JOIN
--    [dbo].[aspnet_Users] ON [dbo].[aspnet_Users].userid = [dbo].[aspnet_UsersInRoles].userid
--WHERE     [dbo].[aspnet_Users].LoweredUserName = 'superuser'

-----------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------
---To check if modules are editable or not according to user role, The following is commented as superuser can edit all the modules so no need
 -- to check if particular module is editable or not Dec 3rd 2013 -------


--IF EXISTS(SELECT 1  FROM   usermodulepermissiON ump 
--    LEFT JOIN    moduledefpermissiON mdp  ON ump.moduledefpermissiONid = mdp.moduledefpermissiONid 
--    WHERE
--         ump.roleid IN (SELECT roleid From @temprole where username=@UserName) AND ump.PortalID = @PortalID
--     AND mdp.permissiONid = 2)
--BEGIN 
-- SET @IsModuleEdit =1 
--END

------------------------------------------------------------------------------------------------------------------------------------------- 


-----------------------------------------------------------
--Check If the User Has Access To the Page
-----------------------------------------------------------

--SET @IsPageAvailable = 0

 IF(@IsPreview=1)
 BEGIN
   IF(@AllowPreview=1)
     BEGIN
      IF EXISTS(SELECT PageID FROM Pages WHERE SEOName=@PageSEOName AND PortalID=@PortalID)     
       SET @IsPageAvailable=1
     END
    ELSE
     BEGIN
      IF EXISTS(SELECT PageID FROM Pages WHERE SEOName=@PageSEOName AND PortalID=@PortalID and IsVisible=1)
        SET @IsPageAvailable = 1
      ELSE
       SET @IsPageAvailable=0
      END
    END
 ELSE
  BEGIN
   IF EXISTS(SELECT PageID FROM Pages WHERE SEOName=@PageSEOName AND PortalID=@PortalID and IsVisible=1)
    SET @IsPageAvailable=1
   ELSE
    SET @IsPageAvailable=0
   
  END
  

  
------------------------------------------------------------------------------------------------------------------------------------------------
 -- @IsPageAccessible is set to 1 as superuser can access all the modules so no need to check if particular page is access or not Dec 3rd 2013 -------
 ------------------------------------------------------------------------------------------------------------------------------------------------

 SET @IsPageAccessible=1 

 ------------------------------------------------------------------------------------------------------------------------------------------------

  ----IF(EXISTS(
  ----      SELECT p.PageID
  ----  FROM dbo.Pages p
  ----  INNER join dbo.PagePermission pm on pm.PageID=p.PageID
  ----  inner join dbo.aspnet_UsersInRoles uir on uir.RoleId=pm.RoleID
  ----  Inner join dbo.aspnet_Users u on u.UserId=uir.UserId
  ----  WHERE pm.RoleID='cd3ca2e2-7120-44ad-a520-394e76aac552' 
  ----  and  u.UserName='superuser'
  ----   AND p.PageID = @PageID
  ----    AND ( p.portalid = @PortalID OR p.portalid = -1 ) 
  ----                      AND  ISNULL(pm.IsDeleted,0)=0 
  ----                      AND ISNULL(p.IsDeleted,0)=0  ))

                       
  ----     BEGIN 
  ----          SET @IsPageAccessible=1 
  ----END 
-----------------------------------------------------------
--Create the PageDetails Table
-----------------------------------------------------------
DECLARE @Title NVARCHAR(250),@RefreshINTerval NVARCHAR(250),@DescriptiON NVARCHAR(500),@KeyWords NVARCHAR(500)
SELECT @Title=p.Title,@RefreshINTerval=CAST(p.RefreshINTerval AS NVARCHAR),@DescriptiON=p.DescriptiON,@KeyWords=p.KeyWords 
FROM   pages p
WHERE  p.PageID = @PageID
       AND p.portalid = @PortalID 
-----------------------------------------------------------
--Get The List Of Page Modules BY PageSEOName AND Portal ID 
-----------------------------------------------------------
SELECT DISTINCT @IsPageAvailable AS IsPageAvailable,@IsPageAccessible AS IsPageAccessible,v.PageID,v.usermoduleid,v.panename, 
       v.moduleORDER, 
       v.ishANDheld, 
       v.suffixclass, 
       v.showheadertext, 
       ISNULL(lmt.LocalModuleTitle,v.HeaderText) as headertext, 
    v.CONtrolSrc,
    v.SupportsPartialRENDering,
    --RoleID,
    v.CONtrolsCount,
    v.PortalID,
    @IsModuleEdit  AS IsEdit,
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
  ---This logic is absolute --  and no more in use
   -- (SELECT count (ump.UserModulePermissionID)
    --FROM   usermodulepermissiON ump 
    -- LEFT JOIN moduledefpermissiON mdp  ON ump.moduledefpermissiONid = mdp.moduledefpermissiONid 
    --       AND ump.usermoduleid = v.UserModuleID
    --       AND ((ump.roleid IN (SELECT roleid From @temprole where username=@UserName)) 
    --        OR ump.username=@UserName)
    --      AND mdp.permissiONid = 2 
    --      AND ump.PortalID=@PortalID
  --) AS IsEdit,
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
    
  @Title AS Title,
  @RefreshINTerval AS RefreshINTerval,
  @DescriptiON AS [DescriptiON],
  @KeyWords AS KeyWords,
     v.usermoduletitle as UserModuleTitle,
v.ModuleDefID     AS ModuleDefID     
 FROM   vw_PageUserModules v 
 left join dbo.LocalModuleTitle lmt on lmt.UserModuleID=v.UserModuleID and  lmt.CultureCode=@CultureCode
  WHERE  ( v.username = @UserName or
   v.RoleID='cd3ca2e2-7120-44ad-a520-394e76aac552' ) 
             AND ( ( v.pageid = @PageID ) 
                    OR ( v.allpages = 1 ) 
                    OR ( @PageID = (SELECT Rtrim(Ltrim(SplittedValue)) 
                                    FROM   UDFsplit(v.showinpages, ',') 
                                    WHERE  SplittedValue = @PageID 
                                          
                                                  ) ) ) 
             AND v.portalid = @PortalID 
             AND v.controltype = 1 
             AND v.isactive = 1 
      ORDER  BY v.moduleorder ASC 


END





GO
