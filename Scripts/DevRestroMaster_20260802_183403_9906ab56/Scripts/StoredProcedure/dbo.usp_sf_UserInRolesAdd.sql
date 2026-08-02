SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_sf_UserInRolesAdd] 
(
@ApplicationName NVARCHAR(120),
@UserID UNIQUEIDENTIFIER,
@RoleNames NVARCHAR(4000),
@PortalID INT
)
as
BEGIN
  DECLARE @TranStarted   BIT
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
        SET @TranStarted = 0

 DECLARE @AppId UNIQUEIDENTIFIER
 SELECT  @AppId = NULL
 SELECT  @AppId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName



 DECLARE @TableNames TABLE(Name NVARCHAR(256) NOT NULL PRIMARY KEY)
 DECLARE @TableUserInRoles table(RoleId UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,UserID UNIQUEIDENTIFIER) 
 DECLARE @Num  INT
 DECLARE @Pos  INT
 DECLARE @NextPos INT
 DECLARE @Name  NVARCHAR(256)

 SET @Num = 0
 SET @Pos = 1
 WHILE(@Pos <= LEN(@RoleNames))
 BEGIN
  SELECT @NextPos = CHARINDEX(N',', @RoleNames,  @Pos)
  IF (@NextPos = 0 OR @NextPos IS NULL)
   SELECT @NextPos = LEN(@RoleNames) + 1
  SELECT @Name = RTRIM(LTRIM(SUBSTRING(@RoleNames, @Pos, @NextPos - @Pos)))
  SELECT @Pos = @NextPos+1

  INSERT INTO @TableNames VALUES (@Name)
  SET @Num = @Num + 1
 END

 INSERT INTO @TableUserInRoles
   SELECT ar.RoleId,@UserID
   FROM   dbo.PortalRole pr INNER JOIN aspnet_Roles ar on pr.RoleID=ar.RoleId
     INNER JOIN  @TableNames t on LOWER(t.Name) = ar.LoweredRoleName   
   WHERE  ar.ApplicationId = @AppId
   AND pr.PortalID=@PortalID OR pr.PortalID=-1

IF (EXISTS (SELECT * FROM dbo.aspnet_UsersInRoles ur, @TableUserInRoles tr WHERE tr.UserID = ur.UserId AND tr.RoleId = ur.RoleId))
 BEGIN
  IF( @TranStarted = 1 )
   ROLLBACK TRANSACTION  
 END

 INSERT INTO dbo.aspnet_UsersInRoles (UserId, RoleId)
  SELECT UserID, RoleId
  FROM  @TableUserInRoles  

 IF( @@ERROR <> 0 )
    BEGIN        
        GOTO Cleanup
    END

IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        COMMIT TRANSACTION
    END


Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        ROLLBACK TRANSACTION
    END   

END





GO
