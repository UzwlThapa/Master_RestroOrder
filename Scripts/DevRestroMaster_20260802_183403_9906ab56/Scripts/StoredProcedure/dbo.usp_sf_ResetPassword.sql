SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_sf_ResetPassword] 
 @UserID UNIQUEIDENTIFIER ,
 @NewPassword NVARCHAR (128),
 @PasswordSalt NVARCHAR (128),
 @PasswordFormat INT AS
BEGIN

SET NOCOUNT ON UPDATE [dbo].[aspnet_Membership]
SET Password =@NewPassword,
 PasswordSalt =@PasswordSalt,
 PasswordFormat =@PasswordFormat,
 LastPasswordChangedDate = getdate()
WHERE
 UserId =@UserID
END





GO
