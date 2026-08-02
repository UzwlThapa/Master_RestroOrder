SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP PROCEDURE [dbo].[sp_AddPagePermission]
CREATE PROCEDURE [dbo].[sp_AddPagePermission] (@PageID       INT,
                                              @RoleID       NVARCHAR(100)=NULL,
                                              @PermissionID INT,
                                              @AllowAccess  BIT,
                                              @Username     NVARCHAR(256)=NULL,
                                              @IsActive     BIT,
                                              @PortalID     INT,
                                              @AddedBy      NVARCHAR(256),
                                              @IsAdmin  BIT)
AS
  BEGIN
--  IF(@Username <>'')
--  BEGIN
--SET @RoleID = (SELECT  [dbo].[aspnet_UsersInRoles].roleid
--FROM         [dbo].[aspnet_UsersInRoles] INNER JOIN
--       [dbo].[aspnet_Users] ON [dbo].[aspnet_Users].userid = [dbo].[aspnet_UsersInRoles].userid
--       WHERE UserName=@Username)
--       END
  IF @IsAdmin = 0
   BEGIN
    INSERT INTO dbo.pagepermission
       (pageid,
        permissionid,
        allowaccess,
        roleid,
        username,
        isactive,
        addedon,
        portalid,
        addedby)
    VALUES      (@PageID,
        @PermissionID,
        @AllowAccess,
        @RoleID,
        @Username,
        @IsActive,
        GETDATE(),
        @PortalID,
        @AddedBy )
   END
  ELSE
   BEGIN   
   declare @totalPortal int 
   declare @count int
   declare @portalTable Table(Row int identity(1,1), PId int )
   Insert Into @portalTable
   select PortalId from Portal 
   Set @totalPortal = (select Count(*) from @portalTable)
   Set @count = 1
   While(@count<=@totalPortal)
    BEGIN  
       DECLARE @newPortalID INT
       SET @newPortalID =(SELECT PId FROM @portalTable WHERE Row = @Count)
       INSERT INTO dbo.pagepermission
          (pageid,
           permissionid,
           allowaccess,
           roleid,
           username,
           isactive,
           addedon,
           portalid,
           addedby)
       VALUES      (@PageID,
           @PermissionID,
           @AllowAccess,
           @RoleID,
           @Username,
           @IsActive,
           GETDATE(),
           @newPortalID,
           @AddedBy )
     Set @count = @count + 1
    END  
   
   END


   delete ump  FROM  UserModulePermission ump
   inner join PageModules pm on ump.UserModuleID=pm.UserModuleID
   where PageID=@PageID AND RoleID=@RoleID
   
   INSERT INTO UserModulePermission(UserModuleID, ModuleDefPermissionID, AllowAccess, RoleID, Username, IsActive,  AddedOn,  PortalID, AddedBy)
   SELECT        UserModuleID, ModuleDefPermissionID, @AllowAccess, @RoleID, @Username, @IsActive, getdate(),@newPortalID, @AddedBy
	FROM           (
    SELECT   DISTINCT     ump.UserModuleID, ModuleDefPermissionID
	FROM            UserModulePermission ump
   inner join PageModules pm on ump.UserModuleID=pm.UserModuleID
   where PageID=@PageID
   ) x
  

  END





GO
