SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
  
-- Create date: 2010-04-26
-- Description: 
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetPasswordRecoveryTokenValue] 
 @UserName NVARCHAR(256),
 @PortalID NVARCHAR
AS
BEGIN
DECLARE @Code UNIQUEIDENTIFIER
 SELECT @Code=NEWID()
 INSERT INTO [dbo].[Codes]([Code],[ActiveFrom],[ActiveTo],[CodeForPurpose],[CodeForUsername],[PortalID]) VALUES (@code,GETDATE(),DATEADD(d,7,GETDATE()),'PasswordRecovery',@UserName,@PortalID)
SELECT @Code AS [%UserActivationCode%],Username AS [%Username%], FirstName AS [%UserFirstName%], LastName AS [%UserLastName%], Email AS [%UserEmail%]
FROM vw_PortalUsers
WHERE Username=@UserName AND PortalID=@PortalID

END
/****** Object:  StoredProcedure [dbo].[sp_GetPermissionByCodeAndKey]    Script Date: 12/02/2012 12:55:59 ******/
SET ANSI_NULLS ON





GO
