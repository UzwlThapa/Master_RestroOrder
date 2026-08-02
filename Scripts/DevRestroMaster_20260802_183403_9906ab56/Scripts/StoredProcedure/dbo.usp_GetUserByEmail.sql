SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[usp_GetUserByEmail] 'mt_bij@yahoo.com', 1
CREATE PROCEDURE [dbo].[usp_GetUserByEmail] 
@email NVARCHAR(100),
@portalID INT
AS
BEGIN

 DECLARE @DUP_EMAIL NVARCHAR(50)
 SET @DUP_EMAIL='DUPLICATE_EMAIL_ALLOWED';
 DECLARE @AllowDuplicateRegistration INT
 DECLARE @DuplicateEmail INT
 SELECT @DuplicateEmail=CAST(SettingValue AS INT) FROM MembershipSettings  where SettingKey = @DUP_EMAIL
 IF( @DuplicateEmail=0)
   BEGIN
   IF(EXISTS(SELECT UserId FROM  PortalUser WHERE Email = @email))
   BEGIN
   DECLARE @UserID NVARCHAR(100)
   SET @UserID = (SELECT UserId FROM  PortalUser WHERE Email = @email )
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
     INNER JOIN portaluser pu 
       ON am.userid = pu.userid  
     INNER JOIN aspnet_Users au ON 
     au.UserId=am.UserId
    WHERE  pu.portalid = 1 
     AND pu.UserID = @UserID 
   END
   ELSE 
   BEGIN
    SELECT   0 AS IsApproved
   END
 END
 ELSE
 BEGIN  
   IF(EXISTS(SELECT UserId FROM  PortalUser WHERE Email = @email and UserName= @email))
   BEGIN
   DECLARE @singleUserID NVARCHAR(100)
   SET @singleUserID = (SELECT UserId FROM  PortalUser WHERE Email = @email and UserName= @email )
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
     INNER JOIN portaluser pu 
       ON am.userid = pu.userid  
     INNER JOIN aspnet_Users au ON 
     au.UserId=am.UserId
    WHERE  pu.portalid = 1 
     AND pu.UserID = @singleUserID 
   END
   ELSE 
   BEGIN
    SELECT   0 AS IsApproved
   END
 END
END





GO
