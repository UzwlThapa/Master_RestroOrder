SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_IsUserInRole]
(
 @UserName nvarchar(250),
 @RoleName nvarchar(250),
 @PortalID int
)
RETURNS int
AS
BEGIN
 DECLARE @ReturnValue int
 
 if(@RoleName='Super User')
 BEGIN
 
  
 select @ReturnValue=count(ar.RoleName) from PortalUser pu inner join aspnet_usersinroles au
 on pu.UserID=au.UserID
 inner join aspnet_roles ar
 on au.RoleID=ar.RoleID
 where pu.Username=@UserName
 and ar.RoleName=@RoleName
 END
 ELSE 
  BEGIN
 
 SELECT @ReturnValue=count(ar.RoleName) from PortalUser pu inner join aspnet_usersinroles au
 on pu.UserID=au.UserID
 inner join aspnet_roles ar
 on au.RoleID=ar.RoleID
 where pu.Username=@UserName
 and (pu.PortalID=@PortalID )
 and ar.RoleName=@RoleName
  END
 
 IF @ReturnValue>0
  SET @ReturnValue=1
 ELSE
  SET @ReturnValue=0

 RETURN @ReturnValue

END





GO
