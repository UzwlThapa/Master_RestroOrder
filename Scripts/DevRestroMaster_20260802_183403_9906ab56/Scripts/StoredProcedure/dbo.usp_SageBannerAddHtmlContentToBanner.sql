SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageBannerAddHtmlContentToBanner]
(
 @Content NVARCHAR(MAX),
 @Bannerid INT,
 @UserModuleId INT,
 @ImageID INT,
 @NavigationImage NVARCHAR(256),
 @PortalID INT,
 @CultureCode NVARCHAR(256)
) 
AS
IF @ImageID=0
BEGIN
 INSERT INTO BannerImage
 (
  HTMLBodyText,
  BannerID,
  UserModuleID,
  NavigationImage,
  PortalID,
  CultureCode
 )
 VALUES
 (
  @Content,
  @Bannerid,
  @UserModuleId,
  @NavigationImage,
  @PortalID,
  @CultureCode
 ) 
 END
ELSE
 UPDATE BannerImage
 SET
 HTMLBodyText=@Content,
 BannerID=@Bannerid,
 UserModuleID=@UserModuleId,
 NavigationImage=@NavigationImage,
 PortalID=@PortalID
 WHERE ImageID=@ImageID





GO
