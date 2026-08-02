SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PageModulesAdd] 
 @PageID INT,
 @UserModuleID INT,
 @PaneName NVARCHAR(50),
 @ModuleOrder INT,
 @CacheTime INT,
 @Alignment NVARCHAR(50),
 @Color NVARCHAR(20),
 @Border NVARCHAR(1),
 @IconFile NVARCHAR(100),
 @Visibility INT, 
 @IsActive BIT,
 @AddedOn DATETIME,
 @PortalID INT,
 @AddedBy NVARCHAR(256)
AS

INSERT INTO dbo.PageModules (
 [PageID],
 [UserModuleID],
 [PaneName],
 [ModuleOrder],
 [CacheTime],
 [Alignment],
 [Color],
 [Border],
 [IconFile],
 [Visibility], 
 [IsActive],
 [AddedOn],
 [PortalID],
 [AddedBy]
) VALUES (
 @PageID,
 @UserModuleID,
 @PaneName,
 @ModuleOrder,
 @CacheTime,
 @Alignment,
 @Color,
 @Border,
 @IconFile,
 @Visibility, 
 @IsActive,
 @AddedOn,
 @PortalID,
 @AddedBy
)





GO
