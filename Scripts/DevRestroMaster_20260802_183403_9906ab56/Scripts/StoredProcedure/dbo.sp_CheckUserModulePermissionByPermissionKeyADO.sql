SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CheckUserModulePermissionByPermissionKeyADO]
@PermissionKey NVARCHAR(100),
@UserModuleID  [INT],
@UserName      [NVARCHAR](256),
@PortalID      [INT]
WITH EXECUTE AS caller
AS
  BEGIN
      IF( EXISTS(SELECT *
                 FROM   moduledefpermission mdf
                        INNER JOIN permission p
                                ON mdf.permissionid = p.permissionid
                        INNER JOIN usermodulepermission ump
                                ON
                        ump.moduledefpermissionid = mdf.moduledefpermissionid
                        AND usermoduleid = @UserModuleID
                 WHERE  LOWER(p.permissionkey) = LOWER(@PermissionKey)
                        AND mdf.moduledefid IN (SELECT moduledefid
                                                FROM   usermodules
                                                WHERE
                            usermoduleid = @UserModuleID)
                        AND ( ump.portalid = @PortalID )
                        AND ump.isactive = 1
                        AND ( ump.isdeleted = 0
                               OR ump.isdeleted IS NULL )
                        AND ( ump.username = @UserName
                               OR ump.roleid IN (SELECT uinr.roleid
                                                 FROM   aspnet_users u
                                  INNER JOIN aspnet_usersinroles
                                             uinr
                                          ON
                                  u.userid = uinr.userid
                                                 WHERE  u.username = @UserName)
                            ))
        )
        BEGIN
            SELECT CONVERT(BIT, 1)
        END
      ELSE
        BEGIN
            SELECT CONVERT(BIT, 0)
        END
  END





GO
