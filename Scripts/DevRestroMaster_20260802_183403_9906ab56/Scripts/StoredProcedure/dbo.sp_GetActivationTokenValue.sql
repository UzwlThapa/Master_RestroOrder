SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- ALTER date: 2010-04-26
-- Modified DATe: 2010-07-30
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetActivationTokenValue] @UserName NVARCHAR(256),
                                                   @PortalID INT
AS
  BEGIN
      DECLARE @code UNIQUEIDENTIFIER

      --SELECT @code = Newid()
       select @code=(select UserID  FROM   vw_sageframeuser
      WHERE  username = @UserName
             AND portalid = @PortalID)

      INSERT INTO [dbo].[codes]
                  ([code],
                   isalreadyused,
                   [activefrom],
                   [activeto],
                   [codeforpurpose],
                   [codeforusername],
                   [portalid])
      VALUES      (@code,
                   0,
                   GETDATE(),
                   Dateadd(d, 7, GETDATE()),
                   'UserActivation',
                   @UserName,
                   @PortalID)

      SELECT @code     AS [%UserActivationCode%],
             username  AS [%Username%],
             firstname AS [%UserFirstName%],
             lastname  AS [%UserLastName%],
             email     AS [%UserEmail%]
      FROM   vw_sageframeuser
      WHERE  username = @UserName
             AND portalid = @PortalID
  END





GO
