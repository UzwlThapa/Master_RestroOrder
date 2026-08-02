SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardSidebarUpdate]
(
 @DisplayName NVARCHAR(200),
 @Depth INT,
 @ImagePath NVARCHAR(250),
 @URL NVARCHAR(250),
 @ParentID INT,
 @IsActive BIT,
 @SidebarItemID INT,
 @PageID INT
) 
AS
BEGIN
SET NOCOUNT ON;
 UPDATE [dbo].[DashboardSidebar]
 SET DisplayName=@DisplayName,URL=@URL,ImagePath=@ImagePath,
 ParentID=@ParentID,IsActive=@IsActive,PageID=@PageID
 WHERE SidebarItemID=@SidebarItemID
END





GO
