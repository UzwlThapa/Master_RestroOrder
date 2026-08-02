SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED DATE: 2010-03-25
CREATE PROCEDURE [dbo].[sp_GetUsernameByPortalIDAuto]
 @Prefix NVARCHAR(50),
 @Count INT,
 @PortalID INT,
 @UserName NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
DECLARE @DynSQL NVARCHAR(1000),@HostRoleId UNIQUEIDENTIFIER,@UserHasHostRole BIT
SELECT @HostRoleId=RoleId FROM dbo.aspnet_roles WHERE RoleName='Super User'
IF(EXISTS(SELECT * FROM dbo.aspnet_usersinroles uir INNER JOIN dbo.aspnet_users u ON uir.UserId=u.UserId INNER JOIN dbo.aspnet_roles r ON uir.RoleId = r.RoleId WHERE u.Username=@UserName AND r.RoleName='Super User'))
BEGIN
 SET @UserHasHostRole=1
END
ELSE
BEGIN
 SET @UserHasHostRole=0
END
IF @UserHasHostRole=1
BEGIN
 SET @DynSQL='SELECT Top '+CAST(ISNULL(@Count,'1000') AS VARCHAR)+' FirstName+'' ''+LastName as UserName FROM vw_SageFrameUser WHERE (((FirstName like '''+ISNULL(@Prefix,'')+'%'') OR (LastName like '''+ISNULL(@Prefix,'')+'%'')OR (username like '''+ISNULL(@Prefix,'')+'%'') OR (email like '''+ISNULL(@Prefix,'')+'%'') )) AND UserName<>''anonymoususer'' ORDER By FirstName,LastName'
END
ELSE
BEGIN
 SET @DynSQL='SELECT Top '+CAST(ISNULL(@Count,'1000') AS VARCHAR)+' FirstName+'' ''+LastName as UserName FROM vw_SageFrameUser WHERE (((FirstName like '''+ISNULL(@Prefix,'')+'%'') OR (LastName like '''+ISNULL(@Prefix,'')+'%'')OR (username like '''+ISNULL(@Prefix,'')+'%'') OR (email like '''+ISNULL(@Prefix,'')+'%'') ) AND (PortalID='+CONVERT(VARCHAR(100),ISNULL(@PortalID,''))+')) AND UserName<>''anonymoususer'' ORDER By FirstName,LastName'
END
EXECUTE(@DynSQL)
/****** Object:  StoredProcedure [dbo].[sp_GoogleAnalyticsAddUpdate]    Script Date: 12/02/2012 13:30:37 ******/
SET ANSI_NULLS ON





GO
