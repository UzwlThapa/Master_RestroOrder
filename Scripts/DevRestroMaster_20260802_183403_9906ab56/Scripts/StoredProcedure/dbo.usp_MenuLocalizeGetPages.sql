SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[usp_MenuLocalizeGetPages]1,'en-US'
CREATE PROCEDURE [dbo].[usp_MenuLocalizeGetPages]
@PortalID INT,
@CultureCode NVARCHAR(20)
AS
BEGIN
DECLARE @MenuID INT
SET @MenuID=(SELECT MenuID FROM Menu WHERE IsDefault=1 and PortalID = @PortalID)
 SELECT 
  p.PageID,
  p.PageName, 
  (
   CASE WHEN 
      (
      SELECT 
       COUNT(PageID) 
      FROM 
       LocalPage 
      WHERE 
        PageID=p.PageID 
       AND CultureCode=@CultureCode
     )>0
    THEN 
     (
      SELECT 
       LocalPageName 
      FROM 
       LocalPage 
      WHERE 
        PageID=p.PageID 
       AND CultureCode=@CultureCode
     )
    ELSE 
     (
      SELECT 
       PageName 
      FROM 
       Pages 
      WHERE 
       PageID=p.PageID
      ) 
    END
  ) AS LocalPageName ,
  (
   CASE WHEN 
      (
      SELECT 
       COUNT(PageID) 
      FROM 
       LocalPage 
      WHERE 
        PageID=p.PageID 
       AND CultureCode=@CultureCode
     )>0
    THEN 
     (
      SELECT 
       LocalPageCaption 
      FROM 
       LocalPage 
      WHERE 
        PageID=p.PageID 
       AND CultureCode=@CultureCode
     )
    ELSE 
     (     
      SELECT 
       Caption 
      FROM 
       MenuItem 
      WHERE 
       PageID=p.PageID AND MenuID=@MenuID
      ) 
    END
  ) AS LocalPageCaption 
 FROM 
  Pages p 
 WHERE 
  (
    p.PortalID=@PortalID 
   OR p.PortalID=-1
   
  )
  AND (p.IsDeleted=0 OR p.IsDeleted IS NULL)
END

  
  
  
  
  
  
  
  
  
  
  
  
--  select * from Pages where PageName Like '%Upgrade%'

--Update Pages
--SET portalID = -1
--WHERE PageID = 18

--select * from PageModules where pageID = 28

--Update Pages
--SET portalID = -1
--WHERE PageID = 18

--Update PageModules
--SET PortalID = -1
--WHERE PageID = 18
--OR PageID = 28





GO
