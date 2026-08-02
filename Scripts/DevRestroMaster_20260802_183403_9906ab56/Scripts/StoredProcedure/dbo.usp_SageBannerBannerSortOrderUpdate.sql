SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SageBannerBannerSortOrderUpdate]
(
 @ImageId INT, 
 @MoveUp BIT
)
AS
BEGIN
 DECLARE @CurrentOrder INT,@BannerUsedID INT,@NewOrder INT
 SELECT @BannerUsedID=BannerID FROM BannerImage WHERE ImageID=@ImageId

 IF @MoveUp=1
 BEGIN
  DECLARE @UpEntryOrder INT,@UpID INT 
  SELECT @CurrentOrder=DisplayOrder FROM BannerImage WHERE ImageID=@ImageId and BannerID=@BannerUsedID
  Select @UpEntryOrder=MAX(DisplayOrder) FROM BannerImage WHERE BannerID=@BannerUsedID AND DisplayOrder<@CurrentOrder
  SELECT @UpID=ImageID FROM BannerImage WHERE DisplayOrder=@UpEntryOrder and BannerID=@BannerUsedID
  SELECT @NewOrder=DisplayOrder FROM BannerImage WHERE ImageID=@UpID 
  UPDATE BannerImage SET DisplayOrder=@CurrentOrder WHERE ImageID=@UpID 
  UPDATE BannerImage SET DisplayOrder=@NewOrder WHERE ImageID=@ImageId
 END
 ELSE
 BEGIN
 DECLARE @DownEntryOrder INT,@DownID INT
  SELECT @CurrentOrder=DisplayOrder FROM BannerImage WHERE ImageID=@ImageId and BannerID=@BannerUsedID
  SELECT @DownEntryOrder=MIN(DisplayOrder) FROM BannerImage WHERE BannerID=@BannerUsedID AND DisplayOrder>@CurrentOrder
  SELECT @DownID=ImageID FROM BannerImage WHERE DisplayOrder=@DownEntryOrder and BannerID=@BannerUsedID
  SELECT @NewOrder=DisplayOrder FROM BannerImage WHERE ImageID=@DownID 
  UPDATE BannerImage SET DisplayOrder=@CurrentOrder WHERE ImageID=@DownID
  UPDATE BannerImage SET DisplayOrder=@NewOrder WHERE ImageID=@ImageId
 END
END





GO
