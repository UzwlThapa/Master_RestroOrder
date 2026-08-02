SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_MasterPageGetPageModules_Anonymous] 1,'Home',1,'anonymoususer','EN-US'
CREATE PROCEDURE [dbo].[usp_MasterPageGetPageModules_Anonymous]
@ControlType [INT], 
@PageSEOName [NVARCHAR](1000), 
@PortalID [INT], 
@UserName [NVARCHAR](256) ,
@CultureCode NVARCHAR(100)
WITH EXECUTE AS caller 
AS 
  BEGIN 
      SET nocount ON; 
     
      DECLARE @IsPageAvailable  BIT, 
              @IsPageAccessible BIT, 
              @PageID           INT 

      ----------------------------------------------------------- 
      --Get PageID From PageSEOName 
      ----------------------------------------------------------- 
      SELECT @PageID = pageid 
      FROM   pages 
      WHERE  seoname = @PageSEOName 
             AND portalid = @PortalID 
             and IsActive = 1 and Isdeleted = 0

      ----------------------------------------------------------- 
      --Check If the User Has Access To the Page 
      ----------------------------------------------------------- 
      IF EXISTS(SELECT pageid 
                FROM   pages 
                WHERE  seoname = @PageSEOName 
                       AND portalid = @PortalID) 
        BEGIN 
            SET @IsPageAvailable=1 
        END 
      
        IF(Exists(
        select p.PageID
    FROM dbo.Pages p
    INNER join dbo.PagePermission pm on pm.PageID=p.PageID
    inner join dbo.aspnet_UsersInRoles uir on uir.RoleId=pm.RoleID
    --Inner join dbo.aspnet_Users u on u.UserId=uir.UserId
    where pm.RoleID='A87E850F-14C8-4C89-86F4-4598FF27DA72' 
    --and  u.UserName='anonymoususer'
     AND p.seoname = @PageSEOName 
     AND p.IsVisible = 1
                       AND  isnull(p.[isdeleted],0) = 0 
                       AND ( p.portalid = @PortalID 
                              OR p.portalid = -1 ) 
                       AND isnull(pm.[isdeleted],0) = 0  ))

        BEGIN 
            SET @IsPageAccessible=1 
        END 

      ----------------------------------------------------------- 
      --Create the PageDetails Table 
      ----------------------------------------------------------- 
      DECLARE @Title           NVARCHAR(250), 
              @RefreshInterval NVARCHAR(250), 
              @Description     NVARCHAR(500), 
              @KeyWords        NVARCHAR(500) 

      SELECT @Title = p.title, 
             @RefreshInterval = Cast(p.refreshinterval AS NVARCHAR), 
             @Description = p.description, 
             @KeyWords = p.keywords 
      FROM   pages p 
      WHERE  p.seoname = @PageSEOName 
             AND p.portalid = @PortalID 
             and IsActive = 1 and Isdeleted = 0

      
      SELECT DISTINCT @IsPageAvailable  AS IsPageAvailable, 
                      @IsPageAccessible AS IsPageAccessible, 
                      v.pageid, 
                      v.usermoduleid, 
                      v.panename, 
                      v.moduleorder, 
                      v.ishandheld, 
                      v.suffixclass, 
                      v.showheadertext, 
                      ISNULL(lmt.LocalModuleTitle,v.HeaderText) as headertext, 
      
                      v.controlsrc, 
                      v.supportspartialrendering, 
                      v.controlscount, 
                      v.portalid, 
                      0                 AS IsEdit, 
                      @Title            AS Title, 
                      @RefreshInterval  AS RefreshInterval, 
                      @Description      AS [Description], 
                      @KeyWords         AS KeyWords, 
                      v.usermoduletitle AS UserModuleTitle,
		      v.ModuleDefID     AS ModuleDefID 
		      
      FROM   vw_PageUserModules v
      left join dbo.LocalModuleTitle lmt on lmt.UserModuleID=v.UserModuleID and  lmt.CultureCode=@CultureCode 
      WHERE  ( v.username = @UserName or
   v.RoleID='A87E850F-14C8-4C89-86F4-4598FF27DA72' ) 
    AND ( ( v.pageid = @PageID ) 
                    OR ( v.allpages = 1 ) 
                    OR ( @PageID = (SELECT SplittedValue 
                                    FROM   UDFSplit(v.showinpages, ',') 
                                    WHERE  SplittedValue = @PageID 
                                          
                                                  ) ) ) 
            
             AND v.portalid = @PortalID 
             AND v.controltype = 1 
             AND v.isactive = 1 
      ORDER  BY v.moduleorder ASC 
  END





GO
