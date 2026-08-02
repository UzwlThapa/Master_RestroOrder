SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageBannerSaveBannerInformation]
(
 @BannerName NVARCHAR(256),
 @BannerDescription NVARCHAR(MAX),
 @UserModuleID INT,
 @PortalID INT,
 @CultureCode NVARCHAR(100)
)
AS
BEGIN
 INSERT INTO SageBanner
 (
  BannerName,
  BannerDescription,
  UserModuleID,
  PortalID,
  CultureCode
 )
 VALUES
 (
  @BannerName,
  @BannerDescription,
  @UserModuleID,
  @PortalID,
  @CultureCode
 )
  
END





GO
