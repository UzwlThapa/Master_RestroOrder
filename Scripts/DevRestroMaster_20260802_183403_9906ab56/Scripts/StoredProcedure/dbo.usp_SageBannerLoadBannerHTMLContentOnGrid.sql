SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageBannerLoadBannerHTMLContentOnGrid] 
(
 @BannerID INT,
 @UserModuleID INT,
 @PortalID INT,
 @CultureCode NVARCHAR(100)
)
AS
BEGIN
 SELECT [ImageID],[HTMLBodyText] 
 FROM BannerImage 
 WHERE DATALENGTH(HTMLBodyText)>0 
 AND BannerID=@BannerID
 AND UserModuleID=@UserModuleID
 AND PortalID=@PortalID
 AND CultureCode=@CultureCode
END





GO
