SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_RO_CheckPinCodeMatch]
    @PinCode VARCHAR(MAX),
    @Username NVARCHAR(255) = ''
AS
SELECT Username
FROM dbo.PortalUser
WHERE PINcode = @PinCode
      AND Username = @Username;




GO
