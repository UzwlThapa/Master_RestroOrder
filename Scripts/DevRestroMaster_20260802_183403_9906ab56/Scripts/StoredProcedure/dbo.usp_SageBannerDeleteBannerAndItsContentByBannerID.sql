SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageBannerDeleteBannerAndItsContentByBannerID]
@BannerID INT
AS
BEGIN
 DELETE FROM SageBanner WHERE BannerID=@BannerID
 DELETE FROM BannerImage WHERE BannerID=@BannerID
END





GO
