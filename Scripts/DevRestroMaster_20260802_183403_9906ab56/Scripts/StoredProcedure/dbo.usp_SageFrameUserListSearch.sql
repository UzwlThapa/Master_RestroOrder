SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_SageFrameUserListSearch]
 @RoleID [NVARCHAR](36),
 @SearchText [NVARCHAR](4000),
 @PortalID [INT],
 @UserName NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
BEGIN
 DECLARE @SearchResult AS TABLE
        (
        UserId UNIQUEIDENTIFIER
        ,UserName NVARCHAR(256)
        ,FirstName NVARCHAR(100)
        ,LastName NVARCHAR(100)
        ,LoweredUserName NVARCHAR(256)
        ,LastActivityDate DATETIME
        ,Email NVARCHAR(256)
		,PINcode nvarchar(4)
        ,LastLoginDate DATETIME
        ,LastPasswordChangedDate DATETIME
        ,LastLockoutDate DATETIME
        ,PortalID INT
        ,PortalSEOName NCHAR(100)
        ,IsActive BIT
        ,IsModified BIT
        ,AddedOn DATETIME 
        ,UpdatedOn DATETIME
        ,DeletedOn DATETIME
        ,AddedBy NVARCHAR(256)
        ,UpdatedBy NVARCHAR(256)
        ,DeletedBy NVARCHAR(256)
        )
        
 DECLARE @TblSearchText as Table
        (
         RowNum INT,
         SearchText NVARCHAR(100)
        )
 DECLARE @SearchCount INT, @Counter INT, @UserHasHostRole BIT, @HostRoleId UNIQUEIDENTIFIER
 SELECT @HostRoleId=RoleId FROM dbo.aspnet_roles WHERE RoleName='Super User' OR RoleName='Site Admin'
 if(EXISTS(SELECT * FROM dbo.aspnet_usersinroles uir INNER JOIN dbo.aspnet_users u ON uir.UserId=u.UserId 
 INNER JOIN dbo.aspnet_roles r on uir.RoleId = r.RoleId WHERE u.Username=@UserName AND r.RoleName='Super User' OR r.RoleName='Site Admin' ))
 BEGIN
  SET @UserHasHostRole=1
 END
 ELSE
 BEGIN
  SET @UserHasHostRole=0
 END
 DECLARE @tmpSearchText NVARCHAR(100)
 IF(@RoleID<>'')
 BEGIN
  IF(@SearchText<>'')
  BEGIN
   INSERT INTO @TblSearchText(RowNum,SearchText)
   SELECT row_number()OVER(ORDER BY items),rtrim(ltrim(items)) FROM split(@SearchText,' ')
   SELECT @SearchCount=count(RowNum) FROM @TblSearchText
   SET @counter=1
   WHILE(@counter<=@SearchCount or @counter=1)
   BEGIN
    SELECT @tmpSearchText=SearchText FROM   @TblSearchText WHERE RowNum = @counter;
    IF @UserHasHostRole=1
    BEGIN
     INSERT INTO @SearchResult
     (
     UserId
     ,UserName
     ,[FirstName]
     ,LastName
     ,LoweredUserName
     ,LastActivityDate
     ,Email
	 ,PINcode
     ,LastLoginDate
     ,LastPasswordChangedDate
     ,LastLockoutDate
     ,PortalID
     ,PortalSEOName
     ,IsActive
     ,IsModified
     ,AddedOn
     ,UpdatedOn
     ,DeletedOn
     ,AddedBy
     ,UpdatedBy
     ,DeletedBy
     )
     SELECT DISTINCT 
      sfu.UserId
      ,sfu.UserName
      ,sfu.[FirstName]
      ,sfu.LastName
      ,sfu.LoweredUserName
      ,sfu.LastActivityDate
      ,sfu.Email
	  ,sfu.PINcode
      ,sfu.LastLoginDate
      ,sfu.LastPasswordChangedDate
      ,sfu.LastLockoutDate
      ,sfu.PortalID
      ,sfu.PortalSEOName
      ,sfu.IsActive
      ,sfu.IsModified
      ,sfu.AddedOn
      ,sfu.UpdatedOn
      ,sfu.DeletedOn
      ,sfu.AddedBy
      ,sfu.UpdatedBy
      ,sfu.DeletedBy 
     FROM vw_PortalUsers sfu
     INNER JOIN aspnet_usersinroles  uir ON sfu.UserId = uir.UserId
     WHERE (PortalID=@PortalID or uir.RoleId in (select RoleId from aspnet_Roles where RoleName='Super User'))       
     AND ( sfu.UserName like @tmpSearchText+'%'
       )
     AND (uir.RoleId = Convert(UNIQUEIDENTIFIER,@RoleId)) 
     AND sfu.UserName<>'anonymoususer'
    END
    ELSE
    BEGIN
     INSERT INTO @SearchResult
     (
     UserId
     ,UserName
     ,[FirstName]
     ,LastName
     ,LoweredUserName
     ,LastActivityDate
     ,Email
	 ,PINcode
     ,LastLoginDate
     ,LastPasswordChangedDate
     ,LastLockoutDate
     ,PortalID
     ,PortalSEOName
     ,IsActive
     ,IsModified
     ,AddedOn
     ,UpdatedOn
     ,DeletedOn
     ,AddedBy
     ,UpdatedBy
     ,DeletedBy
     )
     SELECT DISTINCT sfu.UserId
      ,sfu.UserName
      ,sfu.[FirstName]
      ,sfu.LastName
      ,sfu.LoweredUserName
      ,sfu.LastActivityDate
      ,sfu.Email
	 ,sfu.PINcode
      ,sfu.LastLoginDate
      ,sfu.LastPasswordChangedDate
      ,sfu.LastLockoutDate
      ,sfu.PortalID
      ,sfu.PortalSEOName
      ,sfu.IsActive
      ,sfu.IsModified
      ,sfu.AddedOn
      ,sfu.UpdatedOn
      ,sfu.DeletedOn
      ,sfu.AddedBy
      ,sfu.UpdatedBy
      ,sfu.DeletedBy 
     FROM vw_PortalUsers sfu
     INNER JOIN aspnet_usersinroles  uir ON sfu.UserId = uir.UserId
    WHERE (PortalID=@PortalID or uir.RoleId in (select RoleId from aspnet_Roles where RoleName='Super User'))        
     AND ( sfu.UserName like @tmpSearchText+'%'
)
     AND (uir.RoleId = Convert(UNIQUEIDENTIFIER,@RoleId)) 
     AND sfu.UserName<>'anonymoususer'
    END
    SET @counter=@counter+1
   END
  END
  ELSE
  BEGIN
   IF(@SearchText<>'')
   BEGIN
    INSERT INTO @SearchResult
    SELECT sfu.UserId
    ,sfu.UserName
    ,sfu.[FirstName]
    ,sfu.LastName
    ,sfu.LoweredUserName
    ,sfu.LastActivityDate
    ,sfu.Email
	 ,sfu.PINcode
    ,sfu.LastLoginDate
    ,sfu.LastPasswordChangedDate
    ,sfu.LastLockoutDate
    ,sfu.PortalID
    ,sfu.PortalSEOName
    ,sfu.IsActive
    ,sfu.IsModified
    ,sfu.AddedOn
    ,sfu.UpdatedOn
    ,sfu.DeletedOn
    ,sfu.AddedBy
    ,sfu.UpdatedBy
    ,sfu.DeletedBy
    FROM vw_PortalUsers sfu
     INNER JOIN aspnet_usersinroles  uir on sfu.UserId = uir.UserId
    WHERE (PortalID=@PortalID)    
    AND (uir.RoleId = Convert(UNIQUEIDENTIFIER,@RoleId))
    AND sfu.UserName<>'anonymoususer'
   END
   ELSE
   BEGIN
    INSERT INTO @SearchResult
    SELECT sfu.UserId
    ,sfu.UserName
    ,sfu.[FirstName]
    ,sfu.LastName
    ,sfu.LoweredUserName
    ,sfu.LastActivityDate
    ,sfu.Email
	 ,sfu.PINcode
    ,sfu.LastLoginDate
    ,sfu.LastPasswordChangedDate
    ,sfu.LastLockoutDate
    ,sfu.PortalID
    ,sfu.PortalSEOName
    ,sfu.IsActive
    ,sfu.IsModified
    ,sfu.AddedOn
    ,sfu.UpdatedOn
    ,sfu.DeletedOn
    ,sfu.AddedBy
    ,sfu.UpdatedBy
    ,sfu.DeletedBy
    FROM vw_PortalUsers sfu
     INNER JOIN aspnet_usersinroles  uir ON sfu.UserId = uir.UserId
    WHERE (PortalID=@PortalID or uir.RoleId in (select RoleId from aspnet_Roles where RoleName='Super User'))       
    AND (uir.RoleId = Convert(UNIQUEIDENTIFIER,@RoleId))
    AND sfu.UserName<>'anonymoususer'
   END
  END
 END
 ELSE
 BEGIN
  IF(@SearchText<>'')
  BEGIN  
   INSERT INTO @TblSearchText(RowNum,SearchText)
   SELECT row_number()OVER(ORDER BY items),rtrim(ltrim(items)) FROM split(@SearchText,' ')
   SELECT @SearchCount=count(RowNum) FROM @TblSearchText
   SET @counter=1
   WHILE(@counter<=@SearchCount or @counter=1)
   BEGIN
    SELECT @tmpSearchText=SearchText
    FROM   @TblSearchText
    WHERE RowNum = @counter;
    IF @UserHasHostRole=1 
    BEGIN
     INSERT INTO @SearchResult
     (
     UserId
     ,UserName
     ,[FirstName]
     ,LastName
     ,LoweredUserName
     ,LastActivityDate
     ,Email
	 ,PINcode
     ,LastLoginDate
     ,LastPasswordChangedDate
     ,LastLockoutDate
     ,PortalID
     ,PortalSEOName
     ,IsActive
     ,IsModified
     ,AddedOn
     ,UpdatedOn
     ,DeletedOn
     ,AddedBy
     ,UpdatedBy
     ,DeletedBy
     )
     SELECT DISTINCT sfu.UserId
      ,sfu.UserName
      ,sfu.[FirstName]
      ,sfu.LastName
      ,sfu.LoweredUserName
      ,sfu.LastActivityDate
      ,sfu.Email
	 ,sfu.PINcode
      ,sfu.LastLoginDate
      ,sfu.LastPasswordChangedDate
      ,sfu.LastLockoutDate
      ,sfu.PortalID
      ,sfu.PortalSEOName
      ,sfu.IsActive
      ,sfu.IsModified
      ,sfu.AddedOn
      ,sfu.UpdatedOn
      ,sfu.DeletedOn
      ,sfu.AddedBy
      ,sfu.UpdatedBy
      ,sfu.DeletedBy 
     FROM vw_PortalUsers sfu
     INNER JOIN aspnet_usersinroles  uir ON sfu.UserId = uir.UserId
     WHERE (PortalID=@PortalID or uir.RoleId in (select RoleId from aspnet_Roles where RoleName='Super User'))       
     AND ( sfu.UserName like @tmpSearchText+'%')
     AND sfu.UserName<>'anonymoususer'
    END
    ELSE
    BEGIN
     INSERT INTO @SearchResult
     (
     UserId
     ,UserName
     ,[FirstName]
     ,LastName
     ,LoweredUserName
     ,LastActivityDate
     ,Email
	 ,PINcode
     ,LastLoginDate
     ,LastPasswordChangedDate
     ,LastLockoutDate
     ,PortalID
     ,PortalSEOName
     ,IsActive
     ,IsModified
     ,AddedOn
     ,UpdatedOn
     ,DeletedOn
     ,AddedBy
     ,UpdatedBy
     ,DeletedBy
     )
     SELECT DISTINCT sfu.UserId
      ,sfu.UserName
      ,sfu.[FirstName]
      ,sfu.LastName
      ,sfu.LoweredUserName
      ,sfu.LastActivityDate
      ,sfu.Email
	 ,sfu.PINcode
      ,sfu.LastLoginDate
      ,sfu.LastPasswordChangedDate
      ,sfu.LastLockoutDate
      ,sfu.PortalID
      ,sfu.PortalSEOName
      ,sfu.IsActive
      ,sfu.IsModified
      ,sfu.AddedOn
      ,sfu.UpdatedOn
      ,sfu.DeletedOn
      ,sfu.AddedBy
      ,sfu.UpdatedBy
      ,sfu.DeletedBy 
     FROM vw_PortalUsers sfu
     INNER JOIN aspnet_usersinroles  uir ON sfu.UserId = uir.UserId
     WHERE (PortalID=@PortalID or uir.RoleId in (select RoleId from aspnet_Roles where RoleName='Super User'))    
    AND (PortalID=@PortalID)      
     AND (sfu.UserName like @tmpSearchText+'%' )
     AND sfu.UserName<>'anonymoususer'
     AND (uir.RoleId <> @HostRoleId)
    END
    SET @counter=@counter+1
   END
  END
  ELSE
  BEGIN
   IF @UserHasHostRole=1 
   BEGIN
    INSERT INTO @SearchResult
    SELECT sfu.UserId
    ,sfu.UserName
    ,sfu.[FirstName]
    ,sfu.LastName
    ,sfu.LoweredUserName
    ,sfu.LastActivityDate
    ,sfu.Email
	 ,sfu.PINcode
    ,sfu.LastLoginDate
    ,sfu.LastPasswordChangedDate
    ,sfu.LastLockoutDate
    ,sfu.PortalID
    ,sfu.PortalSEOName
    ,sfu.IsActive
    ,sfu.IsModified
    ,sfu.AddedOn
    ,sfu.UpdatedOn
    ,sfu.DeletedOn
    ,sfu.AddedBy
    ,sfu.UpdatedBy
    ,sfu.DeletedBy
    FROM vw_PortalUsers sfu
     INNER JOIN aspnet_usersinroles  uir ON sfu.UserId = uir.UserId
    WHERE (PortalID=@PortalID or uir.RoleId in (select RoleId from aspnet_Roles where RoleName='Super User'))    
    AND sfu.UserName<>'anonymoususer'
   END
   ELSE
   BEGIN
    INSERT INTO @SearchResult
    SELECT sfu.UserId
    ,sfu.UserName
    ,sfu.[FirstName]
    ,sfu.LastName
    ,sfu.LoweredUserName
    ,sfu.LastActivityDate
    ,sfu.Email
	 ,sfu.PINcode
    ,sfu.LastLoginDate
    ,sfu.LastPasswordChangedDate
    ,sfu.LastLockoutDate
    ,sfu.PortalID
    ,sfu.PortalSEOName
    ,sfu.IsActive
    ,sfu.IsModified
    ,sfu.AddedOn
    ,sfu.UpdatedOn
    ,sfu.DeletedOn
    ,sfu.AddedBy
    ,sfu.UpdatedBy
    ,sfu.DeletedBy
    FROM vw_PortalUsers sfu
     INNER JOIN aspnet_usersinroles  uir ON sfu.UserId = uir.UserId
   WHERE (PortalID=@PortalID or uir.RoleId in (select RoleId from aspnet_Roles where RoleName='Super User'))       
    AND (uir.RoleId <> @HostRoleId)
    AND sfu.UserName<>'anonymoususer'
   END
  END
 END
 SELECT DISTINCT 
UserId
     ,UserName
     ,[FirstName]
     ,LastName
     ,LoweredUserName
     ,LastActivityDate
     ,Email
	 ,PINcode
     ,LastLoginDate
     ,LastPasswordChangedDate
     ,LastLockoutDate
     ,PortalID
     ,PortalSEOName
     ,IsActive
     ,IsModified
     ,ISNULL(AddedOn,getdate()) AS AddedOn
     ,UpdatedOn
     ,DeletedOn
     ,AddedBy
     ,UpdatedBy
     ,DeletedBy
 FROM @SearchResult
 order by UserName
END







GO
