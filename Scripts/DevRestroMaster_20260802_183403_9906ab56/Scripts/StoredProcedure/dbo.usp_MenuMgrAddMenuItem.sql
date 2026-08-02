SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrAddMenuItem]
 @MenuID INT,
 @MenuItemID INT,
 @LinkType NVARCHAR(50),
 @PageID NVARCHAR(50),
 @Title NVARCHAR(50),
 @LinkURL NVARCHAR(50),
 @ImageIcon NVARCHAR(100),
 @Caption NVARCHAR(2000),
 @HtmlContent NVARCHAR(4000),
 @ParentID INT,
 @MenuLevel NVARCHAR(50),
 @MenuOrder NVARCHAR(50),
 @Mode NVARCHAR(50),
 @PreservePageOrder BIT,
 @MainParent INT,
 @IsActive BIT,
 @IsVisible BIT
AS
BEGIN
 DECLARE @NewParentID INT,@NewLevel INT,@NewOrder INT,@ParentLevel INT,@PortalID INT
 SET @PortalID= (
      SELECT 
       ISNULL(MAX(PortalID),0) 
      FROM 
       Menu 
      WHERE 
       MenuID=@MenuID
     )
  IF @Mode='A'
   BEGIN
    
    IF @PreservePageOrder=1
     BEGIN
      IF (EXISTS(SELECT * FROM MenuItem  WHERE PageID=@ParentID AND MenuID=@MenuID))
       BEGIN
        SELECT 
         @NewParentID=MenuItemID 
        FROM 
         MenuItem 
        WHERE 
          PageID=@ParentID 
         AND MenuID=@MenuID
        SET @NewLevel=@MenuLevel
        SELECT 
         @NewOrder=MAX(MenuOrder) 
        FROM 
         MenuItem 
        WHERE 
          ParentID=@ParentID 
         AND MenuID=@MenuID
        SET @NewOrder=@NewOrder+1
       END
      ELSE
       BEGIN
        SET @NewParentID=0   
         IF @NewParentID=0
          BEGIN
           SET @NewLevel=0
           SELECT 
            @NewOrder=MAX(MenuOrder) 
           FROM 
            MenuItem 
           WHERE 
             ParentID=@ParentID 
            AND MenuLevel=@NewLevel 
            AND MenuID=@MenuID
           SET @NewOrder= ISNULL(@NewOrder,0)+1
          END
         ELSE
          BEGIN
           SELECT 
            @ParentLevel=MenuLevel 
            FROM 
             MenuItem 
            WHERE 
             MenuItemID=@NewParentID   
            AND MenuID=@MenuID
           SET @NewLevel=@ParentLevel+1
           SELECT 
            @NewOrder=MAX(MenuOrder) 
           FROM 
            MenuItem 
           WHERE 
             ParentID=@ParentID   
            AND MenuID=@MenuID
           SET @NewOrder=ISNULL(@NewOrder,0)+1
          END
       END
     END
    ELSE
     BEGIN
      SET @NewParentID=@MainParent
       IF @NewParentID=0
        BEGIN
         SET @NewLevel=0
         SELECT 
          @NewOrder=MAX(MenuOrder) 
         FROM 
          MenuItem 
         WHERE 
           ParentID=0 
          AND MenuLevel=@NewLevel 
          AND MenuID=@MenuID
         SET @NewOrder=ISNULL(@NewOrder,0)+1
        END
       ELSE
        BEGIN
         SELECT 
          @ParentLevel=MenuLevel 
         FROM 
          MenuItem 
         WHERE 
           MenuItemID=@NewParentID 
          AND MenuID=@MenuID
         SET @NewLevel=@ParentLevel+1
         SELECT 
          @NewOrder=MAX(MenuOrder) 
         FROM 
          MenuItem 
         WHERE 
           ParentID=@ParentID 
          AND MenuID=@MenuID
         SET @NewOrder=ISNULL(@NewOrder,0)+1
        END
     END
    INSERT INTO MenuItem
          (
            MenuID
           ,LinkType
           ,PageID
           ,Title
           ,LinkURL 
           ,ImageIcon 
           ,Caption 
           ,HtmlContent
           ,ParentID 
           ,MenuLevel 
           ,MenuOrder 
           ,AddedOn
           ,IsActive
           ,IsVisible
           ,PortalID
          )
         VALUES
          (
            @MenuID
           ,@LinkType
           ,@PageID
           ,@Title
           ,@LinkURL 
           ,@ImageIcon 
           ,@Caption 
           ,@HtmlContent
           ,@NewParentID 
           ,@NewLevel
           ,@NewOrder
           ,GETDATE()
           ,@IsActive
           ,@IsVisible
           ,@PortalID
          )
   END
  ELSE
   BEGIN
    IF @ParentID<>0
     BEGIN
      SELECT 
       @NewLevel=MenuLevel 
      FROM 
       MenuItem 
      WHERE 
        MenuItemID=@ParentID 
       AND MenuID=@MenuID
      SET @NewLevel=ISNULL(@NewLevel,0)+1
     END
    ELSE
     BEGIN
      SET @NewLevel=0
     END
    UPDATE 
     [dbo].[MenuItem]
    SET 
     Caption=@Caption,
     MenuLevel=@NewLevel,
     IsActive=@IsActive,
     IsVisible=@IsVisible,
     PortalID=@PortalID,
     IsModified=1,
     ParentID=@ParentID,
     UpdatedOn=GETDATE()
    WHERE 
      MenuItemID=@MenuItemID 
     AND MenuID=@MenuID 
   END
END





GO
