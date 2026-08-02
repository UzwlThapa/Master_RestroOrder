SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_AddUpdateLocalModuleTitle]
@UserModuleID INT,
@LocalModuleTitle NVARCHAR(max),
@CultureCode NVARCHAR(50)
AS
BEGIN
DECLARE @UserModuleTitle NVARCHAR(250)
SET @UserModuleTitle=(SELECT UserModuleTitle FROM UserModules WHERE  UserModuleID=@UserModuleID)
 IF(EXISTS(SELECT UserModuleID FROM [dbo].[LocalModuleTitle] WHERE UserModuleID=@UserModuleID AND CultureCode=@CultureCode))
 BEGIN
  UPDATE [LocalModuleTitle]
  SET LocalModuleTitle=@LocalModuleTitle,UserModule=@UserModuleTitle
  WHERE UserModuleID=@UserModuleID
  AND CultureCode=@CultureCode
 END
ELSE
  BEGIN
   INSERT INTO [LocalModuleTitle](UserModuleID,LocalModuleTitle,CultureCode,UserModule)
   VALUES(@UserModuleID,@LocalModuleTitle,@CultureCode,@UserModuleTitle)
  END
END





GO
