SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageBannerGetAllBanner]
(
 @UserModuleID INT,
 @PortalID INT,
 @CultureCode NVARCHAR(10)
)
AS
BEGIN
 SELECT BannerID,BannerName FROM SageBanner WHERE UserModuleID=@UserModuleID AND PortalID=@PortalID AND CultureCode=@CultureCode
END





GO
