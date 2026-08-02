SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PasswordRecoveryDeactivateCode]
(
 @UserName NVARCHAR(256),
 @PortalID INT
)
AS
BEGIN
UPDATE Codes 
 SET IsAlreadyUsed=1
 WHERE CodeForUsername=@UserName
 AND PortalID=@PortalID
END





GO
