SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrLoadMenu] 
(
 @UserModuleID INT,
 @PortalID INT
)
AS
BEGIN
 DECLARE @MenuID INT
  IF EXISTS(
     SELECT 
      SettingValue 
     FROM 
      SageMenuSettingValue 
     WHERE 
       SettingKey='MenuID' 
      AND UserModuleID=@UserModuleID
    )
   BEGIN
    SELECT 
     @MenuID=SettingValue 
    FROM 
     SageMenuSettingValue 
    WHERE 
      SettingKey='MenuID' 
     AND UserModuleID=@UserModuleID
   END
  ELSE
   BEGIN
    SELECT 
     @MenuID=MenuID 
    FROM 
     Menu 
    WHERE 
     IsDefault=1
   END
 SELECT 
  *,
  mi.PageID,
  (
   SELECT 
    COUNT(*) 
   FROM 
    MenuItem m 
   WHERE 
    m.ParentID=mi.MenuItemID
  ) AS ChildCount 
 FROM 
  [dbo].[MenuItem] mi 
 WHERE 
  mi.MenuID =@MenuID
 ORDER BY
  MenuLevel,MenuOrder
END





GO
