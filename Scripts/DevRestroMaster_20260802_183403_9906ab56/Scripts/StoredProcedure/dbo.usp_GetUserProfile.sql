SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetUserProfile]
@UserName NVARCHAR(250),
@PortalID INT
AS
BEGIN

if exists(select * from PortalUser where  PortalID=@PortalID and Username=@UserName)
begin

SELECT ISNULL(ud.UserName,pu.UserName) AS UserName,ISNULL(ud.FirstName,pu.Firstname) AS FirstName,
ISNULL(ud.LastName,pu.LastName) AS LastName,ISNULL(ud.Email,pu.Email) AS Email,
ud.* FROM UserDetails ud RIGHT JOIN PortalUser pu
ON ud.UserName=pu.UserName AND ud.PortalID=pu.PortalID
WHERE pu.UserName = @UserName AND pu.PortalID=@PortalID
END
ELSE
BEGIN
SELECT ISNULL(ud.UserName,pu.UserName) AS UserName,ISNULL(ud.FirstName,pu.Firstname) AS FirstName,
ISNULL(ud.LastName,pu.LastName) AS LastName,ISNULL(ud.Email,pu.Email) AS Email,
ud.* FROM UserDetails ud RIGHT JOIN PortalUser pu
ON ud.UserName=pu.UserName AND ud.PortalID=pu.PortalID
INNER JOIN aspnet_usersinroles AU
ON PU.UserID=AU.UserId INNER JOIN aspnet_roles AR ON AR.RoleId=AU.RoleId AND RoleName='Super User'

WHERE pu.UserName = @UserName 
END 

END





GO
