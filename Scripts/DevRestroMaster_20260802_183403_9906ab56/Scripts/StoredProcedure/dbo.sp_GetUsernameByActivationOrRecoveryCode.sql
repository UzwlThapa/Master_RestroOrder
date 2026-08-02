SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- Create date: 2010-08-03
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetUsernameByActivationOrRecoveryCode]--'2e1bfd29-b83f-4c08-86de-59e399b68141',29
 @Code NVARCHAR(256),
 @PortalID INT
AS
BEGIN
 SELECT * FROM [dbo].[Codes] WHERE Code=@Code AND GETDATE() BETWEEN ActiveFrom AND ActiveTo
AND  PortalID=@PortalID
END





GO
