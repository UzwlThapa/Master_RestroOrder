SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USP_RO_CheckPinCodeMatch '1121'
CREATE PROCEDURE [dbo].[USP_RO_getUNameNpwdByPIN] @PinCode VARCHAR(max)
AS
--declare @PinCode VARCHAR(max)='1111'
SELECT username,ms.[password]
FROM dbo.PortalUser pu
 join aspnet_Membership ms on pu.UserID=ms.UserId
WHERE PINcode = @PinCode



GO
