SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UsersGetAll] 
AS
BEGIN
 SELECT
  pu.PortalId,
  au.UserName,
  au.UserId,
  pu.FirstName,
  pu.LastName,
  am.Email,
  am.PasswordFormat
 FROM
  [dbo].[PortalUser] pu
 INNER JOIN [dbo].[aspnet_Users] au ON pu.userid = au.userid
 INNER JOIN [dbo].[aspnet_Membership] am ON au.userid = am.userid
 END





GO
