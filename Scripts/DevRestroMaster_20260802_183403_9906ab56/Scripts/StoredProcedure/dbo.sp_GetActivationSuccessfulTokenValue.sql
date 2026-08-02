SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- Created Date: 2010-04-27
CREATE PROCEDURE [dbo].[sp_GetActivationSuccessfulTokenValue] @UserName NVARCHAR(
256),
                                                             @PortalID INT
WITH EXECUTE AS caller
AS
  BEGIN
      SELECT userid    AS [%UserActivationCode%],
             username  AS [%Username%],
             firstname AS [%UserFirstName%],
             lastname  AS [%UserLastName%],
             email     AS [%UserEmail%]
      FROM   vw_sageframeuser
      WHERE  username = @UserName
             AND portalid = @PortalID
  END





GO
