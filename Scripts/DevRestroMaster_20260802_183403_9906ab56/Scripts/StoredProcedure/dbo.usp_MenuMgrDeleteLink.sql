SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrDeleteLink]
@MenuItemID INT

AS 
BEGIN
 DELETE FROM 
  [dbo].[MenuItem] 
 WHERE 
  ParentID=@MenuItemID
 DELETE FROM 
  [dbo].[MenuItem] 
 WHERE 
  MenuItemID=@MenuItemID
END





GO
