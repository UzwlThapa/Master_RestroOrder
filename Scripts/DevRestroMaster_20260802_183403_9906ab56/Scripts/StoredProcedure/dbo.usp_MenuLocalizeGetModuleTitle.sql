SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [dbo].[usp_MenuLocalizeGetModuleTitle]1,'ne-NP'
CREATE PROCEDURE [dbo].[usp_MenuLocalizeGetModuleTitle]
@PortalID INT,
@CultureCode NVARCHAR(20)
AS
BEGIN

 SELECT 
  m.UserModuleID,
  m.UserModuleTitle, 
  (
   CASE WHEN 
      (
      SELECT 
       COUNT(UserModuleID) 
      FROM 
       LocalModuleTitle
      WHERE 
        UserModuleID=m.UserModuleID 
       AND CultureCode=@CultureCode
     )>0
    THEN 
     (
      SELECT 
       LocalModuleTitle 
      FROM 
       LocalModuleTitle 
      WHERE 
        UserModuleID=m.UserModuleID 
       AND CultureCode=@CultureCode
     )
    ELSE 
     (
      SELECT 
        HeaderText
      FROM 
       UserModules 
      WHERE 
       UserModuleID=m.UserModuleID
      ) 
    END
  ) AS LocalModuleTitle 
  
 FROM 
  UserModules m 
 WHERE 
  (
    m.PortalID=@PortalID 
   OR m.PortalID=-1
   
  )
  AND (m.IsDeleted=0 OR m.IsDeleted IS NULL)
END





GO
