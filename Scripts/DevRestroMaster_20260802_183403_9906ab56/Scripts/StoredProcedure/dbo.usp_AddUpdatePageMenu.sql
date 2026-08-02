SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [usp_AddUpdatePageMenu] 4,1,1,1

CREATE PROCEDURE [dbo].[usp_AddUpdatePageMenu] 
 @PageID INT,
 @PortalID INT,
 @IsAdmin BIT,
 @IsFooter BIT
AS
BEGIN

 IF @IsAdmin= 0
  BEGIN
   IF(EXISTS(SELECT 1 FROM [dbo].[PageMenu] WHERE PageID=@PageID))
    UPDATE [dbo].[PageMenu] SET IsAdmin=@IsAdmin,IsFooter=@IsFooter WHERE PageID=@PageID
   ELSE
    INSERT INTO [dbo].[PageMenu]([PageID],[PortalID],[IsAdmin],[IsFooter]) VALUES (@PageID,@PortalID,@IsAdmin,@IsFooter)
  END  
 ELSE
  BEGIN
   DECLARE @totalPortal int 
   DECLARE @count int
   DECLARE @newPortalID int
   DECLARE @portalTable Table(Row int identity(1,1), PId int )
   
   INSERT INTO @portalTable SELECT PortalId FROM Portal     
   SET @totalPortal = @@ROWCOUNT
   
   SET @count = 1
   
   WHILE(@count<=@totalPortal)
    BEGIN
     SELECT  @newPortalID = Pid FROM @portalTable WHERE Row = @Count
     
     IF( EXISTS(SELECT PageID FROM [dbo].[PageMenu] WHERE PageID=@PageID and PortalID = @newPortalID))
      UPDATE [dbo].[PageMenu] SET IsAdmin=@IsAdmin,IsFooter=@IsFooter WHERE PageID=@PageID   
     ELSE
      INSERT INTO [dbo].[PageMenu]([PageID],[PortalID],[IsAdmin],[IsFooter]) VALUES (@PageID,@newPortalID,@IsAdmin,@IsFooter)
     
     SET @count = @count + 1
    END
  END  
END





GO
