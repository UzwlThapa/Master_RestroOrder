SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserModuleHistory]
 @PageID varchar(1000),
 @DeletedBy nvarchar(256),
 @PortalID int
       
 AS 
 BEGIN 
 SET NOCOUNT ON;
  --- update SHowinpages in History table -- added swantina 20140108
  
   DECLARE @PageIdPstnFirstOrMiddle varchar(100) 
   DECLARE @PageIdPstnEnd varchar(100) 

   SET @PageIdPstnFirstOrMiddle = @PageId + ','   
   SET @PageIdPstnEnd =  ',' +@PageId 
   

   IF EXISTS(SELECT CHARINDEX(@PageId,ShowInPages) 
   FROM   UserModules
   WHERE  ShowInPages = @PageID AND PortalID = @PortalID) 
    BEGIN

     INSERT INTO [UserModules_History] 
     SELECT Getdate(),'U', @DeletedBy, * FROM [UserModules] WHERE ShowInPages = @PageID;

     UPDATE [UserModules] SET ShowInPages = NULL, [IsActive] =0 ,[IsDeleted] = 1  WHERE   ShowInPages = @PageID AND PortalID = @PortalID;     
    END   

   ELSE IF EXISTS(SELECT CHARINDEX(@PageIdPstnFirstOrMiddle,ShowInPages) 
   FROM   UserModules
   WHERE  ShowInPages like '%'+@PageIdPstnFirstOrMiddle +'%' AND PortalID = @PortalID ) 
    BEGIN

       INSERT INTO [UserModules_History] 
       SELECT Getdate(),'U', @DeletedBy, * FROM [UserModules] WHERE ShowInPages like '%'+@PageIdPstnFirstOrMiddle +'%' AND PortalID = @PortalID;

       UPDATE UserModules
       SET  ShowInPages =   SUBSTRING(ShowInPages,0,CHARINDEX(@PageIdPstnFirstOrMiddle,ShowInPages))+ SUBSTRING(ShowInPages,CHARINDEX(@PageIdPstnFirstOrMiddle,ShowInPages)+LEN(@PageIdPstnFirstOrMiddle),LEN(ShowInPages))
        ,[IsActive] =0 ,[IsDeleted] = 1 WHERE  ShowInPages like '%'+@PageIdPstnFirstOrMiddle +'%' AND PortalID = @PortalID  

    END

   ELSE IF EXISTS(SELECT CHARINDEX(@PageIdPstnEnd,ShowInPages) 
     FROM   UserModules
     WHERE ShowInPages like '%'+@PageIdPstnEnd +'%' AND PortalID = @PortalID ) 
    BEGIN
     

      INSERT INTO [UserModules_History] 
      SELECT Getdate(),'U', @DeletedBy, * FROM [UserModules] WHERE ShowInPages like '%'+@PageIdPstnEnd +'%' AND PortalID = @PortalID;

      --SUBSTRING(ShowInPages,0,CHARINDEX(@PageIdPstnEnd,ShowInPages)+1)+ SUBSTRING(ShowInPages,CHARINDEX(@PageIdPstnEnd,ShowInPages)+ LEN(@PageIdPstnEnd),LEN(ShowInPages))  

      UPDATE UserModules 
      SET     ShowInPages = SUBSTRING(ShowInPages,0,CHARINDEX(@PageIdPstnEnd,ShowInPages))--+ SUBSTRING(ShowInPages,CHARINDEX(@PageIdPstnEnd,ShowInPages)+ LEN(@PageIdPstnEnd),LEN(ShowInPages))  
        ,[IsActive] =0 ,[IsDeleted] = 1
      WHERE   ShowInPages like '%'+@PageIdPstnEnd +'%'   AND PortalID = @PortalID
    END 

 END





GO
