SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PortalAdd]
 @PortalName NVARCHAR(200),
 @IsParent BIT,
 @TemplateName NVARCHAR(250),
 @UserName NVARCHAR(256),
 
 @PortalParentID INT,
 @PSEOName NVARCHAR(256)
AS
BEGIN
 DECLARE @PortalSEOName NVARCHAR(100), @PortalID INT,@SuperUserID UNIQUEIDENTIFIER
 SELECT @SuperUserID=UserId FROM [dbo].[Aspnet_Users] 
 WHERE LoweredUserName='superuser'
 
 IF(@PSEOName ='')
 SET @PortalSEOName=LOWER(LTRIM(RTRIM(REPLACE(@PortalName,' ','_'))))
 ELSE
 SET @PortalSEOName=@PSEOName
 
 IF(EXISTS(SELECT * FROM dbo.Portal WHERE [SEOName]=@PortalSEOName and IsParent=0))
 BEGIN
  RAISERROR('Portal Already Exist!', 16, 1)
 END
 ELSE
 BEGIN
  INSERT INTO [dbo].[Portal]
      ([Name]
      ,[SEOName]
      ,[IsParent]
      ,[ParentID])
   VALUES
      (@PortalName
      ,@PortalSEOName
      ,@IsParent
      ,@PortalParentID)
  
  SET @PortalID=@@IDENTITY;
  INSERT INTO PageMenu ( PageID, PortalID, IsAdmin, IsFooter,ShowInMenu )
       ( SELECT  PageID, @PortalID ,IsAdmin,IsFooter,ShowInMenu FROM    PageMenu WHERE   PageMenu.PortalID = 1 AND IsAdmin=1)
  --EXEC dbo.usp_PortalUsersAdd @SuperUserID,'superuser','superuser','superuser','info@sageframe.com',1,null,@PortalID,'superuser'
  ----Search Table Update
  INSERT INTO [SageFrameSearchProcedure]
           ([SageFrameSearchTitle]
           ,[SageFrameSearchProcedureName]
           ,[SageFrameSearchProcedureExecuteAs]
           ,[IsActive]
           ,[IsDeleted]
           ,[IsModified]
           ,[AddedOn]
           ,[UpdatedOn]
           ,[DeletedOn]
           ,[PortalID]
           ,[AddedBy]
           ,[UpdatedBy]
           ,[DeletedBy])
     (SELECT[SageFrameSearchTitle]
           ,[SageFrameSearchProcedureName]
           ,[SageFrameSearchProcedureExecuteAs]
           ,[IsActive]
           ,[IsDeleted]
           ,[IsModified]
           ,[AddedOn]
           ,[UpdatedOn]
           ,[DeletedOn]
           ,@PortalID
           ,[AddedBy]
           ,[UpdatedBy]
           ,[DeletedBy] from [SageFrameSearchProcedure]
           WHERE   [SageFrameSearchProcedure].[PortalID] = 1)
           
  EXEC [dbo].[usp_sftemplate_activate] @TemplateName,1,@PortalID
    
  INSERT INTO dbo.SettingValue(SettingType,SettingKey,SettingValue,
  SettingTypeID,IsActive,AddedOn,AddedBy,IsCacheable)
  Select SettingType,SettingKey,SettingValue,@PortalID,1,GetDATE(),
  @UserName,IsCacheable FROM dbo.SettingKey WHERE SettingType='SiteAdmin'
  
  DECLARE @ModuleID INT,@PortalModuleID INT,@ModuleIsActive BIT
  DECLARE CurModule CURSOR FOR
  SELECT ModuleID,IsActive FROM [dbo].[Modules] WHERE IsRequired=1 
  AND (IsDeleted=0 OR IsDeleted IS NULL)
  OPEN CurModule   
  FETCH NEXT FROM CurModule INTO @ModuleID,@ModuleIsActive
  WHILE @@FETCH_STATUS=0
  BEGIN
   INSERT INTO [dbo].[PortalModules]
      ([PortalID]
      ,[ModuleID]
      ,[IsActive]
      ,[AddedOn]
      ,[AddedBy])
   VALUES(@PortalID,@ModuleID,@ModuleIsActive,GETDATE(),@UserName)
   SET @PortalModuleID=@@IDENTITY 
   
   DECLARE @RoleID UNIQUEIDENTIFIER
   SELECT @RoleID=RoleId FROM [dbo].Aspnet_roles WHERE RoleName='super user'
   INSERT INTO [dbo].[PortalModulePermission]
         ([PortalModuleID]
         ,[ModuleDefPermissionID]
         ,[AllowAccess]
         ,[RoleID]
         ,[Username]
         ,[IsActive]
         ,[AddedOn]
         ,[AddedBy])
   SELECT @PortalModuleID,ModuleDefPermissionID,1,@RoleID,NULL,1,GETDATE(),@UserName 
   FROM ModuleDefinitions MD INNER JOIN ModuleDefPermission MDP 
   ON MD.ModuleDefID=MDP.ModuleDefID WHERE MD.ModuleID=@ModuleID AND
   (MDP.IsDeleted=0 OR MDP.IsDeleted IS NULL)
   
   SELECT @RoleID=RoleId FROM [dbo].aspnet_roles WHERE RoleName='site admin'
   INSERT INTO [dbo].[PortalModulePermission]
         ([PortalModuleID]
         ,[ModuleDefPermissionID]
         ,[AllowAccess]
         ,[RoleID]
         ,[Username]
         ,[IsActive]
         ,[AddedOn]
         ,[AddedBy])
   SELECT @PortalModuleID,ModuleDefPermissionID,1,@RoleID,NULL,1,GETDATE(),@UserName 
   FROM ModuleDefinitions MD INNER JOIN ModuleDefPermission MDP 
   ON MD.ModuleDefID=MDP.ModuleDefID WHERE MD.ModuleID=@ModuleID AND 
   (MDP.IsDeleted=0 OR MDP.IsDeleted IS NULL)
   FETCH NEXT FROM CurModule INTO @ModuleID,@ModuleIsActive
  END
  CLOSE CurModule
  DEALLOCATE CurModule

  DECLARE @Name VARCHAR(40),@PageID INT,@NewPageID INT, @PageOrder INT
      ,@PageName NVARCHAR(100)
      ,@IsVisible BIT
      ,@ParentID INT
      ,@Level INT
      ,@IconFile NVARCHAR(100)
      ,@DisableLink BIT
      ,@Title NVARCHAR(200)
      ,@Description NVARCHAR(500)
      ,@KeyWords NVARCHAR(500)
      ,@Url NVARCHAR(255)
      ,@TabPath NVARCHAR(255)
      ,@StartDate DATETIME
      ,@EndDate DATETIME
      ,@RefreshInterval DECIMAL(16,2)
      ,@PageHeadText NVARCHAR(500)
      ,@IsSecure BIT
      ,@IsActive BIT
      ,@SEOName NVARCHAR(100)
      ,@IsShowInFooter BIT
      ,@IsRequiredPage BIT
      
  SELECT PageID,PageOrder,PageName,IsVisible,ParentID,[Level],IconFile,DisableLink,
  Title,Description,KeyWords,Url,TabPath ,StartDate,EndDate ,RefreshInterval,
  PageHeadText,IsSecure,IsActive,SEOName,IsShowInFooter,IsRequiredPage 
  
  INTO #tblReqPages FROM dbo.Pages WHERE IsRequiredPage=1 AND 
  (IsDeleted=0 OR IsDeleted IS NULL) AND PortalID=1
  
  DECLARE CurReqPages CURSOR FOR 
  SELECT PageID,PageOrder,PageName,IsVisible,ParentID,[Level],IconFile,DisableLink,Title,
  Description,KeyWords,Url,TabPath ,StartDate,EndDate ,RefreshInterval,PageHeadText,
  IsSecure,IsActive,SEOName,IsShowInFooter,IsRequiredPage FROM #tblReqPages
  
  OPEN CurReqPages
  
  FETCH NEXT FROM CurReqPages INTO @PageID,@PageOrder,@PageName,@IsVisible,@ParentID,
  @Level,@IconFile,@DisableLink,@Title,@Description,@KeyWords,@Url,@TabPath ,
  @StartDate,@EndDate ,@RefreshInterval,@PageHeadText,@IsSecure,@IsActive,@SEOName,
  @IsShowInFooter,@IsRequiredPage
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN
    INSERT INTO [dbo].[Pages](PageOrder,PageName,IsVisible,ParentID,[Level],IconFile,
    DisableLink,Title,Description,KeyWords,Url,TabPath ,StartDate,EndDate ,
    RefreshInterval,PageHeadText,IsSecure,IsActive,SEOName,IsShowInFooter,
    IsRequiredPage,PortalID,AddedOn,AddedBy)
        VALUES(@PageOrder,@PageName,@IsVisible,@ParentID,@Level,@IconFile,
        @DisableLink,@Title,@Description,@KeyWords,@Url,@TabPath ,@StartDate,
        @EndDate ,@RefreshInterval,@PageHeadText,@IsSecure,@IsActive,
        @SEOName,@IsShowInFooter,1,@PortalID,GETDATE(),@UserName)
    SET @NewPageID=@@IDENTITY

   INSERT INTO PagePreview (
   PageID
   ,PreviewCode
   )
   VALUES (
   @NewPageID
   ,convert(NVARCHAR(256), NEWID())
   )



    --add to pagemenu
    --IF @PageID=1
    --BEGIN
    --EXECUTE [dbo].[usp_PageMenuAdd] @NewPageID,@PortalID,0,@IsShowInFooter
    --END
    --ELSE
    --BEGIN
    EXECUTE [dbo].[usp_PageMenuAdd] @NewPageID,@PortalID,0,@IsShowInFooter
    --END
    INSERT INTO [dbo].[PagePermission]
          ([PageID]
          ,[PermissionID]
          ,[AllowAccess]
          ,[RoleID]
          ,[Username]
          ,[IsActive]
          ,[AddedOn]
          ,[PortalID]
          ,[AddedBy])
    SELECT @NewPageID,[PermissionID]
          ,[AllowAccess]
          ,[RoleID]
          ,[Username],[IsActive],GETDATE(),@PortalID,@UserName 
          FROM PagePermission WHERE PageID=@PageID
   
  FETCH NEXT FROM CurReqPages INTO 
    @PageID,@PageOrder,@PageName,@IsVisible,@ParentID,@Level,@IconFile,
    @DisableLink,@Title,@Description,@KeyWords,@Url,@TabPath ,@StartDate,@EndDate ,
    @RefreshInterval,@PageHeadText,@IsSecure,@IsActive,@SEOName,@IsShowInFooter,
    @IsRequiredPage
  END
  CLOSE CurReqPages
  DEALLOCATE CurReqPages
 
  --INSERT INTO PageMenu Values(select PageID From PageMenu where PortalID=1 and IsAdmin = 1 , @PortalID, 1, 0,1)
 


  DECLARE @MessageTemplateTypeID INT, @NewMessageTemplateTypeID INT 
  DECLARE @MessageTemplateTypeName NVARCHAR(200), @MessageTemplateTypeIsActive BIT
  DECLARE CurMessageTemplateType CURSOR FOR 
  SELECT MessageTemplateTypeID,[Name],[IsActive] FROM [MessageTemplateType] 
  WHERE PortalID=1 AND (IsDeleted=0 OR IsDeleted IS NULL)
  OPEN CurMessageTemplateType
  FETCH NEXT FROM CurMessageTemplateType INTO @MessageTemplateTypeID,@MessageTemplateTypeName,
  @MessageTemplateTypeIsActive 
  WHILE @@FETCH_STATUS = 0  
  BEGIN
   INSERT INTO [dbo].[MessageTemplateType]([Name] ,[IsActive] ,[AddedOn],[PortalID] ,
   [AddedBy])
   VALUES( @MessageTemplateTypeName,@MessageTemplateTypeIsActive,GETDATE() ,@PortalID ,@UserName)
   SET @NewMessageTemplateTypeID=@@IDENTITY   
   INSERT INTO [dbo].[MessageTemplateTypeToken]([MessageTemplateTypeID],[MessageTokenID],[IsActive],[AddedOn],[PortalID],[AddedBy])
   SELECT @NewMessageTemplateTypeID ,[MessageTokenID] ,[IsActive] ,GETDATE() ,@PortalID ,@UserName FROM [dbo].[MessageTemplateTypeToken] 
   WHERE MessageTemplateTypeID=@MessageTemplateTypeID AND (IsDeleted=0 OR IsDeleted IS NULL)

   INSERT INTO [dbo].[MessageTemplate]([MessageTemplateTypeID],[Subject] ,[Body] ,[MailFrom], Culture, [IsActive] ,[AddedOn],[PortalID],[AddedBy])
   SELECT @NewMessageTemplateTypeID,[Subject],[Body],[MailFrom], 'en-US', [IsActive],GETDATE(),@PortalID,@UserName FROM [dbo].[MessageTemplate] 
   WHERE MessageTemplateTypeID=@MessageTemplateTypeID AND (IsDeleted=0 OR IsDeleted IS NULL)

   INSERT INTO [dbo].[MessageTemplateTypeMap]([MessageTemplateTypeID],[PortalSpecID],[PortalID])
   SELECT @MessageTemplateTypeID,@NewMessageTemplateTypeID,@PortalID 
   FETCH NEXT FROM CurMessageTemplateType INTO @MessageTemplateTypeID,@MessageTemplateTypeName,@MessageTemplateTypeIsActive    
  END
  CLOSE CurMessageTemplateType
  DEALLOCATE CurMessageTemplateType
 END
 ---User Agent
 INSERT INTO UserAgent(AgentMode,PortalID,ChangedBy,ChangedDate,IsActive) VALUES('3',@PortalID,@UserName,GETDATE(),1)

END





GO
