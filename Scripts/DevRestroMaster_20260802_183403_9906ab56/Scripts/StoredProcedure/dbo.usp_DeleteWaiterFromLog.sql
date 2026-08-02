SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_DeleteWaiterFromLog]
@WaiterName nvarchar(max)
as
delete  from WaiterNotificationLog where WaiterName = @WaiterName


GO
