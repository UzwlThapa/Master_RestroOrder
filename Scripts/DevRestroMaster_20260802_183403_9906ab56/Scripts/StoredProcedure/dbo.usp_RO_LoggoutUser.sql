SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_RO_CheckIfLoggedIn]8
CREATE PROCEDURE [dbo].[usp_RO_LoggoutUser]
@username nvarchar(256)
AS
UPDATE dbo.Users SET IsLoggedIn = 0 where Username = @username;
delete  from WaiterNotificationLog where WaiterName = @username;

GO
