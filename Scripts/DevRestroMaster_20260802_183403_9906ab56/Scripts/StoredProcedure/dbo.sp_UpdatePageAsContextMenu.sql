SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- earlier the @IsVisible BIT=NULL, @IsPublish bit=NULL this is updated if not published 0-- swantina 20131128


CREATE PROCEDURE [dbo].[sp_UpdatePageAsContextMenu]
@PageID INT,
@IsVisible BIT=0,
@IsPublish BIT=0,
@PortalID INT,
@AddedBy NVARCHAR(256),
@updateFor NVARCHAR(1)
AS
BEGIN
 IF @updateFor ='M'
  BEGIN    
   UPDATE 
    [dbo].[Pages]  
   SET   
     [IsVisible] = @IsVisible
    ,[IsModified] = 1
    ,[UpdatedOn] = GETDATE()
    ,[PortalID] = @PortalID
    ,[UpdatedBy] = @AddedBy    
   WHERE 
     PortalID=@PortalID 
    AND PageID=@PageID  
  END 
 ELSE IF @updateFor ='P'
  BEGIN
   UPDATE [dbo].[Pages]  SET 
   
      [IsActive]=@IsPublish
     ,[IsModified] = 1
     ,[UpdatedOn] = GETDATE()
     ,[PortalID] = @PortalID
     ,[UpdatedBy] = @AddedBy    
   WHERE PortalID=@PortalID AND PageID=@PageID  
  END
END





GO
