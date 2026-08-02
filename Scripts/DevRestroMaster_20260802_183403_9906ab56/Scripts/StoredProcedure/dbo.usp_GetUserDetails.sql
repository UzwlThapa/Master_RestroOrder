SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetUserDetails] 
    ( @UserName NVARCHAR(256), 
               @PortalID INT) 
AS 
  BEGIN 

    
     --DECLARE @TblRole TABLE(RoleID NVARCHAR(256))
     --INSERT INTO @TblRole 
     --SELECT DISTINCT roleid FROM aspnet_usersinroles ur 
     --    INNER JOIN portaluser pu ON pu.userid=ur.userid WHERE username=@UserName
     
     
     
     
     --DECLARE @Counter INT,@rowCount INT,@isRoleSuperuser BIT 
     --SELECT @RowCount = COUNT(RowNum) FROM @TblRole
     
     --SET @Counter=1
     --WHILE(@Counter<=@RowCount or @Counter=1)
     --BEGIN
     -- DECLARE @key UNIQUEIDENTIFIER 
     -- SELECT @key=RoleID FROM @TblRole WHERE RowNum=@Counter
     
     
     --  IF(@key=(SELECT roleid FROM aspnet_roles WHERE RoleName='Super User'))
     --   BEGIN 
     --    SET @isRoleSuperuser=1
     --    BREAK;
     --   END
     --  ELSE
     --   BEGIN
     --    SET @isRoleSuperuser=0
     --   END
     -- SET @Counter=@Counter+1
     --END

   
    DECLARE @isRoleSuperuser BIT     
    DECLARE  @TblRole  TABLE (UserID UNIQUEIDENTIFIER)

     IF(EXISTS(SELECT 1 FROM aspnet_usersinroles ur 
           INNER JOIN portaluser pu ON pu.userid=ur.userid 
           WHERE username=@UserName  AND  
           ur.RoleId IN (SELECT roleid FROM aspnet_roles WHERE RoleName='Super User')
      )
      )
    SET @isRoleSuperuser = 1
    ELSE
    SET @isRoleSuperuser = 0
    
    

 
    INSERT INTO @TblRole 
    SELECT pu.UserID   
          FROM   aspnet_membership am 
           INNER JOIN portaluser pu   ON am.userid = pu.userid  
           INNER JOIN aspnet_Users au ON  au.UserId=am.UserId
          WHERE  pu.portalid = @PortalID and 
           pu.username = @UserName
    
    
           
     IF(@isRoleSuperuser=0)                            
      BEGIN
          SELECT am.userid, 
           am.password, 
           am.passwordformat, 
           am.passwordsalt, 
           am.email, 
           am.isapproved, 
           am.islockedout,
           am.LastLoginDate,
           am.LastPasswordChangedDate,
           am.LastLockoutDate,
           pu.username,
           pu.FirstName,
           pu.LastName,
           am.IsApproved,
          am.CreateDate,
           au.LastActivityDate 
          FROM   aspnet_membership am 
           INNER JOIN portaluser pu   ON am.userid = pu.userid  
           INNER JOIN aspnet_Users au ON  au.UserId=am.UserId
          WHERE  pu.portalid = @PortalID and pu.UserID in (select UserID from @TblRole)
           --AND LOWER(pu.username) = LOWER(@UserName) 
       END  
     ELSE 
      BEGIN
         SELECT am.userid, 
          am.password, 
          am.passwordformat, 
          am.passwordsalt, 
          am.email, 
          am.isapproved, 
          am.islockedout,
          am.LastLoginDate,
          am.LastPasswordChangedDate,
          am.LastLockoutDate,
          pu.username,
          pu.FirstName,
          pu.LastName,
          am.IsApproved,
         am.CreateDate,
          au.LastActivityDate 
         FROM   aspnet_membership am  
          INNER JOIN portaluser pu   ON am.userid = pu.userid  
          INNER JOIN aspnet_Users au ON au.UserId=am.UserId
         WHERE  au.LoweredUserName = LOWER(@UserName)
      END
   END





GO
