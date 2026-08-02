SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrSortMenuItems]
(
 @MenuID INT,
 @MenuItemID INT,
 @ParentID INT,
 @BeforeID INT,
 @AfterID INT,
 @PortalID INT
)

AS
BEGIN
 DECLARE @MenuLevel INT
 DECLARE @MenuOrder INT
 
  IF @ParentID>0
   BEGIN
    SELECT 
     @MenuLevel=MenuLevel 
    FROM 
     MenuItem 
    WHERE 
     MenuID=@MenuID 
    AND 
     MenuItemID=@ParentID 

    SET @MenuLevel=@MenuLevel+1
    SELECT 
     @MenuOrder=MenuOrder 
    FROM 
     MenuItem 
    WHERE 
      MenuID=@MenuID 
     AND MenuItemID=@ParentID 
     AND MenuLevel=@MenuLevel 
   END
  ELSE IF @ParentID=0
   BEGIN
    SET @MenuLevel=0
    SELECT 
     @MenuOrder=MenuOrder 
    FROM 
     MenuItem 
    WHERE 
      MenuID=@MenuID 
     AND MenuLevel=@MenuLevel 
   END
   
 UPDATE 
  MenuItem 
 SET 
  ParentID=@ParentID,
  MenuLevel=@MenuLevel,
  MenuOrder=@MenuOrder
 WHERE 
  MenuItemID=@MenuItemID
END





GO
