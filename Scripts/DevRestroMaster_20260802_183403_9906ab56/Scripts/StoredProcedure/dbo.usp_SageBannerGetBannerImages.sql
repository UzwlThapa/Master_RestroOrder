SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [dbo].[usp_SageBannerGetBannerImages]1,47,1,'ne-NP'
CREATE PROCEDURE [dbo].[usp_SageBannerGetBannerImages]
(
 @BannerID INT,
 @UserModuleID INT,
 @PortalID INT,
 @CultureCode NVARCHAR(100)
) 
AS
BEGIN
 SELECT ImagePath,Caption,LinkToImage,HTMLBodyText,NavigationImage,ReadButtonText,ReadMorePage,[Description]
 FROM BannerImage WHERE BannerID=@BannerID 
 AND UserModuleID=@UserModuleID AND CultureCode=@CultureCode
 AND PortalID=@PortalID ORDER BY DisplayOrder 
END





GO
