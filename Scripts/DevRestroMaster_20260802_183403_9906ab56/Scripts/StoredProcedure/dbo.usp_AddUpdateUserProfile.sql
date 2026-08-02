SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_AddUpdateUserProfile]
 @image NVARCHAR(250),
 @UserName NVARCHAR(256), 
 @FirstName NVARCHAR(100), 
 @LastName NVARCHAR(100),
 @FullName NVARCHAR(250), 
 @Location NVARCHAR(50),
 @AboutYou NVARCHAR(MAX),
 @Email NVARCHAR(MAX), 
 @ResPhone NVARCHAR(50),
 @Mobile NVARCHAR(50),
 @Others NVARCHAR(max),
 @AddedOn DATETIME,
 @AddedBy NVARCHAR,
 @UpdatedOn DATETIME, 
 @PortalID INT, 
 @UpdatedBy NVARCHAR(256),
 @BirthDate DATETIME,
 @Gender INT
AS
BEGIN
UPDATE [dbo].[PortalUser] SET
 FirstName = @FirstName,
 LastName = @LastName,
 Email=@Email,
 UpdatedOn=getdate(),
 UpdatedBy=@UpdatedBy
 WHERE 
 Username=@UserName and PortalID=@PortalID

 DECLARE @UserProfileID INT
 DECLARE @UserId UNIQUEIDENTIFIER
 SELECT @UserId=UserId FROM PortalUser 
 WHERE 
 Username=@UserName and PortalID=@PortalID
 
 
   UPDATE dbo.aspnet_Membership SET Email=@Email,
        LoweredEmail=LOWER(@Email)
       WHERE                 
        UserId=@UserId
        
        UPDATE dbo.Users SET FirstName=@FirstName,
      LastName=@LastName,
      Email=@Email,      
      UpdatedOn=getdate(),
      UpdatedBy=@UpdatedBy
      WHERE
                  Username=@UserName
      AND PortalID=@PortalID

END
IF(Not Exists(SELECT * FROM [dbo].[UserDetails] WHERE  [UserName] = @UserName and [PortalID] = @PortalID))
BEGIN

  INSERT INTO [dbo].[UserDetails] (
  [image],
  Username,
  FirstName,
  LastName,
  FullName,
  BirthDate,
  Gender,
  Location,
  AboutYou,
  Email,
  ResPhone,
  Mobile,
  Others,
  AddedOn,
  AddedBy,
  PortalID
        )
  VALUES
  (
  @image,
  @UserName,
  @FirstName,
  @LastName,
  @FullName,
  @BirthDate,
  @Gender,
  @Location,
  @AboutYou,
  @Email,
  @ResPhone,
  @Mobile,
  @Others,
  @AddedOn,
  @AddedBy,
  @PortalID
  )
   SET @UserProfileID=SCOPE_IDENTITY()
  UPDATE [dbo].[UserDetails] SET UserId=@UserProfileID WHERE ProfileID=@UserProfileID
 End
Else
    BEGIN

 UPDATE [dbo].[UserDetails] SET
  [image] = @image,
  FirstName = @FirstName,
  LastName = @LastName,
  FullName = @FullName,
  BirthDate = @BirthDate,
  Gender = @Gender,
  Location = @Location,
  AboutYou = @AboutYou,
  Email = @Email,
  ResPhone = @ResPhone,
  Mobile = @Mobile,
  Others = @Others,
  UpdatedOn = @UpdatedOn,
  UpdatedBy = @UpdatedBy
 WHERE Username = @UserName and PortalID = @PortalID
END





GO
