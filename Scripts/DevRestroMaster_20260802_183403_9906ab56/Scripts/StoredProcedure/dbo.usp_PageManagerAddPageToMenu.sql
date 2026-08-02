SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PageManagerAddPageToMenu] 
(
@Mode VARCHAR(5), 
@MenuID INT, 
@MenuIDs NVARCHAR(50), 
@PageID NVARCHAR(50), 
@ParentID INT, 
@caption NVARCHAR(250),
@UpdateLabel VARCHAR(5) 
) 
AS 
  BEGIN 
 DECLARE @PageName NVARCHAR(250) 
 DECLARE @PortalID INT
 SET @PortalID= (
      SELECT 
       ISNULL(MAX(PortalID),0) 
      FROM 
       Menu 
      WHERE 
       MenuID=@MenuID
     )
      
      SELECT 
  @PageName = SEOName 
      FROM 
  Pages 
      WHERE 
  PageID = @PageID  
      
      DECLARE @NewParentID INT,@NewOrder INT,@MenuLevel INT 

   IF EXISTS (
     SELECT 
      MenuItemID 
     FROM 
      MenuItem 
     WHERE  
       pageid = @ParentID 
      AND menuid = @MenuID 
      AND linktype = 0 
    )
    BEGIN
     SELECT 
    @NewParentID = MenuItemID,
    @MenuLevel = MenuLevel 
     FROM  
    MenuItem 
     WHERE  
     PageID = @ParentID 
    AND menuid = @MenuID 
    AND linktype = 0 
    END
   ELSE
    BEGIN
   SET @NewParentID=0
   SET @MenuLevel=0
    END
    
  SELECT 
   @NewOrder = MAX(menuorder) 
  FROM 
   MenuItem 
  WHERE
    ParentID = @ParentID 
   AND MenuID = @MenuID 
   AND LinkType = 0 

      SET @NewOrder=ISNULL(@NewOrder, 0) + 1

   IF @ParentID <> 0 
  BEGIN 
   SET @MenuLevel=ISNULL(@MenuLevel, 0) + 1 
  END 
   ELSE 
  BEGIN 
   SET @MenuLevel=ISNULL(@MenuLevel, 0) 
  END 
      SET @NewParentID=ISNULL(@NewParentID, 0)
      IF @Mode = 'A' 
        BEGIN 
            INSERT INTO [dbo].[MenuItem] 
         (
            MenuID, 
            LinkType, 
            PageID, 
            Title, 
            LinkURL, 
            ImageIcon, 
            Caption, 
            HtmlContent, 
            ParentID, 
            MenuLevel, 
            MenuOrder, 
            AddedOn, 
            IsActive, 
            IsVisible,
            PortalID
          ) 
        VALUES      
         ( 
           @MenuID, 
           0, 
           @PageID, 
           @PageName, 
           '', 
           '', 
           @caption, 
           '', 
           ISNULL(@NewParentID, 0) , 
           @MenuLevel, 
           @NewOrder, 
           GETDATE(), 
           1, 
           1,
           @PortalID 
         ) 
        END 
      ELSE 
        IF @Mode = 'E' 
          BEGIN
   IF @UpdateLabel='NA'
    BEGIN
     SET @MenuLevel = 0
    END 
     IF @MenuIDs<>'0'
      BEGIN 
       DELETE FROM 
      [dbo].[MenuItem] 
       WHERE  
       pageid = @PageID
      AND menuid NOT IN
           (
            SELECT 
             RTRIM(LTRIM(items)) 
            FROM   
             Split(@MenuIDs, ',')
           )
      END
     ELSE IF @MenuIDs='0'
    BEGIN
         DELETE FROM 
      [dbo].[MenuItem] 
      WHERE  
      pageid = @PageID 
    END

              DECLARE @TblTemp TABLE
      ( 
       num    INT IDENTITY(1, 1), 
       menuid INT
      ) 
              DECLARE @RowTotal INT 

              INSERT INTO @TblTemp 
              SELECT 
    RTRIM(LTRIM(items)) 
              FROM   
    dbo.Split(@MenuIDs, ',') 

              SELECT 
    @RowTotal = COUNT(*) 
              FROM   
    @TblTemp 

              WHILE( @RowTotal > 0 ) 
                BEGIN 
                    DECLARE @MenuID1 INT 

                    SELECT 
      @MenuID1 = menuid 
                    FROM  
      @TblTemp 
                    WHERE  
      num = @RowTotal       
     set @NewParentID = (SELECT MenuItemID FROM   menuitem WHERE  pageid = @ParentID AND menuid = @MenuID1)      
                    IF( 
      EXISTS(
        SELECT 
         * 
        FROM   
         menuitem 
                               WHERE  
         pageid = @pageid 
                                AND menuid = @MenuID1) ) 
                      BEGIN 
                        UPDATE                                                 
       [dbo].[MenuItem] 
      SET    
        linktype = 0, 
        title = @PageName, 
        linkurl = '', 
        imageicon = '', 
        caption = @caption, 
        htmlcontent = '', 
        parentid = ISNULL(@NewParentID,0), 
        menulevel = @MenuLevel, 
        addedon = GETDATE(), 
        isactive = 1, 
        isvisible = 1 
                         WHERE  
        menuid = @MenuID1 
       AND pageid = @PageID 
                      END 
                    ELSE 
                      BEGIN 
                          INSERT INTO [dbo].[MenuItem] 
          (
           menuid, 
           linktype, 
           pageid, 
           title, 
           linkurl, 
           imageicon, 
           caption, 
           htmlcontent, 
           parentid, 
           menulevel, 
           menuorder, 
           addedon, 
           isactive, 
           isvisible,
           PortalID
          ) 
         VALUES      
          ( 
           @MenuID1, 
           0, 
           @PageID, 
           @PageName, 
           '', 
           '', 
           @caption, 
           '', 
           ISNULL(@NewParentID,0), 
           @MenuLevel, 
           @NewOrder, 
           GETDATE(), 
           1, 
           1,
           @PortalID 
          ) 
                      END 

                    SET @RowTotal=@RowTotal - 1 
                END 
          END 
  END





GO
