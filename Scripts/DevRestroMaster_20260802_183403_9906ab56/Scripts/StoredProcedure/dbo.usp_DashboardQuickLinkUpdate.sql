SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardQuickLinkUpdate]
(
 @DisplayName NVARCHAR(200),
 @URL NVARCHAR(250),
 @ImagePath NVARCHAR(250),
 @QuickLinkID INT,
 @PageID INT,
 @IsActive BIT
) 
AS
BEGIN
 SET NOCOUNT ON;
 UPDATE [dbo].[DashboardQuickLinks]
 SET DisplayName=@DisplayName,URL=@URL,ImagePath=@ImagePath,IsActive=@IsActive,PageID=@PageID
 WHERE QuickLinkID=@QuickLinkID
END





GO
