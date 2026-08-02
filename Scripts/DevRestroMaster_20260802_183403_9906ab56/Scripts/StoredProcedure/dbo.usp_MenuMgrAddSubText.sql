SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrAddSubText]
 @PageID INT,
 @SubText NVARCHAR(254),
 @IsActive BIT,
 @IsVisible BIT
AS
BEGIN
 UPDATE  
  [dbo].[MenuItem] 
 SET 
  SubText = @SubText,
  IsActive = @IsActive,
  IsVisible = @IsVisible 
 WHERE 
  PageID =@PageID
END
SET ANSI_NULLS ON





GO
