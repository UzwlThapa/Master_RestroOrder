SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageBannerLoadBannerListOnGrid]
(
 @PortalID INT,
    @UserModuleID INT,
    @CultureCode NVARCHAR(100)
)
AS
BEGIN
 SELECT BannerID,BannerName,BannerDescription FROM SageBanner 
 WHERE PortalID=@PortalID 
 AND UserModuleID=@UserModuleID 
 AND CultureCode=@CultureCode
END





GO
