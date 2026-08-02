SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_EditPermissionExists] 
(
 @UserName nvarchar(250),
 @UserModuleID int
 
)
RETURNS int
AS
BEGIN
 DECLARE @ReturnValue int
 
 SELECT @ReturnValue=COUNT(*) 
 FROM   usermodulepermission ump 
       INNER JOIN moduledefpermission mdp 
         ON ump.moduledefpermissionid = mdp.moduledefpermissionid 
            AND ump.usermoduleid = @UserModuleID
            AND ump.roleid IN (SELECT roleid 
                               FROM   dbo.aspnet_usersinroles 
                                      INNER JOIN dbo.aspnet_users 
                                        ON dbo.aspnet_usersinroles.userid = 
                                           dbo.aspnet_users.userid 
                               WHERE  dbo.aspnet_users.username = @UserName) 
            AND mdp.permissionid = 2 
    IF @ReturnValue=1  
  SET @ReturnValue=1
 ELSE IF @ReturnValue>1
  SET @ReturnValue=1

 RETURN @ReturnValue

END





GO
