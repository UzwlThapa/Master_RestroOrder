SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageFramePortalUserSearch] 
(
 @RoleID  NVARCHAR(36) , 
    @SearchText NVARCHAR(4000), 
    @PortalID  INT, 
    @UserName NVARCHAR(256) 
  )
WITH EXECUTE AS CALLER 
AS 
  BEGIN 
      DECLARE @SearchMode INT 
      DECLARE @Counter INT 
      DECLARE @Num INT 
      DECLARE @RowCount INT 
      DECLARE @TempSearchText NVARCHAR(100) 
      DECLARE @HostRoleId UNIQUEIDENTIFIER 
      DECLARE @UserHasHostRole INT 
      DECLARE @SearchResult AS TABLE 
      ( 
        UserId                  UNIQUEIDENTIFIER, 
        UserName                NVARCHAR(256), 
        FirstName               NVARCHAR(100), 
        LastName                NVARCHAR(100), 
        LoweredUserName         NVARCHAR(256), 
        LastActivityDate        DATETIME, 
        Email                   NVARCHAR(256), 
        LastLoginDate           DATETIME, 
        LastPasswordChangedDate DATETIME, 
        LastLockOutDate         DATETIME, 
        PortalId                INT, 
        PortalSeoName           NCHAR(100), 
        IsActive                BIT, 
        IsModified              BIT, 
        AddedOn                 DATETIME, 
        UpdatedOn               DATETIME, 
        DeletedOn               DATETIME, 
        AddedBy                 NVARCHAR(256), 
        UpdatedBy               NVARCHAR(256), 
        DeletedBy               NVARCHAR(256)
       ) 
       
      DECLARE @TblSearchText AS TABLE 
      ( 
        RowNum INT, 
        SearchText NVARCHAR(100)
      ) 

      IF( @SearchText <> '' ) 
        BEGIN 
            INSERT INTO @TblSearchText 
                        (RowNum, 
                         SearchText) 
            SELECT ROW_NUMBER()OVER(ORDER BY items), 
                   RTRIM(LTRIM(items)) 
            FROM   Split(@SearchText, ' ') 
        END 
      ELSE 
        BEGIN 
            INSERT INTO @TblSearchText 
                        (RowNum, 
                         SearchText) 
            SELECT 1, 
                   @SearchText 
        END 

      SET @RowCount=@@ROWCOUNT 

      SELECT @HostRoleId = RoleId 
      FROM   dbo.aspnet_Roles 
      WHERE RoleName='Super User' OR RoleName='Site Admin'

      IF( EXISTS(SELECT * 
                 FROM   dbo.aspnet_UsersInRoles uir 
                        INNER JOIN dbo.aspnet_Users u 
                          ON uir.UserId = u.UserId 
                        INNER JOIN dbo.aspnet_Roles r 
                          ON uir.RoleId = r.RoleId 
                 WHERE  u.UserName = @UserName 
                        AND r.RoleName = 'Super User')) 
        BEGIN 
            SET @UserHasHostRole=1 
        END   
      ELSE 
        BEGIN 
            SET @UserHasHostRole=0 
        END 

      SET @SearchMode= CASE 
                         WHEN ( @RoleID = '' 
                                AND @SearchText = '' ) THEN 0 
                         WHEN ( @RoleID = '' 
                                AND @SearchText <> '' ) THEN 1 
                         WHEN ( @RoleID <> '' 
                                AND @SearchText = '' ) THEN 2 
                         WHEN ( @RoleID <> '' 
                                AND @SearchText <> '' ) THEN 3 
                         ELSE 0 
                       END 

      IF @SearchMode = 0 
        BEGIN 
            SET @Counter=1 

            WHILE( @Counter <= @RowCount 
                    OR @Counter = 1 ) 
              BEGIN 
                  SELECT @TempSearchText = SearchText 
                  FROM   @TblSearchText 
                  WHERE  RowNum = @Counter; 

                  IF @UserHasHostRole = 1 
                    BEGIN 
                        INSERT INTO @SearchResult 
                                    (
          UserId, 
          UserName, 
          FirstName, 
          LastName, 
          LoweredUserName, 
          LastActivityDate, 
          Email, 
          LastLoginDate, 
          LastPasswordChangedDate, 
          LastLockOutDate, 
          PortalId, 
          PortalSeoName, 
          IsActive 
         ) 
                        SELECT sfu.UserId, 
                               sfu.UserName, 
                               sfu.FirstName, 
                               sfu.LastName, 
                               sfu.LoweredUserName, 
                               sfu.LastActivityDate, 
                               sfu.Email, 
                               sfu.LastLoginDate, 
                               sfu.LastPasswordChangedDate, 
                               sfu.LastLockoutDate, 
                               sfu.PortalID, 
                               sfu.PortalSEOName, 
                               sfu.IsActive 
                        FROM vw_PortalUsers sfu 
                               INNER JOIN aspnet_UsersInRoles uir 
                                 ON sfu.UserId = uir.UserId 
                  WHERE (PortalID=@PortalID or uir.RoleId in (select RoleId from aspnet_Roles where RoleName='Super User')) 
                    END 

                  SET @Counter=@Counter + 1 
              END 
        END 

      IF @SearchMode = 1 
        BEGIN 
            SET @Counter=1 
            WHILE( @Counter <= @RowCount 
                    OR @Counter = 1 ) 
              BEGIN 
                  SELECT @TempSearchText = SearchText 
                  FROM   @TblSearchText 
                  WHERE  RowNum = @Counter; 

                  IF @UserHasHostRole = 1 
                    BEGIN 
                        INSERT INTO @SearchResult 
                                    (
          UserId, 
          UserName, 
          FirstName, 
          LastName, 
          LoweredUserName, 
          LastActivityDate, 
          Email, 
          LastLoginDate, 
          LastPasswordChangedDate, 
          LastLockOutDate, 
          PortalId, 
          PortalSeoName, 
          IsActive 
                                     ) 
                        SELECT sfu.UserId, 
                               sfu.UserName, 
                               sfu.FirstName, 
                               sfu.LastName, 
                               sfu.LoweredUserName, 
                               sfu.LastActivityDate, 
                               sfu.Email, 
                               sfu.LastLoginDate, 
                               sfu.LastPasswordChangedDate, 
                               sfu.LastLockoutDate, 
                               sfu.PortalID, 
                               sfu.PortalSEOName, 
                               sfu.IsActive 
                        FROM  vw_PortalUsers sfu 
                              INNER JOIN aspnet_UsersInRoles uir 
         ON sfu.UserId = uir.UserId 
                          WHERE (PortalID=@PortalID or uir.RoleId in (select RoleId from aspnet_Roles where RoleName='Super User')) 
                               AND ( sfu.FirstName LIKE @TempSearchText + '%' 
                                      OR sfu.LastName LIKE @TempSearchText + '%' 
                                      OR sfu.Email LIKE @TempSearchText + '%' 
                                      OR sfu.UserName LIKE @TempSearchText + '%' 
                                   ) 
                               AND sfu.UserName <> 'anonymoususer' 
                    END 

                  SET @Counter=@Counter + 1 
              END 
        END 

      IF @SearchMode = 2 
        BEGIN 
            SET @Counter=1 

            WHILE( @Counter <= @RowCount 
                    OR @Counter = 1 ) 
              BEGIN 
                  SELECT @TempSearchText = SearchText 
                  FROM   @TblSearchText 
                  WHERE  RowNum = @Counter; 

                  IF @UserHasHostRole = 1 
                    BEGIN 
                        INSERT INTO @SearchResult 
                                    (
          UserId, 
          UserName, 
          FirstName, 
          LastName, 
          LoweredUserName, 
          LastActivityDate, 
          Email, 
          LastLoginDate, 
          LastPasswordChangedDate, 
          LastLockOutDate, 
          PortalId, 
          PortalSeoName, 
          IsActive
                                     ) 
                        SELECT sfu.UserId, 
                               sfu.UserName, 
                               sfu.FirstName, 
                               sfu.LastName, 
                               sfu.LoweredUserName, 
                               sfu.LastActivityDate, 
                               sfu.Email, 
                               sfu.LastLoginDate, 
                               sfu.LastPasswordChangedDate, 
                               sfu.LastLockoutDate, 
                               sfu.PortalID, 
                               sfu.PortalSEOName, 
                               sfu.IsActive 
                        FROM  vw_PortalUsers sfu 
                               INNER JOIN aspnet_UsersInRoles uir 
                                 ON sfu.UserId = uir.UserId 
                       WHERE (PortalID=@PortalID or uir.RoleId in (select RoleId from aspnet_Roles where RoleName='Super User')) 
                               AND ( uir.RoleId = CONVERT(UNIQUEIDENTIFIER, 
                                                  @RoleId) ) 
                               AND sfu.UserName <> 'anonymoususer' 
                    END 

                  SET @Counter=@Counter + 1 
              END 
        END 

      IF @SearchMode = 3 
        BEGIN 
            SET @Counter=1 

            WHILE( @Counter <= @RowCount 
                    OR @Counter = 1 ) 
              BEGIN 
                  SELECT @TempSearchText = SearchText 
                  FROM   @TblSearchText 
                  WHERE  RowNum = @Counter; 

                  IF @UserHasHostRole = 1 
                    BEGIN 
                        INSERT INTO @SearchResult 
                                    (
          UserId, 
          UserName, 
          FirstName, 
          LastName, 
          LoweredUserName, 
          LastActivityDate, 
          Email, 
          LastLoginDate, 
          LastPasswordChangedDate, 
          LastLockOutDate, 
          PortalId, 
          PortalSeoName, 
          IsActive
                                     ) 
                        SELECT sfu.UserId, 
                               sfu.UserName, 
                               sfu.FirstName, 
                               sfu.LastName, 
                               sfu.LoweredUserName, 
                               sfu.LastActivityDate, 
                               sfu.Email, 
                               sfu.LastLoginDate, 
                               sfu.LastPasswordChangedDate, 
                               sfu.LastLockoutDate, 
                               sfu.PortalID, 
                               sfu.PortalSEOName, 
                               sfu.IsActive 
                        FROM  vw_PortalUsers sfu 
                               INNER JOIN aspnet_UsersInRoles uir 
                                 ON sfu.UserId = uir.UserId 
                      WHERE (PortalID=@PortalID or uir.RoleId in (select RoleId from aspnet_Roles where RoleName='Super User')) 
                               AND ( sfu.FirstName LIKE @TempSearchText + '%' 
                                      OR sfu.LastName LIKE @TempSearchText + '%' 
                                      OR sfu.Email LIKE @TempSearchText + '%' 
                                      OR sfu.UserName LIKE @TempSearchText + '%' 
                                   ) 
                               AND ( uir.RoleId = CONVERT(UNIQUEIDENTIFIER, 
                                                  @RoleId) ) 
                               AND sfu.UserName <> 'anonymoususer' 
                    END 

                  SET @Counter=@Counter + 1 
              END 
        END 

      SELECT DISTINCT * 
      FROM   @SearchResult 
  END





GO
