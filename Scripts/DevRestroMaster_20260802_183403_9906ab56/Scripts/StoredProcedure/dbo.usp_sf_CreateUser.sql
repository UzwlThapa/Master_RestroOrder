SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[usp_sf_CreateUser]
    @ApplicationName                        NVARCHAR(256),
    @UserName                               NVARCHAR(256),
 @FirstName        NVARCHAR(256),
 @LastName        NVARCHAR(256),
    @Password                               NVARCHAR(128),
    @PasswordSalt                           NVARCHAR(128),
    @Email                                  NVARCHAR(256),
    @PasswordQuestion                       NVARCHAR(256),
    @PasswordAnswer                         NVARCHAR(128),
    @IsApproved                             BIT,
    @CurrentTimeUtc                         DATETIME,
    @CreateDate                             DATETIME = NULL,
    @UniqueEmail                            INT      = 0,
    @PasswordFormat                         INT      = 0,
 @PortalID        INT, 
 @AddedOn        DATETIME, 
 @AddedBy        NVARCHAR(256),
 @RoleNames        NVARCHAR(4000),   
    @ErrorCode        INT output,
 @StoreID        INT,
    @CustomerID                             INT output,
    @UserId                                 UNIQUEIDENTIFIER OUTPUT
 
AS
BEGIN
    DECLARE @ApplicationId UNIQUEIDENTIFIER
    SELECT  @ApplicationId = NULL
    DECLARE @NewUserId UNIQUEIDENTIFIER
    SELECT @NewUserId = NULL
    DECLARE @IsLockedOut BIT
    SET @IsLockedOut = 0
    DECLARE @LastLockoutDate DATETIME
    SET @LastLockoutDate = CONVERT(DATETIME,'17540101',112)
    DECLARE @FailedPasswordAttemptCount INT
    SET @FailedPasswordAttemptCount = 0
    DECLARE @FailedPasswordAttemptWindowStart DATETIME
    SET @FailedPasswordAttemptWindowStart = CONVERT( DATETIME, '17540101', 112 )
    DECLARE @FailedPasswordAnswerAttemptCount INT
    SET @FailedPasswordAnswerAttemptCount = 0
    DECLARE @FailedPasswordAnswerAttemptWindowStart DATETIME
    SET @FailedPasswordAnswerAttemptWindowStart = CONVERT( DATETIME, '17540101', 112 )
    DECLARE @NewUserCreated BIT
    DECLARE @ReturnValue   INT
    SET @ReturnValue = 0
 DECLARE @NewID INT
    DECLARE @TranStarted BIT
    SET @TranStarted = 0
 DECLARE @DUP_REG_KEY NVARCHAR(50)
 SET @DUP_REG_KEY='DUPLICATE_USERS_ACROSS_PORTALS';
 DECLARE @DUP_EMAIL NVARCHAR(50)
 SET @DUP_EMAIL='DUPLICATE_EMAIL_ALLOWED';
    DECLARE @AllowDuplicateRegistration INT
 DECLARE @DuplicateEmail INT
 SELECT @DuplicateEmail=CAST(SettingValue AS INT) FROM MembershipSettings 
 WHERE SettingKey=@DUP_EMAIL
 SELECT @AllowDuplicateRegistration=CAST(SettingValue AS INT) FROM MembershipSettings 
 WHERE SettingKey=@DUP_REG_KEY
 DECLARE @IsEmailExists BIT
 SET @IsEmailExists=0

 IF (EXISTS(SELECT Email FROM aspnet_Membership WHERE Email=@Email))
  BEGIN
  SET @IsEmailExists=1
  END

 DECLARE @PortalUserID INT
 SET @PortalUserID=0
 
 IF @DuplicateEmail=0 AND @IsEmailExists=1
  BEGIN
   SET @ErrorCode = 3
   GOTO Cleanup 
  END

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
    SET @CreateDate = @CurrentTimeUtc
    IF @AllowDuplicateRegistration=0 
 BEGIN  
  IF (NOT EXISTS(SELECT UserId 
                 FROM dbo.aspnet_Users 
                 WHERE LOWER(@UserName) = LoweredUserName AND @ApplicationId = ApplicationId))
  BEGIN
   IF @DuplicateEmail=0   
   SET @NewUserId = @UserId
   EXEC @ReturnValue = dbo.aspnet_Users_CreateUser @ApplicationId, 
                       @UserName, 0, @CreateDate, @NewUserId OUTPUT;
   EXEC dbo.usp_PortalUsersAdd @NewUserId,@UserName,@FirstName,
        @LastName,@Email,@IsApproved,@AddedOn,@PortalID,@AddedBy;
   EXEC dbo.usp_sf_UserInRolesAdd @ApplicationName,@NewUserId,@RoleNames,@PortalID;
   EXEC dbo.usp_UsersAdd @NewID output,@UserName,@FirstName,@LastName,
        @Email,@IsApproved,@AddedOn,@PortalID,@AddedBy;
          
   
   SET @NewUserCreated = 1
  END
  ELSE
  BEGIN
   SET @NewUserCreated = 0   
    SET @ErrorCode = 6
    GOTO Cleanup   
  END
    END
 ELSE
 BEGIN
  IF (NOT EXISTS(SELECT * FROM dbo.PortalUser 
                 WHERE  LOWER(Username)=LOWER(@UserName) 
                 AND PortalID=@PortalID))
  BEGIN  
   SET @NewUserId = @UserId 
   EXEC @ReturnValue = dbo.aspnet_Users_CreateUser @ApplicationId,
            @UserName, 0, @CreateDate, @NewUserId OUTPUT;
   EXEC dbo.usp_PortalUsersAdd @NewUserId,@UserName,@FirstName,
            @LastName,@Email,@IsApproved,@AddedOn,@PortalID,@AddedBy;
   EXEC dbo.usp_sf_UserInRolesAdd @ApplicationName,@NewUserId,
            @RoleNames,@PortalID;
   EXEC dbo.usp_UsersAdd @NewID output,@UserName,@FirstName,@LastName,
            @Email,@IsApproved,@AddedOn,@PortalID,@AddedBy
     
   
   SET @NewUserCreated = 1
  END
  ELSE
  BEGIN
   SET @NewUserCreated = 0   
   BEGIN
    SET @ErrorCode = 6
    GOTO Cleanup
   END
  END
    END

    IF( @@ERROR <> 0 )
    BEGIN
        SET @ErrorCode = -1
        GOTO Cleanup
    END

    IF( @ReturnValue = -1 )
    BEGIN
        SET @ErrorCode = 10
        GOTO Cleanup
    END

    IF ( EXISTS ( SELECT UserId
                  FROM   dbo.aspnet_Membership
                  WHERE  @NewUserId = UserId ) )
    BEGIN
        SET @ErrorCode = 6
        GOTO Cleanup
    END

    SET @UserId = @NewUserId

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT *
                    FROM  dbo.aspnet_Membership m WITH ( UPDLOCK, HOLDLOCK )
                    WHERE ApplicationId = @ApplicationId AND LoweredEmail = LOWER(@Email)))
        BEGIN
            SET @ErrorCode = 7
            GOTO Cleanup
        END
    END

    IF (@NewUserCreated = 0)
    BEGIN
        UPDATE dbo.aspnet_Users
        SET    LastActivityDate = @CreateDate
        WHERE  @UserId = UserId
        IF( @@ERROR <> 0 )
        BEGIN
            SET @ErrorCode = -1
            GOTO Cleanup
        END
    END

    INSERT INTO dbo.aspnet_Membership
                ( ApplicationId,
                  UserId,
                  Password,
                  PasswordSalt,
                  Email,
                  LoweredEmail,
                  PasswordQuestion,
                  PasswordAnswer,
                  PasswordFormat,
                  IsApproved,
                  IsLockedOut,
                  CreateDate,
                  LastLoginDate,
                  LastPasswordChangedDate,
                  LastLockoutDate,
                  FailedPasswordAttemptCount,
                  FailedPasswordAttemptWindowStart,
                  FailedPasswordAnswerAttemptCount,
                  FailedPasswordAnswerAttemptWindowStart )
         VALUES ( @ApplicationId,
                  @UserId,
                  @Password,
                  @PasswordSalt,
                  @Email,
                  LOWER(@Email),
                  @PasswordQuestion,
                  @PasswordAnswer,
                  @PasswordFormat,
                  @IsApproved,
                  @IsLockedOut,
                  @CreateDate,
                  @CreateDate,
                  @CreateDate,
                  @LastLockoutDate,
                  @FailedPasswordAttemptCount,
                  @FailedPasswordAttemptWindowStart,
                  @FailedPasswordAnswerAttemptCount,
                  @FailedPasswordAnswerAttemptWindowStart )

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

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
     ROLLBACK TRANSACTION
    END

    RETURN @ErrorCode

END





GO
