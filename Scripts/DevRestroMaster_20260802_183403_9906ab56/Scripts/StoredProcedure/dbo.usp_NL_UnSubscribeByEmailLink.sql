SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NL_UnSubscribeByEmailLink]
@subscriberID INT
AS
BEGIN
 UPDATE DBO.NL_EmailSubscriber 
 SET IsSubscribed=0
 WHERE SubscriberID=@subscriberID
END





GO
