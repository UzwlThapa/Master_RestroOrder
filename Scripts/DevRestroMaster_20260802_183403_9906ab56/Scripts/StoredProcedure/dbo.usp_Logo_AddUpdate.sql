SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_Logo_AddUpdate] 
 @LogoText NVARCHAR(100),
 @LogoPath NVARCHAR(200),
 @UserModuleID INT,
 @PortalID INT,
 @Slogan NVARCHAR(500),
 @url NVARCHAR(250),
 @CultureCode NVARCHAR(100)
AS
BEGIN
 IF(EXISTS(SELECT * FROM dbo.[Logo] WHERE UserModuleID=@UserModuleID AND PortalID=@PortalID AND CultureCode=@CultureCode))
  BEGIN
   UPDATE dbo.Logo SET LogoText=@LogoText,LogoPath=@LogoPath,Slogan=@Slogan,url=@url 
   WHERE UserModuleID=@UserModuleID AND PortalID=@PortalID AND CultureCode=@CultureCode 
  END
 ELSE
  BEGIN
   INSERT INTO dbo.[Logo]
   (
   LogoText,
   LogoPath,
   UserModuleID,
   PortalID,
   Slogan,
   url,
   CultureCode
   )
   VALUES
   (
   @LogoText,
   @LogoPath,
   @UserModuleID,
   @PortalID,
   @Slogan,
   @url,
   @CultureCode
   )
   
  END
END





GO
