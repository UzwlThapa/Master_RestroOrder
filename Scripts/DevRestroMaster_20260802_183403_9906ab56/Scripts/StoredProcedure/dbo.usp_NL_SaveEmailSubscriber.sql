SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NL_SaveEmailSubscriber]
@SubscriberEmail NVARCHAR(128),
@UserModuleID INT,
@PortalID INT,
@UserName NVARCHAR(128),
@ClientIP NVARCHAR(128)
AS
BEGIN
IF EXISTS (
        SELECT * FROM NL_EmailSubscriber WHERE SubscriberEmail = @SubscriberEmail
)
BEGIN
       UPDATE DBO.NL_EmailSubscriber 
       SET IsSubscribed=1 WHERE SubscriberEmail=@SubscriberEmail
END
ELSE
BEGIN
   INSERT INTO DBO.NL_EmailSubscriber 
(
SubscriberEmail,
IsSubscribed,
UserModuleID,
PortalID,
AddedOn,
AddedBy,
ClientIP

)
VALUES
(
@SubscriberEmail,
1,
@UserModuleID,
@PortalID,
GETDATE(),
@UserName,
@ClientIP
)     
END


 
END





GO
