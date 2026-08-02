SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_DashboardSidebarAdd] (
 @DisplayName NVARCHAR(200)
 ,@Depth INT
 ,@ImagePath NVARCHAR(250)
 ,@URL NVARCHAR(250)
 ,@ParentID INT
 ,@IsActive BIT
 ,@DisplayOrder INT
 ,@PageID INT
 )
AS
BEGIN
 SET NOCOUNT ON;

 DECLARE @PDepth INT

 IF (@Depth = 0)
  SET @PDepth = @Depth
 ELSE
  SELECT @PDepth = [DashboardSidebar].Depth + 1
  FROM [dbo].[DashboardSidebar]
  WHERE @ParentID = SidebarItemID

 INSERT INTO [dbo].[DashboardSidebar] (
  DisplayName
  ,Depth
  ,ImagePath
  ,URL
  ,ParentID
  ,IsActive
  ,DisplayOrder
  ,PageID
  )
 VALUES (
  @DisplayName
  ,@PDepth
  ,@ImagePath
  ,@URL
  ,@ParentID
  ,@IsActive
  ,@DisplayOrder
  ,@PageID
  )
END





GO
