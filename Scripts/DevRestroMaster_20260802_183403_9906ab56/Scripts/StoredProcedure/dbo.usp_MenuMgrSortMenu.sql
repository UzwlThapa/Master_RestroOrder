SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrSortMenu]
 @MenuItemID INT,
 @ParentID INT,
 @BeforeID INT,
 @AfterID INT,
 @PortalID INT
AS
BEGIN
 IF(
  EXISTS
   (
    SELECT 
     *  
    FROM 
     [dbo].[MenuItem] 
    WHERE 
     MenuItemID=@MenuItemID
   )
  )
   BEGIN 
   DECLARE @ParentLevel INT, @MenuOrder INT,@oldParentID INT,@oldMenuOrder INT
   SELECT 
    @ParentLevel=MenuLevel 
   FROM 
    MenuItem 
   WHERE 
    MenuItemID=@ParentID  
   SELECT 
    @oldParentID=ParentID,
    @oldMenuOrder=MenuOrder 
   FROM 
    [dbo].[MenuItem] 
   WHERE 
    MenuItemID=@MenuItemID  
    
    IF @oldParentID <> @ParentID
     BEGIN     
      UPDATE 
       MenuItem 
      SET 
       MenuOrder=MenuOrder-1 
      WHERE 
        MenuOrder>@oldMenuOrder 
       AND ParentID=@oldParentID  
     END
     DECLARE @CurrentSortValue INT
     SELECT 
      @CurrentSortValue=MenuOrder 
     FROM 
      dbo.MenuItem 
     WHERE 
       [MenuItemID]=@MenuItemID  
      AND ParentID=@ParentID     
    IF(@BeforeID>0)
     BEGIN
      UPDATE 
       MenuItem 
      SET 
       MenuOrder=MenuOrder-1 
      WHERE 
        MenuOrder>@CurrentSortValue  
       AND ParentID=@ParentID
      SELECT 
       @MenuOrder=[MenuOrder] 
      FROM 
       MenuItem 
      WHERE 
       MenuItemID=@BeforeID 
      UPDATE 
       MenuItem 
      SET 
       MenuOrder=MenuOrder+1 
      WHERE 
        MenuOrder>=@MenuOrder  
       AND ParentID=@ParentID
     END     
    ELSE IF(@AfterID>0)
     BEGIN
      UPDATE 
       MenuItem 
      SET 
       MenuOrder=MenuOrder-1 
      WHERE 
        MenuOrder>@CurrentSortValue  
       AND ParentID=@ParentID 
      SELECT 
       @MenuOrder=[MenuOrder] 
      FROM 
       MenuItem 
      WHERE 
       MenuItemID=@AfterID
      UPDATE 
       MenuItem 
      SET 
       MenuOrder=MenuOrder+1 
      WHERE 
        MenuOrder>@MenuOrder 
       AND ParentID=@ParentID
      SET @MenuOrder=@MenuOrder+1
     END
    ELSE
     BEGIN
      SET @MenuOrder=@CurrentSortValue
     END
   
      UPDATE 
       [dbo].[MenuItem]  
      SET 
        [MenuOrder] = ISNULL(@MenuOrder,1)   
       ,[ParentID] = @ParentID
       ,MenuLevel = ISNULL(@ParentLevel,-1)+1        
      WHERE  
       MenuItemID=@MenuItemID
  END
END





GO
