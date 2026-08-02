SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NL_UnSubscribeUserByEmail]
@Email NVARCHAR(128)
AS
BEGIN
 UPDATE DBO.NL_EmailSubscriber 
 SET IsSubscribed=0 WHERE SubscriberEmail=@Email
END





GO
