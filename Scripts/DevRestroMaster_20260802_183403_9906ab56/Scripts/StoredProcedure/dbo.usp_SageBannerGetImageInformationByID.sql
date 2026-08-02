SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageBannerGetImageInformationByID]
 @ImageID INT
AS
BEGIN
 SELECT ImagePath,Caption,LinkToImage,HTMLBodyText,ReadMorePage,ReadButtonText,Description FROM BannerImage
 WHERE ImageID=@ImageID
END





GO
