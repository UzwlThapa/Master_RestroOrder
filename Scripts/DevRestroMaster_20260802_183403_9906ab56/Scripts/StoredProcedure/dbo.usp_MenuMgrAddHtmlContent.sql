SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrAddHtmlContent]
 @MenuID INT,
 @MenuItemID INT,
 @LinkType NVARCHAR(50),
 @Title NVARCHAR(50),
 @HtmlContent ntext,
 @ImageIcon NVARCHAR(100),
 @Caption NVARCHAR(2000),
 @ParentID NVARCHAR(50),
 @MenuLevel NVARCHAR(50),
 @IsVisible BIT,
 @Mode NVARCHAR(50),
 @IsActive BIT
AS
BEGIN
 DECLARE @GetMenuOrder INT,@PortalID INT;
 SET @PortalID = (
       SELECT 
        ISNULL(MAX(PortalID),0) 
       FROM 
        Menu 
       WHERE 
        MenuID=@MenuID
      )
 SET @GetMenuOrder = (
       SELECT 
        ISNULL(MAX(MenuOrder),0) 
       FROM 
        MenuItem 
       WHERE 
         MenuID=@MenuID 
        AND MenuLevel=@MenuLevel 
       AND ParentID=@ParentID 
      )
 SET @GetMenuOrder = @GetMenuOrder + 1
  IF (@Mode='A')
   BEGIN
    INSERT INTO MenuItem
         (
           MenuID
          ,LinkType
          ,Title
          ,HtmlContent 
          ,ImageIcon 
          ,Caption 
          ,ParentID 
          ,MenuLevel 
          ,MenuOrder 
          ,IsVisible
          ,AddedOn
          ,IsActive
          ,PortalID
         )
        VALUES
         (
           @MenuID
          ,@LinkType
          ,@Title
          ,@HtmlContent 
          ,@ImageIcon 
          ,@Caption 
          ,@ParentID
          ,@MenuLevel 
          ,@GetMenuOrder 
          ,@IsVisible
          ,GETDATE()
          ,@IsActive
          ,@PortalID
         )
   END
  ELSE
   BEGIN
    UPDATE 
     MenuItem
    SET 
     Title=@Title,
     HtmlContent=@HtmlContent,
     ImageIcon=@ImageIcon,
     Caption=@Caption,
     ParentID=@ParentID,
     MenuLevel=@MenuLevel,
     --MenuOrder=@GetMenuOrder,
     IsVisible=@IsVisible,
     IsActive=@IsActive,
     PortalID=@PortalID
    WHERE 
     MenuItemID=@MenuItemID
   END
END





GO
