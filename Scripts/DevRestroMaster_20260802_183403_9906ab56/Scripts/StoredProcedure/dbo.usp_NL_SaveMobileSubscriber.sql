SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_NL_SaveMobileSubscriber]
@SubscriberPhone bigint,
@UserModuleID INT,
@PortalID INT,
@UserName NVARCHAR(128),
@ClientIP NVARCHAR(128)
AS
BEGIN
INSERT INTO DBO.NL_MobileSubsciber 
(
MobileNumber,
IsSubscribed,
UserModuleID,
PortalID,
AddedOn,
AddedBy,
ClientIP

)
VALUES
(
@SubscriberPhone,
1,
@UserModuleID,
@PortalID,
GETDATE(),
@UserName,
@ClientIP
)
 
END





GO
