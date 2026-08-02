SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_NL_GetSubscriberList]
@Offset INT
AS
BEGIN
DECLARE @lower INT
DECLARE @upper INT
DECLARE @SubscribeNo INT
DECLARE @active TABLE
(
RowNo INT IDENTITY(1,1),
SubscriberId INT
)
SET NOCOUNT ON;
INSERT INTO @active
SELECT SubscriberID FROM NL_EmailSubscriber WHERE IsSubscribed=1 
SET @SubscribeNo=(SELECT MAX(RowNo) FROM @active  )
SET @upper=@SubscribeNo-(@Offset*5)
IF(@upper >5)
SET @lower=@upper-4
ELSE
SET @lower=0
SELECT DISTINCT SubscriberID,(SELECT COUNT(*) FROM DBO.NL_EmailSubscriber WHERE IsSubscribed=1) AS EmailCount,SubscriberEmail FROM DBO.NL_EmailSubscriber WHERE 
IsSubscribed=1 AND SubscriberID  in(SELECT SubscriberId FROM  @active WHERE RowNo between @Lower and  @upper  )  ORDER BY SubscriberID DESC

END





GO
