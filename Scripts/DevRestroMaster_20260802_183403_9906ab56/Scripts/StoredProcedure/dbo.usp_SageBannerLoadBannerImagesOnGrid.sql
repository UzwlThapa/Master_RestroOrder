SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageBannerLoadBannerImagesOnGrid]
( 
 @BannerID INT,
 @UserModuleID INT,
 @PortalID INT,
 @CultureCode NVARCHAR(100)
) 
AS
BEGIN
 SELECT [ImageID],[ImagePath],[Caption],DisplayOrder
 FROM BannerImage 
 WHERE BannerID=@BannerID 
 AND  UserModuleID=@UserModuleID 
 AND PortalID=@PortalID  
 AND CultureCode=@CultureCode
 AND DATALENGTH(ImagePath)>0 ORDER BY DisplayOrder
END





GO
