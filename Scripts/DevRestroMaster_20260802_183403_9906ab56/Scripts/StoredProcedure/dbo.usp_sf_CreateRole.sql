SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_sf_CreateRole]
    @ApplicationName  NVARCHAR(256),
    @RoleName         NVARCHAR(256) ,
 @PortalID    INT, 
 @IsActive    BIT,
 @AddedOn    DATETIME,
 @AddedBy          NVARCHAR(256),
 @CreditLimit INT,
 @ErrorCode    INT OUTPUT
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    SELECT  @ApplicationId = NULL   

    DECLARE @TranStarted   BIT
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
        SET @TranStarted = 0

    EXEC dbo.aspnet_Applications_CreateApplication @ApplicationName, @ApplicationId OUTPUT

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END
 DECLARE @DUP_ROLE_KEY NVARCHAR(100)
 SET @DUP_ROLE_KEY='DUPLICATE_ROLES_ACROSS_PORTALS'
 
 DECLARE @AllowDuplicateRoles INT
 SELECT @AllowDuplicateRoles=CAST(SettingValue AS INT) FROM MembershipSettings 
 WHERE SettingKey=@DUP_ROLE_KEY

 IF @AllowDuplicateRoles=0
 BEGIN
    IF (EXISTS(SELECT RoleId FROM dbo.aspnet_Roles WHERE LoweredRoleName = LOWER(@RoleName) AND ApplicationId = @ApplicationId))
    BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END
 END
 ELSE IF @AllowDuplicateRoles=1
 BEGIN
 IF(EXISTS(SELECT ar.RoleID FROM dbo.PortalRole pr INNER JOIN dbo.aspnet_Roles ar ON pr.RoleID=ar.RoleID WHERE ar.LoweredRoleName=LOWER(@RoleName) 
 AND pr.PortalID=@PortalID))
 BEGIN
        SET @ErrorCode = 1
        GOTO Cleanup
    END
 END
    INSERT INTO dbo.aspnet_Roles
                (ApplicationId, RoleName, LoweredRoleName,CreditLimit)
         VALUES (@ApplicationId, @RoleName, LOWER(@RoleName),@CreditLimit)

 DECLARE @NewRoleID INT
 SET @NewRoleID=@@IDENTITY
    DECLARE @NewRoleGUID UNIQUEIDENTIFIER
 SELECT @NewRoleGUID=RoleID FROM dbo.aspnet_Roles WHERE ID=@NewRoleID
 --add the role to PortalRole table
 EXEC usp_PortalRoleAdd @PortalID,@NewRoleGUID,@IsActive,@AddedOn,@AddedBy

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        COMMIT TRANSACTION
    END

    RETURN(0)

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
        ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END
set ANSI_NULLS ON
set QUOTED_IDENTIFIER OFF





GO
