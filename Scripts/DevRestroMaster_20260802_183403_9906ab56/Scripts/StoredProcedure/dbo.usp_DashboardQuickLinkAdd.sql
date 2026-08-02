SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardQuickLinkAdd]
(
 @DisplayName NVARCHAR(200),
 @URL NVARCHAR(250),
 @ImagePath NVARCHAR(250),
 @DisplayOrder INT,
 @PageID INT,
 @IsActive BIT
)
AS
BEGIN
 SET NOCOUNT ON;
 INSERT INTO [dbo].[DashboardQuickLinks]
 (
  DisplayName,URL,ImagePath,DisplayOrder,PageID,IsActive
 )
 VALUES
 (
  @DisplayName,@URL,@ImagePath,@DisplayOrder,@PageID,@IsActive
 )
END





GO
