SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetWaiterLog]
as
select  
wnl.PushNotificationId,
wnl.WaiterName,
wnl.WaiterIP,
wnl.WaiterLoginDateTime,
usd.image from WaiterNotificationLog wnl 
left join Users usr ON wnl.WaiterName = usr.UserName
left join Userdetails usd ON usr.UserName = usd.Username
 where convert(varchar(8),wnl.WaiterLoginDateTime,112) =convert(varchar(8),getdate(),112) --yyyymmdd
 and WaiterName != 'superuser'
 order by WaiterLoginDateTime desc

GO
