SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_sf_UsersUpdate]
(
 @ApplicationName NVARCHAR(256),
 @UserName NVARCHAR(256),
 @UserID UNIQUEIDENTIFIER,
 @FirstName NVARCHAR(256),
 @LastName NVARCHAR(256),
 @Email NVARCHAR(256), 
 @PortalID INT,
 @IsApproved BIT,
 @UpdatedBy NVARCHAR(256),
 @ErrorCode INT OUTPUT,
--For AspsxCommerce 
 @StoreID INT
)
AS
BEGIN
 SET NOCOUNT ON
    DECLARE @AppId UNIQUEIDENTIFIER
 SELECT  @AppId = NULL
 SELECT  @AppId = ApplicationId FROM aspnet_Applications WHERE LOWER(@ApplicationName) = LoweredApplicationName

    DECLARE @TranStarted   BIT
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
        BEGIN TRANSACTION
        SET @TranStarted = 1
    END
    ELSE
        SET @TranStarted = 0


    DECLARE @DUP_EMAIL NVARCHAR(50)
 SET @DUP_EMAIL='DUPLICATE_EMAIL_ALLOWED';
    DECLARE @DuplicateEmail INT
    SELECT @DuplicateEmail=CAST(SettingValue as INT) FROM MembershipSettings 
 WHERE SettingKey=@DUP_EMAIL
    DECLARE @IsEmailExists BIT
 SET @IsEmailExists=0

 IF (EXISTS(SELECT Email FROM aspnet_Membership WHERE Email=@Email AND UserId<>@UserID))
  BEGIN
  SET @IsEmailExists=1
  END

    IF @DuplicateEmail=0 AND @IsEmailExists=1
  BEGIN
   SET @ErrorCode = 1
   GOTO Cleanup 
  END

    UPDATE dbo.aspnet_Membership SET Email=@Email,
        LoweredEmail=LOWER(@Email),
        IsApproved=@IsApproved
       WHERE
                 ApplicationId=@AppId
       AND 
        UserId=@UserId

    UPDATE dbo.PortalUser SET FirstName=@FirstName,
       LastName=@LastName,
       Email=@Email,
       IsActive=@IsApproved,
       UpdatedOn=getdate(),
       UpdatedBy=@UpdatedBy
      WHERE
                   UserID=@UserID

 UPDATE dbo.Users SET FirstName=@FirstName,
      LastName=@LastName,
      Email=@Email,
      IsActive=@IsApproved,
      UpdatedOn=getdate(),
      UpdatedBy=@UpdatedBy
      WHERE
                  Username=@UserName
      AND PortalID=@PortalID
      
      
  UPDATE [dbo].[UserDetails] SET
        
  FirstName = @FirstName,
  LastName = @LastName,
  Email = @Email
  WHERE
   Username = @UserName and PortalID = @PortalID
      

--For Customer table AspxCommerce
IF EXISTS (SELECT * FROM sys.objects 
   WHERE object_id = OBJECT_ID(N'[dbo].[Aspx_Customer]') AND type in (N'U'))
BEGIN
 UPDATE dbo.[Aspx_Customer] SET 
      IsActive=@IsApproved,
      UpdatedOn=getdate(),
      UpdatedBy=@UpdatedBy
      WHERE
                  Username=@UserName AND PortalID=@PortalID AND [StoreID] = @StoreID
END

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
