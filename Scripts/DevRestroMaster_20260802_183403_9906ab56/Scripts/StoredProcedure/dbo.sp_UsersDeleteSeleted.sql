SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_UsersDeleteSeleted] @Usernames NVARCHAR(4000), 
                                               @PortalID  INT, 
                                               @DeletedBy NVARCHAR(256) 
WITH EXECUTE AS caller 
AS 
  BEGIN 
      DECLARE @TblUsername AS TABLE( 
        RowNum   INT, 
        UserName NVARCHAR(256)) 
      DECLARE @UsernameCount INT, 
              @Counter       INT, 
              @tmpUsername   NVARCHAR(256),
     @UserID UNIQUEIDENTIFIER

      INSERT INTO @TblUsername 
                  (RowNum, 
                   UserName) 
      SELECT Row_number()OVER(ORDER BY items), 
             Rtrim(Ltrim(items)) 
      FROM   Split(@Usernames, ',') 

      SELECT @UsernameCount = COUNT(RowNum) 
      FROM   @TblUsername 

      SET @Counter=1 

      WHILE( @Counter <= @UsernameCount ) 
        BEGIN 
            SELECT @tmpUsername = UserName 
            FROM   @TblUsername 
            WHERE  RowNum = @Counter 
            
   SELECT @UserID=UserID FROM PortalUser
   WHERE  UserName=@tmpUsername and (PortalID=@PortalID  or UserId in (SELECT au.UserId  FROM PortalUser P1 INNER JOIN aspnet_usersinroles au
ON P1.UserID=AU.UserId INNER JOIN aspnet_roles AR ON AR.RoleId=AU.RoleId AND AR.RoleName='Super User' AND p1.IsActive=1 AND (p1.IsDeleted =0 OR p1.ISDeleted IS NULL )))

   DELETE             
            FROM   dbo.aspnet_UsersInRoles
   WHERE  dbo.aspnet_UsersInRoles.UserId = @UserID 

            DELETE             
            FROM   dbo.aspnet_membership
   WHERE  dbo.aspnet_membership.UserId = @UserID
            
   DELETE             
            FROM   dbo.aspnet_users
   WHERE  dbo.aspnet_users.UserId = @UserID
            

            DELETE FROM dbo.portaluser 
            WHERE  dbo.portaluser.UserId = @UserID        

            SET @Counter=@Counter + 1 
        END 
  END





GO
