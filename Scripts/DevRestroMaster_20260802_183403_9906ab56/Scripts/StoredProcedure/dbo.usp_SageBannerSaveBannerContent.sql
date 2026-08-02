SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageBannerSaveBannerContent]
( 
 @Caption NVARCHAR(256),
 @ImagePath NVARCHAR(256),
 @LinkToImage NVARCHAR(256),
 @UserModuleID INT,
 @BannerID INT,
 @ImageID INT,
 @NavigationImage NVARCHAR(256),
 @ReadButtonText NVARCHAR(256),
 @Description NVARCHAR(MAX),
 @ReadMorePage NVARCHAR(256),
 @PortalID INT,
 @CultureCode NVARCHAR(100)
)
AS
DECLARE @DisplayOrder INT
 SET @DisplayOrder = ISNULL((SELECT MAX([DisplayOrder]) FROM dbo.BannerImage WHERE BannerID = @BannerID ), 0) + 1
IF @ImageID=0
 BEGIN
  INSERT INTO BannerImage
  (
  Caption,
  ImagePath,
  LinkToImage,
  UserModuleID,
  BannerID,
  NavigationImage,
  ReadButtonText,
  Description,
  ReadMorePage,
  PortalID,
  DisplayOrder,
  CultureCode
  )
  VALUES
  (
  @Caption ,
  @ImagePath,
  @LinkToImage,
  @UserModuleID,
  @BannerID,
  @NavigationImage,
  @ReadButtonText,
  @Description,
  @ReadMorePage,
  @PortalID,
  @DisplayOrder,
  @CultureCode
  )  
 END
ELSE
 BEGIN
  UPDATE BannerImage SET 
  Caption=@Caption,
  ImagePath=@ImagePath,
  LinkToImage=@LinkToImage,
  UserModuleID=@UserModuleID,
  BannerID=@BannerID,
  NavigationImage=@NavigationImage,
  ReadButtonText=@ReadButtonText,
  Description=@Description,
  ReadMorePage=@ReadMorePage,
  PortalID=@PortalID,
  CultureCode=@CultureCode
  WHERE ImageID=@ImageID
 END





GO
