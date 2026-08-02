SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- Created Date: 2010-04-27
CREATE PROCEDURE [dbo].[sp_GetPasswordRecoverySuccessfulTokenValue]
 @UserName [NVARCHAR](256),
 @PortalID [INT]
WITH EXECUTE AS CALLER
AS
BEGIN
SELECT UserId AS [%UserActivationCode%],Username AS [%Username%], FirstName AS [%UserFirstName%], LastName AS [%UserLastName%], Email AS [%UserEmail%]
FROM vw_sageframeuser
WHERE Username=@UserName AND PortalID=@PortalID
END
/****** Object:  StoredProcedure [dbo].[sp_GetPasswordRecoveryTokenValue]    Script Date: 12/02/2012 12:52:57 ******/
SET ANSI_NULLS ON





GO
