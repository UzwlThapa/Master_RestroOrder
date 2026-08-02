SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ActivateUserByUserId]
 @ActivationCode NVARCHAR(256),
 @PortalID INT,
 @UserName NVARCHAR(256) OUTPUT   
WITH EXECUTE AS CALLER
AS
BEGIN 
 DECLARE @UserID UNIQUEIDENTIFIER 
 IF(EXISTS(SELECT * FROM [dbo].[Codes] WHERE Code=@ActivationCode AND GETDATE() BETWEEN ActiveFrom AND ActiveTo AND IsAlreadyUsed=0)) 
 BEGIN  
  SELECT @UserName=UserName,@UserID=UserID FROM [dbo].[PortalUser] pu INNER JOIN [dbo].[Codes] dc ON pu.UserName=dc.CodeForUsername AND pu.PortalID=dc.PortalID
  WHERE dc.Code=CAST(@ActivationCode AS UNIQUEIDENTIFIER)
  
  UPDATE [dbo].[Codes] SET IsAlreadyUsed=1 WHERE Code=@ActivationCode

  UPDATE [dbo].[aspnet_Membership] SET IsApproved=1 
  WHERE UserId=@UserID

  UPDATE [dbo].PortalUser SET IsActive=1
  WHERE username=@UserName AND PortalID=@PortalID

  UPDATE [dbo].Users SET IsActive=1
  WHERE username=@UserName
   
 END
END





GO
