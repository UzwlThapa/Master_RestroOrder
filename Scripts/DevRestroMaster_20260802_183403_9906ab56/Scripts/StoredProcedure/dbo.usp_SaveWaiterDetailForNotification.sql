SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_SaveWaiterDetailForNotification]
@WaiterName nvarchar(max),
@WaiterIP nvarchar(max)
AS

delete from WaiterNotificationLog where WaiterName = @WaiterName

INSERT INTO WaiterNotificationLog (WaiterName, WaiterIP, WaiterLoginDateTime)
VALUES (@WaiterName,@WaiterIP, GETDATE());

GO
